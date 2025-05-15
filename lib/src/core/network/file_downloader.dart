import 'dart:convert';

import 'package:dio/dio.dart';

import '../../shared/utils/file_handler.dart';
import '../../shared/utils/get_directory_path.dart';
import '../system/notification_service.dart';

Future<void> downloadFile(
    {required String url, required String fileName, String doneTitle = "Selesai me-download file"}) async {
  final FileInfo fileInfo = FileInfo(url);
  final String fileExtension = fileInfo.extension.isNotEmpty ? fileInfo.extension : ".png";

  final savePath = await getSavePath("$fileName$fileExtension");
  int progress = 0;

  await Dio().download(
    url,
    savePath,
    onReceiveProgress: (received, total) {
      progress = ((received / total) * 100).toInt();

      NotificationService.downloadNotification(id: 0, title: 'Downloading File', body: '$progress%', progress: progress);
    },
  );

  NotificationService.cancel(id: 0);

  NotificationService.showNotification(
      id: 1,
      title: doneTitle,
      body: "File di simpan di: $savePath \n Ketuk untuk membuka",
      payload: jsonEncode({"filePath": savePath}));
}
