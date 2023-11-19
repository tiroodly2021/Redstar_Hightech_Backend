import 'package:get/get.dart';
import 'package:redstar_hightech_backend/app/modules/product/models/product_model.dart';
import 'package:redstar_hightech_backend/app/services/database_service.dart';
import 'package:responsive_table/responsive_table.dart';

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
