import 'package:get/get.dart';
import 'package:redstar_hightech_backend/app/modules/product/views/new_product_view.dart';

import '../modules/home/bindings/home_binding.dart';
import '../modules/home/views/home_view.dart';
import '../modules/product/bindings/product_binding.dart';
import '../modules/product/views/product_view.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const INITIAL = Routes.HOME;
  static const PRODUCT = Routes.PRODUCT;
  static const NEW_PRODUCT = Routes.NEW_PRODUCT;

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
  ];
}
