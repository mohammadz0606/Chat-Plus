class UserData {
  final String id;
  final String name;
  final String about;
  final String phone;
  final String image;
  final bool isOnline;
  final List<String> groupID;

  factory UserData.fromJson(json) {
    return UserData(
      id: json["id"],
      name: json["name"],
      phone: json["phone"],
      image: json["image"],
      isOnline: json["isOnline"],
      groupID: List<String>.from(json["groupID"] as List).map((e) {
        return e;
      }).toList(),
      about: json["about"],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "name": name,
      "phone": phone,
      "image": image,
      "isOnline": isOnline,
      "groupID": groupID,
      "about": about,
    };
  }

  const UserData({
    required this.id,
    required this.name,
    required this.phone,
    required this.image,
    required this.isOnline,
    required this.groupID,
    required this.about,
  });
}
