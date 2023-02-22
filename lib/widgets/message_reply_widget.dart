import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../service/model/message_reply_model.dart';

class MessageReplyWidget extends StatelessWidget {
  const MessageReplyWidget({
    Key? key,
    required this.messageReplyModel,
  }) : super(key: key);
  final MessageReplyModel messageReplyModel;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 350.w,
      padding: const EdgeInsets.all(8),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  messageReplyModel.isMe ? "Yes" : "No",
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
              GestureDetector(
                onTap: () {},
                child: const Icon(
                  Icons.close,
                  color: Colors.grey,
                  size: 16,
                ),
              ),
            ],
          ),
          SizedBox(height: 8.h),
          Text(messageReplyModel.message),
        ],
      ),
    );
  }
}
