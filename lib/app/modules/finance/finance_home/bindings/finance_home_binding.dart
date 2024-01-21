import 'package:get/get.dart';
import 'package:redstar_hightech_backend/app/modules/finance/account/controllers/account_controller.dart';

import '../controllers/finance_home_controller.dart';

class FinanceHomeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<FinanceHomeController>(
      () => FinanceHomeController(),
    );

    Get.lazyPut<AccountController>(
      () => AccountController(),
    );
  }
}
