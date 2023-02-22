import 'package:chats/helper/constant_widget.dart';
import 'package:chats/service/provider/app_provider.dart';
import 'package:intl/intl.dart';

import '../service/model/chat_contact_model.dart';
import '/service/provider/chat_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../helper/colors.dart';
import '../screens/chats_screen.dart';

class ContactsList extends StatelessWidget {
  const ContactsList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<ChatProvider>(
      builder: (context, provider, child) {
        return Padding(
          padding: const EdgeInsets.only(top: 10.0),
          child: StreamBuilder<List<ChatContactModel>>(
            stream: provider.getChatContact(),
            builder: (context, snapshot) {
              if (snapshot.data == null ||
                  snapshot.connectionState == ConnectionState.waiting) {
                return ConstantWidget.loading(context);
              } else {
                return ListView.builder(
                  shrinkWrap: true,
                  itemCount: snapshot.data!.length,
                  itemBuilder: (context, index) {
                    var contactData = snapshot.data![index];
                    return Column(
                      children: [
                        InkWell(
                          onTap: () {
                            Provider.of<AppProvider>(context, listen: false)
                                .goToChat(
                              id: contactData.contactID,
                            );
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => const ChatScreen(),
                              ),
                            );
                          },
                          child: Padding(
                            padding: const EdgeInsets.only(bottom: 8.0),
                            child: ListTile(
                              title: Text(
                                contactData.userName,
                                style: const TextStyle(
                                  fontSize: 18,
                                  color: Colors.white,
                                ),
                              ),
                              subtitle: Padding(
                                padding: const EdgeInsets.only(top: 6.0),
                                child: Text(
                                  contactData.lastMessage,
                                  style: const TextStyle(
                                    fontSize: 14,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                              leading: CircleAvatar(
                                backgroundImage: NetworkImage(
                                  contactData.image,
                                ),
                                radius: 30,
                              ),
                              trailing: Text(
                                DateFormat.Hm().format(contactData.timeSend),
                                style: const TextStyle(
                                  color: Colors.grey,
                                  fontSize: 13,
                                ),
                              ),
                            ),
                          ),
                        ),
                        if (index != snapshot.data!.length - 1)
                          const Divider(color: dividerColor, indent: 85),
                      ],
                    );
                  },
                );
              }
            },
          ),
        );
      },
    );
  }
}
