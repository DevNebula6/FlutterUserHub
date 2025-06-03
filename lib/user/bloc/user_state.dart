import 'package:equatable/equatable.dart';
import '../user_model.dart';

abstract class UserState extends Equatable {
  const UserState();
  
  @override
  List<Object?> get props => [];
}

class UserInitial extends UserState {}

class UserLoading extends UserState {}

class UserLoaded extends UserState {
  final List<User> users;
  final int total;
  final int skip;
  final int limit;
  final bool hasReachedMax;
  final String? searchQuery;
  
  const UserLoaded({
    required this.users,
    required this.total,
    required this.skip,
    required this.limit,
    this.hasReachedMax = false,
    this.searchQuery,
  });
  
  @override
  List<Object?> get props => [users, total, skip, limit, hasReachedMax, searchQuery];
  
  UserLoaded copyWith({
    List<User>? users,
    int? total,
    int? skip,
    int? limit,
    bool? hasReachedMax,
    String? searchQuery,
  }) {
    return UserLoaded(
      users: users ?? this.users,
      total: total ?? this.total,
      skip: skip ?? this.skip,
      limit: limit ?? this.limit,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
      searchQuery: searchQuery ?? this.searchQuery,
    );
  }
}

class UserError extends UserState {
  final String message;
  
  const UserError(this.message);
  
  @override
  List<Object?> get props => [message];
}

class UserSearching extends UserState {
  final String query;
  
  const UserSearching(this.query);
  
  @override
  List<Object?> get props => [query];
}
