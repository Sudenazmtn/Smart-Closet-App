class UserModel {
  const UserModel({
    required this.id,
    required this.firebaseUid,
    required this.name,
    required this.email,
    required this.createdAt,
  });

  final int id;
  final String firebaseUid;
  final String name;
  final String email;
  final DateTime createdAt;

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] as int,
      firebaseUid: json['firebase_uid'] as String,
      name: json['name'] as String,
      email: json['email'] as String,
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }
}
