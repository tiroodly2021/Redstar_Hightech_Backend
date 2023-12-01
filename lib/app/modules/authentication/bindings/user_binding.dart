import 'package:get/get.dart';

import 'package:redstar_hightech_backend/app/modules/authentication/controllers/user_controller.dart';

import '../controllers/authentication_controller.dart';

class UserBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<UserController>(
      () => UserController(),
    );
  }
}
