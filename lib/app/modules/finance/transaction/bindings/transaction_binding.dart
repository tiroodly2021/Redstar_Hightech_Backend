import 'package:get/get.dart';
import 'package:redstar_hightech_backend/app/modules/finance/transaction/controllers/personalized_transaction_controller.dart';

import '../controllers/transaction_controller.dart';

class TransactionBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<TransactionController>(
      () => TransactionController(),
    );
    Get.lazyPut<PersonalizedTransactionController>(
      () => PersonalizedTransactionController(),
    );
  }
}
