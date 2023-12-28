import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:redstar_hightech_backend/app/modules/category/models/category_model.dart';
import 'package:redstar_hightech_backend/app/modules/product/bindings/product_binding.dart';
import 'package:redstar_hightech_backend/app/modules/product/models/product_model.dart';
import 'package:redstar_hightech_backend/app/routes/app_pages.dart';
import 'package:redstar_hightech_backend/app/services/database_service.dart';

import '../views/update_product_view.dart';

class ProductController extends GetxController {
  DatabaseService databaseService = DatabaseService();
  RxBool loading = false.obs;
  Map<String, dynamic> body = {};
  RxList<Product> products = <Product>[].obs;
  RxString titleGame = ''.obs;
  final List<IconData> iconData = <IconData>[Icons.call, Icons.school];
  final Random r = Random();

  DatabaseService database = DatabaseService();

  Rx<Product> product = Product(
          name: '',
          description: '',
          imageUrl: '',
          isRecommended: false,
          isPopular: false)
      .obs;

  Icon randomIcon2() => Icon(iconData[r.nextInt(iconData.length)]);

  TextEditingController addNameController = TextEditingController();
  TextEditingController addDescriptionController = TextEditingController();

  //RxList<String> categories = <String>[].obs;

  RxList<Category> categories = <Category>[].obs;
  Rx<Category> category = Category(name: '', imageUrl: '').obs;

  RxString categorySelected = ''.obs;
  RxString imageLink = ''.obs;
  RxString imageLinkTemp = ''.obs;

  var count = 0.obs;

  Map checkList = {}.obs;
  Map slideList = {}.obs;

  @override
  void onInit() {
    super.onInit();
    productList();
  }

  get isRecommended => checkList['isRecommended'];
  get isPopular => checkList['isPopular'];

  get price => slideList['price'];
  get quantity => slideList['quantity'];

  void updateProductPrice(int index, Product product, double value) {
    product.price = value;
    products[index] = product;
  }

  void updateProductQuantity(int index, Product product, int value) {
    product.quantity = value;
    products[index] = product;
  }

  void saveNewProductPrice(Product product, String field, double value) {
    database.updateField(product, field, value);
  }

  void saveNewProductQuantity(Product product, String field, int value) {
    database.updateField(product, field, value);
  }

  void productList() async {
    count.bindStream(database.getCount('products', 'ProductController'));
    categories.bindStream(database.getCategories());
    products.bindStream(database.getProducts());
  }

  void addProductWithCategory(Product product, Category category) async {
    databaseService.addProductWithCategory(product, category);

    //  print(product.toMap());
  }

  void deleteProduct(Product product) async {
    print('Here deleting... product');

    databaseService.deleteProduct(product);
  }

  void toUpdateProductView(Product product) {
    print('category selected in controller: ' + categorySelected.value);
    Get.toNamed(AppPages.UPDATE_PRODUCT, arguments: product);
  }

  void editProductWithCategory(Product product, Category category) async {
    databaseService.updateProduct(product, category);
  }

  Future<List<Category>?> getCategoryByProduct(Product product) {
    return databaseService.getCategoryByProduct(product);
  }
}
