import 'package:get/get.dart';
import 'package:redstar_hightech_backend/app/modules/authentication/bindings/user_binding.dart';
import 'package:redstar_hightech_backend/app/modules/authentication/controllers/authentication_controller.dart';
import 'package:redstar_hightech_backend/app/modules/authentication/controllers/user_controller.dart';
import 'package:redstar_hightech_backend/app/modules/authentication/views/add_user.dart';
import 'package:redstar_hightech_backend/app/modules/authentication/views/admin/permissions/add_permission_view.dart';
import 'package:redstar_hightech_backend/app/modules/authentication/views/admin/permissions/permission_view.dart';
import 'package:redstar_hightech_backend/app/modules/authentication/views/admin/permissions/update_permission_view.dart';
import 'package:redstar_hightech_backend/app/modules/authentication/views/admin/roles/add_role_view.dart';
import 'package:redstar_hightech_backend/app/modules/authentication/views/admin/roles/role_view.dart';
import 'package:redstar_hightech_backend/app/modules/authentication/views/admin/roles/update_role_view.dart';
import 'package:redstar_hightech_backend/app/modules/authentication/views/login_view.dart';
import 'package:redstar_hightech_backend/app/modules/authentication/views/registration_view.dart';
import 'package:redstar_hightech_backend/app/modules/authentication/views/update_user.dart';
import 'package:redstar_hightech_backend/app/modules/authentication/views/user_view.dart';
import 'package:redstar_hightech_backend/app/modules/authentication/views/user_view.dart';
import 'package:redstar_hightech_backend/app/modules/category/views/update_category_view.dart';
import 'package:redstar_hightech_backend/app/modules/middleware/redict_to_login_middleware.dart';

import '../modules/authentication/bindings/authentication_binding.dart';
import '../modules/authentication/bindings/permission_binding.dart';
import '../modules/authentication/bindings/role_binding.dart';
import '../modules/cancelled_order/bindings/cancelled_order_binding.dart';
import '../modules/cancelled_order/views/cancelled_order_view.dart';
import '../modules/category/bindings/category_binding.dart';
import '../modules/category/views/add_category_view.dart';
import '../modules/category/views/category_view.dart';
import '../modules/home/bindings/home_binding.dart';
import '../modules/home/views/home_view.dart';

import '../modules/middleware/second_middleware.dart';
import '../modules/order/bindings/order_binding.dart';
import '../modules/order/views/order_view.dart';
import '../modules/order_deliver_pending/bindings/order_deliver_pending_binding.dart';
import '../modules/order_deliver_pending/views/order_deliver_pending_view.dart';
import '../modules/order_delivered/bindings/order_delivered_binding.dart';
import '../modules/order_delivered/views/order_delivered_view.dart';
import '../modules/pending_order/bindings/pending_order_binding.dart';
import '../modules/pending_order/views/pending_order_view.dart';
import '../modules/product/bindings/product_binding.dart';
import '../modules/product/views/update_product_view.dart';
import '../modules/product/views/add_product_view.dart';
import '../modules/product/views/product_view.dart';
import '../modules/product/views/products_list_view.dart';
import '../modules/settings/bindings/settings_binding.dart';
import '../modules/settings/views/edit_profile.dart';
import '../modules/settings/views/settings_view.dart';
import '../splashscreen.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const INITIAL = Routes.INITIAL;
  static const HOME = Routes.HOME;
  static const PRODUCT = Routes.PRODUCT;
  static const ADD_PRODUCT = Routes.ADD_PRODUCT;
  static const PRODUCT_LIST = Routes.PRODUCT_LIST;
  static const ORDER = Routes.ORDER;

  static const CATEGORY = Routes.CATEGORY;
  static const ADD_CATEGORY = Routes.ADD_CATEGORY;
  static const UPDATE_CATEGORY = Routes.UPDATE_CATEGORY;

  static const UPDATE_PRODUCT = Routes.UPDATE_PRODUCT;
  static const PENDING_ORDER = Routes.PENDING_ORDER;
  static const CANCELLED_ORDER = Routes.CANCELLED_ORDER;
  static const ORDER_DELIVERED = Routes.ORDER_DELIVERED;
  static const EDIT_PROFILE = Routes.EDIT_PROFILE;
  static const LOGIN = Routes.LOGIN;
  static const REGISTRATION = Routes.REGISTRATION;
  static const SETTINGS = Routes.SETTINGS;

  static const USER = Routes.USER;
  static const ADD_USER = Routes.ADD_USER;
  static const UPDATE_USER = Routes.UPDATE_USER;

  static const ROLE = Routes.ROLE;
  static const ADD_ROLE = Routes.ADD_ROLE;
  static const UPDATE_ROLE = Routes.UPDATE_ROLE;

  static const PERMISSION = Routes.PERMISSION;
  static const ADD_PERMISSION = Routes.ADD_PERMISSION;
  static const UPDATE_PERMISSION = Routes.UPDATE_PERMISSION;

  static final routes = [
    GetPage(
        name: _Paths.UPDATE_PERMISSION,
        page: () => UpdatePermissionView(),
        binding: PermissionBinding()),
    GetPage(
        name: _Paths.ADD_PERMISSION,
        page: () => AddPermissionView(),
        binding: PermissionBinding()),
    GetPage(
      name: _Paths.PERMISSION,
      page: () => PermissionView(),
      binding:
          PermissionBinding(), /*   middlewares: [RedirectToLoginMiddleware()] */
    ),
    GetPage(name: _Paths.ROLE, page: () => RoleView(), binding: RoleBinding()),
    GetPage(
        name: _Paths.UPDATE_ROLE,
        page: () => UpdateRoleView(),
        binding: RoleBinding()),
    GetPage(
        name: _Paths.ADD_ROLE,
        page: () => AddRoleView(),
        binding: RoleBinding()),
    GetPage(
      name: _Paths.UPDATE_USER,
      page: () => UpdateUserView(),
      binding: UserBinding(), /*  middlewares: [RedirectToLoginMiddleware()] */
    ),
    GetPage(
        name: _Paths.ADD_USER,
        page: () => AddUserView(),
        binding:
            UserBinding() /* ,
        middlewares: [RedirectToLoginMiddleware()] */
        ),
    GetPage(name: _Paths.EDIT_PROFILE, page: () => const EditProfile()),
    GetPage(name: _Paths.SPLASH, page: () => const SplashScreen()),
    GetPage(name: _Paths.HOME, page: () => HomeView(), binding: HomeBinding()),
    GetPage(
      name: _Paths.PRODUCT,
      page: () => ProductView(),
      binding: ProductBinding(),
    ),
    GetPage(
      name: _Paths.ADD_PRODUCT,
      page: () => AddProductView(),
      binding: ProductBinding(),
    ),
    /*  GetPage(
      name: _Paths.PRODUCT_LIST,
      page: () => ProductsListView(),
      binding: ProductBinding(),
    ), */
    GetPage(
      name: _Paths.ORDER,
      page: () => OrderView(),
      binding: OrderBinding(),
    ),
    GetPage(
      name: _Paths.CATEGORY,
      page: () => CategoryView(),
      binding: CategoryBinding(),
    ),
    GetPage(
      name: _Paths.ADD_CATEGORY,
      page: () => AddCategoryView(),
      binding: CategoryBinding(),
    ),
    GetPage(
      name: _Paths.UPDATE_CATEGORY,
      page: () => UpdateCategoryView(),
      binding: CategoryBinding(),
    ),
    GetPage(
      name: _Paths.UPDATE_PRODUCT,
      page: () => UpdateProductView(),
      binding: ProductBinding(),
    ),
    GetPage(
      name: _Paths.PENDING_ORDER,
      page: () => PendingOrderView(),
      binding: PendingOrderBinding(),
    ),
    GetPage(
      name: _Paths.CANCELLED_ORDER,
      page: () => CancelledOrderView(),
      binding: CancelledOrderBinding(),
    ),
    GetPage(
      name: _Paths.ORDER_DELIVERED,
      page: () => OrderDeliveredView(),
      binding: OrderDeliveredBinding(),
    ),
    GetPage(
      name: _Paths.ORDER_DELIVER_PENDING,
      page: () => OrderDeliverPendingView(),
      binding: OrderDeliverPendingBinding(),
    ),
    GetPage(
      name: _Paths.SETTINGS,
      page: () => const SettingsView(),
      binding: SettingsBinding(),
    ),
    GetPage(
      name: _Paths.LOGIN,
      page: () => LoginView(),
      binding: AuthenticationBinding(),
    ),
    GetPage(
      name: _Paths.REGISTRATION,
      page: () => RegistrationView(),
      binding: AuthenticationBinding(),
    ),
    GetPage(
      name: _Paths.USER,
      page: () => UserView(),
      binding: UserBinding(), /*   middlewares: [RedirectToLoginMiddleware()] */
    ),
  ];
}
