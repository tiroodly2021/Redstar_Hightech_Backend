import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/order_deliver_pending_controller.dart';

class OrderDeliverPendingView extends GetView<OrderDeliverPendingController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('OrderDeliverPendingView'),
        centerTitle: true,
      ),
      body: Center(
        child: Text(
          'OrderDeliverPendingView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
