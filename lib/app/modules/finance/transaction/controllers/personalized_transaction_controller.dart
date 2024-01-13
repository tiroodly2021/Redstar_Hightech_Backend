import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:fab_circular_menu/fab_circular_menu.dart';
import 'package:redstar_hightech_backend/app/modules/finance/account/models/account_model.dart';
import 'package:redstar_hightech_backend/app/services/database_service.dart';

class PersonalizedTransactionController extends GetxController {
  RxInt operationType = 0.obs;
  RxInt transactionTypeMobileAgent = 0.obs;
  RxInt transactionTypeLotoAgent = 0.obs;
  RxInt transactionTypeCashMoney = 0.obs;

  RxBool isTransfertActivated = false.obs;

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
}
