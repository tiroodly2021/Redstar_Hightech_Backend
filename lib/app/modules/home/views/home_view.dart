import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:redstar_hightech_backend/app/config/responsive.dart';
import 'package:redstar_hightech_backend/app/config/size_config.dart';
import 'package:redstar_hightech_backend/app/modules/common/navigation_drawer.dart';
import 'package:redstar_hightech_backend/app/modules/home/controllers/home_controller.dart';
import 'package:redstar_hightech_backend/app/modules/home/views/component/appBarActionItems.dart';
import 'package:redstar_hightech_backend/app/modules/home/views/component/barChart.dart';
import 'package:redstar_hightech_backend/app/modules/home/views/component/header.dart';
import 'package:redstar_hightech_backend/app/modules/home/views/component/historyTable.dart';
import 'package:redstar_hightech_backend/app/modules/home/views/component/infoCard.dart';
import 'package:redstar_hightech_backend/app/modules/home/views/component/paymentDetailList.dart';
import 'package:redstar_hightech_backend/app/modules/home/views/component/sideMenu.dart';
import 'package:redstar_hightech_backend/app/modules/order/controllers/orderstat_controller.dart';
import 'package:redstar_hightech_backend/app/routes/app_pages.dart';
import 'package:redstar_hightech_backend/app/shared/app_bar_widget.dart';
import 'package:redstar_hightech_backend/app/shared/app_search_delegate.dart';
import 'package:redstar_hightech_backend/app/shared/button_optional_menu.dart';
import 'package:redstar_hightech_backend/app/style/colors.dart';
import 'package:redstar_hightech_backend/app/style/style.dart';

import 'package:redstar_hightech_backend/app/modules/authentication/controllers/authentication_controller.dart';
import 'package:redstar_hightech_backend/app/modules/authentication/controllers/user_controller.dart';
import 'package:redstar_hightech_backend/app/modules/cancelled_order/controllers/cancelled_order_controller.dart';
import 'package:redstar_hightech_backend/app/modules/category/controllers/category_controller.dart';
import 'package:redstar_hightech_backend/app/modules/order/controllers/order_controller.dart';
import 'package:redstar_hightech_backend/app/modules/order/models/order_stats_model.dart';
import 'package:redstar_hightech_backend/app/modules/order_delivered/controllers/order_delivered_controller.dart';
import 'package:redstar_hightech_backend/app/modules/pending_order/controllers/pending_order_controller.dart';
import 'package:redstar_hightech_backend/app/modules/product/controllers/product_controller.dart';

class HomeView extends GetView<HomeController> {
  GlobalKey<ScaffoldState> _drawerKey = GlobalKey();
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
    SizeConfig(context);
    return Scaffold(
      key: _drawerKey,
      drawer: !Responsive.isDesktop(context) ? NavigationDrawer() : Container(),
      appBar: /*  !Responsive.isDesktop(context)
          ?  */
          AppBarWidget(
        title: 'Redstar Management',
        icon: Icons.search,
        bgColor: Colors.black,
        onPressed: () {
          showSearch(context: context, delegate: AppSearchDelegate());
        },
        authenticationController: Get.find<AuthenticationController>(),
        menuActionButton: ButtonOptionalMenu(),
        tooltip: 'Search',
      )
      /*  : AppBar(
              backgroundColor: Colors.transparent,
            ), */
      ,
      body: SafeArea(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (Responsive.isDesktop(context))
              Expanded(
                flex: 1,
                child: SideMenu(),
              ),
            Expanded(
                flex: 10,
                child: SafeArea(
                  child: SingleChildScrollView(
                    padding: EdgeInsets.symmetric(vertical: 30, horizontal: 30),
                    child: Obx(() {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Header(),
                          SizedBox(
                            height: SizeConfig.blockSizeVertical * 4,
                          ),
                          SizedBox(
                            width: SizeConfig.screenWidth,
                            child: Wrap(
                              spacing: 20,
                              runSpacing: 20,
                              alignment: WrapAlignment.spaceBetween,
                              children: [
                                InfoCard(
                                    title: "USERS",
                                    route: AppPages.USER,
                                    bgColor: Color.fromARGB(255, 210, 36, 143),
                                    iconColor: const Color.fromARGB(
                                        255, 212, 188, 196),
                                    txtColor: Colors.white,
                                    representativeIcon: Icons.person,
                                    count: userController.count.toString()),
                                InfoCard(
                                    title: "PRODUCTS",
                                    route: AppPages.PRODUCT,
                                    bgColor:
                                        const Color.fromARGB(255, 3, 19, 21),
                                    iconColor: const Color.fromARGB(
                                        255, 212, 188, 196),
                                    txtColor: Colors.white,
                                    representativeIcon: Icons.article_outlined,
                                    count: productController.count.toString()),
                                InfoCard(
                                    title: "ORDERS",
                                    route: AppPages.ORDER,
                                    bgColor: Color.fromARGB(255, 31, 200, 84),
                                    iconColor: const Color.fromARGB(
                                        255, 212, 188, 196),
                                    txtColor: Colors.white,
                                    representativeIcon: Icons.sell_outlined,
                                    count: orderController.count.toString()),
                                InfoCard(
                                    title: "CATEGORY",
                                    route: AppPages.CATEGORY,
                                    bgColor: Color.fromARGB(255, 149, 200, 31),
                                    iconColor: const Color.fromARGB(
                                        255, 212, 188, 196),
                                    txtColor: Colors.white,
                                    representativeIcon: Icons.category,
                                    count: categoryController.count.toString()),
                                InfoCard(
                                    title: "PENDING\r\nORDERS",
                                    route: AppPages.PENDING_ORDER,
                                    bgColor: Color.fromARGB(255, 40, 57, 142),
                                    iconColor:
                                        Color.fromARGB(255, 248, 239, 242),
                                    txtColor: Colors.white,
                                    representativeIcon: Icons.watch_later,
                                    count: pendingOrderController.count
                                        .toString()),
                                InfoCard(
                                    title: "CANCELLED\r\nORDER",
                                    route: AppPages.CANCELLED_ORDER,
                                    bgColor: Color.fromARGB(255, 232, 92, 92),
                                    iconColor: const Color.fromARGB(
                                        255, 212, 188, 196),
                                    txtColor: Colors.white,
                                    representativeIcon: Icons.cancel,
                                    count: cancelledOrderController.count
                                        .toString()),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: SizeConfig.blockSizeVertical * 4,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  PrimaryText(
                                    text: 'Balance',
                                    size: 16,
                                    fontWeight: FontWeight.w400,
                                    color: AppColors.secondary,
                                  ),
                                  PrimaryText(
                                      text: '\$1500',
                                      size: 30,
                                      fontWeight: FontWeight.w800),
                                ],
                              ),
                              PrimaryText(
                                text: 'Past 30 DAYS',
                                size: 16,
                                fontWeight: FontWeight.w400,
                                color: AppColors.secondary,
                              ),
                            ],
                          ),
                          SizedBox(
                            height: SizeConfig.blockSizeVertical * 3,
                          ),
                          Container(
                            height: 180,
                            child: FutureBuilder(
                              future: orderStatController.stats.value,
                              builder: (BuildContext context,
                                  AsyncSnapshot<List<OrderStats>> snapshot) {
                                if (snapshot.hasData) {
                                  return Container(
                                    padding: const EdgeInsets.all(10),
                                    height: 255,
                                    child: BarChartCopmponent(
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
                            ), //BarChartCopmponent(),
                          ),
                          SizedBox(
                            height: SizeConfig.blockSizeVertical * 5,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              PrimaryText(
                                  text: 'History',
                                  size: 30,
                                  fontWeight: FontWeight.w800),
                              PrimaryText(
                                text: 'Transaction of lat 6 month',
                                size: 16,
                                fontWeight: FontWeight.w400,
                                color: AppColors.secondary,
                              ),
                            ],
                          ),
                          SizedBox(
                            height: SizeConfig.blockSizeVertical * 3,
                          ),
                          HistoryTable(),
                          if (!Responsive.isDesktop(context))
                            PaymentDetailList()
                        ],
                      );
                    }),
                  ),
                )),
            if (Responsive.isDesktop(context))
              Expanded(
                flex: 4,
                child: SafeArea(
                  child: Container(
                    width: double.infinity,
                    height: SizeConfig.screenHeight,
                    decoration: BoxDecoration(color: AppColors.secondaryBg),
                    child: SingleChildScrollView(
                      padding:
                          EdgeInsets.symmetric(vertical: 30, horizontal: 30),
                      child: Column(
                        children: [
                          //AppBarActionItems(),
                          PaymentDetailList(),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  @override
  List<Object?> get props => [
        _drawerKey,
        orderStatController,
        productController,
        orderController,
        pendingOrderController,
        categoryController,
        cancelledOrderController,
        orderDeliveredController,
        authenticationController,
        userController
      ];
}






















































/* import 'package:drawerbehavior/drawerbehavior.dart';
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
import '../../common/navigation_drawer.dart';
import '../../order/controllers/orderstat_controller.dart';
import '../controllers/home_controller.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:intl/intl.dart';

import 'desktop/desktop_body.dart';
import 'mobile/mobile_body.dart';
import 'responsive_layout.dart';

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
    Orientation myOrientation = MediaQuery.of(context).orientation;

    return Scaffold(
        appBar: /*  AppBar(
        title: Text('Chat View'),
        centerTitle: true,
      ), */
            AppBarWidget(
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
        drawer: NavigationDrawer(),
        body: OrientationBuilder(builder: (_, orientation) {
          if (orientation == Orientation.portrait) {
            return ResponsiveLayout(
                mobileBody: MyMobileBody(),
                desktopBody: MyDesktopBody(),
                orientation: myOrientation.toString());
          } else {
            return ResponsiveLayout(
                mobileBody: MyMobileBody(),
                desktopBody: MyDesktopBody(),
                orientation: myOrientation.toString());
          } // else show the landscape one
        })

        /* Container(
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
              ),
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
      ), */
        );
  }
}
 */