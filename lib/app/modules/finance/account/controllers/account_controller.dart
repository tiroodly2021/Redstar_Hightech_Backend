import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:redstar_hightech_backend/app/modules/finance/account/models/account_model.dart';
import 'package:redstar_hightech_backend/app/modules/finance/account_category/models/account_category.dart';
import 'package:redstar_hightech_backend/app/services/database_service.dart';

class AccountController extends GetxController {
  DatabaseService databaseService = DatabaseService();
  RxBool loading = false.obs;
  Map<String, dynamic> body = {};
  RxList<Account> accounts = <Account>[].obs;

  DatabaseService database = DatabaseService();

  Rx<Account> user =
      Account(number: '', createdAt: '', name: '', categories: []).obs;

  TextEditingController addNameController = TextEditingController();
  TextEditingController addEmailController = TextEditingController();

  RxList<AccountCategory> roles = <AccountCategory>[].obs;
  RxString roleSelected = ''.obs;
  RxString imageLink = ''.obs;
  RxString imageLinkTemp = ''.obs;
  Rx<AccountCategory> role = AccountCategory(categoryName: '', type: 0).obs;
  var count = 0.obs;

  @override
  void onInit() {
    super.onInit();
    userList();
  }

  void userList() async {
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

  void addAccount(Account account) async {
    databaseService.addAccount(account);
  }

  void deleteUser(Account account) async {
    String? imageName = account.photoURL != '' ? account.photoURL : '';

    imageName = imageName!.split("%2F")[1].split("?")[0];

    databaseService.deleteAccount(account);

    // Create a reference to the file to delete
    if (imageName != '') {
      final imageRef =
          FirebaseStorage.instance.ref().child("images/${imageName}");
// Delete the file
      await imageRef.delete();
    }
  }

  void toUpdateAccountView(Account user) async {
    //Get.toNamed(AppPages.UPDATE_USER, arguments: user);
  }

  void editAccount(Account account) async {
    /*  print(user.toMap());
    print(
        "***********************************************************************");
    if (role != null) {
      print(role.toMap());
    } */

    databaseService.updateAccount(account);
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {}
}
