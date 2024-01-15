import 'package:intl/intl.dart';
import 'package:redstar_hightech_backend/app/modules/finance/statistics/controllers/chart_controller.dart';

class MonthlyChartContollrt extends ChartController {
  @override
  next() {
    startDate = DateTime(startDate.year, startDate.month + 1, 1);
    endDate = DateTime(startDate.year, startDate.month + 1, 1);
    setDateFilter(startDate, endDate);
  }

  @override
  prev() {
    startDate = DateTime(startDate.year, startDate.month - 1, 1);
    endDate = DateTime(startDate.year, startDate.month + 1, 1);
    setDateFilter(startDate, endDate);
  }

  @override
  String getPeriod() {
    return '${DateFormat('MMM ').format(startDate).toUpperCase()} ${endDate.year}';
  }
}
