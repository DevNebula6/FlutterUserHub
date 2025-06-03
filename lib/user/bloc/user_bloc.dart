import 'package:flutter_bloc/flutter_bloc.dart';
import '../../repositories/user_repository.dart';
import 'user_event.dart';
import 'user_state.dart';

class UserBloc extends Bloc<UserEvent, UserState> {
  final UserRepository _userRepository;
  final int _pageSize = 20;
  
  UserBloc({required UserRepository userRepository})
      : _userRepository = userRepository,
        super(UserInitial()) {
    on<UserFetchRequested>(_onUserFetchRequested);
    on<UserLoadMoreRequested>(_onUserLoadMoreRequested);
    on<UserSearchRequested>(_onUserSearchRequested);
    on<UserRefreshRequested>(_onUserRefreshRequested);
  }
  
  Future<void> _onUserFetchRequested(
    UserFetchRequested event,
    Emitter<UserState> emit,
  ) async {
    emit(UserLoading());
    try {
      final users = await _userRepository.getUsers(limit: _pageSize, skip: 0);
      emit(UserLoaded(
        users: users.users,
        total: users.total,
        skip: users.skip,
        limit: users.limit,
        hasReachedMax: users.users.length >= users.total,
      ));
    } catch (error) {
      emit(UserError(error.toString()));
    }
  }
  
  Future<void> _onUserLoadMoreRequested(
    UserLoadMoreRequested event,
    Emitter<UserState> emit,
  ) async {
    if (state is UserLoaded) {
      final currentState = state as UserLoaded;
      
      // Don't load more if we've reached the maximum
      if (currentState.hasReachedMax) return;
      
      try {
        // Different approach based on whether we're searching or not
        final nextUsers = currentState.searchQuery != null && currentState.searchQuery!.isNotEmpty
            ? await _userRepository.searchUsers(currentState.searchQuery!)
            : await _userRepository.getUsers(
                limit: _pageSize,
                skip: currentState.users.length,
              );
        
        // Check if we've reached the end
        final hasReachedMax = 
          (currentState.users.length + nextUsers.users.length) >= nextUsers.total;
        
        emit(currentState.copyWith(
          users: [...currentState.users, ...nextUsers.users],
          hasReachedMax: hasReachedMax,
          skip: currentState.skip + _pageSize,
        ));
      } catch (error) {
        emit(UserError(error.toString()));
      }
    }
  }
  
  Future<void> _onUserSearchRequested(
    UserSearchRequested event,
    Emitter<UserState> emit,
  ) async {
    emit(UserSearching(event.query));
    try {
      final results = await _userRepository.searchUsers(event.query);
      emit(UserLoaded(
        users: results.users,
        total: results.total,
        skip: results.skip,
        limit: results.limit,
        hasReachedMax: results.users.length >= results.total,
        searchQuery: event.query,
      ));
    } catch (error) {
      emit(UserError(error.toString()));
    }
  }
  
  Future<void> _onUserRefreshRequested(
    UserRefreshRequested event,
    Emitter<UserState> emit,
  ) async {
    try {
      if (state is UserLoaded) {
        final currentState = state as UserLoaded;
        
        // If we have a search query, refresh the search results
        if (currentState.searchQuery != null && currentState.searchQuery!.isNotEmpty) {
          final results = await _userRepository.searchUsers(currentState.searchQuery!);
          emit(UserLoaded(
            users: results.users,
            total: results.total,
            skip: results.skip,
            limit: results.limit,
            hasReachedMax: results.users.length >= results.total,
            searchQuery: currentState.searchQuery,
          ));
        } else {
          // Otherwise, refresh the full list
          final users = await _userRepository.getUsers(limit: _pageSize, skip: 0);
          emit(UserLoaded(
            users: users.users,
            total: users.total,
            skip: users.skip,
            limit: users.limit,
            hasReachedMax: users.users.length >= users.total,
          ));
        }
      } else {
        // If not in loaded state, just fetch from scratch
        add(const UserFetchRequested());
      }
    } catch (error) {
      emit(UserError(error.toString()));
    }
  }
}
