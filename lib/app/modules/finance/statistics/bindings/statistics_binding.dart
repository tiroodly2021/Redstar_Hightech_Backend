import 'package:get/get.dart';
import 'package:redstar_hightech_backend/app/modules/finance/statistics/controllers/chart_controller.dart';
import 'package:redstar_hightech_backend/app/modules/finance/statistics/controllers/diary_controller.dart';
import 'package:redstar_hightech_backend/app/modules/finance/statistics/controllers/monthly_chart_controller.dart';
import 'package:redstar_hightech_backend/app/modules/finance/statistics/controllers/yearly_chart_contoller.dart';

import '../controllers/statistics_controller.dart';

class StatisticsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<StatisticsController>(
      () => StatisticsController(),
    );

    Get.lazyPut<DiaryController>(
      () => DiaryController(),
    );

    Get.lazyPut<MonthlyChartContollrt>(
      () => MonthlyChartContollrt(),
    );

    Get.lazyPut<YearlyChartContoller>(
      () => YearlyChartContoller(),
    );
  }
}
