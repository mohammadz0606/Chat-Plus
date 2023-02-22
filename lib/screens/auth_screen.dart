import 'package:chats/helper/constant_widget.dart';
import 'package:chats/service/provider/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../helper/colors.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({Key? key}) : super(key: key);

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final TextEditingController _phoneController = TextEditingController();
  final GlobalKey<FormState> _key = GlobalKey<FormState>();

  @override
  void dispose() {
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          "Chat Plus",
          style: TextStyle(
            color: Colors.white,
            fontSize: 22.sp,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _key,
          child: Consumer<UserProvider>(
            builder: (context, provider, child) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Text(
                        "Chats will need to verify your phone number",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 15,
                        ),
                      ),
                      SizedBox(height: 10.h),
                      TextButton(
                        onPressed: () {
                          provider.pickCountry(context);
                        },
                        child: const Text(
                          "Pick Country",
                          style: TextStyle(
                            fontSize: 15,
                          ),
                        ),
                      ),
                      SizedBox(height: 5.h),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            "+",
                            style: TextStyle(color: Colors.white, fontSize: 16),
                          ),
                          Text(
                            provider.countrySelected == null
                                ? "962"
                                : provider.countrySelected!.phoneCode,
                            style: const TextStyle(
                                color: Colors.white, fontSize: 16),
                          ),
                          SizedBox(width: 10.w),
                          SizedBox(
                            width: 200.w,
                            child: TextFormField(
                              cursorColor: tabColor,
                              style: const TextStyle(
                                color: Colors.white,
                              ),
                              validator: (String? userPhone) {
                                if (userPhone!.isEmpty) {
                                  return "phone must not empty";
                                }
                                return null;
                              },
                              controller: _phoneController,
                              keyboardType: TextInputType.phone,
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
                                hintText: "phone number",
                                hintStyle: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w300,
                                  fontSize: 14,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  Visibility(
                    visible: !provider.isLogin,
                    replacement: ConstantWidget.loading(context),
                    child: ElevatedButton(
                      onPressed: () {
                        if (_key.currentState!.validate()) {
                          FocusScope.of(context).unfocus();
                          provider.setPhoneNumber =
                              "${"+"}${provider.countrySelected == null ? "962" : provider.countrySelected!.phoneCode}${_phoneController.text.trim()}";
                          provider.signInChat(
                            context,
                            phoneNumber:
                                "${"+"}${provider.countrySelected == null ? "962" : provider.countrySelected!.phoneCode}${_phoneController.text.trim()}",
                          );
                        }
                      },
                      child: const Text("Next"),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
