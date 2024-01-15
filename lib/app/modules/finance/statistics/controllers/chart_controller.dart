import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:redstar_hightech_backend/app/modules/finance/account/controllers/account_controller.dart';
import 'package:redstar_hightech_backend/app/modules/finance/account/models/account_model.dart';
import 'package:redstar_hightech_backend/app/modules/finance/account/models/account_type.dart';
import 'package:redstar_hightech_backend/app/modules/finance/statistics/helpers/chart_helper.dart';
import 'package:redstar_hightech_backend/app/modules/finance/statistics/models/chart_data_model.dart';
import 'package:redstar_hightech_backend/app/modules/finance/transaction/controllers/transaction_controller.dart';
import 'package:redstar_hightech_backend/app/modules/finance/transaction/models/transaction_model.dart';

abstract class ChartController extends GetxController {
  late Box<Transaction> box;
  late List<Transaction> allTransactions;
  late List<Transaction> filterdList;
  late Future<List<CatChartData>> chartDataList;
  TransactionController transactionController =
      Get.put(TransactionController());
  late Future<List<CatChartData>> displyDataList;
  int currTypeFilter = 0;
  final DateTime now = DateTime.now();
  late DateTime startDate;
  late DateTime endDate;

  initialize(startDate, endDate) {
    allTransactions =
        transactionController.allTransactions.value; //box.values.toList();

    setDateFilter(startDate, endDate);
    setTypeFiler(0);
  }

  prev();
  next();
  String getPeriod();

  setTypeFiler(int type) {
    switch (type) {
      case 0:
        displyDataList = chartDataList;
        update();
        break;

      case 1:
        displyDataList = chartDataList.then((value) => value
            .where((el) =>
                Account.accountIndexToAccountType(el.type) ==
                AccountType.mobileAgent)
            .toList());
        update();
        break;
      case 2:
        displyDataList = chartDataList.then((value) => value
            .where((el) =>
                Account.accountIndexToAccountType(el.type) ==
                AccountType.lotoAgent)
            .toList());
        update();
        break;
      case 3:
        displyDataList = chartDataList.then((value) => value
            .where((el) =>
                Account.accountIndexToAccountType(el.type) ==
                AccountType.cashMoney)
            .toList());

        update();
        break;

      case 4:
        displyDataList = ChartHelper().getOverViewData(filterdList);

        update();
        break;
      //  displyDataList = ChartHelper().getOverViewData(chartDataList);
      default:
        displyDataList = chartDataList;
        update();
        break;
    }
    currTypeFilter = type;
  }

  setDateFilter(DateTime startDate, DateTime endDate) {
    this.startDate = startDate;
    this.endDate = endDate;

    filterdList = allTransactions
        .where((element) =>
            (element.date.isAfter(startDate) || element.date == startDate) &&
            element.date.isBefore(endDate))
        .toList();
    chartDataList = ChartHelper().getCatTotals(filterdList);
    setTypeFiler(currTypeFilter);
  }
}
