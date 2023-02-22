import 'package:chats/screens/contacts_screen.dart';
import 'package:chats/screens/welcome_screen.dart';
import 'package:chats/service/provider/app_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../helper/colors.dart';
import '../service/provider/chat_provider.dart';
import '../service/provider/user_provider.dart';
import '../widgets/contacts_list.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with WidgetsBindingObserver {

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    var provider = Provider.of<UserProvider>(context,listen: false);
    switch(state){
      case AppLifecycleState.resumed:
        provider.setUserIsOnline(true);
        break;
      case AppLifecycleState.inactive:
      case AppLifecycleState.paused:
      case AppLifecycleState.detached:
        provider.setUserIsOnline(false);
        break;
    }
    super.didChangeAppLifecycleState(state);
  }
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback(
      (_) {
        Provider.of<UserProvider>(context, listen: false)
            .getUserDataInDatabase();

        Provider.of<AppProvider>(context, listen: false).getAllContacts();

        Provider.of<ChatProvider>(context, listen: false).getChatContact();
      },
    );
    WidgetsBinding.instance.addObserver(this);
    super.initState();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.addObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            'Chat Plus',
            style: TextStyle(
              fontSize: 20,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.logout, color: Colors.grey),
              onPressed: () {
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(
                    builder: (context) {
                      return WelcomeScreen();
                    },
                  ),
                );
                Provider.of<UserProvider>(context, listen: false)
                    .signOut(context);
              },
            ),
            IconButton(
              icon: const Icon(Icons.settings, color: Colors.grey),
              onPressed: () {},
            ),
          ],
          bottom: const TabBar(
            indicatorColor: tabColor,
            indicatorWeight: 4,
            labelColor: tabColor,
            unselectedLabelColor: Colors.grey,
            labelStyle: TextStyle(
              fontWeight: FontWeight.bold,
            ),
            tabs: [
              Tab(
                text: 'CHATS',
              ),
              Tab(
                text: 'STATUS',
              ),
              Tab(
                text: 'CALLS',
              ),
            ],
          ),
        ),
        body: const ContactsList(),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) {
                  return const ContactsScreen();
                },
              ),
            );
          },
          backgroundColor: tabColor,
          child: const Icon(
            Icons.chat_rounded,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
