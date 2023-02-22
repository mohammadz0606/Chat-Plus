class MessageModel {
  final String senderID;
  final String receiverID;
  final String message;
  final DateTime timeSend;
  final String messageID;
  final String messageType;
  final bool isSeen;
  final DateTime timeServer;

  Map<String, dynamic> toJson() {
    return {
      "senderID": senderID,
      "receiverID": receiverID,
      "message": message,
      "timeSend": timeSend.toIso8601String(),
      "messageID": messageID,
      "messageType": messageType,
      "isSeen": isSeen,
      "timeServer": timeServer.toIso8601String(),
    };
  }

  const MessageModel({
    required this.senderID,
    required this.receiverID,
    required this.message,
    required this.timeSend,
    required this.messageID,
    required this.messageType,
    required this.isSeen,
    required this.timeServer,
  });

  factory MessageModel.fromJson(Map<String, dynamic> json) {
    return MessageModel(
      senderID: json["senderID"],
      receiverID: json["receiverID"],
      message: json["message"],
      timeSend: DateTime.parse(json["timeSend"]),
      messageID: json["messageID"],
      messageType: json["messageType"],
      isSeen: json["isSeen"],
      timeServer: DateTime.parse(json["timeServer"]),
    );
  }
}
