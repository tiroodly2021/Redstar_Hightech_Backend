import 'package:get/get.dart';
import 'package:redstar_hightech_backend/app/services/database_service.dart';

import '../../product/models/product_model.dart';
import '../models/order_model.dart';

class OrderController extends GetxController {
  DatabaseService database = DatabaseService();
  var orders = <Order>[].obs;
  var pendingOrders = <Order>[].obs;
  var products = <Product>[].obs;

  Future<void> updateOrder(Order order, String field, bool value) {
    return database.updateOrder(order, field, value);
  }

  @override
  void onInit() {
    super.onInit();
    orders.bindStream(database.getOrders());
    pendingOrders.bindStream(database.getPendingOrders());
    // products.bindStream(database.getProductsOrders());
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {}
}
