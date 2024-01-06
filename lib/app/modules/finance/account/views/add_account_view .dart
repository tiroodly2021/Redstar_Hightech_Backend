import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/account_controller.dart';

class AddAccountView extends GetView<AccountController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Account'),
        centerTitle: true,
      ),
      body: Center(
        child: Text(
          'AccountView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
