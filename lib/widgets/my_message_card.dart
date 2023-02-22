import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../helper/colors.dart';
import 'display_chat.dart';

class MyMessageCard extends StatelessWidget {
  final String message;
  final String date;
  final String messageEnum;

  const MyMessageCard({
    Key? key,
    required this.message,
    required this.date,
    required this.messageEnum,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerRight,
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: 255.w,
        ),
        child: Card(
          elevation: 1,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          color: messageColor,
          margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
          child: Stack(
            children: [
              Padding(
                padding: const EdgeInsets.only(
                  left: 10,
                  right: 42,
                  top: 5,
                  bottom: 20,
                ),
                child: DisplayChat(
                  message: message,
                  type: messageEnum,
                ),
              ),
              Positioned(
                bottom: 0,
                right: 8,
                child: Row(
                  children: [
                    Text(
                      date,
                      style: const TextStyle(
                        fontSize: 13,
                        color: Colors.white60,
                      ),
                    ),
                    const SizedBox(
                      width: 5,
                    ),
                    const Icon(
                      Icons.done_all,
                      size: 20,
                      color: Colors.white60,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
