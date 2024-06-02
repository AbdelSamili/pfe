import 'package:logger/logger.dart';

class AppLoggerHelper {
  static final Logger _logger = Logger(
    printer: PrettyPrinter(),
    // Customize the log Levels based on your needs
    level: Level.debug,
  );

  // Method to log debug messages
  static void debug(String message) {
    _logger.d(message);
  }

  // Method to log info messages
  static void info(String message) {
    _logger.i(message);
  }

  // Method to log warning messages
  static void warning(String message) {
    _logger.w(message);
  }

  // Method to log error messages
  static void error(String message, [dynamic error]) {
    _logger.e(message, error: error, stackTrace: StackTrace.current);
  }
}