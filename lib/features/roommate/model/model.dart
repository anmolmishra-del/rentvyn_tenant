class RoommateModel {
  final int id;
  final String name;
  final String phoneNumber;
  final String email;
  final String gender;
  final String? photoUrl;

  final String roomNumber;
  final int roomId;

  RoommateModel({
    required this.id,
    required this.name,
    required this.phoneNumber,
    required this.email,
    required this.gender,
    this.photoUrl,
    required this.roomNumber,
    required this.roomId,
  });

  factory RoommateModel.fromJson(Map<String, dynamic> json) {
    return RoommateModel(
      id: json["id"],
      name: json["name"] ?? "",
      phoneNumber: json["phone_number"] ?? "",
      email: json["email"] ?? "",
      gender: json["gender"] ?? "",
      photoUrl: json["photo_url"],
      roomNumber: json["room"]?["room_number"] ?? "",
      roomId: json["room"]?["id"] ?? 0,
    );
  }
}