import 'dart:io';

import 'package:chats/helper/constant_widget.dart';
import 'package:chats/screens/user_information_screen.dart';
import 'package:chats/service/model/user_model.dart';
import 'package:country_picker/country_picker.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../../helper/colors.dart';
import '../../helper/shared_preferences.dart';
import '../../screens/home_screen.dart';
import '../call_data/user_database.dart';

class UserProvider extends ChangeNotifier {
  Country? countrySelected;
  bool isLogin = false;
  bool isUploadData = false;
  String verificationId = "";
  final UserDatabase _userDatabase = UserDatabase();
  final ImagePicker picker = ImagePicker();
  File? profileImage;
  String _phoneNumber = "";
  UserData? userData;

  set setPhoneNumber(String phone) {
    _phoneNumber = phone;
    notifyListeners();
  }

  void pickCountry(BuildContext context) {
    showCountryPicker(
      context: context,
      showPhoneCode: true,
      onSelect: (Country country) {
        countrySelected = country;
        notifyListeners();
      },
    );
  }

  void signInChat(
    BuildContext context, {
    required String phoneNumber,
  }) async {
    try {
      isLogin = true;
      notifyListeners();
      await _userDatabase.signInChat(
        context,
        phoneNumber: phoneNumber,
      );
      notifyListeners();
    } catch (e) {
      ConstantWidget.dialog(
        context: context,
        color: appBarColor,
        title: const Text(
          "Problem",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        content: Text(
          e.toString(),
          style: const TextStyle(
            color: Colors.white,
          ),
        ),
      );
      notifyListeners();
    }
  }

  void verifyOTP(
    BuildContext context, {
    required String verificationId,
    required String userOTP,
  }) async {
    try {
      await _userDatabase.verifyOTP(
        context,
        verificationId: verificationId,
        userOTP: userOTP,
      );
      if (await _userDatabase.isExistingUser(
        phone: _phoneNumber,
      )) {
        endAuth();
        // ignore: use_build_context_synchronously
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) {
              return const HomeScreen();
            },
          ),
        );
      } else {
        // ignore: use_build_context_synchronously
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) {
              return const UserInformationScreen();
            },
          ),
        );
      }

      notifyListeners();
    } catch (e) {
      ConstantWidget.dialog(
        context: context,
        color: appBarColor,
        title: const Text(
          "Problem",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        content: Text(
          e.toString(),
          style: const TextStyle(
            color: Colors.white,
          ),
        ),
      );
      notifyListeners();
    }
  }

  void signOut(BuildContext context) async {
    try {
      await _userDatabase.signOut();
      await SaveData.sharedPreferences.clear();
      countrySelected = null;
      verificationId = "";
      profileImage = null;
      _phoneNumber = "";
      userData = null;
      isLogin = false;
      notifyListeners();
    } catch (e) {
      ConstantWidget.massage(
        context: context,
        text: e.toString(),
      );
      notifyListeners();
    }
  }

  void getProfileImage(
    BuildContext context, {
    required ImageSource source,
  }) async {
    final XFile? image = await picker.pickImage(
      source: source,
    );
    if (image != null) {
      profileImage = File(image.path);
      // ignore: use_build_context_synchronously
      Navigator.of(context).pop();
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

  void endAuth() {
    SaveData.setData(key: "goChat", value: true);
    SaveData.setString(key: "userPhone", value: _phoneNumber);
  }

  void setUserDataInDatabase(
    BuildContext context, {
    required String userName,
    required String about,
  }) async {
    try {
      isUploadData = true;
      notifyListeners();
      endAuth();
      String userImage = "";
      if (profileImage == null) {
        userImage =
            "https://png.pngitem.com/pimgs/s/649-6490124_katie-notopoulos-katienotopoulos-i-write-about-tech-round.png";
      } else {
        userImage = await _userDatabase.uploadImageProfileInFireStorage(
          image: profileImage!.path,
          fileImage: profileImage!,
        );
      }
      await _userDatabase.setUserData(
        userData: UserData(
          id: _phoneNumber,
          name: userName,
          phone: _phoneNumber,
          image: userImage,
          isOnline: true,
          groupID: [],
          about: about,
        ),
      );
      // ignore: use_build_context_synchronously
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) {
            return const HomeScreen();
          },
        ),
      );
      isUploadData = false;
      notifyListeners();
    } catch (e) {
      isUploadData = false;
      ConstantWidget.dialog(
        context: context,
        title: const Text(
          "Problem",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        content: Text(
          e.toString(),
          style: const TextStyle(
            color: Colors.white,
          ),
        ),
      );
      notifyListeners();
    }
  }

  void getUserDataInDatabase() async {
    try {
      userData = UserData.fromJson(await _userDatabase.getUserData());
      notifyListeners();
    } catch (e) {
      notifyListeners();
    }
  }

  void setUserIsOnline(bool isOnline) async {
    _userDatabase.setUserIsOnline(isOnline);
    notifyListeners();
  }
}
