import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:redstar_hightech_backend/app/modules/finance/statistics/controllers/yearly_chart_contoller.dart';
import 'package:redstar_hightech_backend/app/modules/finance/statistics/views/monthly_chart.dart';
import 'package:redstar_hightech_backend/app/modules/finance/widgets/period_bar.dart';

class YearlyChart extends StatefulWidget {
  const YearlyChart({Key? key}) : super(key: key);

  @override
  State<YearlyChart> createState() => _YearlyChartState();
}

class _YearlyChartState extends State<YearlyChart> {
  final YearlyChartContoller chartController = Get.find();
  String period = '';
  int filterType = 0;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    period = chartController.getPeriod();
    return ListView(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 5),
          child: PeriodBar(
            title: period,
            onPrevPress: () {
              chartController.prev();
              setState(() {
                period = chartController.getPeriod();
              });
            },
            onNextPress: () {
              chartController.next();
              setState(() {
                period = chartController.getPeriod();
              });
            },
          ),
        ),
        Padding(
            padding: const EdgeInsets.symmetric(vertical: 20),
            child: GetBuilder<YearlyChartContoller>(
              builder: (controller) {
                return PieChartView(
                  controller: controller,
                );
              },
            ))
      ],
    );
  }
}
