import 'package:flutter/material.dart';
import 'error_handler.dart';
import '../utils/widgets/enhanced_snackbar.dart';

class GlobalErrorHandler {
  static void initialize() {
    // Handle Flutter errors
    FlutterError.onError = (FlutterErrorDetails details) {
      print('Flutter Error: ${details.exception}');
      print('Stack trace: ${details.stack}');
      
      // Forward to Flutter's console error handling
      FlutterError.dumpErrorToConsole(details);
    };
  }
  
  // This method can be called from anywhere in the app to show an error
  static void showError(BuildContext context, dynamic error) {
    final message = ErrorHandler.getErrorMessage(error);
    EnhancedSnackBar.showError(context, message);
  }
  
  // Show success message
  static void showSuccess(BuildContext context, String message) {
    EnhancedSnackBar.showSuccess(context, message);
  }
  
  // Show info message
  static void showInfo(BuildContext context, String message) {
    EnhancedSnackBar.showInfo(context, message);
  }
  
  // Show warning message
  static void showWarning(BuildContext context, String message) {
    EnhancedSnackBar.showWarning(context, message);
  }
}
