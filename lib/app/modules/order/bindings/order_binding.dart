import 'package:get/get.dart';
import 'package:redstar_hightech_backend/app/modules/product/controllers/product_controller.dart';

import '../controllers/order_controller.dart';

class OrderBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<OrderController>(
      () => OrderController(),
    );

    Get.lazyPut<ProductController>(
      () => ProductController(),
    );
  }
}
