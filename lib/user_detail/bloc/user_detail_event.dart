import 'package:equatable/equatable.dart';

abstract class UserDetailEvent extends Equatable {
  const UserDetailEvent();

  @override
  List<Object> get props => [];
}

class UserDetailFetched extends UserDetailEvent {
  final int userId;

  const UserDetailFetched(this.userId);

  @override
  List<Object> get props => [userId];
}

class UserPostsFetched extends UserDetailEvent {
  final int userId;

  const UserPostsFetched(this.userId);

  @override
  List<Object> get props => [userId];
}

class UserTodosFetched extends UserDetailEvent {
  final int userId;

  const UserTodosFetched(this.userId);

  @override
  List<Object> get props => [userId];
}

class UserPostAdded extends UserDetailEvent {
  final int userId;
  final String title;
  final String body;

  const UserPostAdded({
    required this.userId,
    required this.title,
    required this.body,
  });

  @override
  List<Object> get props => [userId, title, body];
}
