import 'package:chats/service/provider/app_provider.dart';
import 'package:chats/widgets/chat_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../helper/colors.dart';
import '../service/model/user_model.dart';
import '../widgets/chat_list.dart';

class ChatScreen extends StatelessWidget {
  const ChatScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<AppProvider>(
      builder: (context, provider, child) {
        var userChat = provider.userDataChat!;
        return Scaffold(
          appBar: AppBar(
            backgroundColor: appBarColor,
            title: StreamBuilder<UserData>(
              stream: provider.getAppBarDataInChat(userChat.id),
              builder: (context, snapshot) {
                if(snapshot.connectionState == ConnectionState.waiting){
                  return Text(
                    userChat.name,
                    style: const TextStyle(
                      color: Colors.white,
                    ),
                  );
                }
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      userChat.name,
                      style: const TextStyle(
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      snapshot.data!.isOnline ? "Online" : "Offline",
                      style: TextStyle(color: Colors.white, fontSize: 11.sp),
                    ),
                  ],
                );
              }
            ),
            centerTitle: false,
            actions: [
              IconButton(
                onPressed: () {},
                icon: const Icon(Icons.video_chat),
              ),
              IconButton(
                onPressed: () {},
                icon: const Icon(Icons.call),
              ),
              IconButton(
                onPressed: () {},
                icon: const Icon(Icons.more_vert),
              ),
            ],
          ),
          body: Column(
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(top: 7),
                  child: ChatList(
                    receiverUserID: userChat.id,
                  ),
                ),
              ),
              const ChatField(),
            ],
          ),
        );
      },
    );
  }
}
