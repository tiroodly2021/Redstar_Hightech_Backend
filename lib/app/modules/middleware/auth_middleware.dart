import 'dart:ffi';

import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:redstar_hightech_backend/app/constants/const.dart';
import 'package:redstar_hightech_backend/app/modules/authentication/bindings/permission_binding.dart';
import 'package:redstar_hightech_backend/app/modules/authentication/bindings/role_binding.dart';
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

  static bool checkPermission(AuthenticationController authController,
      UserController userController, String route) {
    /* PermissionController permissionController = Get.put(PermissionController());
    RoleController roleController = Get.put(RoleController());

    List<String> allPermissions = [];

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

    if (role.permissionIds != null) {
      if (role.permissionIds!.isNotEmpty) {
        for (var id in role.permissionIds!) {
          permissionController.permissions.value.forEach((element) {
            if (element.id == id) {
              allPermissions.add(element.description);
            }
          });
        }
      }
    }

    print('all premission ${allPermissions}');
    print('authenticated: ${authController.authenticated}');
    print(
        ' (Get.find<AuthenticationController>().user!.email == superUserEmail &&Get.find<AuthenticationController>().authenticated) : ' +
            (Get.find<AuthenticationController>().user!.email!.toLowerCase() ==
                        superUserEmail.toLowerCase() &&
                    Get.find<AuthenticationController>().authenticated)
                .toString());

    if (allPermissions.contains(route.replaceAll("/", " ")) ||
        (Get.find<AuthenticationController>().user!.email!.toLowerCase() ==
                superUserEmail.toLowerCase() &&
            Get.find<AuthenticationController>().authenticated)) {
      print("Page authorized route: ${route}");
      return true;
    } */

    return true;
  }

  @override
  RouteSettings? redirect(String? route) {
    PermissionController permissionController = Get.put(PermissionController());
    RoleController roleController = Get.put(RoleController());

    List<String> allPermissions = [];
    List<User> usersList = [];
    List<Role> allRoles = roleController.roles;

    Role roleToTest = Role(id: '', name: '', description: '');

    if (Get.find<AuthenticationController>().user != null) {
      if (Get.find<AuthenticationController>().user!.email!.toLowerCase() !=
          superUserEmail.toLowerCase()) {
        usersList = userController.users.value
            .where((user) =>
                user.email.toLowerCase() ==
                authController.user!.email!.toLowerCase())
            .toList();

        print("userList ${usersList[0].toMap()}");

        /*    print(
            "user from middleware : ${userController.getRoleByUserAsReal(usersList[0])} "); */
/* 
        print(
            'Roles disponible ${userController.roles.value.map((role) => "${role.id} -- ${role.name} -- ${role.description}")}');
 */
        return null;

/* 
        if (usersList.isNotEmpty) {


          roleToTest = userController.getRoleByUserAsReal(usersList[0]) != null
              ? userController.getRoleByUserAsReal(usersList[0])[0]
              : Role(id: '', name: '', description: '');
        } */

        List<Role> roles = authController.authenticated
            ? roleController.roles
                .where((role) => role.id == roleToTest.id)
                .toList()
            : [];

        Role role = roles.isNotEmpty
            ? roles.first
            : Role(id: "", description: '', name: '');

        if (roleController.getPermissionByRoleAsReal(role) != null) {
          if (roleController.getPermissionByRoleAsReal(role)!.isNotEmpty) {
            for (var id in roleController.getPermissionByRoleAsReal(role)!) {
              permissionController.permissions.value.forEach((element) {
                if (element.id == id) {
                  allPermissions.add(element.description);
                }
              });
            }
          }
        }
      }
    }

    if (authController.authenticated == true && route != Routes.LOGIN) {
      if (allPermissions.contains(route?.replaceAll("/", " ")) ||
          (Get.find<AuthenticationController>().user!.email!.toLowerCase() ==
                  superUserEmail.toLowerCase() &&
              Get.find<AuthenticationController>().authenticated)) {
        print("Page authorized route: ${route!}");
        return null;
      } else {
        return const RouteSettings(name: Routes.ACCESS_ERROR);
      }
    } else {
      print("Page not authorization");
      return const RouteSettings(name: Routes.LOGIN);
    }

    //return null;
  }

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
    bindings = [HomeBinding(), PermissionBinding(), RoleBinding()];
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
