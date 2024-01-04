import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:redstar_hightech_backend/app/config/size_config.dart';
import 'package:redstar_hightech_backend/app/constants/app_theme.dart';
import 'package:redstar_hightech_backend/app/routes/app_pages.dart';
import 'package:redstar_hightech_backend/app/style/colors.dart';

class SideMenu extends StatelessWidget {
  const SideMenu({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      elevation: 0,
      child: Container(
        width: double.infinity,
        height: SizeConfig.screenHeight,
        decoration: BoxDecoration(color: AppColors.secondaryBg),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                height: 100,
                alignment: Alignment.topCenter,
                width: double.infinity,
                padding: EdgeInsets.only(top: 20),
                child: SizedBox(
                  width: 35,
                  height: 20,
                  child: SvgPicture.asset('assets/mac-action.svg'),
                ),
              ),
              IconButton(
                  iconSize: 20,
                  padding: EdgeInsets.symmetric(vertical: 20.0),
                  icon: Icon(
                    Icons.home,
                    color: Get.currentRoute == Routes.HOME ||
                            Get.currentRoute == Routes.INITIAL
                        ? AppTheme.allBlack
                        : AppTheme.lihtLessGray,
                  ),
                  onPressed: () => navigate(0)),
              IconButton(
                  iconSize: 20,
                  padding: EdgeInsets.symmetric(vertical: 20.0),
                  icon: Icon(
                    Icons.person,
                    color: Get.currentRoute == Routes.USER
                        ? AppTheme.allBlack
                        : AppTheme.lihtLessGray,
                  ),
                  onPressed: () => navigate(1)),
              IconButton(
                  iconSize: 20,
                  padding: EdgeInsets.symmetric(vertical: 20.0),
                  icon: Icon(
                    Icons.production_quantity_limits,
                    color: Get.currentRoute == Routes.PRODUCT
                        ? AppTheme.allBlack
                        : AppTheme.lihtLessGray,
                  ),
                  onPressed: () => navigate(2)),
              IconButton(
                  iconSize: 20,
                  padding: EdgeInsets.symmetric(vertical: 20.0),
                  icon: Icon(
                    Icons.bar_chart,
                    color: Get.currentRoute == Routes.ORDER
                        ? AppTheme.allBlack
                        : AppTheme.lihtLessGray,
                  ),
                  onPressed: () => navigate(3)),
              IconButton(
                  iconSize: 20,
                  padding: EdgeInsets.symmetric(vertical: 20.0),
                  icon: Icon(
                    Icons.pending,
                    color: Get.currentRoute == Routes.PENDING_ORDER
                        ? AppTheme.allBlack
                        : AppTheme.lihtLessGray,
                  ),
                  onPressed: () => navigate(4)),
              IconButton(
                  iconSize: 20,
                  padding: EdgeInsets.symmetric(vertical: 20.0),
                  icon: Icon(
                    Icons.cancel,
                    color: Get.currentRoute == Routes.CANCELLED_ORDER
                        ? AppTheme.allBlack
                        : AppTheme.lihtLessGray,
                  ),
                  onPressed: () => navigate(5)),
              IconButton(
                  iconSize: 20,
                  padding: EdgeInsets.symmetric(vertical: 20.0),
                  icon: Icon(
                    Icons.settings,
                    color: Get.currentRoute == Routes.SETTINGS
                        ? AppTheme.allBlack
                        : AppTheme.lihtLessGray,
                  ),
                  onPressed: () => navigate(6)),
            ],
          ),
        ),
      ),
    );
  }

  navigate(int index) {
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
