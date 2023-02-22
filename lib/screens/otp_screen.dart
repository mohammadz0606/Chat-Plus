import 'package:chats/service/provider/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../helper/colors.dart';

class OTPScreen extends StatelessWidget {
  OTPScreen({
    Key? key,
    required this.verificationId,
  }) : super(key: key);
  final String verificationId;

  final GlobalKey<FormState> _key = GlobalKey<FormState>();
  final FocusNode _focusOTP = FocusNode();
  final TextEditingController _otpText = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          "Verify Phone",
          style: TextStyle(
            color: Colors.white,
            fontSize: 22.sp,
          ),
        ),
      ),
      body: Form(
        key: _key,
        child: Consumer<UserProvider>(
          builder: (context, provider, child) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: 25.h),
                const Center(
                  child: Text(
                    "We have sent an SMS with a code",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16.5,
                    ),
                  ),
                ),
                SizedBox(height: 15.h),
                SizedBox(
                  width: 200.w,
                  child: TextFormField(
                    cursorColor: tabColor,
                    autofocus: true,
                    controller: _otpText,
                    focusNode: _focusOTP,
                    textInputAction: TextInputAction.done,
                    onEditingComplete: () {
                      if (_otpText.text.length == 6) {
                        FocusScope.of(context).unfocus();
                        provider.verifyOTP(
                          context,
                          verificationId: verificationId,
                          userOTP: _otpText.text.trim(),
                        );
                      }
                    },
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Colors.white,
                    ),
                    validator: (String? userPhone) {
                      if(userPhone!.length < 6 ){
                        return "Error";
                      }
                      return null;
                    },
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      enabled: true,
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: tabColor),
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: tabColor),
                      ),
                      border: UnderlineInputBorder(
                        borderSide: BorderSide(color: tabColor),
                      ),
                      hintText: "- - - - - - ",
                      hintStyle: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w300,
                        fontSize: 30,
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
