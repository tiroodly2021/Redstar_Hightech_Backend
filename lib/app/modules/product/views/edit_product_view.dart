import 'dart:io';

import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

import '../../../services/database_service.dart';
import '../../../services/storage_services.dart';
import '../../category/controllers/category_controller.dart';
import '../../category/models/category_model.dart';
import '../controllers/product_controller.dart';
import '../models/product_model.dart';

class EditProductView extends GetView<ProductController> {
  StorageService storage = StorageService();
  DatabaseService databaseService = DatabaseService();

  initEditItems(Product product) {
    controller.newProduct
        .update("id", (_) => product.id, ifAbsent: () => product.id);
    controller.newProduct
        .update("name", (_) => product.name, ifAbsent: () => product.name);
    controller.newProduct.update("description", (_) => product.description,
        ifAbsent: () => product.description);

    controller.newProduct.update("category", (_) => product.category,
        ifAbsent: () => product.category);

    controller.newProduct.update("isPopular", (_) => product.isPopular,
        ifAbsent: () => product.isPopular);
    controller.newProduct.update("isRecommended", (_) => product.isRecommended,
        ifAbsent: () => product.isRecommended);

    controller.newProduct
        .update("price", (_) => product.price, ifAbsent: () => product.price);

    controller.newProduct.update("quantity", (_) => product.quantity,
        ifAbsent: () => product.quantity);

    if (product.imageUrl != null) {
      controller.newProduct.update("imageUrl", (_) => product.imageUrl,
          ifAbsent: () => product.imageUrl);
    }
  }

  @override
  Widget build(BuildContext context) {
    CategoryController categoryController = Get.find<CategoryController>();
    List<String> categories =
        categoryController.categories.map((category) => category.name).toList();
    //["Smoothies", "Soft Drinks", "Alix Shoes"];
    // List<String> categories = controller.categoriesByName;

    Product product = ModalRoute.of(context)!.settings.arguments as Product;

    initEditItems(product);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Product'),
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
                        ImagePicker _picker = ImagePicker();
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
                          await storage.uploadImage(_image);
                          var imageUrl =
                              await storage.getDownloadURL(_image.name);
                          controller.newProduct.update(
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
                  product.imageUrl == null || product.imageUrl == ""
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
                                  File(controller.newProduct['imageUrl'])),
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
                      "Product Information",
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  //   _buildTextFormField("Product ID", 'id'),
                  _buildTextFormField("Product Name", 'name', product.name),
                  _buildTextFormField("Product Description", 'description',
                      product.description),
                  // _buildTextFormField("Product Category", 'category'),
                  Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: SizedBox(
                          width: 300,
                          child: DropdownButtonFormField(
                              value: product.category,
                              iconSize: 20,
                              decoration:
                                  const InputDecoration(labelText: "Category"),
                              items: categories
                                  .map((category) => DropdownMenuItem(
                                      value: category,
                                      child: Text(
                                        category,
                                      )))
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
                  _buildSlider("Price", 'price', controller.price, 0, 1000,
                      1000, product.price),
                  _buildSlider(
                      "Quantity",
                      'quantity',
                      controller.quantity.toDouble(),
                      0,
                      100,
                      100,
                      product.quantity.toDouble()),
                  const SizedBox(height: 10),
                  _buildCheckBox("Recommended", 'isRecommended',
                      controller.isRecommended, product.isRecommended),
                  _buildCheckBox("Popular", 'isPopular', controller.isPopular,
                      product.isPopular),
                  Center(
                    child: ElevatedButton(
                        style: ElevatedButton.styleFrom(primary: Colors.black),
                        onPressed: () {
                          print(controller.newProduct);

                          Product newProduct = Product(
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
                                  controller.newProduct['quantity'].toInt());
                          print(newProduct);

                          //databaseService.addProduct();
                          //Navigator.pop(context);
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

  Padding _buildCheckBox(
      String label, String name, bool? controllerValue, initialCheck) {
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
              value: (controllerValue ?? initialCheck),
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
      double min, double max, int divisions, initialValue) {
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
              value: (controllerValue ?? initialValue),
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
            child: Text("${controller.newProduct[name] ?? initialValue}"),
          )
        ],
      ),
    );
  }

  Padding _buildTextFormField(String hintText, name, initialValue) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: TextFormField(
        initialValue: initialValue,
        decoration: InputDecoration(hintText: hintText),
        onChanged: (value) {
          controller.newProduct
              .update(name, (_) => value, ifAbsent: () => value);
        },
      ),
    );
  }
}
