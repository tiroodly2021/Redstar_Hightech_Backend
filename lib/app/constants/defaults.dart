import 'package:redstar_hightech_backend/app/modules/finance/account_category/models/account_category.dart'
    as financeCategory;

class Defaults {
  final List<financeCategory.AccountCategory> defaultAccountCategories = [
    //income
    financeCategory.AccountCategory(
        categoryName: 'Salary',
        type: financeCategory.AccountCategoryType.income),
    financeCategory.AccountCategory(
        categoryName: 'Investment',
        type: financeCategory.AccountCategoryType.income),

    //expense
    financeCategory.AccountCategory(
        categoryName: 'Vehicle',
        type: financeCategory.AccountCategoryType.expense),
    financeCategory.AccountCategory(
        categoryName: 'Food',
        type: financeCategory.AccountCategoryType.expense),
    financeCategory.AccountCategory(
        categoryName: 'Transportation',
        type: financeCategory.AccountCategoryType.expense),
    financeCategory.AccountCategory(
        categoryName: 'Shopping',
        type: financeCategory.AccountCategoryType.expense),
    financeCategory.AccountCategory(
        categoryName: 'Fuel',
        type: financeCategory.AccountCategoryType.expense),
    financeCategory.AccountCategory(
        categoryName: 'Mobile',
        type: financeCategory.AccountCategoryType.expense)
  ];
}
