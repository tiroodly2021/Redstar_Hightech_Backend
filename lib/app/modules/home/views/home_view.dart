import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:redstar_hightech_backend/app/modules/order/models/order_stats_model.dart';
import 'package:redstar_hightech_backend/app/routes/app_pages.dart';

import '../../order/controllers/orderstat_controller.dart';
import '../controllers/home_controller.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:intl/intl.dart';

class HomeView extends GetView<HomeController> {
  final OrderStatController orderStatController =
      Get.put(OrderStatController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Redstar Management'),
        centerTitle: true,
        backgroundColor: Colors.black,
      ),
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
              Expanded(
                child: GridView.count(
                  primary: false,
                  padding: const EdgeInsets.all(10),
                  crossAxisSpacing: 1,
                  mainAxisSpacing: 1,
                  crossAxisCount: 2,
                  children: [
                    MainSectionService(
                      title: "PRODUCTS",
                      route: AppPages.PRODUCT,
                      bgColor: const Color.fromARGB(255, 3, 19, 21),
                      iconColor: const Color.fromARGB(255, 212, 188, 196),
                      txtColor: Colors.white,
                      representativeIcon: Icons.article_outlined,
                    ),
                    MainSectionService(
                        title: "ORDERS",
                        route: AppPages.ORDER,
                        bgColor: Color.fromARGB(255, 200, 62, 31),
                        iconColor: const Color.fromARGB(255, 212, 188, 196),
                        txtColor: Colors.white,
                        representativeIcon: Icons.sell_outlined),
                    MainSectionService(
                        title: "CATEGORY",
                        route: AppPages.CATEGORY,
                        bgColor: Color.fromARGB(255, 31, 163, 200),
                        iconColor: const Color.fromARGB(255, 212, 188, 196),
                        txtColor: Colors.white,
                        representativeIcon: Icons.category)
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class MainSectionService extends StatelessWidget {
  String title;
  String route;
  var bgColor;
  Color iconColor;
  Color txtColor;
  IconData? representativeIcon;

  MainSectionService(
      {Key? key,
      required this.title,
      required this.route,
      required this.bgColor,
      required this.iconColor,
      required this.txtColor,
      this.representativeIcon})
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
                Icon(
                  representativeIcon,
                  size: 40,
                  color: iconColor,
                ),
                const SizedBox(
                  width: 10,
                ),
                Text(title,
                    style: TextStyle(
                        color: txtColor,
                        fontSize: 22,
                        fontWeight: FontWeight.bold)),
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
