import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:redstar_hightech_backend/app/modules/finance/account_category/models/account_category.dart';

class AccountCategoryController extends GetxController {
  late Box<AccountCategory> box;
  AccountCategoryController() {
    box = Hive.box<AccountCategory>('categories');
  }

  addCategory(AccountCategory newCategory) {
    box.add(newCategory);
    update();
  }

  updateCategory(key, AccountCategory category) {
    box.put(key, category);
    update();
  }

  deleteCategory(AccountCategory category) {
    category.delete();

    update();
  }

  List<AccountCategory> getActiveCategories(int type) {
    return box.values
        .where((category) => category.type == type && !category.isDeleted)
        .toList();
  }

  bool isCateoryExist(String name) {
    for (AccountCategory category in box.values) {
      if (category.categoryName.toLowerCase() == name.toLowerCase()) {
        return true;
      }
    }
    return false;
  }

  //Box get cateoryBox => box;
  static Box<AccountCategory> getCategoriesBox() {
    return Hive.box<AccountCategory>('categories');
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
