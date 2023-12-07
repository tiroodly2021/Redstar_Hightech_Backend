import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../routes/app_pages.dart';

class SecondMiddleware extends GetMiddleware {
  @override
  int? get priority => 4;

  bool isProfileSet = false;

  @override
  RouteSettings? redirect(String? route) {
    if (isProfileSet == false) {
      return const RouteSettings(name: Routes.PRODUCT);
    }
  }
}
