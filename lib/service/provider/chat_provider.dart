import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_sound/public/flutter_sound_recorder.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import '../../helper/constant_widget.dart';
import '../../helper/message_enum.dart';
import '../call_data/chat_database.dart';
import '../model/chat_contact_model.dart';
import '../model/message_model.dart';
import '../model/user_model.dart';

class ChatProvider extends ChangeNotifier {
  bool isTyping = false;
  final ChatDatabase _chatDatabase = ChatDatabase();
  final TextEditingController messageController = TextEditingController();
  List<ChatContactModel> contacts = [];
  UserData? userData;
  final ImagePicker picker = ImagePicker();
  File? imageFile;
  File? videoFile;
  bool isRecordInt = false;
  bool isRecording = false;
  String pathAudio = "";

  void onChangedMode(String text) {
    if (text.isEmpty) {
      isTyping = false;
      notifyListeners();
    } else {
      isTyping = true;
      notifyListeners();
    }
  }

  void selectImage(
    BuildContext context, {
    required ImageSource source,
    required String receiverUserID,
    required UserData senderUser,
  }) async {
    final XFile? image = await picker.pickImage(
      source: source,
    );
    if (image != null) {
      imageFile = File(image.path);
      // ignore: use_build_context_synchronously
      sendFileMessage(
        context,
        receiverUserID: receiverUserID,
        senderUser: senderUser,
        messageEnum: MessageEnum.image,
      );
      notifyListeners();
    } else {
      // ignore: use_build_context_synchronously
      ConstantWidget.massage(
        context: context,
        text: "You did not select an image 😒",
      );
      notifyListeners();
      return;
    }
  }

  void selectVideo(
    BuildContext context, {
    required ImageSource source,
    required String receiverUserID,
    required UserData senderUser,
  }) async {
    final XFile? video = await picker.pickVideo(
      source: source,
    );
    if (video != null) {
      videoFile = File(video.path);
      // ignore: use_build_context_synchronously
      sendFileMessage(
        context,
        receiverUserID: receiverUserID,
        senderUser: senderUser,
        messageEnum: MessageEnum.video,
      );
      notifyListeners();
    } else {
      // ignore: use_build_context_synchronously
      ConstantWidget.massage(
        context: context,
        text: "You did not select an video 😒",
      );
      notifyListeners();
      return;
    }
  }

  void openAudio(FlutterSoundRecorder flutterSoundRecorder) async {
    final PermissionStatus state = await Permission.microphone.request();
    if (state != PermissionStatus.granted) {
      throw RecordingPermissionException("Permission not found");
    }
    await flutterSoundRecorder.openRecorder();
    isRecordInt = true;
    notifyListeners();
  }

  void closeRecorder() {
    isRecordInt = false;
    notifyListeners();
  }

  void getTempDir(Directory tempDir) async {
    pathAudio = "${tempDir.path}/flutter_sound.aac";
    notifyListeners();
  }

  void changeIsRecording() {
    isRecording = !isRecording;
    notifyListeners();
  }

  void sendMessage(
    BuildContext context, {
    required String message,
    required String receiverUserID,
    required UserData senderUser,
  }) {
    _chatDatabase.sendTextMessage(
      message: message,
      receiverUserID: receiverUserID,
      senderUser: senderUser,
    );
    messageController.text = "";
    isTyping = false;
    notifyListeners();
    /* try {

    } catch (e) {
      ConstantWidget.massage(context: context, text: e.toString());
      notifyListeners();
    }*/
  }

  void sendFileMessage(
    BuildContext context, {
    required String receiverUserID,
    required UserData senderUser,
    required MessageEnum messageEnum,
  }) {
    _chatDatabase.sendFileMessage(
      file: messageEnum == MessageEnum.image
          ? imageFile!
          : messageEnum == MessageEnum.audio
              ? File(pathAudio)
              : videoFile!,
      receiverUserID: receiverUserID,
      senderUser: senderUser,
      messageTypeEnum: messageEnum,
    );
    notifyListeners();
  }

  Stream<List<ChatContactModel>> getChatContact() {
    return _chatDatabase.getChatContact();
  }

  Stream<List<MessageModel>> getMessages({required String receiverUserID}) {
    return _chatDatabase.getMessages(receiverUserID: receiverUserID);
  }
}
