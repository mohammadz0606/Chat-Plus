class ChatContactModel {
  final String userName;
  final String image;
  final String contactID;
  final DateTime timeSend;
  final String lastMessage;
  final DateTime timeServer;

  const ChatContactModel({
    required this.userName,
    required this.image,
    required this.contactID,
    required this.timeSend,
    required this.lastMessage,
    required this.timeServer,
  });

  Map<String, dynamic> toJson() {
    return {
      "userName": userName,
      "image": image,
      "contactID": contactID,
      "timeSend": timeSend.toIso8601String(),
      "lastMessage": lastMessage,
      "timeServer" : timeServer.toIso8601String(),
    };
  }

  factory ChatContactModel.fromJson(json) {
    return ChatContactModel(
      userName: json["userName"],
      image: json["image"],
      contactID: json["contactID"],
      timeSend: DateTime.parse(json["timeSend"]),
      lastMessage: json["lastMessage"],
      timeServer: DateTime.parse(json["timeServer"]),
    );
  }
}
