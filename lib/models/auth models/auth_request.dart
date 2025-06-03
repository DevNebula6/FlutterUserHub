class AuthRequest {
  final String username;
  final String password;
  final String? name;

  AuthRequest({
    required this.username, 
    required this.password, 
    this.name,
  });

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {
      'username': username,
      'password': password,
    };
    if (name != null) {
      data['name'] = name;
    }
    return data;
  }
}