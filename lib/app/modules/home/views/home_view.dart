import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:redstar_hightech_backend/app/routes/app_pages.dart';

import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Redstar Management'),
        centerTitle: true,
        backgroundColor: Colors.black,
      ),
      body: SizedBox(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: double.infinity,
              height: 150,
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: InkWell(
                onTap: () {
                  Get.toNamed(AppPages.PRODUCT);
                },
                child: const Card(
                  child: Center(child: Text("Go to Products")),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
