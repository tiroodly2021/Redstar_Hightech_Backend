import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:redstar_hightech_backend/app/modules/category/models/category_model.dart';
import 'package:redstar_hightech_backend/app/modules/product/models/product_model.dart';
import 'package:redstar_hightech_backend/app/services/database_service.dart';

import '../views/update_category_view.dart';

class CategoryController extends GetxController {
  DatabaseService databaseService = DatabaseService();
  RxBool loading = false.obs;
  Map<String, dynamic> body = {};
  RxList<Category> categories = <Category>[].obs;
  RxList<Product> products = <Product>[].obs;
  RxString titleGame = ''.obs;
  final List<IconData> iconData = <IconData>[Icons.call, Icons.school];
  final Random r = Random();

  DatabaseService database = DatabaseService();

  Rx<Category> category = Category(name: '', imageUrl: '').obs;

  Icon randomIcon2() => Icon(iconData[r.nextInt(iconData.length)]);

  TextEditingController addNameController = TextEditingController();

  RxString imageLink = ''.obs;
  RxString imageLinkTemp = ''.obs;

  var count = 0.obs;

  @override
  void onInit() {
    super.onInit();
    categoryList();
  }

  void categoryList() async {
    count.bindStream(database.getCount('categories', 'CategoryController'));

    categories.bindStream(database.getCategories());
  }

  List<Product> getProductByCategory(Category category) {
    products.bindStream(database.getProductsByCategory(category));
    return products;
  }

  void addCategory(Category category) async {
    databaseService.addCategory(category);

    //  print(category.toMap());
  }

  void deleteCategory(Category category) async {
    print('Category to delete');
    databaseService.deleteCategory(category);
  }

  void toUpdateCategoryView(Category category) async {
    Get.to(() => UpdateCategoryView(
          currentCategory: category,
        ));
  }

  void editCategory(Category category) async {
    databaseService.updateCategory(category);
  }
}
