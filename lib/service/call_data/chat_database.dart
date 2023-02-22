import 'dart:io';

import '/service/model/chat_contact_model.dart';
import '/service/model/message_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';

import '../../helper/message_enum.dart';
import '../../helper/shared_preferences.dart';
import '../model/user_model.dart';
import 'database.dart';

class ChatDatabase extends Database {
  Stream<List<ChatContactModel>> getChatContact() {
    return firestore
        .collection('users')
        .doc(SaveData.getString(key: "userPhone"))
        .collection("chat")
        .orderBy("timeServer", descending: true)
        .snapshots()
        .asyncMap((event) async {
      List<ChatContactModel> contacts = [];
      for (var document in event.docs) {
        var chatContacts = ChatContactModel.fromJson(document.data());
        var userData = await firestore
            .collection("users")
            .doc(chatContacts.contactID)
            .get();
        var user = UserData.fromJson(userData.data());
        contacts.add(
          ChatContactModel(
            timeServer: chatContacts.timeServer,
            userName: user.name,
            image: user.image,
            contactID: chatContacts.contactID,
            timeSend: chatContacts.timeSend,
            lastMessage: chatContacts.lastMessage,
          ),
        );
      }
      return contacts;
    });
  }

  Stream<List<MessageModel>> getMessages({
    required String receiverUserID,
  }) {
    return firestore
        .collection('users')
        .doc(SaveData.getString(key: "userPhone"))
        .collection("chat")
        .doc(receiverUserID)
        .collection("messages")
        .orderBy("timeServer")
        .snapshots()
        .map((event) {
      List<MessageModel> messages = [];
      for (var documents in event.docs) {
        messages.add(MessageModel.fromJson(documents.data()));
      }

      return messages;
    });
  }

  void sendTextMessage({
    required String message,
    required String receiverUserID,
    required UserData senderUser,
  }) async {
    try {
      final timeSent = DateTime.now();
      //final FieldValue timeServer = FieldValue.serverTimestamp();
      final DateTime timeServer = DateTime.now().toUtc();
      final String messageID = const Uuid().v1();
      DocumentSnapshot receiverUserData =
          await firestore.collection("users").doc(receiverUserID).get();
      UserData receiverUser = UserData.fromJson(receiverUserData.data());

      _savaContactToCollection(
        timeServer: timeServer,
        message: message,
        receiverUser: receiverUser,
        receiverUserID: receiverUserID,
        timeSend: timeSent,
        senderUser: senderUser,
      );
      _savaMessageToCollection(
        timeServer: timeServer,
        receiverUserID: receiverUserID,
        message: message,
        timeSend: timeSent,
        messageType: MessageEnum.text,
        messageID: messageID,
        receiverUserName: receiverUser.name,
        userName: senderUser.name,
      );
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  void sendFileMessage({
    required File file,
    required String receiverUserID,
    required UserData senderUser,
    required MessageEnum messageTypeEnum,
  }) async {
    try {
      var timeSend = DateTime.now();
      final DateTime timeServer = DateTime.now().toUtc();
      var messageID = const Uuid().v1();
      String imageUrl = await _uploadToFireStore(
        image: file.path,
        fileImage: file,
        pathName: "chat/${senderUser.id}/",
      );
      DocumentSnapshot receiverUserData =
          await firestore.collection("users").doc(receiverUserID).get();
      String messageType = "";
      if (messageTypeEnum == MessageEnum.image) {
        messageType = "📷 photo";
      } else if (messageTypeEnum == MessageEnum.video) {
        messageType = "🎥 video";
      } else if (messageTypeEnum == MessageEnum.audio) {
        messageType = "🔉 audio";
      }
      UserData receiverUser = UserData.fromJson(receiverUserData.data());
      _savaContactToCollection(
        senderUser: senderUser,
        receiverUser: receiverUser,
        message: messageType,
        timeSend: timeSend,
        receiverUserID: receiverUserID,
        timeServer: timeServer,
      );
      _savaMessageToCollection(
        receiverUserID: receiverUserID,
        timeServer: timeServer,
        message: imageUrl,
        timeSend: timeSend,
        messageID: messageID,
        userName: senderUser.name,
        receiverUserName: receiverUser.name,
        messageType: messageTypeEnum,
      );
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  void _savaContactToCollection({
    required UserData senderUser,
    required UserData receiverUser,
    required String message,
    required DateTime timeSend,
    required DateTime timeServer,
    required String receiverUserID,
  }) async {
    ChatContactModel receiverChatContact = ChatContactModel(
      userName: senderUser.name,
      image: senderUser.image,
      contactID: senderUser.id,
      timeSend: timeSend,
      lastMessage: message,
      timeServer: timeServer,
    );

    await firestore
        .collection("users")
        .doc(receiverUserID)
        .collection("chat")
        .doc(SaveData.getString(key: "userPhone"))
        .set(receiverChatContact.toJson());

    ChatContactModel senderChatContact = ChatContactModel(
      userName: receiverUser.name,
      image: receiverUser.image,
      contactID: receiverUser.id,
      timeSend: timeSend,
      lastMessage: message,
      timeServer: timeServer,
    );

    await firestore
        .collection("users")
        .doc(SaveData.getString(key: "userPhone"))
        .collection("chat")
        .doc(receiverUserID)
        .set(senderChatContact.toJson());
  }

  void _savaMessageToCollection({
    required String receiverUserID,
    required String message,
    required DateTime timeSend,
    required DateTime timeServer,
    required String messageID,
    required String userName,
    required String receiverUserName,
    required MessageEnum messageType,
  }) async {
    MessageModel messageModel = MessageModel(
      senderID: SaveData.getString(key: "userPhone").toString(),
      timeServer: timeServer,
      receiverID: receiverUserID,
      message: message,
      timeSend: timeSend,
      messageID: messageID,
      messageType: messageType.toString(),
      isSeen: false,
    );
    await firestore
        .collection("users")
        .doc(SaveData.getString(key: "userPhone"))
        .collection("chat")
        .doc(receiverUserID)
        .collection("messages")
        .doc(messageID)
        .set(
          messageModel.toJson(),
        );

    await firestore
        .collection("users")
        .doc(receiverUserID)
        .collection("chat")
        .doc(SaveData.getString(key: "userPhone"))
        .collection("messages")
        .doc(messageID)
        .set(
          messageModel.toJson(),
        );
  }

  Future<String> _uploadToFireStore({
    required String image,
    required File fileImage,
    required String pathName,
  }) async {
    String path = "$pathName${Uri.file(fileImage.path).pathSegments.last}";
    await reference.child(path).putFile(fileImage);
    final String getImageUrl = await reference.child(path).getDownloadURL();
    return getImageUrl;
  }
}
