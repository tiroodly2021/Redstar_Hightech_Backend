import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';

import 'package:get/get.dart';
import 'package:googleapis/servicemanagement/v1.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:redstar_hightech_backend/app/constants/const.dart';
import 'package:redstar_hightech_backend/app/modules/category/controllers/category_controller.dart';

import 'package:redstar_hightech_backend/app/services/database_service.dart';
import 'package:redstar_hightech_backend/app/services/storage_services.dart';
import 'package:path/path.dart' as path;
import '../models/category_model.dart';
import '../../../services/image_upload_provider.dart';

class NewCategoryView extends GetView<CategoryController> {
  StorageService storage = StorageService();
  DatabaseService databaseService = DatabaseService();

  late List? imageDataFile;

  @override
  Widget build(BuildContext context) {
    //List<String> categories = ["Smoothies", "Soft Drinks", "Alix Shoes"];
    return Scaffold(
      appBar: AppBar(
        title: const Text('New Category'),
        centerTitle: true,
        backgroundColor: Colors.black,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Obx(() {
            return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 80,
                    child: InkWell(
                      onTap: () async {
                        /*ImagePicker _picker = ImagePicker();
                    final XFile? _image =
                        await _picker.pickImage(source: ImageSource.gallery);

                    if (_image == null) {
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                          content: Text("No Image Selected",
                              style:
                                  TextStyle(fontSize: 16, color: Colors.red))));
                    } else {
                      var selectedImagePath = _image.path;

                      Directory appDocumentsDirectory =
                          await getApplicationDocumentsDirectory();
                      String appDocumentsPath = appDocumentsDirectory.path;

                      var fileName = path.basename(selectedImagePath);

                      String imageUrl = '$appDocumentsPath/' + fileName;

                      await _image.saveTo(imageUrl);

                      final imageFile = File(imageUrl);

                      uploadImage(imageFile, fileName);

                      //  controller.newCategory.update("imageUrl", (_) => imageUrl,
                      //  ifAbsent: () => imageUrl);

                      // print(controller.newProduct['imageUrl']);
                    }*/

                        imageDataFile = await getImage(ImageSource.gallery);
                      },
                      child: Card(
                        color: Colors.black,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            IconButton(
                                onPressed: () {},
                                icon: const Icon(
                                  Icons.add_circle,
                                  color: Colors.white,
                                )),
                            const Text(
                              "Add Category Image",
                              style:
                                  TextStyle(fontSize: 22, color: Colors.white),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  /*    Container(
                margin: const EdgeInsets.symmetric(vertical: 20),
                //padding: const EdgeInsets.symmetric(vertical: 20),
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage("assets/images/add_image.png"),
                    fit: BoxFit.cover,
                  ),
                ),
                width: MediaQuery.of(context).size.width - 28,
                height: 120,
              ), */
                  controller.newCategory['imageUrl'] == null ||
                          controller.newCategory['imageUrl'] == ""
                      ? Container(
                          margin: const EdgeInsets.symmetric(vertical: 20),
                          //padding: const EdgeInsets.symmetric(vertical: 20),
                          decoration: const BoxDecoration(
                            image: DecorationImage(
                              image: AssetImage("assets/images/add_image.png"),
                              fit: BoxFit.cover,
                            ),
                          ),
                          width: MediaQuery.of(context).size.width - 28,
                          height: 120,
                        )
                      : Image.network(
                          controller.newCategory['imageUrl'],
                          width: MediaQuery.of(context).size.width,
                          height: 150,
                          fit: BoxFit.cover,
                        )
                  /*    : Container(
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: FileImage(
                              File(controller.newCategory['imageUrl'])),
                          fit: BoxFit.cover,
                        ),
                      ),
                      width: MediaQuery.of(context).size.width - 28,
                      height: 150,
                    )  */
                  ,
                  const SizedBox(
                    height: 20,
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8.0),
                    child: Text(
                      "Category Information",
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  _buildTextFormField("Category Name", 'name'),
                  Center(
                    child: ElevatedButton(
                        style: ElevatedButton.styleFrom(primary: Colors.black),
                        onPressed: () {
                          databaseService.addCategory(Category(
                            id: controller.newCategory['id'],
                            name: controller.newCategory['name'],
                            imageUrl: controller.newCategory['imageUrl'],
                          ));

                          if (imageDataFile != null) {
                            uploadImage(imageDataFile![0], imageDataFile![1]);
                          }

                          Navigator.pop(context);
                        },
                        child: const Text(
                          "Save",
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        )),
                  )
                ]);
          }),
        ),
      ),
    );
  }

  Padding _buildTextFormField(String hintText, name) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: TextFormField(
        decoration: InputDecoration(hintText: hintText),
        onChanged: (value) {
          controller.newCategory
              .update(name, (_) => value, ifAbsent: () => value);
        },
      ),
    );
  }

  getAndUploadImageToFireStore(context, ImageSource source) async {
    ImagePicker _picker = ImagePicker();
    final XFile? _image = await _picker.pickImage(source: source);

    if (_image == null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text("No Image Selected",
              style: TextStyle(fontSize: 16, color: Colors.red))));
    } else {
      await storage.uploadImage(_image);
      var imageUrl = await storage.getDownloadURL(_image.name);

      controller.newCategory
          .update("imageUrl", (_) => imageUrl, ifAbsent: () => imageUrl);
      // print(controller.newProduct['imageUrl']);

    }
  }

  Future<List<dynamic>?> getImage(ImageSource source) async {
    final pickedImageFile = await ImagePicker().getImage(source: source);

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

      String imageUrl = "${domainUrl}assets/images/uploads/" + fileName;

      controller.newCategory
          .update("imageUrl", (_) => imageUrl, ifAbsent: () => imageUrl);

      return [imageFile, fileName];

      // uploadImage(imageFile, fileName);
    }
  }

  uploadImage(File compressedFile, String filename) {
    /* Get.dialog(
        const Center(
          child: CircularProgressIndicator(),
        ),
        barrierDismissible: false); */

    ImageUploadProvider().uploadImage(compressedFile, filename).then((resp) {
      //Get.back();
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
