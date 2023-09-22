import 'package:get/get.dart';
import 'package:redstar_hightech_backend/app/services/database_service.dart';

import '../models/order_stats_model.dart';

class OrderStatController extends GetxController {
  final DatabaseService database = DatabaseService();
  var stats = Future.value(<OrderStats>[]).obs;

  @override
  void onInit() {
    stats.value = database.getOrderStats();

    super.onInit();
  }
}
