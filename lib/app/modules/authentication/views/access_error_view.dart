import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:redstar_hightech_backend/app/modules/authentication/views/login_view.dart';

class AccessErrorView extends GetView {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('UnAutorized Access'),
        backgroundColor: Colors.black,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.error_outline,
            size: 100,
          ),
          Center(
            child: Text(
              'Unauthorize Access',
              style: TextStyle(fontSize: 20),
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Please Login",
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(
                width: 6,
              ),
              InkWell(
                onTap: () => Get.to(() => LoginView()),
                child: Text(
                  "here",
                  style: TextStyle(
                      color: Colors.blue,
                      fontStyle: FontStyle.normal,
                      fontSize: 16),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
