import 'package:equatable/equatable.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();
  
  @override
  List<Object?> get props => [];
}


class CheckAuthStatus extends AuthEvent {}

class LoginRequested extends AuthEvent {
  final String username;
  final String password;
  
  const LoginRequested({
    required this.username, 
    required this.password,
  });
  
  @override
  List<Object?> get props => [username, password];
}

class RegisterRequested extends AuthEvent {
  final String name;
  final String email;
  final String password;
  
  const RegisterRequested({
    required this.name,
    required this.email,
    required this.password,
  });
  
  @override
  List<Object?> get props => [name, email, password];
}

class LogoutRequested extends AuthEvent {}

