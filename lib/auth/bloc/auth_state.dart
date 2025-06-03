import 'package:equatable/equatable.dart';
import '../../user/user_model.dart';

abstract class AuthState extends Equatable {
  const AuthState();
  
  @override
  List<Object?> get props => [];
}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class Authenticated extends AuthState {
  final User user;
  final String accessToken;
  final String refreshToken;
  
  const Authenticated({required this.user, required this.accessToken, required this.refreshToken});
  
  @override
  List<Object?> get props => [user, accessToken, refreshToken];
}

class Unauthenticated extends AuthState {}

class AuthError extends AuthState {
  final String message;
  
  const AuthError(this.message);
  
  @override
  List<Object?> get props => [message];
}
