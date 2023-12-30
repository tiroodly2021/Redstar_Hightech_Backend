import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:get/get.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../../routes/app_pages.dart';

class HomeController extends GetxController {
  @override
  void onInit() {
    print('>>> HomeController started');
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {}

  navigateToPage(int index) {
    switch (index) {
      case 0:
        return Get.toNamed(AppPages.HOME);
      case 1:
        return Get.toNamed(AppPages.USER);
      case 2:
        return Get.toNamed(AppPages.PRODUCT);
      case 3:
        return Get.toNamed(AppPages.CATEGORY);
      case 4:
        return Get.toNamed(AppPages.ORDER);
      case 5:
        return Get.toNamed(AppPages.PENDING_ORDER);
      case 6:
        return Get.toNamed(AppPages.CANCELLED_ORDER);
      case 7:
        return Get.toNamed(AppPages.SETTINGS);

      default:
        return Get.toNamed(AppPages.PRODUCT);
    }
  }
}
