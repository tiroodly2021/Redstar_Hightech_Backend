import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:redstar_hightech_backend/app/modules/product/models/product_model.dart';
import 'package:redstar_hightech_backend/app/routes/app_pages.dart';

import '../controllers/product_controller.dart';
import '../widgets/product_widget.dart';

class ProductView extends GetView<ProductController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Products'),
          centerTitle: true,
          backgroundColor: Colors.black,
        ),
        body: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            children: [
              SizedBox(
                height: 100,
                child: InkWell(
                  onTap: () {
                    Get.toNamed(AppPages.NEW_PRODUCT);
                  },
                  child: Card(
                    color: Colors.black,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        IconButton(
                            onPressed: () {
                              print("Hello");
                              Get.toNamed(AppPages.NEW_PRODUCT);
                            },
                            icon: const Icon(
                              Icons.add,
                              color: Colors.white,
                            )),
                        const Text(
                          "Add New Product",
                          style: TextStyle(fontSize: 22, color: Colors.white),
                        )
                      ],
                    ),
                  ),
                ),
              ),
              Expanded(
                child: ListView.builder(
                    itemCount: controller.products.length,
                    itemBuilder: ((context, index) {
                      return Obx(() {
                        return SizedBox(
                          height: 210,
                          child: ProductCard(
                            product: controller.products[index],
                            index: index,
                          ),
                        );
                      });
                    })),
              )
            ],
          ),
        ));
  }
}
