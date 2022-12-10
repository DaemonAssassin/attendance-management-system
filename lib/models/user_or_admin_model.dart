class UserOrAdmin {
  UserOrAdmin({
    required this.name,
    required this.image,
    required this.email,
    required this.password,
    required this.accountType,
  });

  final String name;
  final String image;
  final String email;
  final String password;
  final String accountType;

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'name': name,
      'image': image,
      'email': email,
      'password': password,
      'accountType': accountType,
    };
  }

  factory UserOrAdmin.fromMap(Map<String, dynamic> map) {
    return UserOrAdmin(
      name: map['name'] as String,
      image: map['image'] as String,
      email: map['email'] as String,
      password: map['password'] as String,
      accountType: map['accountType'] as String,
    );
  }
}
