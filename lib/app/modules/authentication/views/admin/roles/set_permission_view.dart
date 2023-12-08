import 'package:flutter/material.dart';

import 'package:get/get.dart';

import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:redstar_hightech_backend/app/modules/authentication/controllers/authentication_controller.dart';
import 'package:redstar_hightech_backend/app/modules/authentication/controllers/user_controller.dart';
import 'package:redstar_hightech_backend/app/modules/authentication/views/add_user.dart';
import 'package:redstar_hightech_backend/app/modules/authentication/widgets/user_widget.dart';
import 'package:redstar_hightech_backend/app/modules/product/models/product_model.dart';
import 'package:redstar_hightech_backend/app/routes/app_pages.dart';
import 'package:redstar_hightech_backend/app/shared/app_bar_widget.dart';
import 'package:redstar_hightech_backend/app/shared/app_search_delegate.dart';
import 'package:redstar_hightech_backend/app/shared/button_optional_menu.dart';
import 'package:redstar_hightech_backend/app/shared/list_not_found.sharedWidgets.dart';
import 'package:safe_url_check/safe_url_check.dart';

import '../../../controllers/permission_controller.dart';
import '../../../controllers/role_controller.dart';
import '../../../models/permission_model.dart';
import '../../../models/role_model.dart';
import 'widgets/set_perssion_card.dart';

class SetPermissionView extends GetView<PermissionController> {
  final Role currentRole;
  List<Permission>? permissionList;

  SetPermissionView({required this.currentRole, this.permissionList});

  Future<void> _pullRefresh() async {
    controller.permissionList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBarWidget(
          title: 'Permission for ' + currentRole.name,
          icon: Icons.search,
          bgColor: Colors.black,
          onPressed: () {
            showSearch(context: context, delegate: AppSearchDelegate());
          },
          authenticationController: Get.find<AuthenticationController>(),
          menuActionButton: ButtonOptionalMenu(),
          tooltip: 'Search',
        ),
        body: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            children: [
              /* SizedBox(
                height: 100,
                child: InkWell(
                  onTap: () {
                    // Get.toNamed(AppPages.ADD_USER);
                    Get.to(() => AddPermissionView());
                  },
                  child: Card(
                    color: Colors.black,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        IconButton(
                            onPressed: () {
                              // Get.toNamed(AppPages.ADD_CATEGORY);
                              Get.to(() => AddPermissionView());
                            },
                            icon: const Icon(
                              Icons.add,
                              color: Colors.white,
                            )),
                        const Text(
                          "Add Permission",
                          style: TextStyle(fontSize: 22, color: Colors.white),
                        )
                      ],
                    ),
                  ),
                ),
              ) */
              SizedBox(
                // width: MediaQuery.of(context).size.width,
                height: 60,
                child: Card(
                  color: Colors.black12,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text("All Permissions",
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold)),
                          IconButton(
                              onPressed: () {
                                // Get.toNamed(AppPages.PRODUCT_LIST);
                              },
                              icon: const Icon(Icons.list))
                        ]),
                  ),
                ),
              ),
              Expanded(
                child: ListView.builder(
                    itemCount: permissionList!.length,
                    itemBuilder: ((context, index) {
                      return SizedBox(
                        //  height: 50,
                        child: SetPermissionCard(
                          permission: permissionList![index],
                          index: index,
                          role: currentRole,
                        ),
                      );
                    }))
                /* Obx(() {
                  if (permissionList!.isNotEmpty) {
                    return ;
                  }

                  return ListNotFound(
                      route: AppPages.INITIAL,
                      message: "There are not permissions in the list",
                      info: "Go Back",
                      imageUrl: "assets/images/empty.png");
                }) */
                ,
              )
            ],
          ),
        ));
  }
}
