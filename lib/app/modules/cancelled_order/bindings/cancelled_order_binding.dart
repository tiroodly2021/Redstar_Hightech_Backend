import 'package:get/get.dart';

import '../controllers/cancelled_order_controller.dart';

class CancelledOrderBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<CancelledOrderController>(
      () => CancelledOrderController(),
    );
  }
}
