import 'dart:async';
import 'dart:io';
import 'package:image_cropper/image_cropper.dart';
import 'package:mime/mime.dart';
import 'package:path/path.dart' as path;
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:form_builder_file_picker/form_builder_file_picker.dart';
import 'package:image_picker/image_picker.dart';

Future<List<PlatformFile>?> pickFile({
  List<String>? allowedExtensions,
}) async {
  try {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: allowedExtensions != null ? FileType.custom : FileType.any,
      allowedExtensions: allowedExtensions,
    );

    if (result != null) {
      return result.files;
    } else {
      return null;
    }
  } catch (e) {
    debugPrint('Error picking file: $e');
    return null;
  }
}

Future<PlatformFile?> cropImage(PlatformFile? imageFile) async {
  if (imageFile != null) {
    final croppedFile = await ImageCropper().cropImage(
      sourcePath: imageFile.path!,
      aspectRatio: const CropAspectRatio(ratioX: 1, ratioY: 1),
      uiSettings: [
        AndroidUiSettings(
          toolbarTitle: 'Crop Image',
          toolbarColor: Colors.blue,
          toolbarWidgetColor: Colors.white,
          activeControlsWidgetColor: Colors.blue,
          lockAspectRatio: false,
        ),
        IOSUiSettings(
          title: 'Crop Image',
        ),
      ],
    );
    return croppedFile != null ? convertFileToPlatformFile(File(croppedFile.path)) : null;
  }
  return null;
}

PlatformFile convertFileToPlatformFile(File file) {
  return PlatformFile(
    name: file.path.split('/').last,
    path: file.path,
    size: file.lengthSync(),
    bytes: file.readAsBytesSync(),
  );
}

Future clearFileCache() async {
  await FilePicker.platform.clearTemporaryFiles();
}

String getFileSize(PlatformFile file) {
  int fileSizeInBytes = file.size;
  double fileSizeInKB = fileSizeInBytes / 1024;
  double fileSizeInMB = fileSizeInKB / 1024;

  if (fileSizeInMB >= 1) {
    return '${fileSizeInMB.toStringAsFixed(2)} MB';
  } else {
    return '${fileSizeInKB.toStringAsFixed(2)} KB';
  }
}

Future<Map<String, String>> getFileDetailsFromUrl(String url) async {
  Dio dio = Dio();

  try {
    Response response = await dio.head(url);

    if (response.statusCode == 200) {
      final contentLength = response.headers.value('content-length');
      final fileName = url.split('/').last;

      return {
        'name': fileName,
        'size': contentLength != null ? '${(int.parse(contentLength) / 1024).toStringAsFixed(2)} KB' : 'Unknown',
        'url': url,
      };
    } else {
      return {'Error': 'Failed to retrieve file details. Status code: ${response.statusCode}'};
    }
  } catch (e) {
    return {'Error': 'Failed to get file details: $e'};
  }
}

Future<XFile?> pickImage({ImageSource source = ImageSource.gallery}) async {
  try {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(
      source: source,
      maxWidth: 1024,
      maxHeight: 1024,
      imageQuality: 85,
    );

    return image;
  } catch (e) {
    debugPrint('Error picking image: $e');
    return null;
  }
}

Future<List<PlatformFile>> convertXFilesToPlatformFiles(List<XFile> xFiles) async {
  List<PlatformFile> platformFiles = [];

  for (XFile xFile in xFiles) {
    File file = File(xFile.path);
    platformFiles.add(
      PlatformFile(
        name: xFile.name,
        path: xFile.path,
        size: await file.length(),
        bytes: await file.readAsBytes(),
      ),
    );
  }

  return platformFiles;
}

Future<Size> getImageSize(BuildContext context, String imageUrl) async {
  final Image image = Image.network(imageUrl);

  final Completer<Size> completer = Completer<Size>();
  image.image.resolve(const ImageConfiguration()).addListener(
    ImageStreamListener((ImageInfo info, bool _) {
      final double imageWidth = info.image.width.toDouble();
      final double imageHeight = info.image.height.toDouble();
      final size = MediaQuery.of(context).size;

      final maxWidth = size.width * 0.9;
      final maxHeight = size.height * 0.7;

      double widthScale = 1.0;
      double heightScale = 1.0;

      if (imageWidth > maxWidth) {
        widthScale = maxWidth / imageWidth;
      }
      if (imageHeight > maxHeight) {
        heightScale = maxHeight / imageHeight;
      }

      final scale = widthScale < heightScale ? widthScale : heightScale;

      final finalWidth = imageWidth * scale;
      final finalHeight = imageHeight * scale;

      completer.complete(Size(finalWidth, finalHeight));
    }),
  );

  return completer.future;
}

class FileInfo {
  final String extension;
  final String mimeType;

  FileInfo(String filePath)
      : extension = path.extension(filePath),
        mimeType = lookupMimeType(filePath) ?? 'application/octet-stream';
}

Future<Uri> getSafeUri(String filePath) async {
  if (Platform.isAndroid) {
    File file = File(filePath);
    if (!file.existsSync()) {
      throw Exception('File tidak ditemukan: $filePath');
    }

    return Uri.parse('content://${Uri.file(file.path).path}');
  } else if (Platform.isIOS) {
    return Uri.file(filePath);
  } else {
    throw UnsupportedError('Platform tidak didukung');
  }
}
