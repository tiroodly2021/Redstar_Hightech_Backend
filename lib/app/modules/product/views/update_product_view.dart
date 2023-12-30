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
import 'package:redstar_hightech_backend/app/modules/product/views/product_view.dart';
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

import '../../common/navigation_drawer.dart';

class UpdateProductView extends GetView<ProductController> {
  FirebaseStorage _storage = FirebaseStorage.instance;

  late XFile? imageDataFile = null;
  Product? currentProduct;
  late XFile? imageCategoryDataFile = null;
  CategoryController categoryController = Get.put(CategoryController());

  UpdateProductView({Key? key, this.currentProduct}) : super(key: key);

  void _editProductWithCategory(Product product, Category category) {
    controller.editProductWithCategory(product, category);
  }

  void _addCategory(Category category) {
    categoryController.addCategory(category);
  }

  @override
  Widget build(BuildContext context) {
    currentProduct = ModalRoute.of(context)!.settings.arguments as Product;

    return Scaffold(
      appBar: AppBarWidget(
        title: controller.product.value.name,
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
                    InkWell(
                        onTap: () async {
                          imageDataFile = await getImage(ImageSource.gallery);
                          controller.imageLink.value = '';
                        },
                        child: controller.imageLink.value == '' &&
                                controller.imageLinkTemp.value == ''
                            ? Container(
                                margin: const EdgeInsets.only(left: 6),
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
                            : controller.imageLink.value != ''
                                ? Container(
                                    margin: const EdgeInsets.only(left: 6),
                                    child: Image.network(
                                        controller.imageLink.value,
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
                                        image: FileImage(File(
                                            controller.imageLinkTemp.value)),
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  )

                        /*  Card(
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
                            "Add Product Photo",
                            style:
                                TextStyle(fontSize: 22, color: Colors.white),
                          )
                        ],
                      ),
                    ), */
                        ),
                    const SizedBox(
                      height: 10,
                    ),
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 8.0),
                      child: Text(
                        "Product Details",
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    _buildTextFormField("Name", controller.addNameController),
                    _buildTextFormField(
                        "Descript", controller.addDescriptionController),
                    Row(
                      children: [
                        DropDownWidgetList(
                            controller.categories, 'category', 'Category'),
                        ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                primary: Colors.black,
                                minimumSize: const Size(65, 44)),
                            onPressed: () {
                              _openPopup(context, categoryController);
                            },
                            child: const Icon(Icons.add_circle))
                      ],
                    ),
                    _buildSlider(
                        "Price", 'price', controller.price, 0, 1000, 1000),
                    _buildSlider("Quantity", 'quantity', controller.quantity, 0,
                        100, 100),
                    _buildCheckBox(
                        "Popular?", 'isPopular', controller.isPopular),
                    _buildCheckBox("Recommended?", 'isRecommended',
                        controller.isRecommended),
                    const SizedBox(height: 10),
                    const SizedBox(height: 10),
                    Center(
                      child: ElevatedButton(
                          style:
                              ElevatedButton.styleFrom(primary: Colors.black),
                          onPressed: () async {
                            String imageLink = '';

                            if (!(imageDataFile == null)) {
                              imageLink =
                                  await uploadImageToFirestore(imageDataFile);
                            }

                            if (controller.addNameController.text != "") {
                              Product product = Product(
                                  id: currentProduct!.id,
                                  name: controller.addNameController.text,
                                  description:
                                      controller.addDescriptionController.text,
                                  /*  category:
                                      controller.categorySelected.value != ''
                                          ? controller.categorySelected.value
                                          : currentProduct!.category, */
                                  imageUrl: imageLink != ''
                                      ? imageLink
                                      : controller.imageLink.value,
                                  price: controller.slideList['price'],
                                  quantity:
                                      controller.slideList['quantity'].toInt(),
                                  isPopular: controller.checkList['isPopular'],
                                  isRecommended:
                                      controller.checkList['isRecommended']);

                              _editProductWithCategory(
                                  product, controller.category.value);

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
            })),
      ),
    );
  }

  _openPopup(context, CategoryController categoryController) {
    Alert(
        context: context,
        title: "NEW CATEGORY",
        content: Column(
          children: <Widget>[
            _buildTextFormField("Name", categoryController.addNameController),
            const SizedBox(height: 4),
            SizedBox(
              height: 60,
              child: InkWell(
                onTap: () async {
                  imageCategoryDataFile =
                      await getImage(ImageSource.gallery, isCategory: true);
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
            onPressed: () async {
              String imageLink = '';

              if (!(imageCategoryDataFile == null)) {
                imageLink = await uploadImageToFirestore(imageCategoryDataFile);
              }

              if (categoryController.addNameController.text != "") {
                Category category = Category(
                    name: categoryController.addNameController.text,
                    imageUrl: imageLink != '' ? imageLink : '');

                _addCategory(category);

                resetCategoryFields();

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
              style: TextStyle(color: Colors.white, fontSize: 20),
            ),
          )
        ]).show();
  }

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

  Future<XFile?> getImage(ImageSource source, {bool isCategory = false}) async {
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

      if (!isCategory) {
        controller.imageLinkTemp.value = targetPath;
      }

      return compressedFile;
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

  Padding DropDownWidgetList(RxList<Category> dropLists, field, label) {
    RxList<Category> ll = <Category>[].obs;

    ll.add(Category(id: '', name: '', imageUrl: ''));

    dropLists = ll + dropLists;

    print('selected value: ${controller.category.value.id}');

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: SizedBox(
        width: 300,
        child: DropdownButtonFormField(
            value: controller.category.value.id != ""
                ? controller.category.value.id
                : '',
            iconSize: 20,
            decoration: InputDecoration(labelText: label),
            items: (dropLists)
                .map((drop) =>
                    DropdownMenuItem(value: drop.id, child: Text(drop.name)))
                .toList(),
            onChanged: (value) {
              controller.categorySelected.value = value.toString();

              print('selected value in the view' +
                  controller.categorySelected.value);

              controller.categories.forEach((rl) {
                if (rl.id!.toString().toLowerCase().trim() ==
                    value.toString().toLowerCase().trim()) {
                  controller.category.update((val) {
                    val!.name = rl.name;
                    val.id = rl.id;
                    val.imageUrl = '';
                  });
                }
              });

              print('categ select ${controller.category.value.toMap()}');
            }),
      ),
    );
  }

  Padding _buildCheckBox(String label, String name, bool? controllerValue) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Row(
        children: [
          SizedBox(
            width: 150,
            child: Text(
              label,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
          Checkbox(
              value: controllerValue ?? false,
              checkColor: Colors.black,
              activeColor: Colors.black12,
              onChanged: (value) {
                controller.checkList
                    .update(name, (_) => value, ifAbsent: () => value);
              }),
        ],
      ),
    );
  }

  Padding _buildSlider(String title, String name, double? controllerValue,
      double min, double max, int divisions) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Row(
        children: [
          SizedBox(
            width: 75,
            child: Text(
              title,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
          ),
          Expanded(
            child: Slider(
              value: (controllerValue ?? 0),
              onChanged: (value) {
                controller.slideList
                    .update(name, (_) => value, ifAbsent: () => value);
              },
              min: min,
              max: max,
              divisions: divisions,
              activeColor: Colors.black,
              inactiveColor: Colors.black12,
            ),
          ),
          SizedBox(
            width: 100,
            child: Text("${controller.slideList[name] ?? 0}"),
          )
        ],
      ),
    );
  }

  void resetFields() {
    imageDataFile = null;
    controller.imageLink.value = '';
    controller.imageLinkTemp.value = '';
    controller.addDescriptionController.text = '';
    controller.addNameController.text = '';
    controller.slideList.clear();
    controller.checkList.clear();
    controller.category.update((val) {
      val!.name = "";
      val.id = "";
      val.imageUrl = "";
    });
    controller.categorySelected.update((val) {
      val = '';
    });
  }

  void resetCategoryFields() {
    imageCategoryDataFile = null;
    categoryController.addNameController.text = '';
  }
}
