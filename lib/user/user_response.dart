import 'package:equatable/equatable.dart';
import 'package:flutter_user_hub/user/user_model.dart';

class UserResponse extends Equatable {
  final List<User> users;
  final int total;
  final int skip;
  final int limit;

  const UserResponse({
    required this.users,
    required this.total,
    required this.skip,
    required this.limit,
  });

  factory UserResponse.fromJson(Map<String, dynamic> json) {
    return UserResponse(
      users: (json['users'] as List).map((user) => User.fromJson(user)).toList(),
      total: json['total'] ?? 0,
      skip: json['skip'] ?? 0,
      limit: json['limit'] ?? 0,
    );
  }

  @override
  List<Object?> get props => [users, total, skip, limit];
}

