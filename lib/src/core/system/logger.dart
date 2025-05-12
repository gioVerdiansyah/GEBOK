import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';

enum LogLevel { info, warning, error, debug }

class Logger {
  static Future<String> _getDocumentsDirectory() async {
    try {
      final directory = await getExternalStorageDirectory();
      if (directory != null) {
        final documentsDir = Directory('${directory.parent.path}/Documents');
        return documentsDir.path;
      }
    } on PlatformException catch (e) {
      debugPrint('Error: $e');
    }
    return '';
  }

  static Future<void> log(
      String title,
      String message, {
        String? source,
        StackTrace? stackTrace,
        LogLevel level = LogLevel.info,
      }) async {
    final now = DateTime.now();
    final logLevelStr = level.toString().split('.').last.toLowerCase();
    final logLevelLabel = level.toString().split('.').last.toUpperCase();
    final timestamp = DateFormat('yyyy-MM-dd HH:mm:ss').format(now);

    String logLine = '[$timestamp]\n=== $title ===\n';

    if (source != null) logLine += 'Source: $source\n';
    if (stackTrace != null) logLine += 'Stack Trace:\n$stackTrace\n';

    logLine += "Message:\n$message\n";
    logLine += "--------------------------------------------------------------------------------------------\n";

    final basePath = await _getDocumentsDirectory;
    final folderPath = '$basePath/$logLevelStr';
    final fileName = '${DateFormat('ddMMyyyy').format(now)}_${logLevelLabel}_log.log';
    final logFile = File('$folderPath/$fileName');

    if (!(await logFile.parent.exists())) {
      await logFile.parent.create(recursive: true);
    }

    await logFile.writeAsString(logLine, mode: FileMode.append, flush: true);
  }

  static Future<void> info(String title, String message, {String? source, StackTrace? stackTrace}) =>
      log(title, message, level: LogLevel.info, source: source, stackTrace: stackTrace);

  static Future<void> warning(String title, String message, {String? source, StackTrace? stackTrace}) =>
      log(title, message, level: LogLevel.warning, source: source, stackTrace: stackTrace);

  static Future<void> error(String title, String message, {String? source, StackTrace? stackTrace}) =>
      log(title, message, level: LogLevel.error, source: source, stackTrace: stackTrace);

  static Future<void> debug(String title, String message, {String? source, StackTrace? stackTrace}) =>
      log(title, message, level: LogLevel.debug, source: source, stackTrace: stackTrace);
}
