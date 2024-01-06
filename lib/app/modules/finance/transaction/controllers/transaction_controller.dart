import 'package:get/get.dart';
import 'package:redstar_hightech_backend/app/modules/finance/transaction/models/transaction_model.dart';

class TransactionController extends GetxController {
  late List<Transaction> allTransactions;
  late List<Transaction> filterdList;
  late DateTime startDate;
  late DateTime endDate;
  String currPeriod = '';

  bool isFilterEnabled = false;
  TransactionController() {
    //box = Hive.box<Transaction>('transactions');
    _refreshList();
  }
  addTransaction(Transaction transaction) {
    //box.add(transaction);
    _refreshList();
    update();
  }

  updateTransaction(key, Transaction transaction) {
    //box.put(key, transaction);
    _refreshList();
    update();
  }

  deleteTransaction(Transaction transaction) {
    /*   if (box.values.contains(transaction)) {
      box.delete(transaction.key);
      allTransactions.remove(transaction);
      if (filterdList.contains(transaction)) {
        filterdList.remove(transaction);
      }
      update();
    } */
  }

  setFilter(DateTime start, DateTime end) {
    startDate = start;
    endDate = end;
    isFilterEnabled = true;
    _refreshList();
    update();
  }

  clearFilter() {
    isFilterEnabled = false;
    _refreshList();
    update();
  }

  _refreshList() {
    allTransactions = transactionsData; //box.values.toList();
    if (isFilterEnabled) {
      filterdList = allTransactions
          .where((element) =>
              (element.date.isAfter(startDate) || element.date == startDate) &&
              element.date.isBefore(endDate))
          .toList();
    } else {
      filterdList = allTransactions;
    }

    filterdList.sort((a, b) => b.date.compareTo(a.date));
  }

  Future<List<Transaction>> getTransactions() {
    return Future.value(transactionsData);
  }

  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {}
}
