import 'package:flutter_bloc/flutter_bloc.dart';
import '../../models/post_model.dart';
import '../../models/todo_model.dart';
import '../../repositories/user_repository.dart';
import '../../error handling/error_handler.dart';
import 'user_detail_event.dart';
import 'user_detail_state.dart';

class UserDetailBloc extends Bloc<UserDetailEvent, UserDetailState> {
  final UserRepository userRepository;
  // Keep track of data fetched to prevent race conditions
  List<Post>? _cachedPosts;
  List<Todo>? _cachedTodos;

  UserDetailBloc({required this.userRepository}) : super(UserDetailInitial()) {
    on<UserDetailFetched>(_onUserDetailFetched);
    on<UserPostsFetched>(_onUserPostsFetched);
    on<UserTodosFetched>(_onUserTodosFetched);
    on<UserPostAdded>(_onUserPostAdded);
  }

  Future<void> _onUserDetailFetched(
    UserDetailFetched event,
    Emitter<UserDetailState> emit,
  ) async {
    emit(UserDetailLoading());
    try {
      _cachedPosts = null;
      _cachedTodos = null;
      
      // Fetch user data
      final user = await userRepository.getUserById(event.userId);
      
      // Create initial state with null posts and todos
      emit(UserDetailLoaded(
        user: user,
        posts: null,
        todos: null,
      ));
      
      // Automatically fetch posts and todos
      add(UserPostsFetched(event.userId));
      add(UserTodosFetched(event.userId));
    } catch (e) {
      emit(UserDetailError(ErrorHandler.getErrorMessage(e)));
    }
  }

  Future<void> _onUserPostsFetched(
    UserPostsFetched event,
    Emitter<UserDetailState> emit,
  ) async {
    final currentState = state;
    if (currentState is UserDetailLoaded) {
      try {
        final postsResponse = await userRepository.getUserPosts(event.userId);
        
        // Cache the posts
        _cachedPosts = postsResponse.posts;
        
        
        // Create a new state using both cached data sources
        emit(UserDetailLoaded(
          user: currentState.user,
          posts: _cachedPosts,
          todos: _cachedTodos,  // Use cached todos if available
        ));
      } catch (e) {
        // Log error but don't change state
        print('Failed to load posts: ${ErrorHandler.getErrorMessage(e)}');
      }
    }
  }

  Future<void> _onUserTodosFetched(
    UserTodosFetched event,
    Emitter<UserDetailState> emit,
  ) async {
    final currentState = state;
    if (currentState is UserDetailLoaded) {
      try {
        final todosResponse = await userRepository.getUserTodos(event.userId);
        
        // Cache the todos
        _cachedTodos = todosResponse.todos;
        
        emit(UserDetailLoaded(
          user: currentState.user,
          posts: _cachedPosts,  // Use cached posts if available
          todos: _cachedTodos,
        ));
      } catch (e) {
        // Log error but don't change state
        print('Failed to load todos: ${ErrorHandler.getErrorMessage(e)}');
      }
    }
  }
  
  // Handle adding a new local post
  void _onUserPostAdded(
    UserPostAdded event,
    Emitter<UserDetailState> emit,
  ) {
    final currentState = state;
    if (currentState is UserDetailLoaded) {
      // Get current posts or initialize empty list
      final currentPosts = _cachedPosts ?? [];
      
      // Create a new local post
      final newPost = Post.local(
        title: event.title,
        body: event.body,
        userId: event.userId,
      );
      
      // Add the post to the list of posts at the beginning
      final updatedPosts = [newPost, ...currentPosts];
      
      // Update the cache
      _cachedPosts = updatedPosts;
      
      // Emit new state with all data
      emit(UserDetailLoaded(
        user: currentState.user,
        posts: _cachedPosts,
        todos: _cachedTodos,
      ));
    }
  }
}
