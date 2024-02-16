class UserModel {
  final String name;
  final String userId;
  final String phoneNumber;
  final String email;

  UserModel({
    required this.name,
    required this.userId,
    required this.phoneNumber,
    required this.email,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'name': name,
      'userId': userId,
      'phoneNumber': phoneNumber,
      'email': email,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      name: map['name'] as String,
      userId: map['userId'] as String,
      phoneNumber: map['phoneNumber'] as String,
      email: map['email'] as String,
    );
  }
}
