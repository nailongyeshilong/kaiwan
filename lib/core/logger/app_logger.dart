import 'dart:developer' as developer;

abstract final class AppLogger {
  static void info(
    String message, {
    String scope = 'KaiPlay',
  }) {
    developer.log(message, name: scope);
  }

  static void error(
    String message, {
    required Object error,
    required StackTrace stackTrace,
    String scope = 'KaiPlay',
  }) {
    developer.log(
      message,
      name: scope,
      level: 1000,
      error: error,
      stackTrace: stackTrace,
    );
  }
}
