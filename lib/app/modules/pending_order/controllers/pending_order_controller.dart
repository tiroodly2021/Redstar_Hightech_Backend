import 'package:get/get.dart';

import '../../../services/database_service.dart';
import '../../order/models/order_model.dart';
import '../../product/models/product_model.dart';

class PendingOrderController extends GetxController {
  //TODO: Implement PendingOrderController
  DatabaseService database = DatabaseService();
  var orders = <Order>[].obs;
  var pendingOrders = <Order>[].obs;
  var products = <Product>[].obs;
  var count = 0.obs;

  Future<void> updatePendingOrder(Order order, String field, bool value) {
    return database.updatePendingOrder(order, field, value);
  }

  @override
  void onInit() {
    super.onInit();
    orders.bindStream(database.getOrders());
    pendingOrders.bindStream(database.getPendingOrders());
    count.bindStream(database.getCount('orders', 'PendingOrderController'));
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {}
}
