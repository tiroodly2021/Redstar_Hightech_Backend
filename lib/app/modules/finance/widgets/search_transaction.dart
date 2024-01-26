import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

import 'package:get/get.dart';
import 'package:redstar_hightech_backend/app/modules/finance/account/controllers/account_controller.dart';
import 'package:redstar_hightech_backend/app/modules/finance/account/models/account_model.dart';
import 'package:redstar_hightech_backend/app/modules/finance/transaction/controllers/transaction_controller.dart';
import 'package:redstar_hightech_backend/app/modules/finance/transaction/models/transaction_model.dart';
import 'package:redstar_hightech_backend/app/modules/finance/transaction/models/transaction_type_model.dart';
import 'package:redstar_hightech_backend/app/modules/finance/widgets/empty_view.dart';
import 'package:redstar_hightech_backend/app/modules/finance/widgets/tile_transaction.dart';
import 'package:redstar_hightech_backend/util.dart';
import 'package:flutter_text_drawable/flutter_text_drawable.dart';

class TransactionSearchDelegate extends SearchDelegate {
  List<Transaction> transactions = TransactionController().allTransactions;
  List<Account> accounts = AccountController().accounts;

  final TransactionController transactionController = Get.find();

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

  getObjectType(Object suggestion) {
    print('object instance: ${suggestion}');
    print('object is transaction: ${(suggestion is Transaction)}');
    print('object account: ${(suggestion is Account)}');
  }
}
