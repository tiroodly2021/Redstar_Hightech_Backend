import 'package:cloud_firestore/cloud_firestore.dart' as cloudFirestore;
import 'package:get/get.dart';
import 'package:redstar_hightech_backend/app/modules/finance/account/controllers/account_controller.dart';
import 'package:redstar_hightech_backend/app/modules/finance/account/models/account_model.dart';
import 'package:redstar_hightech_backend/app/modules/finance/account/models/account_type.dart';
import 'package:redstar_hightech_backend/app/modules/finance/statistics/models/chart_data_model.dart';
import 'package:redstar_hightech_backend/app/modules/finance/transaction/models/transaction_model.dart';

class ChartHelper {
  List<CatChartData> tmpdataList = [];
  List<CatChartData> dataList = [];
  // AccountController accountController = Get.put(AccountController());
  List<Account> accounts = [];

  Future<List<CatChartData>> getCatTotals(
      List<Transaction> filteredList) async {
    await _createEmptyList();

    for (Transaction item in filteredList) {
      int index =
          tmpdataList.indexWhere((el) => el.category == item.account.name);
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

  _createEmptyList() async {
    final referenceAccount =
        cloudFirestore.FirebaseFirestore.instance.collection("accounts");

    final accountList = (await referenceAccount.get())
        .docs
        .map((e) => Account.fromSnapShot(e))
        .toList();

    for (Account account in accountList) {
      tmpdataList
          .add(CatChartData(account.name, accountTypeToInt(account.type!), 0));
    }
  }

/*   getOverViewData(List<CatChartData> allData) {
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
  } */

  Future<List<CatChartData>> getOverViewData(List<Transaction> allData) {
    List<Transaction> overviewList = [];
    List<CatChartData> catchartList = [];
    double totalIncome = 0;
    double totalExpense = 0;
    for (Transaction data in allData) {
      if (data.type.index == 1) {
        totalExpense += data.amount;
      } else if (data.type.index == 0) {
        totalIncome += data.amount;
      }
    }
    if (totalExpense > 0 || totalIncome > 0) {
      catchartList.add(CatChartData('Income', -1, totalIncome));
      catchartList.add(CatChartData('Expense', -1, totalExpense));
    }
    return Future.value(catchartList);
  }
}
