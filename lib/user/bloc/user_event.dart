import 'package:equatable/equatable.dart';

abstract class UserEvent extends Equatable {
  const UserEvent();
  
  @override
  List<Object?> get props => [];
}

class UserFetchRequested extends UserEvent {
  const UserFetchRequested();
}

class UserSearchRequested extends UserEvent {
  final String query;
  
  const UserSearchRequested(this.query);
  
  @override
  List<Object?> get props => [query];
}

class UserLoadMoreRequested extends UserEvent {
  const UserLoadMoreRequested();
}

class UserRefreshRequested extends UserEvent {
  const UserRefreshRequested();
}
