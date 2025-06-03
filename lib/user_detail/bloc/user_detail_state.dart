import 'package:equatable/equatable.dart';
import '../../models/post_model.dart';
import '../../models/todo_model.dart';
import '../../user/user_model.dart';

abstract class UserDetailState extends Equatable {
  const UserDetailState();

  @override
  List<Object?> get props => [];
}

class UserDetailInitial extends UserDetailState {}

class UserDetailLoading extends UserDetailState {}

class UserDetailLoaded extends UserDetailState {
  final User user;
  final List<Post>? posts;
  final List<Todo>? todos;

  const UserDetailLoaded({
    required this.user,
    this.posts,
    this.todos,
  });

  UserDetailLoaded copyWith({
    User? user,
    List<Post>? posts,
    List<Todo>? todos,
  }) {
    return UserDetailLoaded(
      user: user ?? this.user,
      posts: posts ?? this.posts,
      todos: todos ?? this.todos,
    );
  }

  @override
  List<Object?> get props => [user, posts, todos];
}

class UserDetailError extends UserDetailState {
  final String message;

  const UserDetailError(this.message);

  @override
  List<Object> get props => [message];
}
