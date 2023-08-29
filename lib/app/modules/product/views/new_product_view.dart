import 'package:flutter/material.dart';

import 'package:get/get.dart';

class NewProductView extends GetView {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('NewProductView'),
        centerTitle: true,
        backgroundColor: Colors.black,
      ),
      body: const Center(
        child: Text(
          'NewProductView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
