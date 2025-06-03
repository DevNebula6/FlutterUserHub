import '../../user/user_model.dart';

class AuthResponse {
  final String? accessToken;
  final String? refreshToken;  
  final User? user;
  final String? message;
  final bool success;

  AuthResponse({
    this.accessToken,
    this.refreshToken,
    this.user,
    this.message,
    this.success = false,
  });

  factory AuthResponse.fromJson(Map<String, dynamic> json) {
  final hasToken = json['accessToken'] != null;
  
  // Create User from fields in the root JSON response
  User? user = hasToken ? User.fromJson({
    'id': json['id']?.toString(),
    'username': json['username'],
    'email': json['email'],
    'firstName': json['firstName'],
    'lastName': json['lastName'],
    'gender': json['gender'],
    'image': json['image'],
  }) : null;

  return AuthResponse(
    accessToken: json['accessToken'],
    refreshToken: json['refreshToken'],
    user: user,
    message: json['message'] ?? (hasToken ? 'success' : 'Authentication failed'),
    success: hasToken,
  );
}

  Map<String, dynamic> toJson() {
    return {
      'accessToken': accessToken,
      'refreshToken': refreshToken,
      'user': user?.toJson(),
      'message': message,
      'success': success,
    };
  }
}