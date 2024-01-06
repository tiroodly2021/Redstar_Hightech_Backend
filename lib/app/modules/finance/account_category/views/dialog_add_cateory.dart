import 'package:flutter/material.dart';

import 'package:redstar_hightech_backend/app/modules/finance/account_category/controllers/account_category_controller.dart';
import 'package:redstar_hightech_backend/app/modules/finance/account_category/models/account_category.dart';
import 'package:redstar_hightech_backend/util.dart';

class AddCateoryDialog extends StatefulWidget {
  const AddCateoryDialog({Key? key, this.category, required this.type})
      : super(key: key);
  final int type;
  final AccountCategory? category;

  @override
  State<AddCateoryDialog> createState() => _AddCateoryDialogState();
}

class _AddCateoryDialogState extends State<AddCateoryDialog> {
  final controller = TextEditingController();
  IconData? icon;
  final AccountCategoryController _categoryManager =
      AccountCategoryController();
  bool isEdit = false;

  String? errorText;
  @override
  void initState() {
    isEdit = widget.category != null;
    if (isEdit) {
      controller.text = widget.category!.categoryName;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        '${isEdit ? 'Edit' : 'New ${_typeString()}'}  Category',
        textAlign: TextAlign.center,
      ),
      titleTextStyle: Theme.of(context)
          .textTheme
          .titleMedium!
          .copyWith(fontWeight: FontWeight.bold),
      elevation: 1,
      content: TextFormField(
        controller: controller,
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
            icon: Util.getCatIcon(widget.type),
            hintText: 'Category Name',
            counterText: '',
            errorText: errorText,
            contentPadding: const EdgeInsets.symmetric(horizontal: 8)),
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
    final String catName = controller.text;
    if (catName.isEmpty) {
      showError("Name can't be empty");
      return;
    }
    /* if (!isEdit && _categoryManager.isCateoryExist(catName)) {
      showError('Category already exist');
      return;
    } */
    AccountCategory category =
        AccountCategory(categoryName: catName, type: widget.type);
    if (isEdit) {
      _categoryManager.updateCategory(widget.category!.key, category);
    } else {
      _categoryManager.addCategory(category);
    }
    Navigator.of(context).pop(category);
  }

  showError(String? string) {
    setState(() {
      errorText = string;
    });
  }

  String _typeString() => widget.type == 0 ? 'Income' : 'Expense';
}
