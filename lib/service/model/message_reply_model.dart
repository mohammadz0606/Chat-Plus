class MessageReplyModel {
  final String message;
  final bool isMe;
  final String messageType;

/*  factory MessageReplyModel.fromJson(json) {
    return MessageReplyModel(
      message: json["message"],
      isMe: json["isMe"].toLowerCase() == 'true',
      messageType: json["messageType"],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "message": message,
      "isMe": isMe,
      "messageType": messageType,
    };
  }*/

  const MessageReplyModel({
    required this.message,
    required this.isMe,
    required this.messageType,
  });
}
