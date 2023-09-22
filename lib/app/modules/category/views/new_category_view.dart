import 'dart:io';

import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:redstar_hightech_backend/app/modules/category/controllers/category_controller.dart';

import 'package:redstar_hightech_backend/app/services/database_service.dart';
import 'package:redstar_hightech_backend/app/services/storage_services.dart';
import 'package:path/path.dart' as path;
import '../models/category_model.dart';

class NewCategoryView extends GetView<CategoryController> {
  StorageService storage = StorageService();
  DatabaseService databaseService = DatabaseService();
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
            child: /*Obx(() {
            return*/
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              SizedBox(
                height: 80,
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
                      /*     await storage.uploadImage(_image);
                      var imageUrl = await storage.getDownloadURL(_image.name); */

                      Directory appDocumentsDirectory =
                          await getApplicationDocumentsDirectory(); // 1
                      String appDocumentsPath = appDocumentsDirectory.path;

                      var fileName = path.basename(_image.path); // 2

                      String imageUrl = '$appDocumentsPath/' + fileName;

                      print(imageUrl);

                      await _image.saveTo('$appDocumentsPath/' + fileName);

                      controller.newCategory.update("imageUrl", (_) => imageUrl,
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
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: FileImage(
                              File(controller.newCategory['imageUrl'])),
                          fit: BoxFit.cover,
                        ),
                      ),
                      width: MediaQuery.of(context).size.width - 28,
                      height: 150,
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
              _buildTextFormField("Category Name", 'name'),
              Center(
                child: ElevatedButton(
                    style: ElevatedButton.styleFrom(primary: Colors.black),
                    onPressed: () {
                      print(controller.newCategory);

                      databaseService.addCategory(Category(
                        id: controller.newCategory['id'],
                        name: controller.newCategory['name'],
                        imageUrl: controller.newCategory['imageUrl'],
                      ));
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
}
