import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:redstar_hightech_backend/app/modules/authentication/controllers/user_list_controller.dart';

import '../models/user_model.dart';

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
import '../controllers/user_controller.dart';

import 'package:crypto/crypto.dart' as crypto;
import 'dart:convert';

import 'package:firebase_storage/firebase_storage.dart';

class AddUserView extends GetView<UserListController> {
  FirebaseStorage _storage = FirebaseStorage.instance;

  late XFile? imageDataFile;

  AddUserView({
    Key? key,
  }) : super(key: key);

  void _addUser(User user) {
    controller.addUser(user);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarWidget(
        title: 'Add User',
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

                  print(imageDataFile);
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
                        "Add User Photo",
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
                      ? Image.network(controller.imageLink.value,
                          width: 150, height: 150, fit: BoxFit.cover,
                          errorBuilder: (context, exception, stackTrace) {
                          return Container(
                            width: 120,
                            height: 100,
                            decoration: const BoxDecoration(
                              image: DecorationImage(
                                image: AssetImage("assets/images/no_image.jpg"),
                                fit: BoxFit.cover,
                              ),
                            ),
                          );
                        })
                      : SizedBox(
                          width: 100,
                          height: 100,
                          child: Container(
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                image: FileImage(
                                    File(controller.imageLinkTemp.value)),
                                fit: BoxFit.cover,
                              ),
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
                "Product Information",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            _buildTextFormField("Name", controller.addNameController),
            _buildTextFormField("Email", controller.addEmailController),
            _buildTextFormField("Password", controller.addPasswordController),
            Row(
              children: [
                DropDownWidgetList(controller.roles, 'role', 'Role'),
                ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        primary: Colors.black, minimumSize: const Size(65, 44)),
                    onPressed: () {
                      // _openPopup(context, categoryController);
                    },
                    child: const Icon(Icons.add_circle))
              ],
            ),
            const SizedBox(height: 10),
            const SizedBox(height: 10),
            Center(
              child: ElevatedButton(
                  style: ElevatedButton.styleFrom(primary: Colors.black),
                  onPressed: () async {
                    String imageLink =
                        await uploadImageToFirestore(imageDataFile);

                    User user = User(
                        buildNumber: '',
                        createdAt: DateTime.now().toString(),
                        email: controller.addEmailController.text,
                        lastLogin: '',
                        name: controller.addNameController.text,
                        password:
                            generateMd5(controller.addPasswordController.text),
                        role: controller.roleSelected.value,
                        photoURL: imageLink);

                    _addUser(user);

                    /*   User user = User(
                              name: controller.newUser['name'],
                              createdAt: DateTime.now().toString(),
                              buildNumber: '',
                              email: controller.newUser['email'],
                              lastLogin: '',
                              role: controller.newUser['role'],
                              photoURL: imageDataFile!.isNotEmpty
                                  ? controller.newUser['photoURL']
                                  : '',
                              password:
                                  generateMd5(controller.newUser['password'])); */

                    /*   print(user.toMap());

                          print(imageDataFile);

                          databaseService.addUser(user);

                          if (imageDataFile!.isNotEmpty) {
                            uploadImage(imageDataFile![0], imageDataFile![1]);
                          }

                          imageDataFile = []; */

                    Navigator.pop(context);
                  },
                  child: const Text(
                    "Save",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  )),
            )
          ]),
        ),
      ),
    );
  }

  /* _openPopup(context, CategoryController categoryController) {
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
                  ImagePicker _picker = ImagePicker();
                  final XFile? _image =
                      await _picker.pickImage(source: ImageSource.gallery);

                  if (_image == null) {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                        content: Text("No Image Selected",
                            style:
                                TextStyle(fontSize: 16, color: Colors.red))));
                  } else {
                    await storage.uploadImage(_image);
                    var imageUrl = await storage.getDownloadURL(_image.name);
                    categoryController.newCategory.update(
                        "imageUrl", (_) => imageUrl,
                        ifAbsent: () => imageUrl);
                    // print(controller.newUser['imageUrl']);
                  }
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
                        "Add Product Image",
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
  } */

  Padding _buildTextFormField(
      String hintText, TextEditingController fieldEditingController) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: TextFormField(
        controller: fieldEditingController,
        decoration: InputDecoration(hintText: hintText),
        /* onChanged: (value) {
          controller.newUser.update(name, (_) => value, ifAbsent: () => value);
        }, */
      ),
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

  Padding DropDownWidgetList(dropLists, field, label) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: SizedBox(
        width: 300,
        child: DropdownButtonFormField(
            iconSize: 20,
            decoration: InputDecoration(labelText: label),
            items: (dropLists as List<String>)
                .map((drop) => DropdownMenuItem(value: drop, child: Text(drop)))
                .toList(),
            onChanged: (value) {
              controller.roleSelected.value = value.toString();

              /*  controller.newUser.update(
                field,
                (_) => value,
                ifAbsent: () => value,
              ); */
            }),
      ),
    );
  }
}

/* class AddUserPage extends StatelessWidget {
  final UserListController userListController = Get.put(UserListController());

  AddUserPage({
    Key? key,
  }) : super(key: key);
  void _addUser(User user) {
    userListController.addUser(user);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          child: Column(
            children: [
              Text(
                'User Information',
                style: TextStyle(
                    fontSize: 25,
                    color: Colors.blueAccent,
                    fontWeight: FontWeight.bold),
              ),
              TextField(
                controller: userListController.addNameController,
                decoration: InputDecoration(hintText: 'Name'),
              ),
              TextField(
                controller: userListController.addEmailController,
                decoration: InputDecoration(hintText: 'Email'),
              ),
              TextField(
                controller: userListController.addPasswordController,
                decoration: InputDecoration(hintText: 'Password'),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  onPrimary: Colors.white,
                  primary: Colors.blue,
                  minimumSize: Size(88, 36),
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(2)),
                  ),
                ),
                onPressed: () {
                  User user = User(
                      buildNumber: '',
                      createdAt: DateTime.now().toString(),
                      email: userListController.addEmailController.text,
                      lastLogin: DateTime.now().toString(),
                      name: userListController.addNameController.text,
                      password: userListController.addPasswordController.text,
                      role: 'user');
                  _addUser(user);
                },
                child: const Text('Save'),
              )
            ],
          ),
        ),
      ),
    );
  }
}
 */
