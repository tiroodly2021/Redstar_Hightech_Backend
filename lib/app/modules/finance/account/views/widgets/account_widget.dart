import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:confirm_dialog/confirm_dialog.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:redstar_hightech_backend/app/constants/const.dart';
import 'package:redstar_hightech_backend/app/modules/authentication/controllers/authentication_controller.dart';
import 'package:redstar_hightech_backend/app/modules/authentication/controllers/user_controller.dart';
import 'package:redstar_hightech_backend/app/modules/authentication/models/user_model.dart';
import 'package:redstar_hightech_backend/app/modules/finance/account/controllers/account_controller.dart';
import 'package:redstar_hightech_backend/app/modules/finance/account/models/account_model.dart';
import 'package:redstar_hightech_backend/app/modules/finance/account/models/account_type.dart';
import 'package:redstar_hightech_backend/app/modules/finance/transaction/controllers/transaction_controller.dart';
import 'package:redstar_hightech_backend/app/modules/finance/transaction/models/transaction_model.dart';
import 'package:redstar_hightech_backend/app/modules/middleware/auth_middleware.dart';

import 'package:redstar_hightech_backend/app/services/database_service.dart';
import 'package:redstar_hightech_backend/app/modules/finance/transaction/models/transaction_model.dart'
    as financeModel;

import 'package:intl/intl.dart';

enum Options { Edit, Delete }

class AccountCard extends StatelessWidget {
  Account account;
  final int index;
  DatabaseService databaseService = DatabaseService();
  double? totalBalance = 0;

  AccountController accountController;

  AccountCard(
      {Key? key,
      required this.account,
      required this.index,
      required this.accountController,
      this.totalBalance})
      : super(key: key);

  Future<void> _onDeleteData(BuildContext context, Account account) async {
    if (AuthorizationMiddleware.checkPermission(
        Get.find<AuthenticationController>(),
        Get.find<UserController>(),
        "/finance/account/delete")) {
      accountController.deleteAccount(account);
      return print("Check Delete route permission valid");
    }
    {
      Get.snackbar("Delete account", "You don't have permission",
          icon: const Icon(Icons.warning_amber),
          margin: const EdgeInsets.only(left: 10, right: 10, bottom: 20),
          backgroundColor: Colors.red,
          snackPosition: SnackPosition.BOTTOM);
      print(
        "Check Delete route permission not valid",
      );
    }

    //   Navigator.of(context).pop();
  }

  Future<void> _onEdit(Account account) async {
    print(' accountype: ${account.type}');
    accountController.account.value = account;
    accountController.addNameController.text = account.name;
    accountController.addNumberController.text = account.number;
    accountController.addNumberController.text = account.number;
    accountController.accountTypeSelected.value =
        account.type != null ? accountTypeToString(account.type!) : "";

    accountController.imageLink.value = account.photoURL!;

    accountController.toUpdateAccountView(account);
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      shadowColor: Colors.blueGrey,
      elevation: 3,
      margin: const EdgeInsets.only(top: 10),
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 40,
              decoration: const BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                        color: Color.fromARGB(255, 189, 207, 216),
                        offset: Offset(0, 1))
                  ],
                  color: Color.fromARGB(255, 232, 234, 239),
                  /* border: Border.all(
                    width: 10,
                    color:  Color.fromARGB(255, 232, 234, 239),
                  ), */
                  borderRadius: BorderRadius.horizontal(
                      left: const Radius.circular(4),
                      right: const Radius.circular(4))),
              // color: Color.fromARGB(255, 232, 234, 239),
              padding: const EdgeInsets.only(left: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Text(
                        account.name,
                        style: const TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  CircleAvatar(
                    backgroundColor: Colors.transparent,
                    child: PopupMenuButton(
                      icon: const Icon(Icons.more_vert_rounded),
                      shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(8),
                              bottomRight: Radius.circular(8),
                              topLeft: Radius.circular(8),
                              topRight: Radius.circular(8))),
                      offset: const Offset(0.0, 1),
                      itemBuilder: (ctx) => [
                        _buildPopMenuItem(
                            "Edit", Icons.edit, Options.Edit.index),
                        _buildPopMenuItem(
                            "Delete", Icons.remove, Options.Delete.index),
                      ],
                      onSelected: (value) async {
                        int selectedValue = value as int;

                        switch (selectedValue) {
                          case 0:
                            /*  Navigator.pushNamed(context, AppPages.EDIT_USER,
                                arguments: user); */
                            _onEdit(account);
                            break;
                          case 1:
                            if (await confirm(context)) {
                              _onDeleteData(context, account);

                              return print('pressedOK');
                            }

                            return print('pressedCancel');

                          default:
                        }
                      },
                    ),
                  )
                ],
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  children: [
                    account.photoURL == ""
                        ? SizedBox(
                            width: 80,
                            height: 80,
                            child: Container(
                              decoration: const BoxDecoration(
                                image: DecorationImage(
                                  image:
                                      AssetImage("assets/images/no_image.jpg"),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          )
                        : Image.network(account.photoURL!,
                            width: 80, height: 80, fit: BoxFit.cover,
                            errorBuilder: (context, exception, stackTrace) {
                            return Container(
                              width: 80,
                              height: 80,
                              decoration: const BoxDecoration(
                                image: DecorationImage(
                                  image:
                                      AssetImage("assets/images/no_image.jpg"),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            );
                          })
                  ],
                ),
                const SizedBox(
                  width: 10,
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(
                      height: 10,
                    ),
                    Row(
                      children: [
                        const Text("Acc. Number: ",
                            style: TextStyle(fontWeight: FontWeight.bold)),
                        const SizedBox(
                          width: 10,
                        ),
                        Text(
                          account.number,
                          //style: const TextStyle(fontWeight: FontWeight.bold),
                        )
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Row(
                      children: [
                        const Text("Created: ",
                            style: TextStyle(fontWeight: FontWeight.bold)),
                        const SizedBox(
                          width: 10,
                        ),
                        Text(
                          DateFormat.yMMMd()
                              .format(DateTime.parse(account.createdAt)),
                          //style: const TextStyle(fontWeight: FontWeight.bold),
                        )
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Row(
                      children: [
                        const Text("Type : ",
                            style: TextStyle(fontWeight: FontWeight.bold)),
                        const SizedBox(
                          width: 10,
                        ),
                        Text(
                          account.type != null
                              ? accountTypeToString(account.type!)
                              : 'Not defined',
                          //style: const TextStyle(fontWeight: FontWeight.bold),
                        )
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Row(
                      children: [
                        const Text("Balance : ",
                            style: TextStyle(fontWeight: FontWeight.bold)),
                        const SizedBox(
                          width: 10,
                        ),
                        totalBalance! >= 0
                            ? Text(
                                '\$${totalBalance!.toStringAsFixed(2)}',
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.green),
                              )
                            : Text(
                                '-  \$${(-totalBalance!).toStringAsFixed(2)}',
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.red),
                              )
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                  ],
                )
              ],
            ),
            const SizedBox(
              height: 4,
            ),
            Row(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: const [],
                    ),
                    Row(
                      children: const [],
                    )
                  ],
                )
              ],
            )
          ],
        ),
      ),
    );
  }

  PopupMenuItem _buildPopMenuItem(String s, IconData edit, int index) {
    return PopupMenuItem(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text(s),
        ],
      ),
      value: index,
    );
  }
}
