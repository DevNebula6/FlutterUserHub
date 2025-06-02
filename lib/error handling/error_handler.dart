import 'package:dio/dio.dart';

class ErrorHandler {
  static String getErrorMessage(dynamic error) {
    if (error == null) {
      return 'An unknown error occurred';
    }
    
    if (error is String) {
      return error;
    }
    
    if (error is DioException) {
      return _handleDioError(error);
    }
    
    // Handle common error patterns
    String errorMessage = error.toString();
    
    // Handle network errors
    if (errorMessage.contains('SocketException') || 
        errorMessage.contains('Connection refused')) {
      return 'Network connection error. Please check your internet connection.';
    }
    
    // Default error message
    return errorMessage.length > 100 
        ? 'Something went wrong. Please try again later.' 
        : errorMessage;
  }
  
  static String _handleDioError(DioException error) {
    // First check if there's a message in the response data
    if (error.response != null) {
      // For 404 errors specifically
      if (error.response!.statusCode == 404) {
        if (error.requestOptions.path.contains('/otp')) {
          return 'The email address was not found or is invalid. Please check and try again.';
        }
        return 'Resource not found. Please try again later.';
      }
      
      // Try to extract message from response data
      if (error.response!.data != null) {
        try {
          if (error.response!.data is Map && error.response!.data['message'] != null) {
            return error.response!.data['message'];
          } else if (error.response!.data is String) {
            var data = error.response!.data as String;
            if (data.contains('Cannot POST')) {
              return 'This feature is currently unavailable. Please try again later.';
            }
            return data;
          }
        } catch (e) {
          // Ignore parsing errors and fall back to status code handling
        }
      }
    }
    
    // Handle based on exception type
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
        return 'Connection timed out. Please check your internet connection.';
      case DioExceptionType.sendTimeout:
        return 'Send timeout. Please try again.';
      case DioExceptionType.receiveTimeout:
        return 'Receive timeout. Please try again.';
      case DioExceptionType.badResponse:
        return _handleBadResponse(error);
      case DioExceptionType.cancel:
        return 'Request was cancelled.';
      case DioExceptionType.connectionError:
        return 'No internet connection.';
      default:
        return 'Network error occurred. Please try again.';
    }
  }

  static String _handleBadResponse(DioException error) {
    final statusCode = error.response?.statusCode;
    
    switch (statusCode) {
      case 400:
        return 'Invalid request. Please check your input.';
      case 401:
        return 'Please log in to continue.';
      case 403:
        return 'Access denied. You may not have permission to access this feature.';
      case 404:
        return 'Resource not found. This email may not be registered.';
      case 409:
        return 'This email is already registered. Please try logging in.';
      case 422:
        return 'Please check your input and try again.';
      case 500:
        return 'Server error. Please try again later.';
      default:
        return 'Error: ${error.response?.statusMessage ?? 'Unknown error'}';
    }
  }
}
