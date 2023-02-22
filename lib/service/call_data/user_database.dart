import 'dart:io';

import 'package:chats/screens/otp_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../helper/shared_preferences.dart';
import '../model/user_model.dart';
import 'database.dart';

class UserDatabase extends Database {
  Future<void> signInChat(
    BuildContext context, {
    required String phoneNumber,
  }) async {
    try {
      return await auth.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        verificationCompleted: (PhoneAuthCredential phoneAuthCredential) async {
          await auth.signInWithCredential(phoneAuthCredential);
        },
        verificationFailed: (e) {
          throw Exception(e.message);
        },
        codeSent: (
          String verificationId,
          int? forceResendingToken,
        ) {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (context) {
                return OTPScreen(
                  verificationId: verificationId,
                );
              },
            ),
          );
        },
        codeAutoRetrievalTimeout: (String verificationId) {},
      );
    } on FirebaseAuthException catch (e) {
      throw Exception(e.message);
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<UserCredential> verifyOTP(
    BuildContext context, {
    required String verificationId,
    required String userOTP,
  }) async {
    try {
      PhoneAuthCredential phoneAuthCredential = PhoneAuthProvider.credential(
        verificationId: verificationId,
        smsCode: userOTP,
      );
      return await auth.signInWithCredential(phoneAuthCredential);
    } on FirebaseAuthException catch (e) {
      throw Exception(e.message);
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<void> signOut() async {
    try {
      await auth.signOut();
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<void> setUserData({
    required UserData userData,
  }) async {
    try {
      return await firestore.collection("users").doc(userData.id).set(
            userData.toJson(),
          );
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<DocumentSnapshot> getUserData() async {
    try {
      return await firestore
          .collection("users")
          .doc(SaveData.getString(key: "userPhone"))
          .get();
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<String> uploadImageProfileInFireStorage({
    required String image,
    required File fileImage,
  }) async {
    String path =
        "usersImageProfile/${Uri.file(fileImage.path).pathSegments.last}";
    await reference.child(path).putFile(fileImage);
    final String getImageUrl = await reference.child(path).getDownloadURL();
    return getImageUrl;
  }

  Future<bool> isExistingUser({
    required String phone,
  }) async {
    DocumentSnapshot isExisting =
        await firestore.collection("users").doc(phone).get();
    return isExisting.exists;
  }

  Future<void> setUserIsOnline(bool isOnline) async {
    return await firestore
        .collection("users")
        .doc(SaveData.getString(key: "userPhone"))
        .update(
      {
        "isOnline": isOnline,
      },
    );
  }
}
