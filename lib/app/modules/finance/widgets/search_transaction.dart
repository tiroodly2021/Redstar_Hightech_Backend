import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

import 'package:get/get.dart';
import 'package:redstar_hightech_backend/app/constants/const.dart';
import 'package:redstar_hightech_backend/app/modules/finance/account/controllers/account_controller.dart';
import 'package:redstar_hightech_backend/app/modules/finance/account/models/account_model.dart';
import 'package:redstar_hightech_backend/app/modules/finance/transaction/controllers/transaction_controller.dart';
import 'package:redstar_hightech_backend/app/modules/finance/transaction/models/transaction_model.dart';
import 'package:redstar_hightech_backend/app/modules/finance/transaction/models/transaction_type_model.dart';
import 'package:redstar_hightech_backend/app/modules/finance/widgets/empty_view.dart';
import 'package:redstar_hightech_backend/app/modules/finance/widgets/filter_bar.dart';
import 'package:redstar_hightech_backend/app/modules/finance/widgets/tile_transaction.dart';
import 'package:redstar_hightech_backend/util.dart';
import 'package:flutter_text_drawable/flutter_text_drawable.dart';

class TransactionSearchDelegate extends SearchDelegate {
  List<Transaction> transactions = TransactionController().filterdList;
  List<Account> accounts = AccountController().accounts;

  final TransactionController transactionController = Get.find();

  double totalBalance = 0;
  double totalIncome = 0;
  double totalExpense = 0;
  final textColor = const Color(0xff324149);

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
      IconButton(
        icon: const Icon(Icons.filter_alt_sharp),
        onPressed: () {
          //query = '';
        },
      ),
    ];
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
    if (query.isNotEmpty && resultList.isEmpty) {
      return const EmptyView(icon: Icons.search, label: 'No Results Found');
    }

    return SlidableAutoCloseBehavior(
      child: Column(
        children: [
          FilterBarv(),
          SizedBox(
            height: MediaQuery.of(context).size.height * .65,
            child: ListView.builder(
                padding: const EdgeInsets.symmetric(vertical: 10),
                itemCount: resultList.length,
                itemBuilder: (context, index) {
                  Transaction currItem = resultList[index];
                  calculateBalances(resultList);

                  return TransactionTile(
                    transaction: currItem,
                    transactionController: transactionController,
                    enableSlide: false,
                  );
                }),
          ),
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
                          "${totalExpense}",
                          style: TextStyle(color: Colors.red),
                        ),
                      ],
                    )),
              ],
            ),
          ),
          Padding(
            padding:
                const EdgeInsets.only(bottom: 2.0, top: 2, right: 20, left: 20),
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
                        Text("${totalIncome}"),
                      ],
                    )),
              ],
            ),
          ),
          Padding(
            padding:
                const EdgeInsets.only(bottom: 2.0, top: 2, right: 20, left: 20),
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
                        Text("Total"),
                        Text("${totalBalance}"),
                      ],
                    )),
              ],
            ),
          ),
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
