import 'package:get/get.dart';

import '../../../services/database_service.dart';
import '../../order/models/order_model.dart';
import '../../product/models/product_model.dart';

class OrderDeliveredController extends GetxController {
  DatabaseService database = DatabaseService();
  var orders = <Order>[].obs;
  var products = <Product>[].obs;
  final count = 0.obs;

  Future<void> updateOrderDelivered(Order order, String field, bool value) {
    return database.updateOrderDelivered(order, field, value);
  }

  @override
  void onInit() {
    super.onInit();
    orders.bindStream(database.getOrderDelivered());
    count.bindStream(database.getCount('orders', 'OrderDeliveredController'));
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {}
}
