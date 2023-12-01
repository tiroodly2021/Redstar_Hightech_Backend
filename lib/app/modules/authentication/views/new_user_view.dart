import 'package:flutter/material.dart';

import 'package:get/get.dart';

class NewUserView extends GetView {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('NewUserView'),
        centerTitle: true,
      ),
      body: Center(
        child: Text(
          'NewUserView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
