import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:redstar_hightech_backend/app/modules/finance/account/models/account_model.dart';
import 'package:redstar_hightech_backend/app/routes/app_pages.dart';
//import 'package:redstar_hightech_backend/app/modules/finance/account_category/models/account_category.dart';
import 'package:redstar_hightech_backend/app/services/database_service.dart';

class AccountController extends GetxController {
  DatabaseService databaseService = DatabaseService();
  RxBool loading = false.obs;
  Map<String, dynamic> body = {};
  RxList<Account> accounts = <Account>[].obs;

  Rx<Account> account = Account(number: '', createdAt: '', name: '').obs;

  DatabaseService database = DatabaseService();

  Rx<Account> user = Account(number: '', createdAt: '', name: '').obs;

  TextEditingController addNameController = TextEditingController();
  TextEditingController addNumberController = TextEditingController();
  TextEditingController addBalanceCreditController = TextEditingController();
  TextEditingController addNBalanceDebitController = TextEditingController();

  //RxList<AccountCategory> roles = <AccountCategory>[].obs;
  RxString roleSelected = ''.obs;
  RxString imageLink = ''.obs;
  RxString imageLinkTemp = ''.obs;
  //Rx<AccountCategory> role = AccountCategory(categoryName: '', type: 0).obs;
  var count = 0.obs;

  ValueNotifier<List<Account>> accountsDataNotifier =
      ValueNotifier(accountsData);

  @override
  void onInit() {
    super.onInit();
    accountList();
  }

  void accountList() async {
    count.bindStream(database.getCount('accounts', 'AccountController'));
    accounts.bindStream(database.getAccounts());
    //  roles.bindStream(database.getRoles());
  }

  /* Future<List<AccountCategory>?> getRoleByUser(Account user) {
    // devices.bindStream(Stream.fromFuture(database.getDeviceByUser(user)));
    final listRoles = databaseService.getRoleByUser(user);

    return listRoles;
  }

  List<AccountCategory> getRoleByUserAsReal(Account user) {
    // devices.bindStream(Stream.fromFuture(database.getDeviceByUser(user)));
    RxList<AccountCategory> roleLists = <AccountCategory>[].obs;

    print("avant bind");
    roleLists.bindStream(databaseService.getRoleByUserASStream(user));

    print('test:   ${roleLists.first}');

    return roleLists;
  }

  Future<AccountCategory> getRoleFromId(String str) {
    Future<AccountCategory> futureRole = database.getRoleById(str);

    return futureRole;
  } */

  List<Account> getActiveAccounts() {
    return accountsData;
  }

  void addAccount(Account account) async {
    databaseService.addAccount(account);
    // print(account.toMap());
  }

  void deleteAccount(Account account) async {
    String? imageName = account.photoURL != '' ? account.photoURL : '';
    databaseService.deleteAccount(account);

    if (imageName != '') {
      imageName = imageName!.split("%2F")[1].split("?")[0];
      final imageRef =
          FirebaseStorage.instance.ref().child("images/${imageName}");

      await imageRef.delete();
    }
  }

  void toUpdateAccountView(Account account) async {
    Get.toNamed(AppPages.FINANCE_UPDATE_ACCOUNT, arguments: account);
  }

  void editAccount(Account account) async {
    databaseService.updateAccount(account);
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {}

  void updateAccount(String? id, Account account) {
    print(' id : ${id} account : ${account.toMap()}');
    //databaseService.updateAccount(account);
  }
}