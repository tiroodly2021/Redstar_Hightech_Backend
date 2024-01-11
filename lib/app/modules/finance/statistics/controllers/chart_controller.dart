import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:redstar_hightech_backend/app/modules/finance/account/controllers/account_controller.dart';
import 'package:redstar_hightech_backend/app/modules/finance/account/models/account_model.dart';
import 'package:redstar_hightech_backend/app/modules/finance/statistics/models/chart_data_model.dart';
import 'package:redstar_hightech_backend/app/modules/finance/transaction/controllers/transaction_controller.dart';
import 'package:redstar_hightech_backend/app/modules/finance/transaction/models/transaction_model.dart';

abstract class ChartController extends GetxController {
  late Box<Transaction> box;
  late List<Transaction> allTransactions;
  late List<Transaction> filterdList;
  late List<CatChartData> chartDataList;
  TransactionController transactionController =
      Get.put(TransactionController());
  List<CatChartData> displyDataList = [];
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
        /*    .where(
                (el) => el.type == financeCategory.AccountCategoryType.expense)
            .toList(); */
        update();
        break;
      case 1:
        displyDataList = chartDataList;
        /*  .where(
                (el) => el.type == financeCategory.AccountCategoryType.income)
            .toList(); */
        update();
        break;
      case 2:
        displyDataList = ChartHelper().getOverViewData(chartDataList);
        update();
        break;
      default:
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

class ChartHelper {
  List<CatChartData> tmpdataList = [];
  List<CatChartData> dataList = [];
  List<CatChartData> getCatTotals(List<Transaction> filteredList) {
    _createEmptyList();
    for (Transaction item in filteredList) {
      int index =
          tmpdataList.indexWhere((el) => el.category == item.account.number);
      if (index != -1) {
        tmpdataList[index].toatal += item.amount;
      } else {
        //print('not contains');
      }
    }
    for (CatChartData data in tmpdataList) {
      if (data.toatal > 0) {
        dataList.add(data);
      }
    }
    return dataList;
  }

  _createEmptyList() {
    List<Account> accounts = AccountController().accounts;

    for (Account account in accounts) {
      tmpdataList.add(CatChartData(account.name, 0, 0));
    }
  }

  getOverViewData(List<CatChartData> allData) {
    List<CatChartData> overviewList = [];
    double totalIncome = 0;
    double totalExpense = 0;
    for (CatChartData data in allData) {
      if (data.type == 1) {
        totalExpense += data.toatal;
      } else if (data.type == 0) {
        totalIncome += data.toatal;
      }
    }
    if (totalExpense > 0 || totalIncome > 0) {
      overviewList.add(CatChartData('Income', -1, totalIncome));
      overviewList.add(CatChartData('Expense', -1, totalExpense));
    }
    return overviewList;
  }
}
