import 'package:dio/dio.dart';
import '../models/post_model.dart';
import '../models/todo_model.dart';
import '../user/user_model.dart';
import '../user/user_response.dart';

class UserRepository {
  final Dio _dio;
  
  UserRepository({Dio? dio}) : _dio = dio ?? Dio(BaseOptions(
    baseUrl: 'https://dummyjson.com',
    connectTimeout: const Duration(seconds: 15),
    receiveTimeout: const Duration(seconds: 15),
  ));

  // Get user by ID
  Future<User> getUserById(int userId) async {
    try {
      final response = await _dio.get('/users/$userId');
      return User.fromJson(response.data);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  // Get users with pagination
  Future<UserResponse> getUsers({int limit = 10, int skip = 0}) async {
    try {
      final response = await _dio.get(
        '/users',
        queryParameters: {
          'limit': limit,
          'skip': skip,
        },
      );
      
      return UserResponse.fromJson(response.data);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  // Search users by query
  Future<UserResponse> searchUsers(String query) async {
    try {
      final response = await _dio.get(
        '/users/search',
        queryParameters: {
          'q': query,
        },
      );
      
      return UserResponse.fromJson(response.data);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  // Get user posts by user ID - correct endpoint 
  Future<PostResponse> getUserPosts(int userId) async {
    try {
      // Updated endpoint from /users/$userId/posts to /posts/user/$userId
      final response = await _dio.get('/posts/user/$userId');
      return PostResponse.fromJson(response.data);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<TodoResponse> getUserTodos(int userId) async {
    try {
      final response = await _dio.get('/todos/user/$userId');
      return TodoResponse.fromJson(response.data);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Exception _handleError(DioException e) {
    if (e.type == DioExceptionType.connectionTimeout ||
        e.type == DioExceptionType.receiveTimeout ||
        e.type == DioExceptionType.sendTimeout) {
      return Exception('Connection timeout. Please check your internet connection.');
    }
    
    if (e.type == DioExceptionType.connectionError) {
      return Exception('Network error. Please check your internet connection.');
    }
    
    if (e.response != null) {
      final statusCode = e.response!.statusCode;
      final message = e.response!.statusMessage;
      
      return Exception('API Error ($statusCode): ${message ?? "Unknown error"}');
    }
    
    return Exception('An unexpected error occurred: ${e.message}');
  }
}
