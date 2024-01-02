import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:redstar_hightech_backend/app/modules/authentication/controllers/authentication_controller.dart';
import 'package:redstar_hightech_backend/app/modules/authentication/controllers/user_controller.dart';
import 'package:redstar_hightech_backend/app/modules/cancelled_order/controllers/cancelled_order_controller.dart';
import 'package:redstar_hightech_backend/app/modules/category/controllers/category_controller.dart';
import 'package:redstar_hightech_backend/app/modules/home/controllers/home_controller.dart';
import 'package:redstar_hightech_backend/app/modules/order/controllers/order_controller.dart';
import 'package:redstar_hightech_backend/app/modules/order/controllers/orderstat_controller.dart';
import 'package:redstar_hightech_backend/app/modules/order/models/order_stats_model.dart';
import 'package:redstar_hightech_backend/app/modules/order_delivered/controllers/order_delivered_controller.dart';
import 'package:redstar_hightech_backend/app/modules/pending_order/controllers/pending_order_controller.dart';
import 'package:redstar_hightech_backend/app/modules/product/controllers/product_controller.dart';
import 'package:redstar_hightech_backend/app/routes/app_pages.dart';
import 'package:redstar_hightech_backend/app/shared/custom_bar_chart.dart';
import 'package:redstar_hightech_backend/app/shared/main_section.dart';

class MyDesktopBody extends GetView<HomeController> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final OrderStatController orderStatController =
      Get.put(OrderStatController());
  //Get.find<OrderStatController>();
  final ProductController productController = Get.put(ProductController());
  final OrderController orderController = Get.put(OrderController());
  final PendingOrderController pendingOrderController =
      Get.put(PendingOrderController());
  final CategoryController categoryController = Get.put(CategoryController());
  final CancelledOrderController cancelledOrderController =
      Get.put(CancelledOrderController());
  final OrderDeliveredController orderDeliveredController =
      Get.put(OrderDeliveredController());

  AuthenticationController authenticationController =
      Get.put(AuthenticationController());

  UserController userController = Get.put(UserController());

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage("assets/images/bg.png"),
          fit: BoxFit.cover,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            // First column
            Expanded(
              child: Column(
                children: [
                  // youtube video
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: AspectRatio(
                        aspectRatio: 0.8, //16 / 9,
                        child: FutureBuilder(
                          future: orderStatController.stats.value,
                          builder: (BuildContext context,
                              AsyncSnapshot<List<OrderStats>> snapshot) {
                            if (snapshot.hasData) {
                              return Container(
                                padding: const EdgeInsets.all(10),
                                height: 255,
                                child: CustomBarChart(
                                  orderStats: snapshot.data!,
                                ),
                              );
                            } else if (snapshot.hasError) {
                              return Center(
                                child: Text("${snapshot.error}"),
                              );
                            }

                            return const Center(
                              child: CircularProgressIndicator(
                                  color: Colors.black),
                            );
                          },
                        )

                        /* Container(
                        height: 295,
                        color: Colors.deepPurple[400],
                      ), */
                        ),
                  ),

                  // comment section & recommended videos
                  /*     Expanded(
                    child: 
                  ) */
                ],
              ),
            ),

            // second column
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                  width: 400,
                  //  color: Colors.deepPurple[300],
                  child: ListView(
                    children: [
                      MainSectionService(
                          title: "USERS",
                          route: AppPages.USER,
                          bgColor: Color.fromARGB(255, 210, 36, 143),
                          iconColor: const Color.fromARGB(255, 212, 188, 196),
                          txtColor: Colors.white,
                          representativeIcon: Icons.person,
                          count: userController.count.toString()),
                      MainSectionService(
                          title: "PRODUCTS",
                          route: AppPages.PRODUCT,
                          bgColor: const Color.fromARGB(255, 3, 19, 21),
                          iconColor: const Color.fromARGB(255, 212, 188, 196),
                          txtColor: Colors.white,
                          representativeIcon: Icons.article_outlined,
                          count: productController.count.toString()),
                      MainSectionService(
                          title: "COMPLETED\r\nORDERS",
                          route: AppPages.ORDER,
                          bgColor: Color.fromARGB(255, 31, 200, 84),
                          iconColor: const Color.fromARGB(255, 212, 188, 196),
                          txtColor: Colors.white,
                          representativeIcon: Icons.sell_outlined,
                          count: orderController.count.toString()),
                      MainSectionService(
                          title: "CATEGORY",
                          route: AppPages.CATEGORY,
                          bgColor: Color.fromARGB(255, 149, 200, 31),
                          iconColor: const Color.fromARGB(255, 212, 188, 196),
                          txtColor: Colors.white,
                          representativeIcon: Icons.category,
                          count: categoryController.count.toString()),
                      MainSectionService(
                          title: "PENDING\r\nORDERS",
                          route: AppPages.PENDING_ORDER,
                          bgColor: Color.fromARGB(255, 40, 57, 142),
                          iconColor: Color.fromARGB(255, 248, 239, 242),
                          txtColor: Colors.white,
                          representativeIcon: Icons.watch_later,
                          count: pendingOrderController.count.toString()),
                      MainSectionService(
                          title: "CANCELLED\r\nORDER",
                          route: AppPages.CANCELLED_ORDER,
                          bgColor: Color.fromARGB(255, 232, 92, 92),
                          iconColor: const Color.fromARGB(255, 212, 188, 196),
                          txtColor: Colors.white,
                          representativeIcon: Icons.cancel,
                          count: cancelledOrderController.count.toString()),
                    ],
                  )

                  /* ListView.builder(
                  itemCount: 8,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        color: Colors.deepPurple[400],
                        height: 120,
                      ),
                    );
                  },
                ), */
                  ),
            )
          ],
        ),
      ),
    );
  }
}
