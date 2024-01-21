import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:redstar_hightech_backend/app/config/responsive.dart';
import 'package:redstar_hightech_backend/app/constants/app_theme.dart';
import 'package:redstar_hightech_backend/app/modules/authentication/controllers/authentication_controller.dart';
import 'package:redstar_hightech_backend/app/modules/common/navigation_drawer.dart';
import 'package:redstar_hightech_backend/app/modules/finance/account/controllers/account_controller.dart';
import 'package:redstar_hightech_backend/app/modules/finance/account/models/account_model.dart';
import 'package:redstar_hightech_backend/app/modules/finance/account/models/account_type.dart';
import 'package:redstar_hightech_backend/app/modules/finance/account/views/add_account_dialog.dart';
import 'package:redstar_hightech_backend/app/modules/finance/transaction/controllers/personalized_transaction_controller.dart';
import 'package:redstar_hightech_backend/app/modules/finance/transaction/controllers/transaction_controller.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:redstar_hightech_backend/app/modules/finance/transaction/models/transaction_model.dart';
import 'package:redstar_hightech_backend/app/modules/finance/transaction/models/transaction_type_model.dart';
import 'package:redstar_hightech_backend/app/modules/finance/widgets/circular_button.dart';
import 'package:redstar_hightech_backend/app/modules/finance/widgets/floating_circle_menu.dart';
import 'package:redstar_hightech_backend/app/modules/finance/widgets/search_transaction.dart';
import 'package:redstar_hightech_backend/app/routes/app_pages.dart';
import 'package:redstar_hightech_backend/app/shared/app_bar_widget.dart';
import 'package:redstar_hightech_backend/app/shared/app_search_delegate.dart';
import 'package:redstar_hightech_backend/app/shared/button_optional_menu.dart';
import 'package:toggle_switch/toggle_switch.dart';
import 'dart:math' as math;

class PersonalizedTransactionView extends StatefulWidget {
  final Transaction? transaction;

  const PersonalizedTransactionView({this.transaction, Key? key})
      : super(key: key);

  @override
  State<PersonalizedTransactionView> createState() =>
      _PersonalizedTransactionViewViewState();
}

class _PersonalizedTransactionViewViewState
    extends State<PersonalizedTransactionView> {
  final TransactionController transactionController =
      Get.put(TransactionController());

  final _formKey = GlobalKey<FormState>();
  late bool isEdit;
  DateTime date = DateTime.now();

  final amountController = TextEditingController();
  final dateController = TextEditingController();

  final descriptionController = TextEditingController();
  final FocusNode _accountFocus = FocusNode();

  final FocusNode _amountFocus = FocusNode();
  final FocusNode _descriptionFocus = FocusNode();

  /*  Account accountMobileAgent = Account(number: '', createdAt: '', name: '');
  late Account accountLotoAgent;
  late Account accountCashMoney;
 */
  final transactionMobileAgent = ['Retrait', 'Depot', 'Transfert'];

  final transactionLotoAgent = ['Depot', 'Loto Sell'];

  final transactionCashMoney = ["Entre Cash", "Sortie Cash"];

  final transactionSellType = ['MONCASH', 'LOTTO', 'CASH'];

  TransactionType transactionType = TransactionType.expense;
  AccountController accountManager = Get.put(AccountController());

  @override
  void initState() {
    if (widget.transaction != null) {
      final Transaction transaction = widget.transaction!;
      date = transaction.date;
      amountController.text = transaction.amount.toString();
      descriptionController.text = transaction.description ?? '';
      transactionType = transaction.type;
    }

    super.initState();
  }

  @override
  void dispose() {
    amountController.dispose();
    dateController.dispose();
    descriptionController.dispose();
    _amountFocus.dispose();
    _accountFocus.dispose();

    //transactionController.operationType.value = -1;

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    isEdit = widget.transaction != null;
    dateController.text = getFormatedDate(date);

    return Obx(() {
      /*   accountManager.accounts.forEach((element) {
        if (element.type == AccountType.mobileAgent) {
          accountMobileAgent = element;
        }
      });

      print(accountMobileAgent.toMap()); */
      /*print(accountCashMoney.toMap()); */

      return Scaffold(
        backgroundColor: const Color(0xFFF3f3f3),
        /*  appBar: AppBar(
            title: Text(isEdit
                ? transactionTypes[transactionType.index]
                : 'Add Transaction'),
            centerTitle: true,
          ) ,*/
        drawer:
            !Responsive.isDesktop(context) ? NavigationDrawer() : Container(),
        appBar: /*  !Responsive.isDesktop(context)
              ?  */
            AppBarWidget(
          title: 'Make a sell',
          icon: Icons.search,
          bgColor: Colors.black,
          onPressed: () {
            showSearch(context: context, delegate: TransactionSearchDelegate());
          },
          authenticationController: Get.find<AuthenticationController>(),
          menuActionButton: ButtonOptionalMenu(),
          tooltip: 'Search',
        ),
        floatingActionButton: FloatingCircleMenu(),
        body: Form(
          key: _formKey,
          child: Stack(children: [
            ListView(
                padding: const EdgeInsets.fromLTRB(20, 10, 20, 55),
                children: [
                  const SizedBox(height: 10),
                  if (transactionController.operationType.value == 0)
                    _buildToggleSwitchMobileAgent(size, 3),
                  if (transactionController.operationType.value == 1)
                    _buildToggleSwitchLotoAgent(size, 2),
                  if (transactionController.operationType.value == 2)
                    _buildToggleSwitchCashMoney(size, 2),
                  const SizedBox(height: 20),
                  /*     Row(
                    children: [
                      Text(accountManager.accountMobileAgent.value.name),
                      SizedBox(
                        width: 10,
                      ),
                      Text(accountManager.accountLotoAgent.value.name),
                      SizedBox(
                        width: 10,
                      ),
                      Text(accountManager.accountCashMoney.value.name),
                      SizedBox(
                        width: 10,
                      ),
                    ],
                  ), */
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(boxShadow: const [
                      BoxShadow(color: Colors.black),
                      BoxShadow(
                        color: Colors.white,
                        spreadRadius: 0,
                        blurRadius: 4,
                      ),
                    ], borderRadius: BorderRadius.circular(10)),
                    child: Column(
                      children: [
                        TextFormField(
                          controller: amountController,
                          focusNode: _amountFocus,
                          inputFormatters: [
                            DecimalTextInputFormatter(decimalRange: 2)
                          ],
                          keyboardType: const TextInputType.numberWithOptions(
                              decimal: true),
                          textInputAction: TextInputAction.next,
                          onFieldSubmitted: (term) {
                            _fieldFocusChange(_amountFocus, _descriptionFocus);
                          },
                          validator: (amount) =>
                              amount != null && double.tryParse(amount) == null
                                  ? 'Enter Amount'
                                  : null,
                          decoration: const InputDecoration(
                              prefixIcon: Icon(
                                Icons.currency_rupee,
                                color: Colors.blue,
                              ),
                              label: Text('Amount'),
                              hintText: ' 0'),
                        ),
                        TextFormField(
                          controller: descriptionController,
                          focusNode: _descriptionFocus,
                          textCapitalization: TextCapitalization.sentences,
                          maxLength: 30,
                          decoration: const InputDecoration(
                              prefixIcon: Icon(
                                Icons.edit_note,
                                color: Colors.blue,
                              ),
                              label: Text('Note'),
                              counterText: ''),
                        )
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  _buildToggleSwitchSellType(size, 3)
                ]),
            Positioned(
              bottom: 0,
              child: Container(
                width: size.width,
                color: Colors.white,
                child: Column(
                  children: [
                    const Divider(thickness: 1.5, height: 1.5),
                    Row(
                      children: [
                        Visibility(
                          visible: !isEdit,
                          child: SizedBox(
                            height: 40,
                            child: TextButton(
                              autofocus: false,
                              onPressed: () {
                                save(close: false);
                              },
                              style: TextButton.styleFrom(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 25)),
                              child: const Text('SAVE & ADD ANOTHER'),
                            ),
                          ),
                        ),
                        const Spacer(),
                        SizedBox(
                          height: 40,
                          child: TextButton(
                            onPressed: () {
                              save(close: true);
                            },
                            style: TextButton.styleFrom(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 25)),
                            child: const Text('SAVE'),
                          ),
                        )
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ]),
        ),
      );
    });
  }

  _buildToggleSwitchSellType(Size size, int itemCount) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      // mainAxisSize: MainAxisSize.min,
      children: [
        ToggleSwitch(
          minWidth: isEdit ? size.width * .42 : size.width * .28,
          minHeight: 28,
          cornerRadius: 25.0,
          activeBgColors: const [
            [Colors.white, Color(0xFFEBFFE3)],
            [Colors.white, Color(0xFFEBFFE3)],
            [Colors.white, Color(0xFFEBFFE3)],
          ],
          activeFgColor: Colors.black,
          inactiveBgColor: AppTheme.lihtGray,
          inactiveFgColor: Colors.black,
          customTextStyles: const [TextStyle(fontWeight: FontWeight.bold)],
          borderColor: const [AppTheme.lihtGray],
          initialLabelIndex: transactionController.operationType.value,
          totalSwitches: itemCount,
          labels: transactionSellType,
          radiusStyle: true,
          onToggle: (index) {
            if (index != null) {
              transactionController.operationType.value = index;
            }
          },
        ),
      ],
    );
  }

  _buildToggleSwitchMobileAgent(Size size, int itemCount) {
    descriptionController.text = myTransactionTypeToString(
        transactionController.transactionTypeMobileAgent.value);
    return Column(
      children: [
        const SizedBox(
          height: 20,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Text("MONCASH TRANSACTION",
                style: TextStyle(fontSize: 22, color: Colors.red))
          ],
        ),
        const SizedBox(
          height: 20,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          // mainAxisSize: MainAxisSize.min,
          children: [
            ToggleSwitch(
              minWidth: isEdit ? size.width * .42 : size.width * .28,
              minHeight: 28,
              cornerRadius: 25.0,
              activeBgColors: const [
                [Colors.white, Color(0xFFEBFFE3)],
                [Colors.white, Color(0xFFFCE5E5)],
                [Colors.white, Color.fromARGB(255, 220, 155, 71)]
              ],
              activeFgColor: Colors.black,
              inactiveBgColor: AppTheme.lihtGray,
              inactiveFgColor: Colors.black,
              customTextStyles: const [TextStyle(fontWeight: FontWeight.bold)],
              borderColor: const [AppTheme.lihtGray],
              initialLabelIndex:
                  transactionController.transactionTypeMobileAgent.value,
              totalSwitches: itemCount,
              labels: transactionMobileAgent,
              radiusStyle: true,
              onToggle: (index) {
                transactionController.transactionTypeMobileAgent.value = index!;
                descriptionController.text = myTransactionTypeToString(
                    transactionController.transactionTypeMobileAgent.value);
              },
            ),
          ],
        ),
      ],
    );
  }

  _buildToggleSwitchLotoAgent(Size size, int itemCount) {
    descriptionController.text = myTransactionTypeToString(
        transactionController.transactionTypeLotoAgent.value);
    return Column(
      children: [
        const SizedBox(
          height: 20,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Text("LOTO TRANSACTION",
                style: TextStyle(fontSize: 22, color: Colors.red))
          ],
        ),
        const SizedBox(
          height: 20,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          // mainAxisSize: MainAxisSize.min,
          children: [
            ToggleSwitch(
              minWidth: isEdit ? size.width * .42 : size.width * .28,
              minHeight: 28,
              cornerRadius: 25.0,
              activeBgColors: const [
                [Colors.white, Color(0xFFEBFFE3)],
                [Colors.white, Color(0xFFFCE5E5)]
              ],
              activeFgColor: Colors.black,
              inactiveBgColor: AppTheme.lihtGray,
              inactiveFgColor: Colors.black,
              customTextStyles: const [TextStyle(fontWeight: FontWeight.bold)],
              borderColor: const [AppTheme.lihtGray],
              initialLabelIndex:
                  transactionController.transactionTypeLotoAgent.value,
              totalSwitches: itemCount,
              labels: transactionLotoAgent,
              radiusStyle: true,
              onToggle: (index) {
                transactionController.transactionTypeLotoAgent.value = index!;
                descriptionController.text = myTransactionTypeToString(
                    transactionController.transactionTypeLotoAgent.value);
              },
            ),
          ],
        ),
      ],
    );
  }

  _buildToggleSwitchCashMoney(Size size, int itemCount) {
    descriptionController.text = myTransactionTypeToString(
        transactionController.transactionTypeCashMoney.value);
    return Column(
      children: [
        const SizedBox(
          height: 20,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Text("CASH TRANSACTION",
                style: TextStyle(fontSize: 22, color: Colors.red))
          ],
        ),
        const SizedBox(
          height: 20,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          // mainAxisSize: MainAxisSize.min,
          children: [
            ToggleSwitch(
              minWidth: isEdit ? size.width * .42 : size.width * .28,
              minHeight: 28,
              cornerRadius: 25.0,
              activeBgColors: const [
                [Colors.white, Color(0xFFEBFFE3)],
                [Colors.white, Color(0xFFFCE5E5)]
              ],
              activeFgColor: Colors.black,
              inactiveBgColor: AppTheme.lihtGray,
              inactiveFgColor: Colors.black,
              customTextStyles: const [TextStyle(fontWeight: FontWeight.bold)],
              borderColor: const [AppTheme.lihtGray],
              initialLabelIndex:
                  transactionController.transactionTypeCashMoney.value,
              totalSwitches: itemCount,
              labels: transactionCashMoney,
              radiusStyle: true,
              onToggle: (index) {
                transactionController.transactionTypeCashMoney.value = index!;
                descriptionController.text = myTransactionTypeToString(
                    transactionController.transactionTypeCashMoney.value);
              },
            ),
          ],
        ),
      ],
    );
  }

  String myTransactionTypeToString(int i) {
    String out = '';
    if (i == 0) {
      out = "Entree";
    }
    if (i == 1) {
      out = "Sortie";
    }

    if (i == 2) {
      out = "Transfert";
    }

    return out;
  }

  save({required bool close}) {
    final isValid = _formKey.currentState!.validate();
    late Transaction transaction;
    late Transaction tx1;
    late Transaction tx2;

    if (isValid) {
      //MONCASH MANAGEMENT
      if (transactionController.operationType.value == 0) {
        print("moncash transction...");
        if (transactionController.transactionTypeMobileAgent.value == 0) {
          // print("retrait...");

          tx1 = Transaction(
              title: transactionTypeToString(TransactionType.expense),
              date: date,
              account: accountManager
                  .accountCashMoney.value, //accountController.text,
              amount: double.parse(amountController.text),
              type: TransactionType.expense,
              description: 'Sortie pour retrait moncash');

          tx2 = Transaction(
              title: transactionTypeToString(TransactionType.income),
              date: date,
              account: accountManager.accountMobileAgent
                  .value, //destinationAccountController.text,
              amount: double.parse(amountController.text),
              type: TransactionType.income,
              description: 'Rentree pour retrait moncash');

          transactionController.addTransaction(tx1);
          transactionController.addTransaction(tx2);
        }

        if (transactionController.transactionTypeMobileAgent.value == 1) {
          print("depot...");
          tx1 = Transaction(
              title: transactionTypeToString(TransactionType.expense),
              date: date,
              account: accountManager
                  .accountMobileAgent.value, //accountController.text,
              amount: double.parse(amountController.text),
              type: TransactionType.expense,
              description: 'Sortie pour depot moncash');

          tx2 = Transaction(
              title: transactionTypeToString(TransactionType.income),
              date: date,
              account: accountManager
                  .accountCashMoney.value, //destinationAccountController.text,
              amount: double.parse(amountController.text),
              type: TransactionType.income,
              description: 'Rentree pour depot moncash');

          transactionController.addTransaction(tx1);
          transactionController.addTransaction(tx2);
        }

        if (transactionController.transactionTypeMobileAgent.value == 2) {
          print("transfert...");
          tx1 = Transaction(
              title: transactionTypeToString(TransactionType.expense),
              date: date,
              account: accountManager
                  .accountMobileAgent.value, //accountController.text,
              amount: double.parse(amountController.text),
              type: TransactionType.expense,
              description: 'Sortie pour transfert moncash');

          tx2 = Transaction(
              title: transactionTypeToString(TransactionType.income),
              date: date,
              account: accountManager
                  .accountCashMoney.value, //destinationAccountController.text,
              amount: double.parse(amountController.text),
              type: TransactionType.income,
              description: 'Rentree pour transfert moncash');

          transactionController.addTransaction(tx1);
          transactionController.addTransaction(tx2);
        }
      }
      // LOTO MANAGEMENT
      if (transactionController.operationType.value == 1) {
        print("loto transction...");

        if (transactionController.transactionTypeLotoAgent.value == 0) {
          print("ajouter credit...");

          tx1 = Transaction(
              title: transactionTypeToString(TransactionType.income),
              date: date,
              account: accountManager
                  .accountLotoAgent.value, //accountController.text,
              amount: double.parse(amountController.text),
              type: TransactionType.income,
              description: 'Rentree Credit Loto');

          transactionController.addTransaction(tx1);
        }

        if (transactionController.transactionTypeLotoAgent.value == 1) {
          print("vente...");

          tx1 = Transaction(
              title: transactionTypeToString(TransactionType.expense),
              date: date,
              account: accountManager
                  .accountLotoAgent.value, //accountController.text,
              amount: double.parse(amountController.text),
              type: TransactionType.expense,
              description: 'Vente Loto');

          tx2 = Transaction(
              title: transactionTypeToString(TransactionType.income),
              date: date,
              account: accountManager
                  .accountCashMoney.value, //accountController.text,
              amount: double.parse(amountController.text),
              type: TransactionType.income,
              description: 'Rentree CASH Vente Loto');

          transactionController.addTransaction(tx1);
          transactionController.addTransaction(tx2);
        }
      }

      //CASH MANAGEMENT

      if (transactionController.operationType.value == 2) {
        print("cash transction...");
        if (transactionController.transactionTypeCashMoney == 0) {
          print("Entree...");
          tx1 = Transaction(
              title: transactionTypeToString(TransactionType.income),
              date: date,
              account: accountManager
                  .accountCashMoney.value, //accountController.text,
              amount: double.parse(amountController.text),
              type: TransactionType.income,
              description: 'Rentre Cash');
          transactionController.addTransaction(tx1);
        }

        if (transactionController.transactionTypeCashMoney.value == 1) {
          print("Sortie...");
          tx1 = Transaction(
              title: transactionTypeToString(TransactionType.expense),
              date: date,
              account: accountManager
                  .accountCashMoney.value, //accountController.text,
              amount: double.parse(amountController.text),
              type: TransactionType.expense,
              description: 'Sortie Cash');

          transactionController.addTransaction(tx1);
        }
      }

      if (close) {
        Navigator.pop(context);
      } else {
        amountController.clear();
        descriptionController.clear;

        transactionController.operationType.value = 0;
        transactionController.transactionTypeMobileAgent.value = 0;
        transactionController.transactionTypeLotoAgent.value = 0;
        transactionController.transactionTypeCashMoney.value = 0;

        FocusScope.of(context).requestFocus(_amountFocus);
        FocusScope.of(context).requestFocus(_descriptionFocus);
      }
    }
  }

  _fieldFocusChange(FocusNode currentFocus, FocusNode nextFocus) {
    currentFocus.unfocus();
    FocusScope.of(context).requestFocus(nextFocus);
  }

  Future pickDate() async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: date,
        firstDate: DateTime(2000),
        lastDate: DateTime(2100));
    if (picked != null && picked != date) {
      date = picked;
      dateController.text = getFormatedDate(date);
    }
  }

  String getFormatedDate(DateTime dateTime) =>
      DateTime.now().year == dateTime.year
          ? DateFormat('d MMM, E').format(date)
          : DateFormat('d MMM y, E').format(date);

  @override
  List<Object?> get props => [
        transactionController,
        _formKey,
        isEdit,
        date,
        amountController,
        dateController,
        descriptionController,
        _accountFocus,
        _amountFocus,
        _descriptionFocus,
        transactionMobileAgent,
        transactionLotoAgent,
        transactionCashMoney,
        transactionSellType,
        transactionType
      ];
}

class AccountSheet extends StatefulWidget {
  const AccountSheet({
    Key? key,
  }) : super(key: key);

  @override
  State<AccountSheet> createState() => _AccountSheetState();
}

class _AccountSheetState extends State<AccountSheet> {
  final accountObjController = Get.put(AccountController());

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: MediaQuery.of(context).size.height * .45,
      decoration: const BoxDecoration(
          color: Colors.white,
          border: Border(top: BorderSide(color: Color(0xFF777777), width: .5)),
          boxShadow: [
            BoxShadow(),
          ]),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Text(
                  'Accounts',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),
                const Spacer(),
                CircularButton(
                  icon: Icons.add,
                  size: 30,
                  onPressed: () {
                    showDialog(
                            context: context,
                            builder: (context) => const AddAccountDialog())
                        .whenComplete(() {
                      setState(() {});
                    });
                  },
                )
              ],
            ),
          ),
          Expanded(child: GetBuilder<AccountController>(builder: (controller) {
            //ist<Account> accounts = AccountController().getActiveAccounts();

            // List<Account> accounts = accountsData;
            return Obx(() {
              List<Account> accounts = accountObjController.accounts;

              return GridView.builder(
                  gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                    maxCrossAxisExtent: 200,
                    childAspectRatio: 8 / 1.75,
                  ),
                  itemCount: accounts.length,
                  itemBuilder: (ctx, index) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Container(
                        margin: const EdgeInsets.only(left: 8.0),
                        decoration: BoxDecoration(
                            color: const Color.fromARGB(255, 245, 245, 245),
                            border: Border.all(color: Colors.grey, width: .25)),
                        child: InkWell(
                          onTap: () {
                            Navigator.of(context).pop(accounts[index]);
                          },
                          child: Center(
                            child: Column(
                              children: [
                                Text(
                                  accounts[index].name,
                                ),
                                const SizedBox(
                                  height: 1,
                                ),
                                Text(
                                  accounts[index].number,
                                  style: TextStyle(
                                      fontSize: 10,
                                      color: Colors.green.shade900,
                                      fontWeight: FontWeight.bold),
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  });
            });
          }))
        ],
      ),
    );
  }

  @override
  List<Object?> get props => [accountObjController];
}

class DecimalTextInputFormatter extends TextInputFormatter {
  DecimalTextInputFormatter({required this.decimalRange})
      : assert(decimalRange == null || decimalRange > 0);

  final int decimalRange;

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue, // unused.
    TextEditingValue newValue,
  ) {
    TextSelection newSelection = newValue.selection;
    String truncated = newValue.text;

    if (decimalRange != null) {
      String value = newValue.text;

      if (value.contains(".") &&
          value.substring(value.indexOf(".") + 1).length > decimalRange) {
        truncated = oldValue.text;
        newSelection = oldValue.selection;
      } else if (value == ".") {
        truncated = "0.";

        newSelection = newValue.selection.copyWith(
          baseOffset: math.min(truncated.length, truncated.length + 1),
          extentOffset: math.min(truncated.length, truncated.length + 1),
        );
      }

      return TextEditingValue(
        text: truncated,
        selection: newSelection,
        composing: TextRange.empty,
      );
    }
    return newValue;
  }
}
