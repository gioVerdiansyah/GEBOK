import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';

Future<String> getDownloadDirectory() async {
  final directory = Directory('/storage/emulated/0/Download/Simaster Jakon');
  if (!await directory.exists()) {
    await directory.create(recursive: true);
  }
  return directory.path;
}

Future<String> getDocumentsDirectory() async {
  final directory = await getApplicationDocumentsDirectory();
  return directory.path;
}

Future<String> getSavePath(String fileName) async {
  if (Platform.isAndroid) {
    final directory = await getDownloadDirectory();
    final savePath = '$directory/$fileName';
    debugPrint("Get Save file: $savePath");
    return savePath;
  } else if (Platform.isIOS) {
    final directory = await getDocumentsDirectory();
    final savePath = '$directory/$fileName';
    debugPrint("Get Save file: $savePath");
    return savePath;
  } else {
    throw UnsupportedError('Platform not supported');
  }
}