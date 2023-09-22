import 'package:get/get.dart';
import 'package:redstar_hightech_backend/app/modules/category/controllers/category_controller.dart';

import 'package:redstar_hightech_backend/app/modules/product/controllers/products_list_controller.dart';

import '../controllers/product_controller.dart';

class ProductBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ProductsListController>(
      () => ProductsListController(),
    );
    Get.lazyPut<ProductController>(
      () => ProductController(),
    );

    Get.lazyPut<CategoryController>(() => CategoryController());
  }
}
