import 'package:chats/widgets/sender_message.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../helper/constant_widget.dart';
import '../helper/shared_preferences.dart';
import '../service/model/message_model.dart';
import '../service/provider/chat_provider.dart';
import 'my_message_card.dart';

class ChatList extends StatefulWidget {
  const ChatList({
    Key? key,
    required this.receiverUserID,
  }) : super(key: key);
  final String receiverUserID;

  @override
  State<ChatList> createState() => _ChatListState();
}

class _ChatListState extends State<ChatList> {
  final ScrollController messageAutoScrolled = ScrollController();

  @override
  void dispose() {
    messageAutoScrolled.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ChatProvider>(
      builder: (context, provider, child) {
        return StreamBuilder<List<MessageModel>>(
          stream: provider.getMessages(receiverUserID: widget.receiverUserID),
          builder: (context, snapshot) {
            if (snapshot.data == null) {
              return ConstantWidget.loading(context);
            } else {
              SchedulerBinding.instance.addPostFrameCallback((_) {
                messageAutoScrolled
                    .jumpTo(messageAutoScrolled.position.maxScrollExtent);
              });
              return ListView.builder(
                controller: messageAutoScrolled,
                itemCount: snapshot.data!.length,
                itemBuilder: (context, index) {
                  final messageData = snapshot.data![index];
                  var date = DateFormat.Hm().format(messageData.timeSend);
                  if (messageData.senderID ==
                      SaveData.getString(key: "userPhone")) {
                    return MyMessageCard(
                      message: messageData.message,
                      date: date,
                      messageEnum: messageData.messageType,
                    );
                  }
                  return SenderMessageCard(
                    message: messageData.message,
                    date: date,
                    messageEnum: messageData.messageType,
                  );
                },
              );
            }
          },
        );
      },
    );
  }
}
