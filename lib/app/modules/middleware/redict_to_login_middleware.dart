import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:redstar_hightech_backend/app/modules/authentication/bindings/permission_binding.dart';
import 'package:redstar_hightech_backend/app/modules/authentication/controllers/authentication_controller.dart';
import 'package:redstar_hightech_backend/app/modules/category/bindings/category_binding.dart';
import 'package:redstar_hightech_backend/app/modules/home/bindings/home_binding.dart';
import 'package:redstar_hightech_backend/app/modules/home/controllers/home_controller.dart';

import '../../routes/app_pages.dart';
import '../authentication/controllers/user_controller.dart';
import '../authentication/models/user_model.dart';
import '../authentication/views/login_view.dart';

class RedirectToLoginMiddleware extends GetMiddleware {
  @override
  int? get priority => 2;

  final authController = Get.find<AuthenticationController>();
  final userController = Get.put(UserController());

  @override
  RouteSettings? redirect(String? route) {
    return authController.authenticated || route == Routes.LOGIN
        ? null
        : const RouteSettings(name: Routes.LOGIN);
  }

  //This function will be called  before anything created we can use it to
  // change something about the page or give it new page
  @override
  GetPage? onPageCalled(GetPage? page) {
    print('>>> Page ${page!.name} called');

    print(
        '>>> User ${authController.user != null ? authController.user!.email : ''} logged');

    print('>>> Authenticated : ${authController.authenticated} ');

    if (authController.user != null) {
      List<User> userModel = userController.users.value
          .where((user) =>
              user.email.toLowerCase() ==
              authController.user!.email!.toLowerCase())
          .toList();

      /* if (userModel != null) {
        print("Role: " + userModel.role);
      } 
 */
      for (var user in userModel /* userController.users.value */) {
        print(user.email);
        print(user.name);
        //print(user.role);
      }
    }

    authController.user != null
        ? page.copyWith(arguments: {'user': authController.user!.email})
        : page;

    return super.onPageCalled(page);
  }

  //This function will be called right before the Bindings are initialized.
  // Here we can change Bindings for this page.
  @override
  List<Bindings>? onBindingsStart(List<Bindings>? bindings) {
    bindings = [CategoryBinding(), HomeBinding(), PermissionBinding()];
    return super.onBindingsStart(bindings);
  }

  //This function will be called right after the Bindings are initialized.
  // Here we can do something after  bindings created and before creating the page widget.
  @override
  GetPageBuilder? onPageBuildStart(GetPageBuilder? page) {
    print('Bindings of ${page.toString()} are ready');

    return super.onPageBuildStart(page);
  }

  // Page build and widgets of page will be shown
  @override
  Widget onPageBuilt(Widget page) {
    print('Widget ${page.toStringShort()} will be showed');
    return super.onPageBuilt(page);
  }

  //This function will be called right after disposing all the related objects
  // (Controllers, views, ...) of the page.
  @override
  void onPageDispose() {
    print('PageDisposed');
    super.onPageDispose();
  }
}
