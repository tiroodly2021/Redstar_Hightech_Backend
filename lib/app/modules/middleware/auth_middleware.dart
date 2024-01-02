import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:redstar_hightech_backend/app/constants/const.dart';
import 'package:redstar_hightech_backend/app/modules/authentication/bindings/permission_binding.dart';
import 'package:redstar_hightech_backend/app/modules/authentication/bindings/role_binding.dart';
import 'package:redstar_hightech_backend/app/modules/authentication/bindings/user_binding.dart';
import 'package:redstar_hightech_backend/app/modules/authentication/controllers/authentication_controller.dart';
import 'package:redstar_hightech_backend/app/modules/authentication/controllers/permission_controller.dart';
import 'package:redstar_hightech_backend/app/modules/authentication/controllers/role_controller.dart';
import 'package:redstar_hightech_backend/app/modules/authentication/models/permission_model.dart';
import 'package:redstar_hightech_backend/app/modules/category/bindings/category_binding.dart';
import 'package:redstar_hightech_backend/app/modules/home/bindings/home_binding.dart';
import 'package:redstar_hightech_backend/app/modules/home/controllers/home_controller.dart';

import '../../routes/app_pages.dart';
import '../authentication/controllers/user_controller.dart';
import '../authentication/models/role_model.dart';
import '../authentication/models/user_model.dart';
import '../authentication/views/login_view.dart';

import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:redstar_hightech_backend/app/modules/authentication/models/user_model.dart'
    as localModel;

class AuthorizationMiddleware extends GetMiddleware {
  @override
  int? get priority => midPriority;
  int? midPriority;

  AuthorizationMiddleware({this.midPriority = 10});

  late List<Permission> permissions;

  final authController = Get.put(
      AuthenticationController()); //Get.find<AuthenticationController>();
  final userController = Get.put(UserController());

  static bool checkPermission(AuthenticationController authController,
      UserController userController, String route) {
    List<String> permissionStringLists =
        authController.userPermission.map((e) => e.description).toList();

    if (permissionStringLists.contains(route.replaceAll("/", " ")) ||
        (Get.find<AuthenticationController>().user!.email!.toLowerCase() ==
                superUserEmail.toLowerCase() &&
            Get.find<AuthenticationController>().authenticated)) {
      return true;
    }

    return false;
  }

  @override
  RouteSettings? redirect(String? route) {
    List<String> permissionStringLists =
        authController.userPermission.map((e) => e.description).toList();

    List<String> guestPermissionStringLists =
        authController.guestPermission.map((e) => e.description).toList();

    print('check guest permissions ${authController.guestPermission}');

    print('check auth permissions ${authController.userPermission}');

    if (authController.authenticated == true && route != Routes.LOGIN) {
      if (permissionStringLists.contains(route?.replaceAll("/", " ")) ||
          (Get.find<AuthenticationController>().user!.email!.toLowerCase() ==
                  superUserEmail.toLowerCase() &&
              Get.find<AuthenticationController>().authenticated)) {
        return null;
      } else {
        return const RouteSettings(name: Routes.ACCESS_ERROR);
      }
    } else {
      if (guestPermissionStringLists.contains(route?.replaceAll("/", " "))) {
        return null;
      }
      return const RouteSettings(name: Routes.LOGIN);
    }
  }

  //This function will be called  before anything created we can use it to
  // change something about the page or give it new page
  @override
  GetPage? onPageCalled(GetPage? page) {
    print('>>> Page ${page!.name} called/  Auth Middleware applied');

    Get.find<AuthenticationController>().onInit();

    authController.user != null
        ? page.copyWith(arguments: {'user': authController.user!.email})
        : page;

    return super.onPageCalled(page);
  }

  //This function will be called right before the Bindings are initialized.
  // Here we can change Bindings for this page.
  @override
  List<Bindings>? onBindingsStart(List<Bindings>? bindings) {
    bindings = [
      HomeBinding(),
      PermissionBinding(),
      RoleBinding(),
      UserBinding()
    ];
    return super.onBindingsStart(bindings);
  }

  //This function will be called right after the Bindings are initialized.
  // Here we can do something after  bindings created and before creating the page widget.
  @override
  GetPageBuilder? onPageBuildStart(GetPageBuilder? page) {
    return super.onPageBuildStart(page);
  }

  // Page build and widgets of page will be shown
  @override
  Widget onPageBuilt(Widget page) {
    return super.onPageBuilt(page);
  }

  //This function will be called right after disposing all the related objects
  // (Controllers, views, ...) of the page.
  @override
  void onPageDispose() {
    super.onPageDispose();
  }

  @override
  List<Object?> get props => [authController, userController];
}
