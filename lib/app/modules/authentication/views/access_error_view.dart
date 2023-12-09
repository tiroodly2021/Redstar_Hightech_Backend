import 'package:flutter/material.dart';

import 'package:get/get.dart';

class AccessErrorView extends GetView {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('AccessErrorView'),
        centerTitle: true,
      ),
      body: Center(
        child: Text(
          'Unauthorize Access',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
