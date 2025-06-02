import 'package:flutter/material.dart';

enum SnackBarType {
  success,
  error,
  info,
  warning,
}

class EnhancedSnackBar {
  static void show({
    required BuildContext context,
    required String message,
    SnackBarType type = SnackBarType.info,
    Duration duration = const Duration(seconds: 3),
    VoidCallback? onAction,
    String? actionLabel,
  }) {
    // Dismiss any existing snackbar
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    
    // Icon and color based on type
    IconData icon;
    Color backgroundColor;
    Color textColor = Colors.white;
    
    switch (type) {
      case SnackBarType.success:
        icon = Icons.check_circle;
        backgroundColor = Colors.green.shade600;
        break;
      case SnackBarType.error:
        icon = Icons.error;
        backgroundColor = Colors.red.shade500;
        break;
      case SnackBarType.warning:
        icon = Icons.warning_amber_rounded;
        backgroundColor = Colors.orange.shade800;
        break;
      case SnackBarType.info:
      default:
        icon = Icons.info_outline;
        backgroundColor = Colors.blue.shade600;
        break;
    }
    
    final SnackBar snackBar = SnackBar(
      content: Row(
        children: [
          Icon(icon, color: textColor, size: 24),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              message,
              style: TextStyle(
                color: textColor,
                fontFamily: 'PP Pangram Sans Rounded',
                fontSize: 14,
              ),
            ),
          ),
        ],
      ),
      backgroundColor: backgroundColor,
      duration: duration,
      behavior: SnackBarBehavior.floating,
      margin: const EdgeInsets.all(16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      action: actionLabel != null && onAction != null
          ? SnackBarAction(
              label: actionLabel,
              textColor: textColor,
              onPressed: onAction,
            )
          : null,
    );
    
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
  
  static void showSuccess(BuildContext context, String message, {Duration? duration}) {
    show(
      context: context,
      message: message,
      type: SnackBarType.success,
      duration: duration ?? const Duration(seconds: 3),
    );
  }
  
  static void showError(BuildContext context, String message, {Duration? duration}) {
    show(
      context: context,
      message: message,
      type: SnackBarType.error,
      duration: duration ?? const Duration(seconds: 4),
    );
  }
  
  static void showInfo(BuildContext context, String message, {Duration? duration}) {
    show(
      context: context,
      message: message,
      type: SnackBarType.info,
      duration: duration ?? const Duration(seconds: 3),
    );
  }
  
  static void showWarning(BuildContext context, String message, {Duration? duration}) {
    show(
      context: context,
      message: message,
      type: SnackBarType.warning,
      duration: duration ?? const Duration(seconds: 4),
    );
  }
}
