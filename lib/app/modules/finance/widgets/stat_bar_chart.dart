import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:intl/intl.dart';
import 'package:redstar_hightech_backend/app/modules/finance/statistics/models/chart_data_model.dart';

class StatBarChart extends StatelessWidget {
  List<CatChartData> catChartDatas;

  StatBarChart({Key? key, required this.catChartDatas}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<charts.Series<CatChartData, String>> series = [
      charts.Series(
          id: 'catChart',
          data: catChartDatas,
          domainFn: (series, _) => series.category,
          measureFn: (series, _) => series.toatal,
          colorFn: (series, _) => intToColor(series.type))
    ];
    return charts.BarChart(
      series,
      animate: true,
    );
  }

  charts.Color intToColor(int i) {
    if (i == 0) {
      return charts.ColorUtil.fromDartColor(Colors.green);
    }
    if (i == 1) {
      return charts.ColorUtil.fromDartColor(Colors.red);
    }

    return charts.ColorUtil.fromDartColor(Colors.orange);
  }
}
