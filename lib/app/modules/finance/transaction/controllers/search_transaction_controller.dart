import 'package:get/get.dart';
import 'package:redstar_hightech_backend/app/modules/finance/transaction/models/transaction_model.dart';
import 'package:redstar_hightech_backend/app/modules/finance/transaction/models/transaction_type_model.dart';

class SearchTransactionController extends GetxController {
  List<Transaction> resultList = [];
  late RxList<Transaction> filterdList = <Transaction>[].obs;

  late DateTime startDate;
  late DateTime endDate;

  double totalBalance = 0;
  double totalIncome = 0;
  double totalExpense = 0;

  RxBool isFilterEnabled = false.obs;

  RxInt transType = (-1).obs;

  void addItem(Transaction item) {
    resultList.add(item);
    update();
  }

  void setFilterSearchList(List<Transaction> passedResultList) {
    resultList = passedResultList.obs;

    _refreshList();
    update();
  }

  _refreshList() {
    if (isFilterEnabled.value) {
      filterdList = resultList
          .where((element) =>
              (element.date.isAfter(startDate) || element.date == startDate) &&
              element.date.isBefore(endDate))
          .toList()
          .obs;
    } else if (!isFilterEnabled.value) {
      filterdList = resultList.obs;
    }

    if (transType.value != -1) {
      print(
          'transaction type value: ${transType.value}  - filterList len ${filterdList.length}');

      filterdList = filterdList
          .where((element) =>
              element.type ==
              Transaction.transactionIndexToTransactionType(transType.value))
          .toList()
          .obs;
    }

    print('filterList len after ${filterdList.length}');

    filterdList.sort((a, b) => b.date.compareTo(a.date));
  }

  setFilter(DateTime start, DateTime end) {
    startDate = start;
    endDate = end;
    isFilterEnabled.value = true;
    _refreshList();
    update();
  }

  clearFilter() {
    isFilterEnabled.value = false;

    _refreshList();
    update();
  }

  calculateBalances(List<Transaction> tarnsactions) {
    totalBalance = 0;
    totalExpense = 0;
    totalIncome = 0;
    for (Transaction transaction in tarnsactions) {
      if (transaction.type == TransactionType.income) {
        totalBalance += transaction.amount;
        totalIncome += transaction.amount;
      } else {
        totalBalance -= transaction.amount;
        totalExpense += transaction.amount;
      }
    }

    return [totalBalance, totalExpense, totalIncome];
  }

  void setFilterListByTransactionType(TransactionType transactionType,
      {bool clear = false}) {
    if (!clear) {
      transType.value = transactionType.index;
    }

    _refreshList();
    update();
  }
}
