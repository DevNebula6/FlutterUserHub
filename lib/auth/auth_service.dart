import 'dart:convert';
import 'package:dio/dio.dart' show DioException;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../models/auth models/auth_request.dart';
import '../models/auth models/auth_response.dart';
import '../user/user_model.dart';
import 'auth_constants.dart';
import '../services/http_service.dart';

class AuthService {
  final HttpService _httpService = HttpService();
  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  // Check if user is logged in
  Future<bool> isLoggedIn() async {
    final hasToken = await _storage.read(key: ApiConstants.accessTokenKey) != null;
    
    return hasToken ;
  }

  // Get current user
  Future<User?> getCurrentUser() async {
    try {
      final userData = await _storage.read(key: ApiConstants.userKey);
      if (userData != null) {
        return User.fromJson(json.decode(userData));
      }
      return null;
    } catch (e) {
      return null;
    }
  }
  
  // Get current token
  Future<List<String?>> getToken() async {
    String? accessToken = await _storage.read(key: ApiConstants.accessTokenKey);
    String? refreshToken = await _storage.read(key: ApiConstants.refreshTokenKey);

    return [accessToken, refreshToken];
  }


  // Login with email and password
  Future<AuthResponse> login(String username, String password) async {
    try {
      final request = AuthRequest(
        username: username,
        password: password,
      );

      final response = await _httpService.dio.post(
        ApiConstants.loginEndpoint,
        data: request.toJson(),
      );
      print("LOGIN STATUS CODE: ${response.statusCode}");
      // Check if the response has an error status code
      if (response.statusCode! >= 400) {
        print("LOGIN ERROR: ${response.data}");
        // Extract error message from response body if it exists
        String errorMessage = 'Login failed';
        if (response.data is Map && response.data['message'] != null) {
          errorMessage = response.data['message'];
        }
        
        return AuthResponse(
          success: false,
          message: errorMessage,
        );
      }

      final authResponse = AuthResponse.fromJson(response.data);
      print("PARSED AUTH: ${authResponse.toJson()}");
      if (authResponse.accessToken != null  && authResponse.refreshToken != null) {
        // Save token
        await _storage.write(
          key: ApiConstants.accessTokenKey, 
          value: authResponse.accessToken
        );
        await _storage.write(
          key: ApiConstants.refreshTokenKey,
          value: authResponse.refreshToken
        );
        
        // Save user data
        if (authResponse.user != null) {
          await _storage.write(
            key: ApiConstants.userKey,
            value: json.encode(authResponse.user!.toJson())
          );
        }
      }
      
      return authResponse;
    } catch (e) {
      // Extract error message from Dio exceptions
      String errorMessage = 'Login failed';
      
      if (e is DioException) {
        if (e.response?.data is Map && e.response?.data['message'] != null) {
          errorMessage = e.response?.data['message'];
        } else if (e.error is String) {
          errorMessage = e.error.toString();
        }
      }
      
      return AuthResponse(
        success: false,
        message: errorMessage,
      );
    }
  }

  // logout user
  Future<void> logout() async {
    await _httpService.logout();
  }
}