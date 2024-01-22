import 'package:flutter/material.dart';

import 'package:get/get.dart';

import 'package:flutter/material.dart';

import 'package:redstar_hightech_backend/app/modules/authentication/controllers/authentication_controller.dart';

import 'package:redstar_hightech_backend/app/modules/common/navigation_drawer.dart';
import 'package:redstar_hightech_backend/app/modules/finance/account/controllers/account_controller.dart';
import 'package:redstar_hightech_backend/app/modules/finance/account/models/account_model.dart';
import 'package:redstar_hightech_backend/app/modules/finance/account/views/widgets/account_widget.dart';
import 'package:redstar_hightech_backend/app/modules/finance/transaction/controllers/transaction_controller.dart';
import 'package:redstar_hightech_backend/app/modules/finance/transaction/models/transaction_model.dart';
import 'package:redstar_hightech_backend/app/modules/finance/transaction/models/transaction_type_model.dart';
import 'package:redstar_hightech_backend/app/modules/finance/widgets/floating_circle_menu.dart';

import 'package:redstar_hightech_backend/app/routes/app_pages.dart';
import 'package:redstar_hightech_backend/app/shared/app_bar_widget.dart';
import 'package:redstar_hightech_backend/app/shared/app_search_delegate.dart';
import 'package:redstar_hightech_backend/app/shared/button_optional_menu.dart';
import 'package:redstar_hightech_backend/app/shared/list_not_found.sharedWidgets.dart';

class AccountView extends GetView<AccountController> {
  var exists;
  TransactionController transactionController =
      Get.put(TransactionController());
  double totalBalance = 0;
  double totalIncome = 0;
  double totalExpense = 0;
  final textColor = const Color(0xff324149);

  AccountView({Key? key}) : super(key: key);

  Future<void> _pullRefresh() async {
    controller.accountList();
  }

  @override
  Widget build(BuildContext context) {
    AccountController controller = Get.put(AccountController());

    return Scaffold(
        appBar: AppBarWidget(
          title: 'Accounts',
          icon: Icons.search,
          bgColor: Colors.black,
          onPressed: () {
            showSearch(context: context, delegate: AppSearchDelegate());
          },
          authenticationController: Get.find<AuthenticationController>(),
          menuActionButton: ButtonOptionalMenu(),
          tooltip: 'Search',
        ),
        drawer: NavigationDrawer(),
        floatingActionButton: FloatingCircleMenu(
          tempIcon: Icons.person_add,
          tempRoute: AppPages.FINANCE_ADD_ACCOUNT,
        ),
        body: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            children: [
              Expanded(
                child: Obx(() {
                  if (controller.accounts.isNotEmpty) {
                    return ListView.builder(
                        itemCount: controller.accounts.length,
                        itemBuilder: ((context, index) {
                          Account account = controller.accounts[index];
                          List<Transaction> transactionByAccount = [];

                          /*   List<Transaction> txByAccount = */ transactionController
                              .allTransactions
                              .forEach((element) {
                            if (element.account.id == account.id) {
                              transactionByAccount.add(element);
                            }
                          });

                          /*          .takeWhile((transaction) =>
                                  transaction.account.id == account.id)
                              .toList();
 */
                          calculateBalances(transactionByAccount);

                          return SizedBox(
                            height: 230,
                            child: InkWell(
                              onTap: () => Get.toNamed(
                                  AppPages.FINANCE_TRANSACTION,
                                  arguments: {'acc': account}),
                              child: AccountCard(
                                  account: account,
                                  totalBalance: totalBalance,
                                  index: index,
                                  accountController: controller),
                            ),
                          );
                        }));
                  }

                  return ListNotFound(
                      route: AppPages.INITIAL,
                      message: "There are not account in the list",
                      info: "Go Back",
                      imageUrl: "assets/images/empty.png");
                }),
              )
            ],
          ),
        ));
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
  }
}

































/* import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:redstar_hightech_backend/app/config/responsive.dart';
import 'package:redstar_hightech_backend/app/constants/app_theme.dart';
import 'package:redstar_hightech_backend/app/modules/authentication/controllers/authentication_controller.dart';
import 'package:redstar_hightech_backend/app/modules/common/navigation_drawer.dart';
import 'package:redstar_hightech_backend/app/modules/finance/account/controllers/account_controller.dart';
import 'package:redstar_hightech_backend/app/modules/finance/account/models/account_model.dart';
import 'package:redstar_hightech_backend/app/modules/finance/account/views/add_account_dialog.dart';

import 'package:redstar_hightech_backend/app/modules/finance/widgets/empty_view.dart';
import 'package:redstar_hightech_backend/app/shared/app_bar_widget.dart';
import 'package:redstar_hightech_backend/app/shared/app_search_delegate.dart';
import 'package:redstar_hightech_backend/app/shared/button_optional_menu.dart';
import 'package:redstar_hightech_backend/util.dart';

import 'package:flutter/material.dart';

class AccountView extends StatefulWidget {
  const AccountView({Key? key}) : super(key: key);

  @override
  State<AccountView> createState() => _AccountViewState();
}

class _AccountViewState extends State<AccountView>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  int currType = 0;

  @override
  void initState() {
    _tabController = TabController(length: 1, vsync: this);
    _tabController.addListener(() {
      setState(() {
        currType = _tabController.index;
      });
    });
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _tabController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    bool keyboardIsOpen = MediaQuery.of(context).viewInsets.bottom != 0;
    return Scaffold(
      drawer: !Responsive.isDesktop(context) ? NavigationDrawer() : Container(),
      appBar: /*  !Responsive.isDesktop(context)
          ?  */
          AppBarWidget(
        title: 'Redstar Management',
        icon: Icons.search,
        bgColor: Colors.black,
        onPressed: () {
          showSearch(context: context, delegate: AppSearchDelegate());
        },
        authenticationController: Get.find<AuthenticationController>(),
        menuActionButton: ButtonOptionalMenu(),
        tooltip: 'Search',
      ),
      floatingActionButton: Visibility(
        visible: !keyboardIsOpen,
        child: FloatingActionButton(
          onPressed: () async {
            showDialog(
                context: context,
                builder: (context) => AddAccountDialog(
                      type: currType,
                    ));
          },
          tooltip: 'New Account',
          child: const Icon(Icons.add),
        ),
      ),
      resizeToAvoidBottomInset: false,
      body: SizedBox(
        width: size.width,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Column(
            children: [
              Container(
                height: 35,
                width: size.width /* * .8 */,
                margin: const EdgeInsets.only(top: 15, bottom: 4),
                padding: const EdgeInsets.only(
                    left: 10, right: 10, top: 3, bottom: 3),
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  // borderRadius: BorderRadius.circular(25.0),
                ),
                child:
                    /* TabBar(
                  controller: _tabController,
                  indicator: BoxDecoration(
                      borderRadius: BorderRadius.circular(25.0),
                      gradient: LinearGradient(colors: [
                        Colors.white,
                        _tabController.index == 0
                            ? const Color(0xFFEBFFE3)
                            : const Color(0xFFFCE5E5)
                      ])),
                  labelColor: Colors.black,
                  unselectedLabelColor: Colors.black54,
                  labelStyle: const TextStyle(fontWeight: FontWeight.bold),
                  tabs: const [
                    Tab(text: 'Income'),
                    Tab(text: 'Expense'),
                  ],
                )  */
                    Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: const [
                    Text(
                      'Account Name',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Text(
                      'Account Number',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Text(
                      'Actions',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    )
                  ],
                ),
              ),
              const Divider(thickness: 1),
              Expanded(
                  child: TabBarView(controller: _tabController, children: [
                AccountList(),
              ]))
            ],
          ),
        ),
      ),
    );
  }
}

class AccountList extends StatefulWidget {
  final int? type;

  AccountList({Key? key, this.type}) : super(key: key);

  @override
  State<AccountList> createState() => _AccountListState();
}

class _AccountListState extends State<AccountList> {
  AccountController accountController = AccountController();

  @override
  Widget build(BuildContext context) {
    /* return GetBuilder<AccountController>(builder: (controller) {
      List<Account> categoriesList = controller.getActiveCategories(type);
      return ListView.separated(
          padding: const EdgeInsets.fromLTRB(15, 5, 15, 15),
          itemCount: categoriesList.length,
          itemBuilder: (context, index) {
            Account currCat = categoriesList[index];
            return Card(
              child: ListTile(
                leading: Util.getCatIcon(type),
                contentPadding:
                    const EdgeInsets.symmetric(vertical: 0, horizontal: 25),
                visualDensity: const VisualDensity(horizontal: 0, vertical: 0),
                title: Text(
                  currCat.categoryName,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                        onPressed: () {
                          showDialog(
                              context: context,
                              builder: (context) => AddCateoryDialog(
                                  type: type, account: currCat));
                        },
                        icon: const Icon(
                          Icons.edit,
                          color: AppTheme.darkGray,
                        )),
                    IconButton(
                        onPressed: () {
                          showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                    content: const Text(
                                      'Are you sure to delete this Account? ',
                                      style: TextStyle(
                                          fontWeight: FontWeight.w500),
                                    ),
                                    actions: [
                                      TextButton(
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                          },
                                          child: const Text('No')),
                                      TextButton(
                                          onPressed: () {
                                            AccountController()
                                                .deleteAccount(currCat);
                                            Navigator.of(context).pop();
                                          },
                                          child: const Text('Yes'))
                                    ],
                                  ));
                        },
                        icon: const Icon(
                          Icons.delete,
                          color: AppTheme.darkGray,
                        ))
                  ],
                ),
              ),
            );
          },
          separatorBuilder: (context, index) => const SizedBox());
    });*/
    return ValueListenableBuilder(
        valueListenable: accountController
            .accountsDataNotifier /* Hive.box<financeAccount.Account>('categories').listenable() */,
        builder: (context, List<Account> accounts, index) {
          List<Account> accountsList = accountsData;
          /*  box.values.where((element) => element.type == type).toList();*/
          if (accountsList.isEmpty) {
            return SizedBox(
              height: MediaQuery.of(context).size.height * 0.9,
              child: const EmptyView(
                icon: Icons.credit_card,
                label: 'No Accounts',
                color: Color.fromARGB(249, 26, 93, 148),
              ),
            );
          }
          return ListView.separated(
              padding: const EdgeInsets.fromLTRB(0, 1, 0, 1),
              itemCount: accountsList.length,
              itemBuilder: (context, index) {
                Account currAccount = accountsList[index];
                return ListTile(
                  // leading: Util.getCatIcon(type),
                  title: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        currAccount.name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(width: 10),
                      Text(
                        currAccount.number,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                          onPressed: () {
                            showDialog(
                                context: context,
                                builder: (context) =>
                                    AddAccountDialog(account: currAccount));
                          },
                          icon: const Icon(
                            Icons.edit,
                            color: AppTheme.darkGray,
                          )),
                      IconButton(
                          onPressed: () {
                            showDialog(
                                context: context,
                                builder: (context) => AlertDialog(
                                      content: const Text(
                                        'Are you sure to delete this Account? ',
                                        style: TextStyle(
                                            fontWeight: FontWeight.w500),
                                      ),
                                      actions: [
                                        TextButton(
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                            },
                                            child: const Text('No')),
                                        TextButton(
                                            onPressed: () {
                                              AccountController()
                                                  .deleteAccount(currAccount);
                                              Navigator.of(context).pop();
                                            },
                                            child: const Text('Yes'))
                                      ],
                                    ));
                          },
                          icon: const Icon(
                            Icons.delete,
                            color: AppTheme.redColor,
                          ))
                    ],
                  ),
                );
              },
              separatorBuilder: (context, index) => const Divider());
        });
  }
}



 */