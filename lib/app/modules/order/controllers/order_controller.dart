import 'package:get/get.dart';
import 'package:redstar_hightech_backend/app/services/database_service.dart';

import '../../product/models/product_model.dart';
import '../models/order_model.dart';

class OrderController extends GetxController {
  DatabaseService database = DatabaseService();
  var orders = <Order>[].obs;
  var products = <Product>[].obs;
  var count = 0.obs;

  Future<void> updateOrder(Order order, String field, bool value) {
    return database.updateOrder(order, field, value);
  }

  @override
  void onInit() {
    super.onInit();
    orders.bindStream(database.getOrders());
    count.bindStream(database.getCount('orders', 'OrderController'));
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {}

  @override
  List<Object?> get props => [database, orders, products, count];
}
