import 'package:cloud_firestore/cloud_firestore.dart';

import '../../helper/shared_preferences.dart';
import '../model/user_model.dart';
import '/service/call_data/database.dart';

class AppDatabase extends Database {
  Future<List<UserData>> getAllContact() async {
    List<UserData> allContact = [];
    try {
      QuerySnapshot contacts = await firestore
          .collection("users")
          .where(
            "id",
            isNotEqualTo: SaveData.getString(key: "userPhone"),
          )
          .get();
      for (int i = 0; i < contacts.docs.length; i++) {
        allContact.add(UserData.fromJson(contacts.docs[i]));
      }
      return allContact;
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Stream<UserData> getAppBarDataInChat(String userID) {
    return firestore.collection("users").doc(userID).snapshots().map((event) {
      return UserData.fromJson(event.data());
    });
  }
}
