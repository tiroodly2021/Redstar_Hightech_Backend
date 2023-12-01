import 'package:flutter/material.dart';

import 'package:get/get.dart';

class EditUserView extends GetView {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('EditUserView'),
        centerTitle: true,
      ),
      body: Center(
        child: Text(
          'EditUserView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
