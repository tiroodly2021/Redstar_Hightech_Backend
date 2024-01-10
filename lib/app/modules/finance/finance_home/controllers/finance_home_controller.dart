import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:fab_circular_menu/fab_circular_menu.dart';

class FinanceHomeController extends GetxController {
  final GlobalKey<FabCircularMenuState> fabKey = GlobalKey();

  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {}

  openCloseFabMenu() {
    if (fabKey.currentState!.isOpen) {
      fabKey.currentState!.close();
    } else {
      fabKey.currentState!.open();
    }
  }
}
