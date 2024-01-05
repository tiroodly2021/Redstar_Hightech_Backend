import 'package:redstar_hightech_backend/app/modules/finance/statistics/controllers/chart_controller.dart';

class YearlyChartContoller extends ChartController {
  @override
  next() {
    startDate = DateTime(startDate.year + 1, 1, 1);
    endDate = DateTime(startDate.year + 1, 1, 1);
    setDateFilter(startDate, endDate);
  }

  @override
  prev() {
    startDate = DateTime(startDate.year - 1);
    endDate = DateTime(startDate.year + 1);
    setDateFilter(startDate, endDate);
  }

  @override
  String getPeriod() {
    return startDate.year.toString();
  }
}
