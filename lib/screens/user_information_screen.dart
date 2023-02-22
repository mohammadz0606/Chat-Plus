import 'package:chats/helper/colors.dart';
import 'package:chats/helper/constant_widget.dart';
import 'package:chats/service/provider/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class UserInformationScreen extends StatefulWidget {
  const UserInformationScreen({Key? key}) : super(key: key);

  @override
  State<UserInformationScreen> createState() => _UserInformationScreenState();
}

class _UserInformationScreenState extends State<UserInformationScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _aboutController = TextEditingController();
  final GlobalKey<FormState> _key = GlobalKey<FormState>();

  @override
  void dispose() {
    _nameController.dispose();
    _aboutController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          "Information's",
          style: TextStyle(
            color: Colors.white,
            fontSize: 22.sp,
          ),
        ),
      ),
      body: Form(
        key: _key,
        child: SafeArea(
          child: Center(
            child: Consumer<UserProvider>(
              builder: (context, provider, child) {
                return Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        children: [
                          Stack(
                            children: [
                              provider.profileImage == null
                                  ? CircleAvatar(
                                      radius: 71.r,
                                      backgroundImage: const NetworkImage(
                                        "https://png.pngitem.com/pimgs/s/649-6490124_katie-notopoulos-katienotopoulos-i-write-about-tech-round.png",
                                      ),
                                    )
                                  : CircleAvatar(
                                      radius: 71.r,
                                      backgroundImage: FileImage(
                                        provider.profileImage!,
                                      ),
                                    ),
                              Positioned(
                                bottom: 0,
                                left: 100,
                                child: CircleAvatar(
                                  backgroundColor: tabColor,
                                  child: IconButton(
                                    onPressed: () {
                                      ConstantWidget.bottomSheet(
                                        context,
                                        size: 110.h,
                                        widget: Column(
                                          children: [
                                            const Divider(
                                              thickness: 4,
                                              color: Colors.white,
                                              indent: 95,
                                              endIndent: 95,
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.all(20),
                                              child: Row(
                                                children: [
                                                  _buildOptions(
                                                    iconData: Icons.camera,
                                                    onPressed: () {
                                                      provider.getProfileImage(
                                                        context,
                                                        source:
                                                            ImageSource.camera,
                                                      );
                                                    },
                                                  ),
                                                  SizedBox(width: 12.w),
                                                  _buildOptions(
                                                    iconData: Icons.image,
                                                    onPressed: () {
                                                      provider.getProfileImage(
                                                        context,
                                                        source:
                                                            ImageSource.gallery,
                                                      );
                                                    },
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      );
                                    },
                                    color: Colors.white,
                                    icon: const Icon(
                                      Icons.add_a_photo,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Container(
                            width: 255.w,
                            padding: const EdgeInsets.all(20),
                            child: TextFormField(
                              controller: _nameController,
                              keyboardType: TextInputType.name,
                              validator: (String? userName) {
                                if (userName!.isEmpty) {
                                  return "must not empty";
                                } else if (userName.length < 3) {
                                  return "length more 3 char";
                                }
                                return null;
                              },
                              style: const TextStyle(
                                color: Colors.white,
                              ),
                              decoration: const InputDecoration(
                                  hintText: "user name",
                                  hintStyle: TextStyle(
                                    color: Colors.white,
                                  )),
                            ),
                          ),
                          Container(
                            width: 255.w,
                            padding: const EdgeInsets.all(20),
                            child: TextFormField(
                              controller: _aboutController,
                              keyboardType: TextInputType.text,
                              validator: (String? about) {
                                if (about!.isEmpty) {
                                  return "must not empty";
                                } else if (about.length < 4) {
                                  return "length more 4 char";
                                }
                                return null;
                              },
                              style: const TextStyle(
                                color: Colors.white,
                              ),
                              decoration: const InputDecoration(
                                  hintText: "about",
                                  hintStyle: TextStyle(
                                    color: Colors.white,
                                  )),
                            ),
                          ),
                        ],
                      ),
                      Visibility(
                        visible: !provider.isUploadData,
                        replacement: ConstantWidget.loading(context),
                        child: ElevatedButton(
                          onPressed: () {
                            if (_key.currentState!.validate()) {
                              FocusScope.of(context).unfocus();
                              provider.setUserDataInDatabase(
                                context,
                                userName: _nameController.text.trim(),
                                about: _aboutController.text.trim(),
                              );
                            }
                          },
                          child: const Text("Accept"),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  CircleAvatar _buildOptions({
    required IconData iconData,
    required Function() onPressed,
  }) {
    return CircleAvatar(
      radius: 27.r,
      backgroundColor: tabColor,
      child: IconButton(
        onPressed: onPressed,
        color: Colors.white,
        icon: Icon(
          iconData,
          size: 27,
        ),
      ),
    );
  }
}
