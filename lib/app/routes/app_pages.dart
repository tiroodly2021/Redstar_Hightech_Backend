import 'package:get/get.dart';
import 'package:redstar_hightech_backend/app/modules/category/views/edit_category_view.dart';
import 'package:redstar_hightech_backend/app/modules/category/views/new_category_view.dart';
import 'package:redstar_hightech_backend/app/modules/product/views/edit_product_view.dart';

import '../modules/category/bindings/category_binding.dart';
import '../modules/category/views/category_view.dart';
import '../modules/home/bindings/home_binding.dart';
import '../modules/home/views/home_view.dart';
import '../modules/order/bindings/order_binding.dart';
import '../modules/order/views/order_view.dart';
import '../modules/product/bindings/product_binding.dart';
import '../modules/product/views/new_product_view.dart';
import '../modules/product/views/product_view.dart';
import '../modules/product/views/products_list_view.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const INITIAL = Routes.HOME;
  static const PRODUCT = Routes.PRODUCT;
  static const NEW_PRODUCT = Routes.NEW_PRODUCT;
  static const PRODUCT_LIST = Routes.PRODUCT_LIST;
  static const ORDER = Routes.ORDER;
  static const CATEGORY = Routes.CATEGORY;
  static const NEW_CATEGORY = Routes.NEW_CATEGORY;
  static const EDIT_CATEGORY = Routes.EDIT_CATEGORY;
  static const EDIT_PRODUCT = Routes.EDIT_PRODUCT;

  static final routes = [
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
  ];
}
