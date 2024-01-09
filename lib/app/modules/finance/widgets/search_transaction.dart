import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

import 'package:get/get.dart';
import 'package:redstar_hightech_backend/app/modules/finance/account/controllers/account_controller.dart';
import 'package:redstar_hightech_backend/app/modules/finance/account/models/account_model.dart';
import 'package:redstar_hightech_backend/app/modules/finance/transaction/controllers/transaction_controller.dart';
import 'package:redstar_hightech_backend/app/modules/finance/transaction/models/transaction_model.dart';
import 'package:redstar_hightech_backend/app/modules/finance/widgets/empty_view.dart';
import 'package:redstar_hightech_backend/app/modules/finance/widgets/tile_transaction.dart';
import 'package:redstar_hightech_backend/util.dart';

class TransactionSearchDelegate extends SearchDelegate {
  @override
  String? get searchFieldLabel => 'Serch Transactions';
  List<Transaction> transactions = TransactionController().allTransactions;
  List<Account> accounts = AccountController().accounts;

  final TransactionController transactionController = Get.find();
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
          item.account.name.toLowerCase().contains(query.toLowerCase())) {
        resultList.add(item);
      }
    }
    if (query.isNotEmpty && resultList.isEmpty) {
      return const EmptyView(icon: Icons.search, label: 'No Results Found');
    }
    return SlidableAutoCloseBehavior(
      child: ListView.builder(
          padding: const EdgeInsets.symmetric(vertical: 10),
          itemCount: resultList.length,
          itemBuilder: (context, index) {
            Transaction currItem = resultList[index];
            return TransactionTile(
              transaction: currItem,
              transactionController: transactionController,
              enableSlide: false,
            );
          }),
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    List<Account> suggestionList = [];

    for (var item in accounts) {
      if (query.isNotEmpty &&
          item.name.toLowerCase().contains(query.toLowerCase())) {
        suggestionList.add(item);
      }
    }

    return SlidableAutoCloseBehavior(
      child: ListView.builder(
          padding: const EdgeInsets.symmetric(vertical: 10),
          itemCount: suggestionList.length,
          itemBuilder: (context, index) {
            final currCat = suggestionList[index];
            return ListTile(
              leading:
                  const Icon(Icons.person) /* Util.getCatIcon(currCat.type) */,
              contentPadding:
                  const EdgeInsets.symmetric(vertical: 0, horizontal: 25),
              visualDensity: const VisualDensity(horizontal: 0, vertical: 0),
              title: Text(suggestionList[index].name,
                  style: const TextStyle(fontWeight: FontWeight.bold)),
              onTap: () {
                query = currCat.name;
                showResults(context);
              },
            );
          }),
    );
  }
}
