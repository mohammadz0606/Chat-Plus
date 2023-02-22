import 'package:flutter/material.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import '../call_data/app_database.dart';
import '../model/user_model.dart';

class AppProvider extends ChangeNotifier {
  List<UserData> allContactFirebase = [];
  List<Contact> allContactDevice = [];
  UserData? userDataChat;
  String selectContactNumber = "";
  final AppDatabase _appDatabase = AppDatabase();

  void selectAContact(String phone){
    selectContactNumber = phone;
    notifyListeners();
  }

  Future<void> getAllContacts() async {
    try {
      allContactFirebase = await _appDatabase.getAllContact();
      notifyListeners();
      if (await FlutterContacts.requestPermission()) {
        allContactDevice =
            await FlutterContacts.getContacts(withProperties: true);
        allContactDevice = allContactDevice.where((element) => element.phones.isNotEmpty).toList();
        notifyListeners();
      }
    } catch (e) {
      notifyListeners();
    }
  }

  void goToChat({required String id}) async {
    if (userDataChat != null) {
      userDataChat = null;
      notifyListeners();
    }
    userDataChat = allContactFirebase.firstWhere((element) => element.id == id);
    notifyListeners();
  }

  Stream<UserData> getAppBarDataInChat(String userID) {
    return _appDatabase.getAppBarDataInChat(userID);
  }
}
