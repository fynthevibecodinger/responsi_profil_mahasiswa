import 'package:flutter/foundation.dart';

/// Tingkat kepentingan log.
enum LogLevel { debug, info, warning, error }

/// Logger aman yang hanya aktif pada mode debug.
///
/// Data sensitif seperti token, password, dan API key disamarkan
/// sebelum dicetak agar tidak bocor ke log.
class Logger {
  /// Log informasi teknis.
  static void debug(String message, {Object? error, StackTrace? stackTrace}) {
    _log(LogLevel.debug, message, error: error, stackTrace: stackTrace);
  }

  /// Log informasi umum.
  static void info(String message, {Object? error, StackTrace? stackTrace}) {
    _log(LogLevel.info, message, error: error, stackTrace: stackTrace);
  }

  /// Log kondisi yang berpotensi bermasalah.
  static void warning(String message, {Object? error, StackTrace? stackTrace}) {
    _log(LogLevel.warning, message, error: error, stackTrace: stackTrace);
  }

  /// Log kesalahan.
  static void error(String message, {Object? error, StackTrace? stackTrace}) {
    _log(LogLevel.error, message, error: error, stackTrace: stackTrace);
  }

  static void _log(
    LogLevel level,
    String message, {
    Object? error,
    StackTrace? stackTrace,
  }) {
    if (!kDebugMode) return;

    final label = level.name.toUpperCase();
    final buffer = StringBuffer('[$label] ${_redact(message)}');

    if (error != null) {
      buffer.write(' | error: ${_redact(error.toString())}');
    }

    debugPrint(buffer.toString());

    if (stackTrace != null) {
      debugPrint(stackTrace.toString());
    }
  }

  /// Menyamarkan nilai sensitif sebelum log dicetak.
  static String _redact(String text) {
    var redacted = text.replaceAllMapped(
      RegExp(r'\bbearer\s+[^\s,;]+', caseSensitive: false),
      (_) => 'Bearer ***',
    );

    redacted = redacted.replaceAllMapped(
      RegExp(
        r'\b(password|passwd|token|api[_-]?key|authorization|secret)\b(\s*[:=]\s*)([^\s,;]+)',
        caseSensitive: false,
      ),
      (match) => '${match[1]}${match[2]}***',
    );

    return redacted;
  }
}
