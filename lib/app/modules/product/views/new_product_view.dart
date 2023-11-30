import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';

import 'package:get/get.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
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

class NewProductView extends GetView<ProductController> {
  StorageService storage = StorageService();
  DatabaseService databaseService = DatabaseService();
  late List? imageDataFile;

  @override
  Widget build(BuildContext context) {
    List<String> categories =
        controller.categories.map((category) => category.name).toList();
    //["Smoothies", "Soft Drinks", "Alix Shoes"];

    CategoryController categoryController = Get.find<CategoryController>();

    return Scaffold(
      appBar: AppBarWidget(
        title: 'Add Product',
        icon: Icons.search,
        bgColor: Colors.black,
        onPressed: () {
          showSearch(context: context, delegate: AppSearchDelegate());
        },
        authenticationController: Get.find<AuthenticationController>(),
        menuActionButton: ButtonOptionalMenu(),
        tooltip: 'Search',
      )

      /* AppBarWidget(
        title: 'Add Product',
        icon: Icons.search,
        bgColor: Colors.black,
        onPressed: () {
          /*  showSearch(
                      context: context, delegate: TransactionSearchDelegate()); */
        },
        tooltip: 'Search',
      ) */
      ,
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
                        /*                 ImagePicker _picker = ImagePicker();
                        final XFile? _image = await _picker.pickImage(
                            source: ImageSource.gallery);

                        if (_image == null) {
                          ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content: Text(
                                      "No Image Selected",
                                      style: TextStyle(
                                          fontSize: 16, color: Colors.red))));
                        } else {
                          Directory appDocumentsDirectory =
                              await getApplicationDocumentsDirectory(); // 1
                          String appDocumentsPath = appDocumentsDirectory.path;

                          var fileName = path.basename(_image.path); // 2

                          String imageUrl = '$appDocumentsPath/' + fileName;

                          print(imageUrl);

                          await _image.saveTo('$appDocumentsPath/' + fileName);

                          controller.newProduct.update(
                              "imageUrl", (_) => imageUrl,
                              ifAbsent: () => imageUrl);
                          print(controller.newProduct['imageUrl']); 
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
                              "Add Product Image",
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
                  /*  controller.newProduct['imageUrl'] == null ||
                          controller.newProduct['imageUrl'] == '' */
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
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8.0),
                    child: Text(
                      "Product Information",
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  //   _buildTextFormField("Product ID", 'id'),
                  _buildTextFormField("Product Name", 'name'),
                  _buildTextFormField("Product Description", 'description'),
                  // _buildTextFormField("Product Category", 'category'),
                  Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: SizedBox(
                          width: 300,
                          child: DropdownButtonFormField(
                              iconSize: 20,
                              decoration:
                                  const InputDecoration(labelText: "Category"),
                              items: categories
                                  .map((category) => DropdownMenuItem(
                                      value: category, child: Text(category)))
                                  .toList(),
                              onChanged: (value) {
                                controller.newProduct.update(
                                  "category",
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
                            _openPopup(context, categoryController);
                          },
                          child: const Icon(Icons.add_circle))
                    ],
                  ),
                  const SizedBox(height: 10),
                  _buildSlider(
                      "Price", 'price', controller.price, 0, 1000, 1000),
                  _buildSlider(
                      "Quantity", 'quantity', controller.quantity, 0, 100, 100),
                  const SizedBox(height: 10),
                  _buildCheckBox(
                      "Recommended", 'isRecommended', controller.isRecommended),
                  _buildCheckBox("Popular", 'isPopular', controller.isPopular),
                  Center(
                    child: ElevatedButton(
                        style: ElevatedButton.styleFrom(primary: Colors.black),
                        onPressed: () {
                          print(imageDataFile);

                          databaseService.addProduct(Product(
                              id: controller.newProduct['id'],
                              name: controller.newProduct['name'],
                              description: controller.newProduct['description'],
                              category: controller.newProduct['category'],
                              imageUrl: controller.newProduct['imageUrl'],
                              isRecommended:
                                  controller.newProduct['isRecommended'] ??
                                      false,
                              isPopular:
                                  controller.newProduct['isPopular'] ?? false,
                              price: controller.newProduct['price'],
                              quantity:
                                  controller.newProduct['quantity'].toInt()));

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

  _openPopup(context, CategoryController categoryController) {
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
                    // print(controller.newProduct['imageUrl']);
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
              value: (controllerValue ?? false),
              checkColor: Colors.black,
              activeColor: Colors.black12,
              onChanged: (value) {
                controller.newProduct
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
                controller.newProduct
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
            child: Text("${controller.newProduct[name] ?? 0}"),
          )
        ],
      ),
    );
  }

  Padding _buildTextFormField(String hintText, name) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: TextFormField(
        decoration: InputDecoration(hintText: hintText),
        onChanged: (value) {
          controller.newProduct
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

      controller.newProduct
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

      controller.newProduct
          .update("imageUrl", (_) => imageUrl, ifAbsent: () => imageUrl);

      controller.imageLocalPath.value = targetPath;

      print("image path is : " + imageFile.path);

      return [imageFile, fileName];
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
