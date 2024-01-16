import 'package:fab_circular_menu/fab_circular_menu.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:redstar_hightech_backend/app/modules/finance/finance_home/controllers/finance_home_controller.dart';

import 'package:redstar_hightech_backend/app/routes/app_pages.dart';

class FloatingCircleMenu extends StatelessWidget {
  FinanceHomeController financeHomeController =
      Get.put(FinanceHomeController());

  FloatingCircleMenu({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Builder(
        builder: (context) => FabCircularMenu(
              alignment: Alignment.bottomRight,
              ringColor: Colors.black.withOpacity(0.7),
              ringDiameter: 300.0,
              ringWidth: 100.0,
              fabSize: 64.0,
              fabElevation: 8.0,
              fabIconBorder: const CircleBorder(),
              fabColor: Colors.black,
              fabOpenIcon: const Icon(Icons.menu, color: Colors.white),
              fabCloseIcon: const Icon(Icons.close, color: Colors.white),
              fabMargin: const EdgeInsets.all(16.0),
              animationDuration: const Duration(milliseconds: 800),
              animationCurve: Curves.easeInOutCirc,
              onDisplayChange: (isOpen) {
                print(isOpen);
              },
              children: <Widget>[
                RawMaterialButton(
                  onPressed: () {
                    if (financeHomeController.fabKey != null) {
                      financeHomeController.fabKey.currentState!.close();
                    }

                    Get.toNamed(AppPages.FINANCE_PERSONALIZEDTRANSACTION);
                  },
                  shape: const CircleBorder(
                    side: BorderSide(width: 1, color: Colors.white),
                  ),
                  padding: const EdgeInsets.all(10.0),
                  child: const Icon(Icons.sell, color: Colors.white),
                ),
                RawMaterialButton(
                    onPressed: () {
                      Get.toNamed(AppPages.FINANCE_ADD_TRANSACTION);
                    },
                    shape: const CircleBorder(
                      side: BorderSide(width: 1, color: Colors.white),
                    ),
                    padding: const EdgeInsets.all(10.0),
                    child: const Icon(Icons.transform, color: Colors.white)),
                RawMaterialButton(
                    onPressed: () {
                      Get.toNamed(AppPages.FINANCE_STATISTIC);
                    },
                    shape: const CircleBorder(
                      side: BorderSide(width: 1, color: Colors.white),
                    ),
                    padding: const EdgeInsets.all(10.0),
                    child: const Icon(Icons.bar_chart, color: Colors.white)),
                RawMaterialButton(
                  onPressed: () {
                    Get.toNamed(AppPages.FINANCE_ACCOUNT);
                  },
                  shape: const CircleBorder(
                    side: BorderSide(width: 1, color: Colors.white),
                  ),
                  padding: const EdgeInsets.all(10.0),
                  child: const Icon(Icons.account_box, color: Colors.white),
                )
              ],
            ));
  }
}
