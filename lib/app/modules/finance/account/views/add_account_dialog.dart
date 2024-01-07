import 'package:flutter/material.dart';
import 'package:redstar_hightech_backend/app/modules/finance/account/controllers/account_controller.dart';
import 'package:redstar_hightech_backend/app/modules/finance/account/models/account_model.dart';

import 'package:redstar_hightech_backend/util.dart';

class AddAccountDialog extends StatefulWidget {
  const AddAccountDialog({Key? key, this.account, this.type}) : super(key: key);
  final int? type;
  final Account? account;

  @override
  State<AddAccountDialog> createState() => _AddAccountDialogState();
}

class _AddAccountDialogState extends State<AddAccountDialog> {
  final controllerName = TextEditingController();
  final controllerNumber = TextEditingController();
  IconData? icon;
  final AccountController _accountManager = AccountController();
  bool isEdit = false;

  String? errorText;
  @override
  void initState() {
    isEdit = widget.account != null;
    if (isEdit) {
      controllerName.text = widget.account!.name;
      controllerNumber.text = widget.account!.number;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        '${isEdit ? 'Edit' : 'New '}  account',
        textAlign: TextAlign.center,
      ),
      titleTextStyle: Theme.of(context)
          .textTheme
          .titleMedium!
          .copyWith(fontWeight: FontWeight.bold),
      elevation: 1,
      content: SizedBox(
        height: 130,
        child: SingleChildScrollView(
          child: Column(
            children: [
              TextFormField(
                controller: controllerName,
                onChanged: (name) {
                  if (errorText != null) showError(null);
                },
                autofocus: true,
                maxLength: 15,
                textCapitalization: TextCapitalization.sentences,
                textInputAction: TextInputAction.done,
                onFieldSubmitted: (name) {
                  save();
                },
                decoration: InputDecoration(
                    icon: const Icon(Icons.person_add),
                    hintText: 'account Name',
                    counterText: '',
                    errorText: errorText,
                    contentPadding: const EdgeInsets.symmetric(horizontal: 8)),
              ),
              const SizedBox(
                height: 10,
              ),
              TextFormField(
                controller: controllerNumber,
                onChanged: (name) {
                  if (errorText != null) showError(null);
                },
                autofocus: true,
                maxLength: 15,
                textCapitalization: TextCapitalization.sentences,
                textInputAction: TextInputAction.done,
                onFieldSubmitted: (name) {
                  save();
                },
                decoration: InputDecoration(
                    icon: const Icon(Icons.numbers),
                    hintText: 'account Number',
                    counterText: '',
                    errorText: errorText,
                    contentPadding: const EdgeInsets.symmetric(horizontal: 8)),
              ),
            ],
          ),
        ),
      ),
      actions: [_cancelButton(context), _okButton(context)],
    );
  }

  _okButton(BuildContext context) {
    return TextButton(
        onPressed: () {
          save();
        },
        child: const Text('OK'));
  }

  _cancelButton(BuildContext context) {
    return TextButton(
        onPressed: () {
          Navigator.of(context).pop();
        },
        child: const Text('Cancel'));
  }

  save() {
    final String accountName = controllerName.text;
    final String accountNumber = controllerNumber.text;
    if (accountName.isEmpty) {
      showError("Name can't be empty");
      return;
    }
    if (accountNumber.isEmpty) {
      showError("Number can't be empty");
      return;
    }
    /* if (!isEdit && _accountManager.isAccountExist(catName)) {
      showError('account already exist');
      return;
    } */
    Account account = Account(
        name: accountName,
        number: accountNumber /* widget.account!.number */,
        createdAt: DateTime.now().toIso8601String(),
        balanceCredit: 0,
        balanceDebit: 0,
        photoURL: '');
    if (isEdit) {
      _accountManager.updateAccount(widget.account!.id, account);
    } else {
      _accountManager.addAccount(account);
    }
    Navigator.of(context).pop(account);
  }

  showError(String? string) {
    setState(() {
      errorText = string;
    });
  }

  String _typeString() => widget.type == 0 ? 'Income' : 'Expense';
}
