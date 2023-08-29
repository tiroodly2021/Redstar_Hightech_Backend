import 'package:get/get.dart';
import 'package:redstar_hightech_backend/app/modules/product/models/product_model.dart';

class ProductController extends GetxController {
  List<Product> products = Product.products.obs;

  void updateProductPrice(int index, Product product, double value) {
    product.price = value;
    products[index] = product;
  }

  void updateProductQuantity(int index, Product product, int value) {
    product.quantity = value;
    products[index] = product;
  }

  final count = 0.obs;
  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {}
  void increment() => count.value++;
}
