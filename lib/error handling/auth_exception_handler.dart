import 'package:flutter/material.dart';

import '../utils/widgets/enhanced_snackbar.dart';

class AuthExceptionHandler {
  // Handle network related errors
  static void handleNetworkError(BuildContext context, dynamic error) {
    EnhancedSnackBar.showError(
      context,
      'Network error: Please check your internet connection.',
    );
  }
  
  // Handle authentication errors
  static void handleAuthError(BuildContext context, String message) {
    EnhancedSnackBar.showError(context, message);
  }
  
  // Handle validation errors
  static void handleValidationError(BuildContext context, String message) {
    EnhancedSnackBar.showError(context, message);
  }
  
  // Handle OTP related errors
  static void handleOtpError(BuildContext context, String message) {
    EnhancedSnackBar.showError(context, message);
  }
  
  // Handle success messages
  static void handleSuccess(BuildContext context, String message) {
    EnhancedSnackBar.showSuccess(context, message);
  }
}
