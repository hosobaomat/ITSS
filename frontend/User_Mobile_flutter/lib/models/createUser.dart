class User {
  final String username;
  final String password;
  final String email;
  final String fullName;
  final String role;

  User({
    required this.username,
    required this.password,
    required this.email,
    required this.fullName,
    required this.role,
  });

  Map<String, dynamic> toJson() {
    return {
      'username': username,
      'password': password,
      'email': email,
      'fullName': fullName,
      'role': role,
    };
  }
}
