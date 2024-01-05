import 'package:get/get.dart';

import '../controllers/account_category_controller.dart';

class AccountCategoryBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AccountCategoryController>(
      () => AccountCategoryController(),
    );
  }
}
