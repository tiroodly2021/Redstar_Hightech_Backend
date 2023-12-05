import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:redstar_hightech_backend/app/modules/category/models/category_model.dart';
import 'package:redstar_hightech_backend/app/modules/product/models/product_model.dart';
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
          category: '',
          imageUrl: '',
          isRecommended: false,
          isPopular: false)
      .obs;

  Icon randomIcon2() => Icon(iconData[r.nextInt(iconData.length)]);

  TextEditingController addNameController = TextEditingController();
  TextEditingController addDescriptionController = TextEditingController();

  RxList<String> categories = <String>[].obs;
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
    categories.bindStream(database.getCategoriesByName());
    products.bindStream(database.getProducts());
  }

  void addProduct(Product product) async {
    databaseService.addProduct(product);

    //  print(product.toMap());
  }

  void deleteProduct(Product product) async {
    print('Product to delete');
    print(product.toMap());
  }

  void toUpdateProductView(Product product) async {
    Get.to(() => UpdateProductView(
          currentProduct: product,
        ));
  }

  void editProduct(Product product) async {
    databaseService.updateProduct(product);
  }
}



/* import 'package:get/get.dart';
import 'package:redstar_hightech_backend/app/modules/product/models/product_model.dart';
import 'package:redstar_hightech_backend/app/services/database_service.dart';
//import 'package:responsive_table/responsive_table.dart';

import '../../category/models/category_model.dart';

class ProductController extends GetxController {
  DatabaseService database = DatabaseService();
  var products = <Product>[].obs;
  var imageLocalPath = ''.obs;
  var newProduct = {}.obs;
  var categories = <Category>[].obs;
  var categoriesByName = <String>[].obs;
  RxInt selectedIndex = 0.obs;
  var count = 0.obs;

  get price => newProduct['price'];
  get quantity => newProduct['quantity'];

  get isRecommended => newProduct['isRecommended'];

  get isPopular => newProduct['isPopular'];

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

  @override
  void onInit() {
    super.onInit();

    products.bindStream(database.getProducts());
    categories.bindStream(database.getCategories());
    count.bindStream(database.getCount('products', 'ProductController'));
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {}
}
 */