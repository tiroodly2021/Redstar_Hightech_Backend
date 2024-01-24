import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:get/get.dart';
//import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:redstar_hightech_backend/app/constants/app_theme.dart';
import 'package:redstar_hightech_backend/app/modules/authentication/controllers/authentication_controller.dart';
import 'package:redstar_hightech_backend/app/modules/authentication/controllers/user_controller.dart';
import 'package:redstar_hightech_backend/app/modules/finance/finance_home/bindings/finance_home_binding.dart';
import 'package:redstar_hightech_backend/app/modules/finance/transaction/controllers/transaction_controller.dart';
import 'package:redstar_hightech_backend/app/modules/finance/transaction/models/transaction_model.dart';
import 'package:redstar_hightech_backend/app/modules/finance/transaction/models/transaction_type_model.dart';
import 'package:redstar_hightech_backend/app/modules/finance/transaction/views/add_transaction_view.dart';
import 'package:redstar_hightech_backend/app/modules/middleware/auth_middleware.dart';
import 'package:redstar_hightech_backend/app/routes/app_pages.dart';

import 'package:redstar_hightech_backend/util.dart';

class TransactionTile extends StatelessWidget {
  TransactionTile(
      {Key? key,
      required this.transaction,
      required this.transactionController,
      this.enableSlide = true})
      : super(key: key);
  final Transaction transaction;
  final TransactionController transactionController;
  final DateTime today = DateTime.now();
  final bool enableSlide;
  final textColors = [Colors.green, Colors.red, Colors.orange];
  @override
  Widget build(BuildContext context) {
    return Slidable(
      enabled: enableSlide,
      key: ObjectKey(transaction),
      endActionPane: ActionPane(
          extentRatio: 0.25,
          dragDismissible: true,
          motion: const DrawerMotion(),
          children: [
            /*  SlidableAction(
            onPressed: (ctx) {},
            backgroundColor:const Color(0xFF21B7CA),
            foregroundColor: Colors.white,
            icon: Icons.edit),*/

            SlidableAction(
              flex: 1,
              autoClose: true,
              onPressed: (ctx) {
                if (AuthorizationMiddleware.checkPermission(
                    Get.find<AuthenticationController>(),
                    Get.find<UserController>(),
                    "/finance/transaction/delete")) {
                  final Transaction transactionCopy = Transaction(
                      date: transaction.date,
                      account: transaction.account,
                      amount: transaction.amount,
                      type: transaction.type);
                  transactionController.deleteTransaction(transaction);
                  ScaffoldMessenger.of(context)
                    ..removeCurrentSnackBar()
                    ..showSnackBar(SnackBar(
                      backgroundColor: AppTheme.darkGray,
                      content: const Text('Transaction Deleted'),
                      duration: const Duration(seconds: 2),
                      action: SnackBarAction(
                          label: 'UNDO',
                          onPressed: () {
                            transactionController
                                .addTransaction(transactionCopy);
                          }),
                    ));
                  return print("Check Delete route permission valid");
                }
                {
                  Get.snackbar(
                      "Delete Transaction", "You don't have permission",
                      icon: const Icon(Icons.warning_amber),
                      margin: const EdgeInsets.only(
                          left: 10, right: 10, bottom: 20),
                      backgroundColor: Colors.red,
                      snackPosition: SnackPosition.BOTTOM);
                  print(
                    "Check Delete route permission not valid",
                  );
                }
              },
              backgroundColor: const Color(0xFFFE4A49),
              foregroundColor: Colors.white,
              icon: Icons.delete,
            )
          ]),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 20),
        decoration: const BoxDecoration(
            color: Colors.white,
            border: Border.symmetric(
                horizontal: BorderSide(color: Color(0x22000000), width: .5))),
        child: InkWell(
          onTap: () => Get.toNamed(AppPages.FINANCE_ADD_TRANSACTION,
              arguments: transaction),
          onLongPress: () {
            if (enableSlide) {
              Util.showSnackbar(context, 'Slide transaction to delete');
            }
          },
          child: Row(
            children: [
              TileDateView(transaction.date),
              const SizedBox(width: 15),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      transaction.account.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context)
                          .textTheme
                          .titleMedium!
                          .copyWith(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(
                      height: 6,
                    ),
                    Text(
                      transaction.description!,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context)
                          .textTheme
                          .titleSmall!
                          .copyWith(fontWeight: FontWeight.w400),
                    ),
                    if (transaction.description != null &&
                        transaction.description!.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.only(top: 5),
                        child: Text(
                          DateFormat.yMMMEd().format(DateTime.parse(
                              transaction.date.toLocal().toIso8601String())),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                              fontSize: 12, color: AppTheme.darkGray),
                        ),
                      ),
                  ],
                ),
              ),
              Column(
                children: [
                  Text('\u{0024} ${transaction.amount.toString()}',
                      style: TextStyle(
                          color: textColors[transaction.type.index],
                          fontSize: 14,
                          fontWeight: FontWeight.bold)),
                  const SizedBox(
                    height: 5,
                  ),
                  Text(transactionTypeToString(transaction.type),
                      style: TextStyle(
                          color: textColors[transaction.type.index],
                          fontSize: 10,
                          fontWeight: FontWeight.bold)),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}

class TileDateView extends StatelessWidget {
  final DateTime date;
  final DateTime today = DateTime.now();
  TileDateView(this.date, {Key? key, required}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      width: 50,
      decoration: getDateString(today) == getDateString(date)
          ? BoxDecoration(
              color: const Color(0x00E0E0E0),
              border: Border.all(width: .5),
              borderRadius: BorderRadius.circular(5))
          : BoxDecoration(
              color: const Color(0xfff0f0f0),
              borderRadius: BorderRadius.circular(5)),
      padding: const EdgeInsets.all(3),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(date.day.toString(),
              style: const TextStyle(
                  color: Colors
                      .amberAccent) /*  GoogleFonts.orbitron(
                  color: Colors.black,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 3) */
              ),
          const SizedBox(
            width: 8,
          ),
          Text(
            DateFormat('MMM').format(date).toUpperCase(),
            style: const TextStyle(
                color: Colors
                    .amberAccent) /* GoogleFonts.orbitron(
              color: Colors.black,
              fontSize: 10,
              fontWeight: FontWeight.bold,
            ) */
            ,
          )
        ],
      ),
    );
  }

  String getDateString(DateTime date) {
    return '${date.day}-${date.month}-${date.year}';
  }
}
