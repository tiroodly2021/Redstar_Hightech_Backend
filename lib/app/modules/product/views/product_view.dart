import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:redstar_hightech_backend/app/modules/authentication/controllers/authentication_controller.dart';
import 'package:redstar_hightech_backend/app/modules/product/models/product_model.dart';
import 'package:redstar_hightech_backend/app/routes/app_pages.dart';
import 'package:redstar_hightech_backend/app/shared/app_bar_widget.dart';
import 'package:redstar_hightech_backend/app/shared/app_search_delegate.dart';
import 'package:redstar_hightech_backend/app/shared/button_optional_menu.dart';
import 'package:redstar_hightech_backend/app/shared/list_not_found.sharedWidgets.dart';

import '../controllers/product_controller.dart';
import '../widgets/product_widget.dart';

class ProductView extends GetView<ProductController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBarWidget(
          title: 'Products',
          icon: Icons.search,
          bgColor: Colors.black,
          onPressed: () {
            showSearch(context: context, delegate: AppSearchDelegate());
          },
          authenticationController: Get.find<AuthenticationController>(),
          menuActionButton: ButtonOptionalMenu(),
          tooltip: 'Search',
        )

        /* AppBarWidget(
          title: 'Products',
          icon: Icons.search,
          bgColor: Colors.black,
          onPressed: () {
            /*  showSearch(
                      context: context, delegate: TransactionSearchDelegate()); */
          },
          tooltip: 'Search',
        ) */
        ,
        body: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            children: [
              SizedBox(
                height: 100,
                child: InkWell(
                  onTap: () {
                    Get.toNamed(AppPages.NEW_PRODUCT);
                  },
                  child: Card(
                    color: Colors.black,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        IconButton(
                            onPressed: () {
                              print("Hello");
                              Get.toNamed(AppPages.NEW_PRODUCT);
                            },
                            icon: const Icon(
                              Icons.add,
                              color: Colors.white,
                            )),
                        const Text(
                          "Add New Product",
                          style: TextStyle(fontSize: 22, color: Colors.white),
                        )
                      ],
                    ),
                  ),
                ),
              ),
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
                          const Text("All Product",
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold)),
                          IconButton(
                              onPressed: () {
                                Get.toNamed(AppPages.PRODUCT_LIST);
                              },
                              icon: const Icon(Icons.list))
                        ]),
                  ),
                ),
              ),
              Expanded(
                child: Obx(() {
                  print(controller.products);

                  if (controller.products.isNotEmpty) {
                    return ListView.builder(
                        itemCount: controller.products.length,
                        itemBuilder: ((context, index) {
                          return SizedBox(
                            height: 300,
                            child: ProductCard(
                              product: controller.products[index],
                              index: index,
                            ),
                          );
                        }));
                  }

                  return ListNotFound(
                      route: AppPages.INITIAL,
                      message: "There are not product in the list",
                      info: "Go Back",
                      imageUrl: "assets/images/empty.png");
                }),
              )
            ],
          ),
        ));
  }
}
