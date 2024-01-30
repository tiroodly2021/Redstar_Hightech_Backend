import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

import 'package:get/get.dart';
import 'package:redstar_hightech_backend/app/constants/const.dart';
import 'package:redstar_hightech_backend/app/modules/finance/account/controllers/account_controller.dart';
import 'package:redstar_hightech_backend/app/modules/finance/account/models/account_model.dart';
import 'package:redstar_hightech_backend/app/modules/finance/transaction/controllers/search_transaction_controller.dart';
import 'package:redstar_hightech_backend/app/modules/finance/transaction/controllers/transaction_controller.dart';
import 'package:redstar_hightech_backend/app/modules/finance/transaction/models/transaction_model.dart';
import 'package:redstar_hightech_backend/app/modules/finance/transaction/models/transaction_type_model.dart';
import 'package:redstar_hightech_backend/app/modules/finance/widgets/empty_view.dart';
import 'package:redstar_hightech_backend/app/modules/finance/widgets/filter_bar.dart';
import 'package:redstar_hightech_backend/app/modules/finance/widgets/tile_transaction.dart';
import 'package:redstar_hightech_backend/util.dart';
import 'package:flutter_text_drawable/flutter_text_drawable.dart';

enum SearchTransactionType { none, income, expense }

class TransactionSearchDelegate extends SearchDelegate {
  List<Transaction> transactions = TransactionController().allTransactions;
  List<Account> accounts = AccountController().accounts;

  final TransactionController transactionController = Get.find();
  SearchTransactionController searchTransactionController =
      Get.put(SearchTransactionController());

  double totalBalance = 0;
  double totalIncome = 0;
  double totalExpense = 0;
  final textColor = const Color(0xff324149);

  late TransactionType transactionType = TransactionType.income;

  @override
  String? get searchFieldLabel => 'Serch Transactions';

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(
          Icons.clear,
        ),
        onPressed: () {
          query = '';
        },
      ),
      /*   IconButton(
        icon: const Icon(Icons.filter_alt_sharp),
        onPressed: () {
          //query = '';
        },
      ), */
      PopupMenuButton(
          icon: const Icon(Icons.filter_alt_sharp),
          itemBuilder: (context) => [
                PopupMenuItem<int>(
                    value: 0,
                    child: Row(
                      children: const [
                        Icon(
                          Icons.arrow_back_rounded,
                          color: Colors.black,
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Text("Income"),
                      ],
                    )),
                PopupMenuItem<int>(
                  value: 1,
                  child: Row(
                    children: const [
                      Icon(
                        Icons.arrow_forward,
                        color: Colors.black,
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Text("Expense"),
                    ],
                  ),
                ),
                PopupMenuItem<int>(
                    value: 2,
                    child: Row(
                      children: const [
                        Icon(
                          Icons.clear,
                          color: Colors.black,
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Text("Clear"),
                      ],
                    )),
              ],
          onSelected: (item) => selectedItem(context, item))
    ];
  }

  selectedItem(BuildContext context, Object? item) {
    switch (item) {
      case 0:
        transactionType = TransactionType.income;

        searchTransactionController
            .setFilterListByTransactionType(transactionType);

        break;
      case 1:
        transactionType = TransactionType.expense;
        searchTransactionController
            .setFilterListByTransactionType(transactionType);

        break;
      case 2:
        //transactionType = TransactionType.expense;
        searchTransactionController.transType.value = -1;
        searchTransactionController
            .setFilterListByTransactionType(transactionType, clear: true);

        break;

      default:
        print('default');
    }
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    List<Transaction> resultList = [];

    for (var item in transactions) {
      if (query.isNotEmpty &&
          (item.description!.toLowerCase().contains(query.toLowerCase()) ||
              item.amount
                  .toString()
                  .toLowerCase()
                  .contains(query.toLowerCase()))) {
        resultList.add(item);
      }
    }

    searchTransactionController.setFilterSearchList(resultList);

    if (query.isNotEmpty && searchTransactionController.filterdList.isEmpty) {
      return const EmptyView(icon: Icons.search, label: 'No Results Found');
    }

    return SlidableAutoCloseBehavior(
      child: Column(
        children: [
          MyFilterBarv(),
          /* Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Row(
              children: [Text('Selected information show')],
            ),
          ), */
          SizedBox(
            height: MediaQuery.of(context).size.height * .60,
            child:
                GetBuilder<SearchTransactionController>(builder: (controller) {
              return ListView.builder(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  itemCount: controller.filterdList.length,
                  itemBuilder: (context, index) {
                    Transaction currItem = controller.filterdList[index];

                    return TransactionTile(
                      transaction: currItem,
                      transactionController: transactionController,
                      enableSlide: false,
                    );
                  });
            }),
          ),
          GetBuilder<SearchTransactionController>(builder: (controller) {
            calculateBalances(controller.filterdList);

            return Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(
                      bottom: 2.0, top: 20, right: 20, left: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Container(
                          padding: const EdgeInsets.only(
                              top: 4, bottom: 4, left: 4, right: 4),
                          width: MediaQuery.of(context).size.width - 40,
                          decoration: customBoxBorder,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Expense",
                                style: TextStyle(color: Colors.red),
                              ),
                              Text(
                                "\$ ${totalExpense.toStringAsFixed(2)}",
                                style: TextStyle(color: Colors.red),
                              ),
                            ],
                          )),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                      bottom: 2.0, top: 2, right: 20, left: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Container(
                          padding: const EdgeInsets.only(
                              top: 4, bottom: 4, left: 4, right: 4),
                          width: MediaQuery.of(context).size.width - 40,
                          decoration: customBoxBorder,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text("Income"),
                              Text("\$ ${totalIncome.toStringAsFixed(2)}"),
                            ],
                          )),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                      bottom: 2.0, top: 2, right: 20, left: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Container(
                          padding: const EdgeInsets.only(
                              top: 4, bottom: 4, left: 4, right: 4),
                          width: MediaQuery.of(context).size.width - 40,
                          decoration: customBoxBorder,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text("Total",
                                  style:
                                      TextStyle(fontWeight: FontWeight.bold)),
                              Text(
                                  totalBalance >= 0
                                      ? "\$ ${totalBalance.toStringAsFixed(2)}"
                                      : (totalBalance == 0)
                                          ? "\$ 0.00"
                                          : "- \$ ${(-totalBalance).toStringAsFixed(2)}",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: totalBalance >= 0
                                          ? Colors.black
                                          : Colors.red)),
                            ],
                          )),
                    ],
                  ),
                ),
              ],
            );
          })
        ],
      ),
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    List<Transaction> suggestionList = [];

    /*  for (var item in accounts) {
      if (query.isNotEmpty &&
          item.name.toLowerCase().contains(query.toLowerCase())) {
        suggestionList.add(item);
      }
    }
 */
    for (Transaction item in transactions) {
      if (query.isNotEmpty &&
          (item.description!.toLowerCase().contains(query.toLowerCase()) ||
              item.amount
                  .toString()
                  .toLowerCase()
                  .contains(query.toLowerCase()))) {
        suggestionList.addIf(
            suggestionList
                .where((e) => e.description == item.description)
                .toList()
                .isEmpty,
            item);
      }
    }

    return SlidableAutoCloseBehavior(
      child: ListView.builder(
          padding: const EdgeInsets.symmetric(vertical: 10),
          itemCount: suggestionList.length,
          itemBuilder: (context, index) {
            final currSearchedObject = suggestionList[index];

            return ListTile(
              leading: TextDrawable(
                text: suggestionList[index].description!,
                isTappable: true,
                onTap: (val) {
                  print("$index selected: $val");
                },
                boxShape: BoxShape.rectangle,
                borderRadius: BorderRadius.circular(8),
              ),
              contentPadding:
                  const EdgeInsets.symmetric(vertical: 0, horizontal: 25),
              visualDensity: const VisualDensity(horizontal: 0, vertical: 0),
              title: Text(suggestionList[index].description!,
                  style: const TextStyle(fontWeight: FontWeight.bold)),
              onTap: () {
                query = currSearchedObject.description!;
                showResults(context);
              },
            );
          }),
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
    return [totalBalance, totalExpense, totalIncome];
  }
}

class MyFilterBarv extends StatefulWidget {
  String? number;
  MyFilterBarv({Key? key, this.number}) : super(key: key);

  @override
  State<MyFilterBarv> createState() => _MyFilterBarvState();
}

class _MyFilterBarvState extends State<MyFilterBarv> {
  final List<String> items = [
    'All',
    'Today',
    'Yesterday',
    'This Week',
    'This Month',
    'Custom Range'
  ];
  int selFilterIndex = 0;
  @override
  void initState() {
    /* if (widget.number != null) {
      setFilter(widget.number);
      setState(() {
        // selFilterIndex = index;
      });
    } */

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40,
      width: double.infinity,
      child: Row(
        children: [
          Expanded(
            child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: items.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      setFilter(items[index]);
                      setState(() {
                        selFilterIndex = index;
                      });
                    },
                    child: Card(
                      color: selFilterIndex == index
                          ? const Color(0xFFF3f3f3)
                          : Colors.white,
                      margin: selFilterIndex == index
                          ? const EdgeInsets.only(top: 10)
                          : const EdgeInsets.only(bottom: 5),
                      shape: const RoundedRectangleBorder(),
                      elevation: selFilterIndex == index ? 0 : 2,
                      child: Container(
                        constraints: const BoxConstraints(minWidth: 100),
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: Align(
                          alignment: Alignment.center,
                          child: Text(
                            items[index],
                            style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: selFilterIndex == index
                                    ? Colors.blue
                                    : const Color(0x77000000)),
                          ),
                        ),
                      ),
                    ),
                  );
                }),
          ),
        ],
      ),
    );
  }

  setFilter(var selction) async {
    final SearchTransactionController controller = Get.find();
    final DateTime now = DateTime.now();
    switch (selction) {
      case 'All':
        controller.clearFilter();
        break;
      case 'Today':
        DateTime start = DateTime(now.year, now.month, now.day);
        DateTime end = start.add(const Duration(days: 1));
        controller.setFilter(start, end);
        break;
      case 'Yesterday':
        DateTime start = DateTime(now.year, now.month, now.day - 1);
        DateTime end = start.add(const Duration(days: 1));
        controller.setFilter(start, end);
        break;
      case 'This Week':
        DateTime start = DateTime(now.year, now.month, now.day - 6);
        DateTime end = DateTime(start.year, start.month, start.day + 7);
        controller.setFilter(start, end);
        break;
      case 'This Month':
        DateTime start = DateTime(now.year, now.month, 1);
        DateTime end = DateTime(start.year, start.month + 1, start.day);
        controller.setFilter(start, end);
        break;

      case 'Custom Range':
        DateTimeRange? picked = await showDateRangePicker(
            context: context,
            saveText: 'APPLY',
            firstDate: DateTime(2000),
            lastDate: DateTime(2101));
        if (picked != null) {
          controller.setFilter(
              picked.start, picked.end.add(const Duration(days: 1)));
        }

        break;
      default:
        //controller.setFilterByAccount(widget.number!);
        break;
    }
  }
}
