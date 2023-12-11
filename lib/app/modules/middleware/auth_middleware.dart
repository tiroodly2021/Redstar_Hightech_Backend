import 'dart:ffi';

import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:redstar_hightech_backend/app/modules/authentication/bindings/permission_binding.dart';
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

class AuthorizationMiddleware extends GetMiddleware {
  @override
  int? get priority => 2;

  final authController = Get.find<AuthenticationController>();
  final userController = Get.put(UserController());

  @override
  RouteSettings? redirect(String? route) {
    PermissionController permissionController = Get.put(PermissionController());
    RoleController roleController = Get.put(RoleController());

    //
    List<Role> roles = authController.authenticated
        ? roleController.roles
            .where((role) =>
                role.id ==
                Role.fromMap(userController.users.value
                        .where((user) =>
                            user.email.toLowerCase() ==
                            authController.user!.email!.toLowerCase())
                        .toList()[0]
                        .roles!)
                    .id)
            .toList()
        : [];
    Role role = roles.isNotEmpty
        ? roles.first
        : Role(id: "", description: '', name: '');

    List<Permission> permissions = role.permissionIds!.isEmpty
        ? []
        // ignore: invalid_use_of_protected_member
        : permissionController.permissions.value
            .where((permission) => permission.id == role.permissionIds![0])
            .toList();

    Permission permission = permissions.isNotEmpty
        ? permissions.first
        : Permission(description: '');

    print(permission.description);

    if (authController.authenticated || route == Routes.LOGIN) {
      if (permission.description == route?.replaceAll("/", " ")) {
        print("Page authorized");
        return null;
      } else {
        return const RouteSettings(name: Routes.ACCESS_ERROR);
      }
    } else {
      print("Page not authorization");
      return const RouteSettings(name: Routes.LOGIN);
    }

    /*  return authController.authenticated || route == Routes.LOGIN
        ? null
        : const RouteSettings(name: Routes.LOGIN); */
  }

  /*




  */

  //This function will be called  before anything created we can use it to
  // change something about the page or give it new page
  @override
  GetPage? onPageCalled(GetPage? page) {
    print('>>> Page ${page!.name} called');

    /* print(
        '>>> User ${authController.user != null ? authController.user!.email : ''} logged');

    print('>>> Authenticated : ${authController.authenticated} ');*/

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

  @override
  List<Object?> get props => [authController, userController];
}
