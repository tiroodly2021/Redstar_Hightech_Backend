import 'package:get/get.dart';
import 'package:redstar_hightech_backend/app/modules/cancelled_order/controllers/cancelled_order_controller.dart';
import 'package:redstar_hightech_backend/app/modules/category/controllers/category_controller.dart';
import 'package:redstar_hightech_backend/app/modules/order/controllers/order_controller.dart';
import 'package:redstar_hightech_backend/app/modules/order/controllers/orderstat_controller.dart';
import 'package:redstar_hightech_backend/app/modules/order_delivered/controllers/order_delivered_controller.dart';
import 'package:redstar_hightech_backend/app/modules/pending_order/controllers/pending_order_controller.dart';
import 'package:redstar_hightech_backend/app/modules/product/controllers/product_controller.dart';

import '../controllers/home_controller.dart';

class HomeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<HomeController>(
      () => HomeController(),
    );

    Get.lazyPut<OrderStatController>(
      () => OrderStatController(),
    );

    Get.lazyPut<ProductController>(
      () => ProductController(),
    );

    Get.lazyPut<CategoryController>(
      () => CategoryController(),
    );

    Get.lazyPut<OrderController>(
      () => OrderController(),
    );

    Get.lazyPut<PendingOrderController>(
      () => PendingOrderController(),
    );

    Get.lazyPut<CancelledOrderController>(
      () => CancelledOrderController(),
    );

    Get.lazyPut<OrderDeliveredController>(
      () => OrderDeliveredController(),
    );
  }
}
