import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';

import 'package:get/get.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:redstar_hightech_backend/app/modules/authentication/controllers/authentication_controller.dart';
import 'package:redstar_hightech_backend/app/modules/category/controllers/category_controller.dart';
import 'package:redstar_hightech_backend/app/shared/app_bar_widget.dart';
import 'package:redstar_hightech_backend/app/shared/app_search_delegate.dart';
import 'package:redstar_hightech_backend/app/shared/button_optional_menu.dart';

import '../../../constants/const.dart';
import '../../../services/database_service.dart';
import '../../../services/storage_services.dart';
import '../models/category_model.dart';
import 'package:path/path.dart' as path;

import '../../../services/image_upload_provider.dart';

class EditCategoryView extends GetView<CategoryController> {
  StorageService storage = StorageService();
  DatabaseService databaseService = DatabaseService();
  String doldOnwloadImageUrl = '';
  late List? imageDataFile = [];
  @override
  Widget build(BuildContext context) {
    Category category = ModalRoute.of(context)!.settings.arguments as Category;

    if (category.imageUrl != null) {
      controller.imageLocalPath.value = category.imageUrl;
      controller.newCategory.update("imageUrl", (_) => category.imageUrl,
          ifAbsent: () => category.imageUrl);
    }

    controller.newCategory
        .update("name", (_) => category.name, ifAbsent: () => category.name);

    return Scaffold(
      appBar: AppBarWidget(
        title: 'Edit Category ' + category.name,
        icon: Icons.search,
        bgColor: Colors.black,
        onPressed: () {
          showSearch(context: context, delegate: AppSearchDelegate());
        },
        authenticationController: Get.find<AuthenticationController>(),
        menuActionButton: ButtonOptionalMenu(),
        tooltip: 'Search',
      ),
      body: SingleChildScrollView(
        child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: /*Obx(() {
            return*/
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              SizedBox(
                width: MediaQuery.of(context).size.width,
                height: 210,
                child: InkWell(
                  onTap: () async {
                    imageDataFile = await getImage(ImageSource.gallery);
                  },
                  child: Obx(() {
                    return Card(
                      color: Colors.black,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          controller.imageLocalPath == ''
                              ? Container(
                                  padding: const EdgeInsets.all(30),
                                  decoration: const BoxDecoration(
                                    image: DecorationImage(
                                      image: AssetImage(
                                          "assets/images/add_image.png"),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  width: 150,
                                  height: 150,
                                )
                              : (controller.imageLocalPath
                                          .contains("https://") ||
                                      controller.imageLocalPath
                                          .contains("http://"))
                                  ? Image.network(
                                      controller.imageLocalPath.value,
                                      width: 150,
                                      height: 150,
                                      fit: BoxFit.cover,
                                    )
                                  : Container(
                                      padding: const EdgeInsets.all(20),
                                      decoration: BoxDecoration(
                                        image: DecorationImage(
                                          image: FileImage(File(
                                              controller.imageLocalPath.value)),
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                      width: 150,
                                      height: 150,
                                    ),

                          /*   controller.newCategory['imageUrl'] == null ||
                                  controller.newCategory['imageUrl'] == ""
                              ? Container(
                                  padding: const EdgeInsets.all(30),
                                  decoration: const BoxDecoration(
                                    image: DecorationImage(
                                      image: AssetImage(
                                          "assets/images/add_image.png"),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  width: MediaQuery.of(context).size.width - 28,
                                  height: 150,
                                )
                              : Image.network(
                                  controller.newCategory['imageUrl'],
                                  width: MediaQuery.of(context).size.width - 30,
                                  height: 140,
                                  fit: BoxFit.cover,
                                ) */
                          /* : Container(
                                  decoration: BoxDecoration(
                                    image: DecorationImage(
                                      image: FileImage(File(category.imageUrl)),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  width: MediaQuery.of(context).size.width - 28,
                                  height: 150,
                                ) */
                        ],
                      ),
                    );
                  }),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 8.0),
                child: Text(
                  "Category Information",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              _buildTextFormField("Category Name", 'name', category.name),
              Center(
                child: ElevatedButton(
                    style: ElevatedButton.styleFrom(primary: Colors.black),
                    onPressed: () {
                      var lastName = '';
                      print(controller.newCategory);

                      if (category.imageUrl != null) {
                        lastName = category.imageUrl.split("/").last;
                      }

                      databaseService.updateCategory(
                        Category(
                          id: category.id!,
                          name: controller.newCategory['name'],
                          imageUrl: imageDataFile!.isNotEmpty
                              ? controller.newCategory['imageUrl']
                              : category.imageUrl,
                        ),
                      );

                      if (imageDataFile!.isNotEmpty) {
                        deleteAndUploadNewImage(
                            lastName, imageDataFile![0], imageDataFile![1]);
                      }

                      /*  var imageUrl =
                          await storage.getDownloadURL(category.imageUrl);
                      await storage.storage
                          .ref('product_images/${imageUrl}')
                          .delete(); */

                      Navigator.pop(context);
                    },
                    child: const Text(
                      "Save",
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    )),
              )
            ])
            //}),
            ),
      ),
    );
  }

  Padding _buildTextFormField(String hintText, name, String? initialValue) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: TextFormField(
        initialValue: initialValue,
        decoration: InputDecoration(hintText: hintText),
        onChanged: (value) {
          controller.newCategory
              .update(name, (_) => value, ifAbsent: () => value);
        },
      ),
    );
  }

  Future<List<dynamic>?> getImage(ImageSource source) async {
    var pickedImageFile = await ImagePicker().getImage(source: source);

    if (pickedImageFile != null) {
      final selectedImagePath = pickedImageFile.path;
      final cropImageFile = await ImageCropper.platform.cropImage(
          sourcePath: selectedImagePath,
          maxHeight: 512,
          maxWidth: 512,
          compressFormat: ImageCompressFormat.jpg);
      final croppedImagdePath = cropImageFile!.path;

      final dir = await Directory.systemTemp;
      final targetPath = dir.absolute.path + "/temp.jpg";

      var compressedFile = await FlutterImageCompress.compressAndGetFile(
          croppedImagdePath, targetPath,
          quality: 90);

      var fileName = path.basename(selectedImagePath);

      final imageFile = File(targetPath);

      //  uploadImage(imageFile, fileName);
      String imageUrl = "${domainUrl}assets/images/uploads/" + fileName;

      controller.newCategory
          .update("imageUrl", (_) => imageUrl, ifAbsent: () => imageUrl);

      controller.imageLocalPath.value = targetPath;

      return [imageFile, fileName];
    }
  }

  deleteAndUploadNewImage(
      String oldFileName, File compressedFile, String newFileName) {
    ImageUploadProvider()
        .deleteAndUploadNewFile(oldFileName, compressedFile, newFileName)
        .then((resp) {
      var msg = resp.toString();
      print("the message is: " + msg);

      if (msg == "success") {
        Get.snackbar("Success", "File Uploaded",
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.green,
            colorText: Colors.white);
      } else if (msg == "fail") {
        Get.snackbar("Error", "Failled to upload the image",
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.red,
            colorText: Colors.white);
      } else {
        Get.snackbar("Error", "Unknown Error",
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.red,
            colorText: Colors.white);
      }
    });
  }

  uploadImage(File compressedFile, String filename) {
    Get.dialog(
        const Center(
          child: CircularProgressIndicator(),
        ),
        barrierDismissible: false);

    ImageUploadProvider().uploadImage(compressedFile, filename).then((resp) {
      Get.back();
      var msg = resp[0].toString();
      filename = resp[1].toString();

      if (msg == "success") {
        Get.snackbar("Success", "File Uploaded",
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.green,
            colorText: Colors.white);
      } else if (msg == "fail") {
        Get.snackbar("Error", "Failled to upload the image",
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.red,
            colorText: Colors.white);
      } else {
        Get.snackbar("Error", "Unknown Error",
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.red,
            colorText: Colors.white);
      }
    });
  }
}
