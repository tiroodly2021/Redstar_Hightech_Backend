import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:redstar_hightech_backend/app/modules/authentication/controllers/role_controller.dart';

import 'package:flutter_image_compress/flutter_image_compress.dart';

import 'package:get/get.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:path_provider/path_provider.dart';
import 'package:redstar_hightech_backend/app/modules/authentication/controllers/authentication_controller.dart';
import 'package:redstar_hightech_backend/app/modules/category/controllers/category_controller.dart';
import 'package:redstar_hightech_backend/app/modules/category/models/category_model.dart';
import 'package:redstar_hightech_backend/app/modules/common/navigation_drawer.dart';
import 'package:redstar_hightech_backend/app/modules/finance/account/controllers/account_controller.dart';
import 'package:redstar_hightech_backend/app/modules/finance/account/models/account_model.dart';
import 'package:redstar_hightech_backend/app/modules/finance/account/models/account_type.dart';
import 'package:redstar_hightech_backend/app/modules/finance/transaction/controllers/transaction_controller.dart';
import 'package:redstar_hightech_backend/app/modules/finance/transaction/models/transaction_model.dart';
import 'package:redstar_hightech_backend/app/modules/finance/transaction/models/transaction_type_model.dart';
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

import 'package:crypto/crypto.dart' as crypto;
import 'dart:convert';

import 'package:firebase_storage/firebase_storage.dart';

class AddAccountView extends GetView<AccountController> {
  FirebaseStorage _storage = FirebaseStorage.instance;

  late XFile? imageDataFile = null;
  TransactionController transactionController =
      Get.put(TransactionController());

  AddAccountView({
    Key? key,
  }) : super(key: key) {
    resetFields();
  }

  void _addAccount(Account account) {
    controller.addAccount(account);
  }

  /* void _addRole(Role role) {
    roleController.addRole(role);
  }
 */
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarWidget(
        title: 'Add Account',
        icon: Icons.search,
        bgColor: Colors.black,
        onPressed: () {
          showSearch(context: context, delegate: AppSearchDelegate());
        },
        authenticationController: Get.find<AuthenticationController>(),
        menuActionButton: ButtonOptionalMenu(),
        tooltip: 'Search',
      ),
      drawer: NavigationDrawer(),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Obx(() {
            return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 60,
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
                              "Add Account Photo",
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
                  controller.imageLink.value == '' &&
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
                                  width: 150,
                                  height: 150,
                                  fit: BoxFit.cover, errorBuilder:
                                      (context, exception, stackTrace) {
                                return Container(
                                  width: 150,
                                  height: 150,
                                  decoration: const BoxDecoration(
                                    image: DecorationImage(
                                      image: AssetImage(
                                          "assets/images/no_image.jpg"),
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
                            ),
                  const SizedBox(
                    height: 10,
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8.0),
                    child: Text(
                      "Account Information",
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  _buildTextFormField("Name", controller.addNameController),
                  _buildTextFormField(
                      "Account Number", controller.addNumberController),
                  _buildTextFormField(
                      "Credit", controller.addBalanceCreditController,
                      isNumber: true),
                  _buildTextFormField(
                      "Debit", controller.addNBalanceDebitController,
                      isNumber: true),
                  Row(
                    children: [
                      DropDownWidgetList(controller.accountType, 'type', 'Type',
                          MediaQuery.of(context).size.width * .91),
                    ],
                  ),
                  const SizedBox(height: 10),
                  const SizedBox(height: 10),
                  Center(
                    child: ElevatedButton(
                        style: ElevatedButton.styleFrom(primary: Colors.black),
                        onPressed: () async {
                          String imageLink = '';

                          if (!(imageDataFile == null)) {
                            imageLink =
                                await uploadImageToFirestore(imageDataFile);
                          }

                          if (controller.addNameController.text != "" &&
                              controller.addNumberController.text != "" &&
                              controller.addBalanceCreditController.text !=
                                  controller.addNBalanceDebitController.text) {
                            Account account = Account(
                                number: controller.addNumberController.text,
                                createdAt: DateTime.now().toString(),
                                name: controller.addNameController.text,
                                photoURL: imageLink != ''
                                    ? imageLink
                                    : controller.imageLink.value,
                                type: Account.accountStringToAccountType(
                                    controller.acountTypeSelected.value));

                            _addAccount(account);

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

  Padding DropDownWidgetList(RxList<String> dropLists, field, label, width) {
    /*    RxList<String> ll = <AccountType>[].obs;

    ll.add(AccountType.));

    dropLists = ll + dropLists; */

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: SizedBox(
        width: width,
        child: DropdownButtonFormField(
            iconSize: 20,
            decoration: InputDecoration(labelText: label),
            items: dropLists
                .map((drop) => DropdownMenuItem(value: drop, child: Text(drop)))
                .toList(),
            onChanged: (value) {
              controller.acountTypeSelected.value = value.toString();

              /*    controller.accountType.forEach((rl) {
                if (rl.id!.toString().toLowerCase().trim() ==
                    value.toString().toLowerCase().trim()) {
                  controller.role.update((val) {
                    val!.name = rl.name;
                    val.id = rl.id;
                    val.description = rl.description;
                  });
                }
              }); */
            }),
      ),
    );
  }

  Padding _buildTextFormField(
      String hintText, TextEditingController fieldEditingController,
      {bool isEmail = false, isNumber = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: isEmail
          ? TextFormField(
              controller: fieldEditingController,
              decoration: InputDecoration(hintText: hintText),
              autovalidateMode: AutovalidateMode.onUserInteraction,
              validator: (value) {
                if (GetUtils.isEmail(value!)) {
                  return null;
                }
                return 'Email required';
              })
          : !isNumber
              ? TextFormField(
                  controller: fieldEditingController,
                  decoration: InputDecoration(hintText: hintText),
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  validator: (value) {
                    if (value == null || value.isEmpty || value.length < 3) {
                      return 'Field must contain at least 3 characters';
                    } else if (value.contains(RegExp(r'^[0-9_\-=@,\.;]+$'))) {
                      return 'Field cannot contain special characters';
                    }

                    return null;
                  })
              : TextFormField(
                  controller: fieldEditingController,
                  decoration: InputDecoration(hintText: hintText),
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  validator: (value) {
                    if (GetUtils.isNumericOnly(value!)) {
                      return null;
                    }
                    return 'Only number required';
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

      controller.imageLinkTemp.value = targetPath;

      return compressedFile;
    }
  }

  String generateMd5(String input) {
    return crypto.md5.convert(utf8.encode(input)).toString();
  }

/*   Padding DropDownWidgetList(RxList<Role> dropLists, field, label) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: SizedBox(
        width: 300,
        child: DropdownButtonFormField(
            iconSize: 20,
            decoration: InputDecoration(labelText: label),
            items: dropLists
                .map((drop) =>
                    DropdownMenuItem(value: drop.id, child: Text(drop.name)))
                .toList(),
            onChanged: (value) {
              controller.roleSelected.value = value.toString();

              controller.roles.forEach((rl) {
                if (rl.id!.toString().toLowerCase().trim() ==
                    value.toString().toLowerCase().trim()) {
                  controller.role.update((val) {
                    val!.name = rl.name;
                    val.id = rl.id;
                    val.description = rl.description;
                  });
                }
              });
            }),
      ),
    );
  }
 */
  void resetFields() {
    imageDataFile = null;
    controller.imageLink.value = '';
    controller.imageLinkTemp.value = '';
    controller.addNumberController.text = '';
    controller.addNameController.text = '';
    controller.addBalanceCreditController.text = '';
    controller.addNBalanceDebitController.text = '';
    controller.acountTypeSelected.value = '';
    /*    controller.role.update((val) {
      val!.name = "";
      val.id = "";
      val.description = "";
    }); */
  }

/*   void resetRoleFields() {
    roleController.addNameController.text = '';
    roleController.addDescriptionController.text = '';
  } */
}



/* import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/account_controller.dart';

class AddAccountView extends GetView<AccountController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Account'),
        centerTitle: true,
      ),
      body: Center(
        child: Text(
          'AccountView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
 */