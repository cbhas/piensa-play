// lib/core/services/logger_service.dart
// Logger service that only prints in debug mode

import 'package:flutter/foundation.dart';

/// A centralized logging service that only prints in debug mode.
/// Use this instead of print() statements throughout the app.
class AppLogger {
  /// Log a general message (blue icon)
  static void log(String message) {
    if (kDebugMode) {
      print('🔵 $message');
    }
  }

  /// Log a success message (green icon)
  static void success(String message) {
    if (kDebugMode) {
      print('🟢 $message');
    }
  }

  /// Log a warning message (yellow/orange icon)
  static void warning(String message) {
    if (kDebugMode) {
      print('⚠️ $message');
    }
  }

  /// Log an error message (red icon)
  static void error(String message) {
    if (kDebugMode) {
      print('❌ $message');
    }
  }

  /// Log a debug/trace message (for detailed debugging)
  static void debug(String message) {
    if (kDebugMode) {
      print('🔍 $message');
    }
  }

  /// Log a refresh/update message
  static void refresh(String message) {
    if (kDebugMode) {
      print('🔄 $message');
    }
  }

  /// Log an info message
  static void info(String message) {
    if (kDebugMode) {
      print('ℹ️ $message');
    }
  }
}
