import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'auth_constants.dart';

class HttpService {
  static final HttpService _instance = HttpService._internal();
  final FlutterSecureStorage _storage = const FlutterSecureStorage();
  late final Dio dio;

  factory HttpService() => _instance;

  HttpService._internal() {
    dio = Dio(
      BaseOptions(
        connectTimeout: const Duration(seconds: 15),
        receiveTimeout: const Duration(seconds: 15),
        responseType: ResponseType.json,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        // Don't automatically throw an exception for error status codes
        // This allows us to handle the response and extract error messages
        validateStatus: (status) => true,
      ),
    );
    
    // Add logging interceptor for debugging
    dio.interceptors.add(LogInterceptor(
      requestBody: true,
      responseBody: true,
      logPrint: (object) => print('[HttpService] $object'),
    ));
    
    // Add interceptors for token handling
    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          final token = await _storage.read(key: ApiConstants.accessTokenKey);
          if (token != null) {
            options.headers['Authorization'] = 'Bearer $token';
          }
          return handler.next(options);
        },
        onResponse: (response, handler) {
          // For successful responses, just pass through
          if (response.statusCode! >= 200 && response.statusCode! < 300) {
            return handler.next(response);
          }
          
          // For error responses, extract the message if possible
          String? errorMessage;
          if (response.data is Map && response.data['message'] != null) {
            errorMessage = response.data['message'];
          } else if (response.data is String && response.data.isNotEmpty) {
            errorMessage = response.data;
          }
          
          // Create a DioException with the extracted message
          return handler.reject(
            DioException(
              requestOptions: response.requestOptions,
              response: response,
              // Include the extracted message in the error
              error: errorMessage ?? 'Request failed with status ${response.statusCode}',
            ),
          );
        },
      ),
    );
  }

  Future<void> logout() async {
    await _storage.deleteAll();
  }
}