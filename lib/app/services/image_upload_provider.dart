import 'dart:io';

import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import '../constants/const.dart';

class ImageUploadProvider extends GetConnect {
  Future<List<dynamic>> uploadImage(File file, String fileName) async {
    try {
      final form = FormData({
        'file': MultipartFile(file, filename: fileName),
        'filename': fileName
      });
      final response = await post("${domainUrl}setfile", form);

      if (response.status.hasError) {
        return [Future.error(response.body).toString()];
      } else {
        //print(response.body);

        return response.body['result'];
      }
    } catch (e) {
      return [Future.error(e.toString()).toString()];
    }
  }

  Future<dynamic> deleteImage(String fileName) async {
    try {
      final form = FormData({'filename': fileName});
      final response = await post("${domainUrl}deletefile", form);

      if (response.status.hasError) {
        return Future.error(response.body).toString();
      } else {
        //print(response.body);

        return response.body['result'];
      }
    } catch (e) {
      return Future.error(e.toString()).toString();
    }
  }

  Future<dynamic> deleteAndUploadNewFile(
      String oldFileName, File file, String newFileName) async {
    try {
      final form = FormData({
        'file': MultipartFile(file, filename: newFileName),
        'oldFileName': oldFileName,
        'newFileName': newFileName
      });
      final response = await post("${domainUrl}setAndDeleteFile", form);

      if (response.status.hasError) {
        return Future.error(response.body).toString();
      } else {
        //print(response.body);

        return response.body['result'];
      }
    } catch (e) {
      return Future.error(e.toString()).toString();
    }
  }
}
