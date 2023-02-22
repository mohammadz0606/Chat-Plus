import 'package:chats/helper/colors.dart';
import 'package:chats/helper/constant_widget.dart';
import 'package:chats/widgets/contacts.dart';

import '/service/provider/app_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import 'chats_screen.dart';

class ContactsScreen extends StatelessWidget {
  const ContactsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Select Contact",
          style: TextStyle(
            color: Colors.white,
            fontSize: 20.sp,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(
              Icons.search,
              color: Colors.grey,
            ),
            onPressed: () {},
          ),
          SizedBox(width: 3.w),
        ],
      ),
      body: Consumer<AppProvider>(
        builder: (context, provider, child) {
          return Padding(
            padding: const EdgeInsets.only(top: 10, bottom: 10, left: 6),
            child: RefreshIndicator(
              backgroundColor: tabColor,
              color: Colors.white,
              onRefresh: () async {
                await provider.getAllContacts();
              },
              child: ListView.separated(
                physics: const AlwaysScrollableScrollPhysics(),
                itemCount: provider.allContactDevice.length,
                itemBuilder: (context, index) {
                  var contact = provider.allContactDevice[index];
                  return InkWell(
                    onTap: () {
                      if (contact.phones[0].number.toString().startsWith("0")) {
                        provider.selectAContact(
                          contact.phones[0].number.toString().replaceFirst("0", "+962").replaceAll(" ","").trim(),
                        );
                      }else{
                        provider.selectAContact(contact.phones[0].number.toString().replaceAll(" ","").trim());
                      }
                      if (provider.allContactFirebase
                          .any((element) => element.id == provider.selectContactNumber)) {
                        provider.goToChat(
                            id: provider.selectContactNumber);
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) {
                              return const ChatScreen();
                            },
                          ),
                        );
                      } else if (contact.phones.isEmpty) {
                        ConstantWidget.massage(
                          context: context,
                          text: "The user does not exist in the application",
                        );
                      } else {
                        ConstantWidget.massage(
                          context: context,
                          text: "The user does not exist in the application",
                        );
                      }
                    },
                    child: ContactsWidget(contact: contact),
                  );
                },
                separatorBuilder: (context, index) {
                  return const Divider(color: dividerColor);
                },
              ),
            ),
          );
        },
      ),
    );
  }
}
