import 'package:get/get.dart';

import '../../product/controllers/product_controller.dart';
import '../controllers/pending_order_controller.dart';

class PendingOrderBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PendingOrderController>(
      () => PendingOrderController(),
    );
    Get.lazyPut<ProductController>(
      () => ProductController(),
    );
  }
}
