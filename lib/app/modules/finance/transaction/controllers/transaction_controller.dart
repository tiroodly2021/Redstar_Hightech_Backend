import 'package:get/get.dart';
import 'package:redstar_hightech_backend/app/modules/finance/transaction/models/transaction_model.dart';
import 'package:redstar_hightech_backend/app/services/database_service.dart';

class TransactionController extends GetxController {
  DatabaseService databaseService = DatabaseService();

  late RxList<Transaction> allTransactions = <Transaction>[].obs;
  late RxList<Transaction> filterdList = <Transaction>[].obs;
  late DateTime startDate;
  late DateTime endDate;
  late String accountNumber;
  String currPeriod = '';

  RxBool isFilterEnabled = false.obs;

  RxBool isFilterByAccountEnabled = false.obs;

  RxBool isTransfertActivated = false.obs;

  TransactionController() {
    //box = Hive.box<Transaction>('transactions');
    clearFilterByAccount();
    clearFilter();
    _refreshList();
  }
  addTransaction(Transaction transaction) {
    //box.add(transaction);

    databaseService.addTransaction(transaction);
    //print(transaction.toMap());

    _refreshList();
    // update();
  }

  updateTransaction(String key, Transaction transaction) {
    //box.put(key, transaction);
    databaseService.updateTransaction(key, transaction);
    _refreshList();
    update();
  }

  deleteTransaction(Transaction transaction) {
    databaseService.deleteTransaction(transaction);
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
    isFilterEnabled.value = true;
    _refreshList();
    update();
  }

  setFilterByAccount(String number) {
    accountNumber = number;
    isFilterByAccountEnabled.value = true;
    _refreshList();
    //update();
  }

  clearFilter() {
    isFilterEnabled.value = false;

    _refreshList();
    update();
  }

  clearFilterByAccount() {
    isFilterByAccountEnabled.value = false;
    _refreshList();
    update();
  }

  _refreshList() {
    allTransactions.bindStream(databaseService.getTransactions());
    // allTransactions.value = transactionsData; //box.values.toList();
    if (isFilterEnabled.value && !isFilterByAccountEnabled.value) {
      filterdList = allTransactions
          .where((element) =>
              (element.date.isAfter(startDate) || element.date == startDate) &&
              element.date.isBefore(endDate))
          .toList()
          .obs;
    } else if (!isFilterEnabled.value && isFilterByAccountEnabled.value) {
      filterdList = allTransactions
          .where((element) => element.account == accountNumber)
          .toList()
          .obs;
    } else if (isFilterEnabled.value && isFilterByAccountEnabled.value) {
      filterdList = allTransactions
          .where((element) =>
              (element.date.isAfter(startDate) || element.date == startDate) &&
              element.date.isBefore(endDate))
          .where((element) => element.account == accountNumber)
          .toList()
          .obs;
    } else if (!isFilterEnabled.value && !isFilterByAccountEnabled.value) {
      filterdList = allTransactions;
    }

    filterdList.sort((a, b) => b.date.compareTo(a.date));
  }

  @override
  void onClose() {
    clearFilterByAccount();
    clearFilter();

    super.onClose();
  }
}


/* 



import 'package:get/get.dart';
import 'package:redstar_hightech_backend/app/modules/finance/transaction/models/transaction_model.dart';
import 'package:redstar_hightech_backend/app/services/database_service.dart';

class TransactionController extends GetxController {
  DatabaseService databaseService = DatabaseService();

  late RxList<Transaction> allTransactions = <Transaction>[].obs;
  late List<Transaction> filterdList;
  late DateTime startDate;
  late DateTime endDate;
  late String accountNumber;
  String currPeriod = '';

  bool isFilterEnabled = false;

  bool isFilterByAccountEnabled = false;

  TransactionController() {
    //box = Hive.box<Transaction>('transactions');
    _refreshList();
  }
  addTransaction(Transaction transaction) {
    //box.add(transaction);

    databaseService.addTransaction(transaction);

    _refreshList();
    update();
  }

  updateTransaction(String key, Transaction transaction) {
    //box.put(key, transaction);
    databaseService.updateTransaction(key, transaction);
    _refreshList();
    update();
  }

  deleteTransaction(Transaction transaction) {
    databaseService.deleteTransaction(transaction);
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

  setFilterByAccount(String number) {
    accountNumber = number;
    isFilterByAccountEnabled = true;
    _refreshList();
    //update();
  }

  clearFilter() {
    isFilterEnabled = false;
    _refreshList();
    update();
  }

  _refreshList() {
    allTransactions.bindStream(databaseService.getTransactions());
    // allTransactions.value = transactionsData; //box.values.toList();
    if (isFilterEnabled) {
      filterdList = allTransactions
          .where((element) =>
              (element.date.isAfter(startDate) || element.date == startDate) &&
              element.date.isBefore(endDate))
          .toList();
    } else {
      filterdList = allTransactions;
    }

    if (isFilterByAccountEnabled) {
      filterdList = filterdList
          .where((element) => element.account == accountNumber)
          .toList();
    }

    filterdList.sort((a, b) => b.date.compareTo(a.date));
  }

  Future<List<Transaction>> getTransactions() {
    return Future.value(transactionsData);
  }
}






 */