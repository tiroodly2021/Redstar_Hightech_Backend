import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:redstar_hightech_backend/app/modules/authentication/views/login_view.dart';

class AccessErrorView extends GetView {
  AccessErrorView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String route = ModalRoute.of(context)?.settings.arguments as String;
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
              'Unauthorize Access To',
              style: TextStyle(fontSize: 20),
            ),
          ),
          SizedBox(
            height: 20,
          ),
          route != null
              ? Text(
                  route,
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                )
              : Container(),
          SizedBox(
            height: 10,
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
