import 'package:get/get.dart';

import '../../../services/database_service.dart';
import '../../order/models/order_model.dart';
import '../../product/models/product_model.dart';

class CancelledOrderController extends GetxController {
  DatabaseService database = DatabaseService();
  var cancelledOrders = <Order>[].obs;
  var products = <Product>[].obs;
  var count = 0.obs;

  Future<void> updateCancelledOrder(Order order, String field, bool value) {
    return database.updateCancelledOrder(order, field, value);
  }

  @override
  void onInit() {
    super.onInit();
    cancelledOrders.bindStream(database.getCancelledOrders());
    count.bindStream(database.getCount('orders', 'CancelledOrderController'));
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {}
}
