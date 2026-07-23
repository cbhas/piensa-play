import 'package:flutter/foundation.dart';

/// Registro centralizado que no expone datos en compilaciones de produccion.
class AppLogger {
  static void _write(String level, String message) {
    if (kDebugMode) debugPrint('[$level] $message');
  }

  static void log(String message) => _write('INFO', message);
  static void success(String message) => _write('OK', message);
  static void warning(String message) => _write('WARN', message);
  static void error(String message) => _write('ERROR', message);
  static void debug(String message) => _write('DEBUG', message);
  static void refresh(String message) => _write('SYNC', message);
  static void info(String message) => _write('INFO', message);
}
