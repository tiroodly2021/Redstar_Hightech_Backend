import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:redstar_hightech_backend/app/modules/authentication/controllers/authentication_controller.dart';
import 'package:redstar_hightech_backend/app/modules/authentication/controllers/user_controller.dart';
import 'package:redstar_hightech_backend/app/modules/cancelled_order/controllers/cancelled_order_controller.dart';
import 'package:redstar_hightech_backend/app/modules/category/controllers/category_controller.dart';
import 'package:redstar_hightech_backend/app/modules/order/controllers/order_controller.dart';
import 'package:redstar_hightech_backend/app/modules/order/models/order_stats_model.dart';
import 'package:redstar_hightech_backend/app/modules/order_delivered/controllers/order_delivered_controller.dart';
import 'package:redstar_hightech_backend/app/modules/pending_order/controllers/pending_order_controller.dart';
import 'package:redstar_hightech_backend/app/modules/product/controllers/product_controller.dart';
import 'package:redstar_hightech_backend/app/modules/settings/views/edit_profile.dart';
import 'package:redstar_hightech_backend/app/modules/settings/views/settings_view.dart';
import 'package:redstar_hightech_backend/app/routes/app_pages.dart';
import 'package:redstar_hightech_backend/app/shared/app_bar_widget.dart';
import 'package:redstar_hightech_backend/app/shared/app_search_delegate.dart';

import '../../../shared/button_optional_menu.dart';
import '../../../shared/menu_widget.dart';
import '../../order/controllers/orderstat_controller.dart';
import '../controllers/home_controller.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:intl/intl.dart';

class HomeView extends GetView<HomeController> {
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
    authenticationController = Get.find<AuthenticationController>();

    return Scaffold(
      appBar: AppBarWidget(
        title: 'Redstar Management',
        icon: Icons.search,
        bgColor: Colors.black,
        onPressed: () {
          showSearch(context: context, delegate: AppSearchDelegate());
        },
        authenticationController: Get.find<AuthenticationController>(),
        menuActionButton: ButtonOptionalMenu(),
        tooltip: 'Search',
      ),
      key: _scaffoldKey,
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/bg.png"),
            fit: BoxFit.cover,
          ),
        ),
        child: SizedBox(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              FutureBuilder(
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
                    child: CircularProgressIndicator(color: Colors.black),
                  );
                },
              )
              /*   Container(
                padding: const EdgeInsets.all(10),
                height: 255,
                child: CustomBarChart(
                  orderStats: OrderStats.orderStats,
                ),
              ) */
              ,
              Obx(() {
                return Expanded(
                  child: GridView.count(
                    primary: false,
                    padding: const EdgeInsets.all(10),
                    crossAxisSpacing: 1,
                    mainAxisSpacing: 1,
                    crossAxisCount: 2,
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
                  ),
                );
              })
            ],
          ),
        ),
      ),
    );
  }

  @override
  List<Object?> get props => [
        _scaffoldKey,
        orderStatController,
        productController,
        orderController,
        pendingOrderController,
        categoryController,
        cancelledOrderController,
        orderDeliveredController,
        authenticationController
      ];
}

class MainSectionService extends StatelessWidget {
  String title;
  String route;
  var bgColor;
  Color iconColor;
  Color txtColor;
  IconData? representativeIcon;
  String? count;

  MainSectionService(
      {Key? key,
      required this.title,
      required this.route,
      required this.bgColor,
      required this.iconColor,
      required this.txtColor,
      this.representativeIcon,
      this.count})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        width: double.infinity,
        height: 150,
        padding: const EdgeInsets.symmetric(horizontal: 5),
        child: InkWell(
          onTap: () {
            Get.toNamed(route);
          },
          child: Card(
            color: bgColor,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                  Icon(
                    representativeIcon,
                    size: 40,
                    color: iconColor,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  title.contains("\r\n")
                      ? Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(title.split("\r\n")[0],
                                style: TextStyle(
                                    color: txtColor,
                                    fontSize: 22,
                                    fontWeight: FontWeight.bold)),
                            Text(title.split("\r\n")[1],
                                style: TextStyle(
                                    color: txtColor,
                                    fontSize: 22,
                                    fontWeight: FontWeight.bold))
                          ],
                        )
                      : Text(title,
                          style: TextStyle(
                              color: txtColor,
                              fontSize: 22,
                              fontWeight: FontWeight.bold)),
                  Text(
                    "(" + count! + ")",
                    style: TextStyle(
                        color: txtColor,
                        fontSize: 16,
                        fontWeight: FontWeight.bold),
                  )
                ]),
              ],
            ),
          ),
        ));
  }
}

class CustomBarChart extends StatelessWidget {
  CustomBarChart({Key? key, required this.orderStats}) : super(key: key);
  List<OrderStats> orderStats;

  @override
  Widget build(BuildContext context) {
    List<charts.Series<OrderStats, String>> series = [
      charts.Series(
          id: 'orders',
          data: orderStats,
          domainFn: (series, _) =>
              DateFormat.d().format(series.dateTime).toString(),
          measureFn: (series, _) => series.orders,
          colorFn: (series, _) => series.barColor!)
    ];
    return charts.BarChart(
      series,
      animate: true,
    );
  }
}
