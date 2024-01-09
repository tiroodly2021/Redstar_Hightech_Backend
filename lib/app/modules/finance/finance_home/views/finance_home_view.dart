import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

import 'package:get/get.dart';
import 'package:redstar_hightech_backend/app/config/responsive.dart';
import 'package:redstar_hightech_backend/app/constants/app_theme.dart';
import 'package:redstar_hightech_backend/app/modules/authentication/controllers/authentication_controller.dart';
import 'package:redstar_hightech_backend/app/modules/common/navigation_drawer.dart';
/* import 'package:redstar_hightech_backend/app/modules/finance/account_category/controllers/account_category_controller.dart';
import 'package:redstar_hightech_backend/app/modules/finance/statistics/controllers/monthly_chart_controller.dart';
import 'package:redstar_hightech_backend/app/modules/finance/statistics/controllers/yearly_chart_contoller.dart';
 */
import 'package:redstar_hightech_backend/app/modules/finance/transaction/controllers/transaction_controller.dart';
import 'package:redstar_hightech_backend/app/modules/finance/transaction/models/transaction_model.dart';
import 'package:redstar_hightech_backend/app/modules/finance/transaction/models/transaction_type_model.dart';
//import 'package:redstar_hightech_backend/app/modules/finance/transaction/models/transaction.dart';
import 'package:redstar_hightech_backend/app/modules/finance/transaction/views/add_transaction_view.dart';
import 'package:redstar_hightech_backend/app/modules/finance/transaction/views/transaction_view.dart';
import 'package:redstar_hightech_backend/app/modules/finance/widgets/empty_view.dart';
import 'package:redstar_hightech_backend/app/modules/finance/widgets/filter_bar.dart';
import 'package:redstar_hightech_backend/app/modules/finance/widgets/search_transaction.dart';
import 'package:redstar_hightech_backend/app/modules/finance/widgets/tile_transaction.dart';
/* import 'package:redstar_hightech_backend/app/modules/finance/widgets/empty_view.dart';
import 'package:redstar_hightech_backend/app/modules/finance/widgets/filter_bar.dart';
import 'package:redstar_hightech_backend/app/modules/finance/widgets/tile_transaction.dart'; */
import 'package:redstar_hightech_backend/app/routes/app_pages.dart';
import 'package:redstar_hightech_backend/app/shared/app_bar_widget.dart';
import 'package:redstar_hightech_backend/app/shared/app_search_delegate.dart';
import 'package:redstar_hightech_backend/app/shared/button_optional_menu.dart';

import '../controllers/finance_home_controller.dart';

class FinanceHomeView extends GetView<FinanceHomeController> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  final transactionController = Get.put(TransactionController());
  /* final cateoryController = Get.put(AccountCategoryController());
  final chartController = Get.put(MonthlyChartContollrt());
  final ychartController = Get.put(YearlyChartContoller()); */

  double totalBalance = 0;
  double totalIncome = 0;
  double totalExpense = 0;
  final textColor = const Color(0xff324149);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: !Responsive.isDesktop(context) ? NavigationDrawer() : Container(),
      appBar: /*  !Responsive.isDesktop(context)
          ?  */
          AppBarWidget(
        title: 'Finance',
        icon: Icons.search,
        bgColor: Colors.black,
        onPressed: () {
          showSearch(context: context, delegate: TransactionSearchDelegate());
        },
        authenticationController: Get.find<AuthenticationController>(),
        menuActionButton: ButtonOptionalMenu(),
        tooltip: 'Search',
      ),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            heroTag: "btn1",
            onPressed: () {
              Get.toNamed(AppPages.FINANCE_ADD_TRANSACTION);
            },
            tooltip: 'New Transaction',
            child: const Icon(Icons.add),
          ),
          const SizedBox(
            width: 10,
          ),
          FloatingActionButton(
            heroTag: "btn2",
            onPressed: () {
              Get.toNamed(AppPages.FINANCE_ACCOUNT);
            },
            tooltip: 'Accounts',
            child: const Icon(Icons.list),
          ),
        ],
      ),
      body: /* ListView(children: [
          //     const FilterBarv(),
          const SizedBox(height: 25),
          _buildBalanceWidget(textColor),
          const SizedBox(height: 5),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Recent Transactions',
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context)
                      .textTheme
                      .titleMedium!
                      .copyWith(fontWeight: FontWeight.bold),
                ),
                TextButton(
                  onPressed: () {
                    Get.toNamed(AppPages.FINANCE_TRANSACTION);
                  },
                  child: const Text(
                    'See all',
                  ),
                )
              ],
            ),
          ),
          SizedBox(
            child: transactionController.filterdList.isEmpty
                ? SizedBox(
                    height: MediaQuery.of(context).size.height * 0.4,
                    child: const EmptyView(
                        icon: Icons.receipt_long,
                        label: 'No Transactions Found'),
                  )
                : SlidableAutoCloseBehavior(
                    closeWhenOpened: true,
                    child: ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: transactionController.filterdList.length < 5
                            ? transactionController.filterdList.length
                            : 5,
                        itemBuilder: (context, index) {
                          Transaction currItem =
                              transactionController.filterdList[index];
                          return TransactionTile(
                              transaction: currItem,
                              transactionController: transactionController);
                        }),
                  ),
          ),
        ]) */
          GetBuilder<TransactionController>(builder: (controller) {
        return Obx(() {
          calculateBalances(controller.filterdList);

          return ListView(children: [
            const FilterBarv(),
            const SizedBox(height: 25),
            _buildBalanceWidget(textColor),
            const SizedBox(height: 5),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Recent Transactions',
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context)
                        .textTheme
                        .titleMedium!
                        .copyWith(fontWeight: FontWeight.bold),
                  ),
                  TextButton(
                    onPressed: () {
                      Get.toNamed(AppPages.FINANCE_TRANSACTION);
                    },
                    child: const Text(
                      'See all',
                    ),
                  )
                ],
              ),
            ),
            SizedBox(
              child: controller.allTransactions.isEmpty //.filterdList.isEmpty
                  ? SizedBox(
                      height: MediaQuery.of(context).size.height * 0.4,
                      child: const EmptyView(
                          icon: Icons.receipt_long,
                          label: 'No Transactions Found'),
                    )
                  : SlidableAutoCloseBehavior(
                      closeWhenOpened: true,
                      child: ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: controller.filterdList.length < 5
                              ? controller.filterdList.length
                              : 5,
                          itemBuilder: (context, index) {
                            Transaction currItem =
                                controller.filterdList[index];

                            return TransactionTile(
                                transaction: currItem,
                                transactionController: transactionController);
                          }),
                    ),
            ),
          ]);
        });
      }),
    );
  }

  Container _buildBalanceWidget(Color textColor) {
    return Container(
      width: double.infinity,
      height: 165,
      margin: const EdgeInsets.symmetric(horizontal: 20),
      clipBehavior: Clip.hardEdge,
      decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: const [
            BoxShadow(blurRadius: 5, color: Color.fromARGB(65, 0, 0, 0))
          ],
          borderRadius: BorderRadius.circular(20)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(30, 30, 30, 10),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Total Balance',
                      style: TextStyle(
                          color: AppTheme.darkGray,
                          fontSize: 15,
                          fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      '\u{20B9} $totalBalance',
                      style: const TextStyle(
                          fontSize: 20,
                          color: AppTheme.darkGray,
                          fontWeight: FontWeight.bold),
                    )
                  ]),
            ),
          ),
          Row(
            children: [
              Expanded(
                child: Container(
                  height: 50,
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        stops: [
                          0.1,
                          0.8,
                          0.95
                        ],
                        colors: [
                          Color(0x0027FF2E),
                          Color(0x3227FF2E),
                          Color(0x8827FF2E)
                        ]),
                  ),
                  child: Column(
                    children: [
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: const [
                          Icon(
                            Icons.arrow_upward,
                            color: AppTheme.darkGray,
                            size: 18,
                          ),
                          SizedBox(width: 10),
                          Text('Income',
                              style: TextStyle(
                                  color: AppTheme.darkGray,
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600))
                        ],
                      ),
                      const SizedBox(height: 5),
                      Text(
                        '\u{20B9} $totalIncome',
                        style: const TextStyle(
                            fontSize: 15,
                            color: Color(0xff4EAE51),
                            fontWeight: FontWeight.bold),
                      )
                    ],
                  ),
                ),
              ),
              Expanded(
                child: Container(
                  height: 50,
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        stops: [
                          0.1,
                          .8,
                          .95
                        ],
                        colors: [
                          Color(0x00FF6969),
                          Color(0x32FF6969),
                          Color(0x88FF6969)
                        ]),
                  ),
                  child: Column(
                    children: [
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: const [
                          Icon(
                            Icons.arrow_downward,
                            color: AppTheme.darkGray,
                            size: 18,
                          ),
                          SizedBox(width: 10),
                          Text('Expense',
                              style: TextStyle(
                                  color: AppTheme.darkGray,
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600))
                        ],
                      ),
                      const SizedBox(height: 5),
                      Text(
                        '\u{20B9} $totalExpense',
                        style: const TextStyle(
                            fontSize: 15,
                            color: Color(0xffFF5F5F),
                            fontWeight: FontWeight.bold),
                      )
                    ],
                  ),
                ),
              )
            ],
          )
        ],
      ),
    );
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
/* 
class FinanceHomeView extends GetView<FinanceHomeController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('AccountView'),
        centerTitle: true,
      ),
      body: Center(
        child: Text(
          'AccountView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
 */