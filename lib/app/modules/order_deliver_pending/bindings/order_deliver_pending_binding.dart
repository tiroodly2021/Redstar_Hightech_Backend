import 'package:get/get.dart';

import '../controllers/order_deliver_pending_controller.dart';

class OrderDeliverPendingBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<OrderDeliverPendingController>(
      () => OrderDeliverPendingController(),
    );
  }
}
