import 'package:get/get.dart';

import 'package:redstar_hightech_backend/app/modules/authentication/controllers/role_controller.dart';
import 'package:redstar_hightech_backend/app/modules/authentication/controllers/user_controller.dart';

import '../controllers/authentication_controller.dart';

class AuthenticationBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<UserController>(
      () => UserController(),
    );

    Get.lazyPut<AuthenticationController>(
      () => AuthenticationController(),
    );
  }
}
