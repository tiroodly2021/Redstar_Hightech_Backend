import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';

import 'package:get/get.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:redstar_hightech_backend/app/modules/authentication/controllers/authentication_controller.dart';
import 'package:redstar_hightech_backend/app/modules/authentication/controllers/user_controller.dart';
import 'package:redstar_hightech_backend/app/shared/app_bar_widget.dart';
import 'package:redstar_hightech_backend/app/shared/app_search_delegate.dart';
import 'package:redstar_hightech_backend/app/shared/button_optional_menu.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

import '../../../constants/const.dart';
import '../../../services/database_service.dart';
import '../../../services/image_upload_provider.dart';
import '../../../services/storage_services.dart';
import '../../category/controllers/category_controller.dart';
import '../../category/models/category_model.dart';

import 'package:path/path.dart' as path;

import '../models/user_model.dart';

import 'package:crypto/crypto.dart' as crypto;
import 'dart:convert';

class EditUserView extends GetView<UserController> {
  StorageService storage = StorageService();
  DatabaseService databaseService = DatabaseService();
  late List? imageDataFile = [];
  UserController userController = Get.put(UserController());

  initEditItems(User user) {
    controller.newUser.update("uid", (_) => user.uid, ifAbsent: () => user.uid);
    controller.newUser
        .update("name", (_) => user.name, ifAbsent: () => user.name);
    controller.newUser
        .update("email", (_) => user.email, ifAbsent: () => user.email);

    controller.newUser.update("password", (_) => user.password,
        ifAbsent: () => user.password);

    controller.newUser
        .update("role", (_) => user.role, ifAbsent: () => user.role);

    if (user.photoURL != null) {
      controller.imageLocalPath.value = user.photoURL!;
      controller.newUser.update("photoURL", (_) => user.photoURL,
          ifAbsent: () => user.photoURL);
    }
  }

  @override
  Widget build(BuildContext context) {
    CategoryController categoryController = Get.find<CategoryController>();
    List<String> roles =
        // categoryController.categories.map((category) => category.name).toList();
        ["user", "editor", "admin"];
    // List<String> categories = controller.categoriesByName;

    User user = ModalRoute.of(context)!.settings.arguments as User;

    initEditItems(user);

    return Scaffold(
      appBar: AppBarWidget(
        title: user.name,
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
          child: Obx(() {
            return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 80,
                    child: InkWell(
                      onTap: () async {
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
                              "Add user Image",
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
                  /*  controller.newUser['imageUrl'] == null ||
                          controller.newUser['imageUrl'] == "" */

                  controller.imageLocalPath == ''
                      ? Container(
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

                      /* CircleAvatar(
                  
                    backgroundImage: FileImage(File(category.imageUrl)),
                    radius: 10,
                    backgroundColor: Colors.white,
                  )  */ /* Image.network(
                    category.imageUrl,
                    width: MediaQuery.of(context).size.width,
                    height: 150,
                    fit: BoxFit.cover,
                  ) */
                      /*  : Image.network(
                          controller.newUser['imageUrl'],
                          width: 150,
                          height: 150,
                          fit: BoxFit.cover,
                        ) */
                      : (controller.imageLocalPath.contains("https://") ||
                              controller.imageLocalPath.contains("http://"))
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
                                  image: FileImage(
                                      File(controller.imageLocalPath.value)),
                                  fit: BoxFit.cover,
                                ),
                              ),
                              width: 150,
                              height: 150,
                            ),
                  const SizedBox(
                    height: 20,
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8.0),
                    child: Text(
                      "user Information",
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  //   _buildTextFormField("user ID", 'id'),
                  _buildTextFormField("Name", 'name', user.name),
                  _buildTextFormField("Email", 'email', user.email),
                  _buildTextFormField("Password", 'password', ''),

                  // _buildTextFormField("user Category", 'category'),
                  Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: SizedBox(
                          width: 300,
                          child: DropdownButtonFormField(
                              value: user.role,
                              iconSize: 20,
                              decoration:
                                  const InputDecoration(labelText: "Role"),
                              items: roles
                                  .map((role) => DropdownMenuItem(
                                      value: role,
                                      child: Text(
                                        role,
                                      )))
                                  .toList(),
                              onChanged: (value) {
                                controller.newUser.update(
                                  "role",
                                  (_) => value,
                                  ifAbsent: () => value,
                                );
                              }),
                        ),
                      ),
                      ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              primary: Colors.black,
                              minimumSize: const Size(65, 44)),
                          onPressed: () {
                            //_openPopup(context, categoryController);
                          },
                          child: const Icon(Icons.add_circle))
                    ],
                  ),
                  const SizedBox(height: 20),
                  Center(
                    child: ElevatedButton(
                        style: ElevatedButton.styleFrom(primary: Colors.black),
                        onPressed: () {
                          var lastName = '';

                          if (user.photoURL != null) {
                            lastName = user.photoURL!.split("/").last;
                          }

                          User newUser = User(
                              name: controller.newUser['name'],
                              createdAt: user.createdAt,
                              buildNumber: user.buildNumber,
                              email: controller.newUser['email'],
                              lastLogin: user.lastLogin,
                              role: controller.newUser['role'],
                              photoURL: imageDataFile!.isNotEmpty
                                  ? controller.newUser['photoURL']
                                  : user.photoURL,
                              uid: user.uid,
                              password: controller.newUser['password'] != ''
                                  ? generateMd5(controller.newUser['password'])
                                  : user.password);

                          databaseService.updateUser(newUser);

                          if (imageDataFile!.isNotEmpty) {
                            if (lastName != '') {
                              deleteAndUploadNewImage(lastName,
                                  imageDataFile![0], imageDataFile![1]);
                            } else {
                              uploadImage(imageDataFile![0], imageDataFile![1]);
                            }
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

/*   _openPopup(context, CategoryController categoryController) {
    Alert(
        context: context,
        title: "NEW CATEGORY",
        content: Column(
          children: <Widget>[
            TextField(
              decoration: const InputDecoration(
                //icon: Icon(Icons.account_circle),
                labelText: 'Name',
              ),
              onChanged: (value) {
                categoryController.newCategory
                    .update('name', (_) => value, ifAbsent: () => value);
              },
            ),
            const SizedBox(height: 4),
            SizedBox(
              height: 60,
              child: InkWell(
                onTap: () async {
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
                        "Add user Image",
                        style: TextStyle(fontSize: 20, color: Colors.white),
                      )
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
        buttons: [
          DialogButton(
            color: Colors.black,
            height: 50,
            onPressed: () {
              databaseService.addCategory(Category(
                  name: categoryController.newCategory['name'],
                  imageUrl: categoryController.newCategory['imageUrl']));
              Navigator.pop(context);
            },
            child: const Text(
              "Save",
              style: TextStyle(color: Colors.white, fontSize: 20),
            ),
          )
        ]).show();
  }
 */
  Padding _buildTextFormField(String hintText, name, initialValue) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: TextFormField(
        initialValue: initialValue,
        decoration: InputDecoration(hintText: hintText),
        onChanged: (value) {
          controller.newUser.update(name, (_) => value, ifAbsent: () => value);
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

      String imageUrl = "${domainUrl}assets/images/uploads/" + fileName;

      controller.newUser
          .update("photoURL", (_) => imageUrl, ifAbsent: () => imageUrl);

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
    /* Get.dialog(
        const Center(
          child: CircularProgressIndicator(),
        ),
        barrierDismissible: false); */

    ImageUploadProvider().uploadImage(compressedFile, filename).then((resp) {
      //Get.back();
      var msg = resp[0].toString();
      // filename = resp[1].toString();

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

  deleteImage(String fileName) {
    ImageUploadProvider().deleteImage(fileName).then((resp) {
      // Get.back();

      if (resp == "success") {
        Get.snackbar("Success", "File Uploaded",
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.green,
            colorText: Colors.white);
      } else if (resp == "fail") {
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
}
