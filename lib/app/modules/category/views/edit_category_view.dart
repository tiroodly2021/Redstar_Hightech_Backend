import 'dart:io';

import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:redstar_hightech_backend/app/modules/category/controllers/category_controller.dart';

import '../../../services/database_service.dart';
import '../../../services/storage_services.dart';
import '../models/category_model.dart';
import 'package:path/path.dart' as path;

class EditCategoryView extends GetView<CategoryController> {
  StorageService storage = StorageService();
  DatabaseService databaseService = DatabaseService();
  String doldOnwloadImageUrl = '';

  @override
  Widget build(BuildContext context) {
    Category category = ModalRoute.of(context)!.settings.arguments as Category;

    return Scaffold(
      appBar: AppBar(
          title: Text('Edit Category ' + category.name),
          centerTitle: true,
          backgroundColor: Colors.black),
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
                      ImagePicker _picker = ImagePicker();
                      final XFile? _image =
                          await _picker.pickImage(source: ImageSource.gallery);

                      if (_image == null) {
                        ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text("No Image Selected",
                                    style: TextStyle(
                                        fontSize: 16, color: Colors.red))));
                      } else {
                        /*    await storage.uploadImage(_image);
                        var imageUrl =
                            await storage.getDownloadURL(_image.name);
 */

                        Directory appDocumentsDirectory =
                            await getApplicationDocumentsDirectory(); // 1
                        String appDocumentsPath = appDocumentsDirectory.path;

                        var fileName = path.basename(_image.path); // 2

                        String imageUrl = '$appDocumentsPath/' + fileName;

                        print(imageUrl);

                        await _image.saveTo('$appDocumentsPath/' + fileName);

                        controller.newCategory.update(
                            "imageUrl", (_) => imageUrl,
                            ifAbsent: () => imageUrl);
                        // print(controller.newProduct['imageUrl']);
                      }
                    },
                    child: /* Obx(() {
                    return  */
                        Card(
                      color: Colors.black,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          category.imageUrl == null || category.imageUrl == ""
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
                                      image: FileImage(File(category.imageUrl)),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  width: MediaQuery.of(context).size.width - 28,
                                  height: 150,
                                )
                        ],
                      ),
                    )
                    //}),
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
                    onPressed: () async {
                      print(controller.newCategory);

                      databaseService.updateCategory(
                        Category(
                          id: category.id!,
                          name: controller.newCategory['name'],
                          imageUrl: controller.newCategory['imageUrl'],
                        ),
                      );
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
}
