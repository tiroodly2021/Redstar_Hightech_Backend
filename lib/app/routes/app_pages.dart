import 'package:get/get.dart';
import 'package:redstar_hightech_backend/app/modules/settings/views/edit_profile.dart';

import '../modules/cancelled_order/bindings/cancelled_order_binding.dart';
import '../modules/cancelled_order/views/cancelled_order_view.dart';
import '../modules/category/bindings/category_binding.dart';
import '../modules/category/views/category_view.dart';
import '../modules/category/views/edit_category_view.dart';
import '../modules/category/views/new_category_view.dart';
import '../modules/home/bindings/home_binding.dart';
import '../modules/home/views/home_view.dart';
import '../modules/order/bindings/order_binding.dart';
import '../modules/order/views/order_view.dart';
import '../modules/order_deliver_pending/bindings/order_deliver_pending_binding.dart';
import '../modules/order_deliver_pending/views/order_deliver_pending_view.dart';
import '../modules/order_delivered/bindings/order_delivered_binding.dart';
import '../modules/order_delivered/views/order_delivered_view.dart';
import '../modules/pending_order/bindings/pending_order_binding.dart';
import '../modules/pending_order/views/pending_order_view.dart';
import '../modules/product/bindings/product_binding.dart';
import '../modules/product/views/edit_product_view.dart';
import '../modules/product/views/new_product_view.dart';
import '../modules/product/views/product_view.dart';
import '../modules/product/views/products_list_view.dart';
import '../modules/settings/bindings/settings_binding.dart';
import '../modules/settings/views/settings_view.dart';
import '../splashscreen.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const INITIAL = Routes.INITIAL;
  static const HOME = Routes.HOME;
  static const PRODUCT = Routes.PRODUCT;
  static const NEW_PRODUCT = Routes.NEW_PRODUCT;
  static const PRODUCT_LIST = Routes.PRODUCT_LIST;
  static const ORDER = Routes.ORDER;
  static const CATEGORY = Routes.CATEGORY;
  static const NEW_CATEGORY = Routes.NEW_CATEGORY;
  static const EDIT_CATEGORY = Routes.EDIT_CATEGORY;
  static const EDIT_PRODUCT = Routes.EDIT_PRODUCT;
  static const PENDING_ORDER = Routes.PENDING_ORDER;
  static const CANCELLED_ORDER = Routes.CANCELLED_ORDER;
  static const ORDER_DELIVERED = Routes.ORDER_DELIVERED;
  static const EDIT_PROFILE = Routes.EDIT_PROFILE;

  static final routes = [
    GetPage(name: _Paths.EDIT_PROFILE, page: () => const EditProfile()),
    GetPage(name: _Paths.SPLASH, page: () => const SplashScreen()),
    GetPage(
      name: _Paths.HOME,
      page: () => HomeView(),
      binding: HomeBinding(),
    ),
    GetPage(
      name: _Paths.PRODUCT,
      page: () => ProductView(),
      binding: ProductBinding(),
    ),
    GetPage(
      name: _Paths.NEW_PRODUCT,
      page: () => NewProductView(),
      binding: ProductBinding(),
    ),
    GetPage(
      name: _Paths.PRODUCT_LIST,
      page: () => ProductsListView(),
      binding: ProductBinding(),
    ),
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
      name: _Paths.NEW_CATEGORY,
      page: () => NewCategoryView(),
      binding: CategoryBinding(),
    ),
    GetPage(
      name: _Paths.EDIT_CATEGORY,
      page: () => EditCategoryView(),
      binding: CategoryBinding(),
    ),
    GetPage(
      name: _Paths.EDIT_PRODUCT,
      page: () => EditProductView(),
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
      page: () =>const SettingsView(),
      binding: SettingsBinding(),
    ),
  ];

  @override
  List<Object?> get props => [
        INITIAL,
        HOME,
        PRODUCT,
        NEW_PRODUCT,
        PRODUCT_LIST,
        ORDER,
        CATEGORY,
        NEW_CATEGORY,
        EDIT_CATEGORY,
        EDIT_PRODUCT,
        PENDING_ORDER,
        CANCELLED_ORDER,
        ORDER_DELIVERED,
        EDIT_PROFILE,
        routes
      ];

  @override
  String toString() {
    return 'AppPages{INITIAL=$INITIAL, HOME=$HOME, PRODUCT=$PRODUCT, NEW_PRODUCT=$NEW_PRODUCT, PRODUCT_LIST=$PRODUCT_LIST, ORDER=$ORDER, CATEGORY=$CATEGORY, NEW_CATEGORY=$NEW_CATEGORY, EDIT_CATEGORY=$EDIT_CATEGORY, EDIT_PRODUCT=$EDIT_PRODUCT, PENDING_ORDER=$PENDING_ORDER, CANCELLED_ORDER=$CANCELLED_ORDER, ORDER_DELIVERED=$ORDER_DELIVERED, EDIT_PROFILE=$EDIT_PROFILE, routes=$routes}';
  }
}
