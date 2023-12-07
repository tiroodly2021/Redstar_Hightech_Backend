import 'package:get/get.dart';
import 'package:redstar_hightech_backend/app/modules/authentication/controllers/permission_controller.dart';

import 'package:redstar_hightech_backend/app/modules/authentication/controllers/user_controller.dart';

import '../controllers/authentication_controller.dart';

class PermissionBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PermissionController>(
      () => PermissionController(),
    );
  }
}
