import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:redstar_hightech_backend/app/config/responsive.dart';
import 'package:redstar_hightech_backend/app/constants/app_theme.dart';
import 'package:redstar_hightech_backend/app/modules/authentication/controllers/authentication_controller.dart';
import 'package:redstar_hightech_backend/app/modules/common/navigation_drawer.dart';
import 'package:redstar_hightech_backend/app/modules/finance/account/controllers/account_controller.dart';
import 'package:redstar_hightech_backend/app/modules/finance/account/models/account_model.dart';
import 'package:redstar_hightech_backend/app/modules/finance/account/views/add_account_dialog.dart';
import 'package:redstar_hightech_backend/app/modules/finance/transaction/controllers/transaction_controller.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:redstar_hightech_backend/app/modules/finance/transaction/models/transaction_model.dart';
import 'package:redstar_hightech_backend/app/modules/finance/transaction/models/transaction_type_model.dart';
import 'package:redstar_hightech_backend/app/modules/finance/widgets/circular_button.dart';
import 'package:redstar_hightech_backend/app/modules/finance/widgets/search_transaction.dart';
import 'package:redstar_hightech_backend/app/routes/app_pages.dart';
import 'package:redstar_hightech_backend/app/shared/app_bar_widget.dart';
import 'package:redstar_hightech_backend/app/shared/app_search_delegate.dart';
import 'package:redstar_hightech_backend/app/shared/button_optional_menu.dart';
import 'package:toggle_switch/toggle_switch.dart';

class AddTransactionView extends StatefulWidget {
  final Transaction? transaction;

  const AddTransactionView({this.transaction, Key? key}) : super(key: key);

  @override
  State<AddTransactionView> createState() => _AddTransactionViewState();
}

class _AddTransactionViewState extends State<AddTransactionView> {
  final TransactionController transactionManager =
      Get.find<TransactionController>();
  final _formKey = GlobalKey<FormState>();
  late bool isEdit;
  DateTime date = DateTime.now();
  final accountController = TextEditingController();
  final destinationAccountController = TextEditingController();
  final amountController = TextEditingController();
  final dateController = TextEditingController();
  final descriptionController = TextEditingController();
  final FocusNode _accountFocus = FocusNode();
  final FocusNode _destinationAccountFocus = FocusNode();
  final FocusNode _amountFocus = FocusNode();
  final FocusNode _descriptionFocus = FocusNode();
  final transactionTypes = ['Income', 'Expense', 'Transfert'];
  TransactionType transactionType = TransactionType.expense;

  late Account accountPrimary;
  late Account destinationAccount;

  @override
  void initState() {
    if (widget.transaction != null) {
      final Transaction transaction = widget.transaction!;
      date = transaction.date;
      accountController.text = transaction.account.number;
      amountController.text = transaction.amount.toString();
      descriptionController.text = transaction.description ?? '';
      transactionType = transaction.type;
      accountPrimary = widget.transaction!.account;
    }
    super.initState();
  }

  @override
  void dispose() {
    accountController.dispose();
    amountController.dispose();
    dateController.dispose();
    descriptionController.dispose();
    _amountFocus.dispose();
    _accountFocus.dispose();
    _destinationAccountFocus.dispose();
    transactionManager.isFilterByAccountEnabled.value = false;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    isEdit = widget.transaction != null;
    dateController.text = getFormatedDate(date);
    return Obx(() {
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
          title: 'Add Transaction',
          icon: Icons.search,
          bgColor: Colors.black,
          onPressed: () {
            showSearch(context: context, delegate: TransactionSearchDelegate());
          },
          authenticationController: Get.find<AuthenticationController>(),
          menuActionButton: ButtonOptionalMenu(),
          tooltip: 'Search',
        ),
        body: Form(
          key: _formKey,
          child: Stack(children: [
            ListView(
                padding: const EdgeInsets.fromLTRB(20, 10, 20, 55),
                children: [
                  const SizedBox(height: 10),
                  /*  if (!isEdit) */ _buildToggleSwitch(size),
                  const SizedBox(height: 20),
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
                          controller: dateController,
                          readOnly: true,
                          textInputAction: TextInputAction.next,
                          onTap: () {
                            pickDate();
                          },
                          decoration: const InputDecoration(
                            prefixIcon:
                                Icon(Icons.calendar_month, color: Colors.blue),
                            label: Text('Date'),
                          ),
                        ),
                        TextFormField(
                          controller: accountController,
                          focusNode: _accountFocus,
                          textInputAction: TextInputAction.next,
                          readOnly: isEdit ? true : false,
                          onTap: () {
                            if (!isEdit) {
                              pickAccount(accountController);
                            }
                          },
                          autofocus: !isEdit,
                          validator: (account) =>
                              account != null && account.isEmpty
                                  ? 'Enter  Account'
                                  : null,
                          decoration: const InputDecoration(
                            prefixIcon: Icon(
                              Icons.category,
                              color: Colors.blue,
                            ),
                            label: Text('Account'),
                          ),
                        ),
                        (transactionManager.isTransfertActivated.value)
                            ? TextFormField(
                                controller: destinationAccountController,
                                focusNode: _destinationAccountFocus,
                                textInputAction: TextInputAction.next,
                                readOnly: isEdit ? true : false,
                                onTap: () {
                                  pickAccount(destinationAccountController);
                                },
                                autofocus: !isEdit,
                                validator: (account) =>
                                    account != null && account.isEmpty
                                        ? 'Enter  Destination Account '
                                        : null,
                                decoration: const InputDecoration(
                                  prefixIcon: Icon(
                                    Icons.category,
                                    color: Colors.blue,
                                  ),
                                  label: Text('Destination Account'),
                                ),
                              )
                            : Container(),
                        TextFormField(
                          controller: amountController,
                          focusNode: _amountFocus,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly
                          ],
                          keyboardType: TextInputType.number,
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
                  const SizedBox(height: 5),
                  ElevatedButton(
                      onPressed: () {
                        Get.toNamed(AppPages.FINANCE_ACCOUNT);
                      },
                      style: ElevatedButton.styleFrom(primary: Colors.black),
                      child: const Text("All Accounts"))
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

  _buildToggleSwitch(Size size) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      // mainAxisSize: MainAxisSize.min,
      children: [
        ToggleSwitch(
          minWidth: isEdit ? size.width * .42 : size.width * .28,
          minHeight: 28,
          cornerRadius: 25.0,
          activeBgColors: !isEdit
              ? const [
                  [Colors.white, Color(0xFFEBFFE3)],
                  [Colors.white, Color(0xFFFCE5E5)],
                  [Colors.white, Color.fromARGB(255, 220, 155, 71)]
                ]
              : const [
                  [Colors.white, Color(0xFFEBFFE3)],
                  [Colors.white, Color(0xFFFCE5E5)]
                ],
          activeFgColor: Colors.black,
          inactiveBgColor: AppTheme.lihtGray,
          inactiveFgColor: Colors.black,
          customTextStyles: const [TextStyle(fontWeight: FontWeight.bold)],
          borderColor: const [AppTheme.lihtGray],
          initialLabelIndex: transactionType.index,
          totalSwitches: !isEdit ? 3 : 2,
          labels: transactionTypes,
          radiusStyle: true,
          onToggle: (index) {
            transactionType = index == 0
                ? TransactionType.income
                : (index == 1)
                    ? TransactionType.expense
                    : TransactionType.transfert;
            // accountController.clear();
            if (index == 2) {
              transactionManager.isTransfertActivated.value = true;
            } else {
              transactionManager.isTransfertActivated.value = false;
            }
          },
        ),
      ],
    );
  }

  pickAccount(TextEditingController controller) async {
    /* String? */ Account newAcc = await showModalBottomSheet(
        context: context,
        backgroundColor: Colors.transparent,
        barrierColor: Colors.transparent,
        builder: (context) => AccountSheet());

    controller.text = newAcc != null ? newAcc.number : '';

    if (!transactionManager.isTransfertActivated.value) {
      accountPrimary = newAcc;
    } else {
      destinationAccount = newAcc;
    }

    _fieldFocusChange(_accountFocus, _amountFocus);
  }

  save({required bool close}) {
    final isValid = _formKey.currentState!.validate();
    late Transaction transaction;
    late Transaction tx1;
    late Transaction tx2;

    if (isValid) {
      if (!transactionManager.isTransfertActivated.value) {
        transaction = Transaction(
            title: transactionTypeToString(transactionType),
            date: date,
            account: accountPrimary,
            amount: double.parse(amountController.text),
            type: transactionType,
            description: descriptionController.text);
      } else {
        tx1 = Transaction(
            title: transactionTypeToString(TransactionType.expense),
            date: date,
            account: accountPrimary, //accountController.text,
            amount: double.parse(amountController.text),
            type: TransactionType.expense,
            description: descriptionController.text +
                ' ' +
                accountController.text +
                ' To ' +
                destinationAccountController.text);

        tx2 = Transaction(
            title: transactionTypeToString(TransactionType.income),
            date: date,
            account: destinationAccount, //destinationAccountController.text,
            amount: double.parse(amountController.text),
            type: TransactionType.income,
            description: descriptionController.text +
                ' ' +
                accountController.text +
                ' To ' +
                destinationAccountController.text);
      }

      if (isEdit) {
        transactionManager.updateTransaction(
            widget.transaction!.id!, transaction);
      } else {
        if (!transactionManager.isTransfertActivated.value) {
          transactionManager.addTransaction(transaction);
        } else {
          if (transactionType.index == 2) {
            transactionManager.addTransaction(tx1);
            transactionManager.addTransaction(tx2);
            Get.showSnackbar(const GetSnackBar(
              title: 'Error',
              message: "Destination can't be empty",
              backgroundColor: Colors.red,
            ));
          }
        }
      }
      if (close) {
        Navigator.pop(context);
      } else {
        accountController.clear();
        amountController.clear();
        destinationAccountController.clear();
        descriptionController.clear;
        transactionManager.isTransfertActivated.value = false;
        FocusScope.of(context).requestFocus(_accountFocus);
        FocusScope.of(context).requestFocus(_destinationAccountFocus);
        pickAccount(accountController);
        if (transactionManager.isTransfertActivated.value) {
          pickAccount(destinationAccountController);
        }
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
