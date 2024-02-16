class UserModel {
  final String name;
  final String userId;
  final String phoneNumber;
  final String email;
  final String city;
  List<String>? savedAddresses;
  List<UserModel>? closeRelatives;
  final String safeWord;
  final List<String> emergencyNumbers;

  UserModel({
    required this.name,
    required this.userId,
    required this.phoneNumber,
    required this.email,
    required this.city,
    this.savedAddresses,
    this.closeRelatives,
    required this.safeWord,
    required this.emergencyNumbers,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'name': name,
      'userId': userId,
      'phoneNumber': phoneNumber,
      'email': email,
      'savedAddresses': savedAddresses,
      'city': city,
      'closeRelatives': closeRelatives != null
          ? closeRelatives!.map((x) => x.toMap()).toList()
          : null,
      'safeWord': safeWord,
      'emergencyNumbers': emergencyNumbers,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      name: map['name'] as String,
      userId: map['userId'] as String,
      phoneNumber: map['phoneNumber'] as String,
      email: map['email'] as String,
      city: map['city'] as String,
      savedAddresses: map['savedAddresses'] != null
          ? List<String>.from(map['savedAddresses'] as List<dynamic>)
          : null,
      closeRelatives: map['closeRelatives'] != null
          ? (map['closeRelatives'] as List<dynamic>)
              .map<UserModel>((x) => UserModel.fromMap(x as Map<String, dynamic>))
              .toList()
          : null,
      safeWord: map['safeWord'] as String,
      emergencyNumbers: List<String>.from(map['emergencyNumbers'] as List<dynamic>),
    );
  }
}
