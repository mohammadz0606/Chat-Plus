import '/helper/message_enum.dart';
import 'package:chats/service/provider/chat_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';

import '../helper/colors.dart';
import '../helper/constant_widget.dart';
import '../service/provider/app_provider.dart';
import '../service/provider/user_provider.dart';

class ChatField extends StatefulWidget {
  const ChatField({Key? key}) : super(key: key);

  @override
  State<ChatField> createState() => _ChatFieldState();
}

class _ChatFieldState extends State<ChatField> {
  FlutterSoundRecorder? _flutterSoundRecorder;

  @override
  void initState() {
    _flutterSoundRecorder = FlutterSoundRecorder();
    Provider.of<ChatProvider>(context, listen: false)
        .openAudio(_flutterSoundRecorder!);
    super.initState();
  }

  @override
  void dispose() {
    _flutterSoundRecorder!.closeRecorder();
    Provider.of<ChatProvider>(context, listen: false).closeRecorder();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ChatProvider>(
      builder: (context, provider, child) {
        return Row(
          children: [
            Expanded(
              child: TextField(
                controller: provider.messageController,
                onChanged: (String typing) {
                  provider.onChangedMode(provider.messageController.text);
                },
                style: const TextStyle(
                  color: Colors.white,
                ),
                cursorColor: tabColor,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: mobileChatBoxColor,
                  suffixIcon: Visibility(
                    visible: !provider.isTyping,
                    child: SizedBox(
                      width: 60.w,
                      child: IconButton(
                        onPressed: () {
                          FocusScope.of(context).unfocus();
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
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      _buildOptions(
                                        iconData: Icons.camera,
                                        onPressed: () {
                                          provider.selectImage(
                                            receiverUserID:
                                                Provider.of<AppProvider>(
                                              context,
                                              listen: false,
                                            ).userDataChat!.id,
                                            senderUser:
                                                Provider.of<UserProvider>(
                                              context,
                                              listen: false,
                                            ).userData!,
                                            context,
                                            source: ImageSource.camera,
                                          );
                                          Navigator.of(context).pop();
                                        },
                                      ),
                                      SizedBox(width: 12.w),
                                      _buildOptions(
                                        iconData: Icons.image,
                                        onPressed: () {
                                          provider.selectImage(
                                            receiverUserID:
                                                Provider.of<AppProvider>(
                                              context,
                                              listen: false,
                                            ).userDataChat!.id,
                                            senderUser:
                                                Provider.of<UserProvider>(
                                              context,
                                              listen: false,
                                            ).userData!,
                                            context,
                                            source: ImageSource.gallery,
                                          );
                                          Navigator.of(context).pop();
                                        },
                                      ),
                                      SizedBox(width: 12.w),
                                      _buildOptions(
                                        iconData: Icons.video_call_rounded,
                                        onPressed: () {
                                          provider.selectVideo(
                                            receiverUserID:
                                                Provider.of<AppProvider>(
                                              context,
                                              listen: false,
                                            ).userDataChat!.id,
                                            senderUser:
                                                Provider.of<UserProvider>(
                                              context,
                                              listen: false,
                                            ).userData!,
                                            context,
                                            source: ImageSource.camera,
                                          );
                                          Navigator.of(context).pop();
                                        },
                                      ),
                                      SizedBox(width: 12.w),
                                      _buildOptions(
                                        iconData:
                                            Icons.video_camera_back_rounded,
                                        onPressed: () {
                                          provider.selectVideo(
                                            receiverUserID:
                                                Provider.of<AppProvider>(
                                              context,
                                              listen: false,
                                            ).userDataChat!.id,
                                            senderUser:
                                                Provider.of<UserProvider>(
                                              context,
                                              listen: false,
                                            ).userData!,
                                            context,
                                            source: ImageSource.gallery,
                                          );
                                          Navigator.of(context).pop();
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                        icon: const Icon(
                          Icons.camera_alt,
                        ),
                        color: Colors.grey,
                      ),
                    ),
                  ),
                  hintText: 'Message',
                  hintStyle: const TextStyle(
                    color: Colors.grey,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20.0.r),
                    borderSide: BorderSide(
                      width: 0.w,
                      style: BorderStyle.none,
                    ),
                  ),
                  contentPadding: const EdgeInsets.all(10),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 2, right: 2, bottom: 8),
              child: provider.isTyping
                  ? CircleAvatar(
                      backgroundColor: tabColor,
                      radius: 25.r,
                      child: IconButton(
                        icon: const Icon(
                          Icons.send,
                          color: Colors.white,
                        ),
                        onPressed: () {
                          provider.sendMessage(
                            context,
                            message: provider.messageController.text.trim(),
                            receiverUserID: Provider.of<AppProvider>(
                              context,
                              listen: false,
                            ).userDataChat!.id,
                            senderUser: Provider.of<UserProvider>(
                              context,
                              listen: false,
                            ).userData!,
                          );
                        },
                      ),
                    )
                  : CircleAvatar(
                      backgroundColor: tabColor,
                      radius: 25.r,
                      child: IconButton(
                        icon: Icon(
                          provider.isRecording ? Icons.close : Icons.mic,
                          color: Colors.white,
                        ),
                        onPressed: () async {
                          var tempDir = await getTemporaryDirectory();
                          provider.getTempDir(tempDir);
                          if (!provider.isRecordInt) {
                            return;
                          }
                          if (provider.isRecording) {
                            await _flutterSoundRecorder!.stopRecorder();
                            // ignore: use_build_context_synchronously
                            provider.sendFileMessage(
                              context,
                              // ignore: use_build_context_synchronously
                              receiverUserID: Provider.of<AppProvider>(
                                context,
                                listen: false,
                              ).userDataChat!.id,
                              // ignore: use_build_context_synchronously
                              senderUser: Provider.of<UserProvider>(
                                context,
                                listen: false,
                              ).userData!,
                              messageEnum: MessageEnum.audio,
                            );
                          } else {
                            await _flutterSoundRecorder!.startRecorder(
                              toFile: provider.pathAudio,
                            );
                          }
                          provider.changeIsRecording();
                        },
                      ),
                    ),
            ),
          ],
        );
      },
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
