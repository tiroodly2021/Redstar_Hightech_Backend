import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:flutter_image_compress/flutter_image_compress.dart';

import 'package:get/get.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:path_provider/path_provider.dart';
import 'package:redstar_hightech_backend/app/modules/authentication/controllers/authentication_controller.dart';
import 'package:redstar_hightech_backend/app/modules/category/controllers/category_controller.dart';
import 'package:redstar_hightech_backend/app/modules/category/models/category_model.dart';
import 'package:redstar_hightech_backend/app/modules/home/controllers/home_controller.dart';
import 'package:redstar_hightech_backend/app/modules/product/controllers/product_controller.dart';
import 'package:redstar_hightech_backend/app/modules/product/models/product_model.dart';
import 'package:redstar_hightech_backend/app/routes/app_pages.dart';
import 'package:redstar_hightech_backend/app/services/database_service.dart';
import 'package:redstar_hightech_backend/app/services/storage_services.dart';
import 'package:redstar_hightech_backend/app/shared/app_bar_widget.dart';
import 'package:redstar_hightech_backend/app/shared/app_search_delegate.dart';
import 'package:redstar_hightech_backend/app/shared/button_optional_menu.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:path/path.dart' as path;
import 'dart:io';

import '../../../constants/const.dart';
import '../../../services/image_upload_provider.dart';

import 'package:crypto/crypto.dart' as crypto;
import 'dart:convert';

import 'package:firebase_storage/firebase_storage.dart';

class UpdateCategoryView extends GetView<CategoryController> {
  FirebaseStorage _storage = FirebaseStorage.instance;

  late XFile? imageDataFile = null;
  Category? currentCategory;

  UpdateCategoryView({Key? key, this.currentCategory}) : super(key: key);

  void _editCategory(Category category) {
    controller.editCategory(category);
  }

  @override
  Widget build(BuildContext context) {
    currentCategory = ModalRoute.of(context)!.settings.arguments as Category;
    return Scaffold(
      appBar: AppBarWidget(
        title: controller.category.value.name,
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
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            SizedBox(
              height: 80,
              child: InkWell(
                onTap: () async {
                  imageDataFile = await getImage(ImageSource.gallery);
                  controller.imageLink.value = '';
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
                        "Edit Category Photo",
                        style: TextStyle(fontSize: 22, color: Colors.white),
                      )
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Obx(() {
              return controller.imageLink.value == '' &&
                      controller.imageLinkTemp.value == ''
                  ? Container(
                      margin: const EdgeInsets.only(left: 6),
                      padding: const EdgeInsets.all(30),
                      decoration: const BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage("assets/images/add_image.png"),
                          fit: BoxFit.cover,
                        ),
                      ),
                      width: 150,
                      height: 150,
                    )
                  : controller.imageLink.value != ''
                      ? Container(
                          margin: const EdgeInsets.only(left: 6),
                          child: Image.network(controller.imageLink.value,
                              width: 150, height: 150, fit: BoxFit.cover,
                              errorBuilder: (context, exception, stackTrace) {
                            return Container(
                              width: 150,
                              height: 150,
                              decoration: const BoxDecoration(
                                image: DecorationImage(
                                  image:
                                      AssetImage("assets/images/no_image.jpg"),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            );
                          }),
                        )
                      : Container(
                          padding: const EdgeInsets.all(30),
                          margin: const EdgeInsets.only(left: 6),
                          width: 150,
                          height: 150,
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: FileImage(
                                  File(controller.imageLinkTemp.value)),
                              fit: BoxFit.cover,
                            ),
                          ),
                        );
            }),
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
            _buildTextFormField("Name", controller.addNameController),
            Row(
              children: [],
            ),
            const SizedBox(height: 10),
            const SizedBox(height: 10),
            Center(
              child: ElevatedButton(
                  style: ElevatedButton.styleFrom(primary: Colors.black),
                  onPressed: () async {
                    String imageLink = '';

                    if (!(imageDataFile == null)) {
                      imageLink = await uploadImageToFirestore(imageDataFile);
                    }
                    if (controller.addNameController.text != "") {
                      Category category = Category(
                          id: currentCategory!.id,
                          name: controller.addNameController.text,
                          imageUrl: imageLink != ''
                              ? imageLink
                              : controller.imageLink.value);

                      _editCategory(category);

                      resetFields();

                      Navigator.pop(context);
                    } else {
                      Get.showSnackbar(const GetSnackBar(
                        title: "Info",
                        message: "Form not valid",
                        backgroundColor: Colors.red,
                        duration: Duration(seconds: 3),
                        margin: EdgeInsets.all(12),
                      ));
                    }
                  },
                  child: const Text(
                    "Update",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  )),
            )
          ]),
        ),
      ),
    );
  }

  Padding _buildTextFormField(
      String hintText, TextEditingController fieldEditingController) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: TextFormField(
          controller: fieldEditingController,
          decoration: InputDecoration(hintText: hintText),
          autovalidateMode: AutovalidateMode.onUserInteraction,
          validator: (value) {
            if (value == null || value.isEmpty || value.length < 3) {
              return 'Category Name must contain at least 3 characters';
            } else if (value.contains(RegExp(r'^[0-9_\-=@,\.;]+$'))) {
              return 'Category cannot contain special characters';
            }

            return null;
          }),
    );
  }

  Future<String> uploadImageToFirestore(XFile? pickedImage) async {
    if (pickedImage != null) {
      String fileName = DateTime.now().millisecondsSinceEpoch.toString();
      Reference storageReference =
          FirebaseStorage.instance.ref().child('images/$fileName');

      UploadTask uploadTask = storageReference.putFile(File(pickedImage.path));
      TaskSnapshot taskSnapshot = await uploadTask.whenComplete(() {});
      String imageUrl = await taskSnapshot.ref.getDownloadURL();

      return imageUrl;
    } else {
      return '';
    }
  }

  /*  getAndUploadImageToFireStore(context, ImageSource source) async {
    ImagePicker _picker = ImagePicker();
    final XFile? _image = await _picker.pickImage(source: source);

    if (_image == null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text("No Image Selected",
              style: TextStyle(fontSize: 16, color: Colors.red))));
    } else {
      await storage.uploadImage(_image);
      var imageUrl = await storage.getDownloadURL(_image.name);

      controller.newUser
          .update("imageUrl", (_) => imageUrl, ifAbsent: () => imageUrl);
      // print(controller.newUser['imageUrl']);

    }
  } */

  Future<XFile?> getImage(ImageSource source) async {
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

      // var fileName = path.basename(selectedImagePath);

      // final imageFile = File(targetPath);

      //  String imageUrl = "${domainUrl}assets/images/uploads/" + fileName;

      /*     controller.newUser
          .update("photoURL", (_) => imageUrl, ifAbsent: () => imageUrl); */

      //  controller.imageLocalPath.value = targetPath;

      controller.imageLinkTemp.value = targetPath;

      return compressedFile; //[imageFile, fileName];
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

  String generateMd5(String input) {
    return crypto.md5.convert(utf8.encode(input)).toString();
  }

  void resetFields() {
    imageDataFile = null;
    controller.imageLink.value = '';
    controller.imageLinkTemp.value = '';
    controller.addNameController.text = '';
  }
}

/* import 'dart:io';

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

class UpdateCategoryView extends GetView<CategoryController> {
  StorageService storage = StorageService();
  DatabaseService databaseService = DatabaseService();
  String doldOnwloadImageUrl = '';
  late List? imageDataFile = [];
  @override
  Widget build(BuildContext context) {
    Category category = ModalRoute.of(context)!.settings.arguments as Category;

    //controller.imageLocalPath.value = category.imageUrl;

    controller.newCategory.update("imageUrl", (_) => category.imageUrl,
        ifAbsent: () => category.imageUrl);

    controller.newCategory
        .update("name", (_) => category.name, ifAbsent: () => category.name);

    return Scaffold(
      appBar: AppBarWidget(
        title: category.name,
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
                        if (lastName != '') {
                          deleteAndUploadNewImage(
                              lastName, imageDataFile![0], imageDataFile![1]);
                        } else {
                          uploadImage(imageDataFile![0], imageDataFile![1]);
                        }
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
 */
