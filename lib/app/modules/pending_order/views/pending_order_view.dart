import 'dart:io';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:get/get.dart';
import 'package:redstar_hightech_backend/app/modules/product/controllers/product_controller.dart';
import 'package:redstar_hightech_backend/app/routes/app_pages.dart';
import 'package:redstar_hightech_backend/app/services/database_service.dart';
import 'package:redstar_hightech_backend/app/shared/list_not_found.sharedWidgets.dart';

import '../../order/controllers/order_controller.dart';
import '../../order/models/order_model.dart';
import '../../product/models/product_model.dart';
import '../controllers/pending_order_controller.dart';

class PendingOrderView extends GetView<PendingOrderController> {
  DatabaseService database = DatabaseService();
  ProductController productController = Get.find<ProductController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pending Orders'),
        centerTitle: true,
        backgroundColor: Colors.black,
      ),
      body: Column(
        children: [
          Expanded(
            child: Obx(() {
              if (controller.pendingOrders.isNotEmpty) {
                return ListView.builder(
                    itemCount: controller.pendingOrders.length,
                    itemBuilder: (BuildContext context, index) {
                      var products = productController.products
                          .where((product) => controller
                              .pendingOrders[index].productIds
                              .contains(product.id))
                          .toList();

                      return OrderCard(
                          order: controller.pendingOrders[index],
                          products: products);
                    });
              } else if (controller.pendingOrders.isEmpty) {
                /* return const Center(
                  child: CircularProgressIndicator(),
                ); */

                return ListNotFound(
                    route: AppPages.INITIAL,
                    message: "There's no pending orders",
                    info: "Go Back",
                    imageUrl: "assets/images/empty.png");
              }
              return const Center(
                child: CircularProgressIndicator(),
              );
            }),
          )
        ],
      ),
    );
  }
}

class OrderCard extends StatelessWidget {
  OrderCard({Key? key, required this.order, required this.products})
      : super(key: key);

  Order order;
  PendingOrderController pendingOrderController =
      Get.find<PendingOrderController>();
  List<Product> products;

  @override
  Widget build(BuildContext context) {
    // var products = Product.products;
    //  .where((product) => order.productIds.contains(product.id))
    // .toList();

    //   var products = productController.products;
    // .where((product) => order.productIds.contains(product.id))
    // .toList();

    print(products);

    return Card(
      margin: const EdgeInsets.all(10),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            ColoredBox(
              color: Colors.black12,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "Created At: ",
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      DateFormat("yyyy-mm-dd").format(order.createdAt),
                      style: const TextStyle(
                          fontSize: 16, fontWeight: FontWeight.bold),
                    )
                  ],
                ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            const SizedBox(
              height: 10,
            ),
            ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: products.length,
                itemBuilder: ((context, index) {
                  return Padding(
                    padding: const EdgeInsets.all(6.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: 50,
                          width: 50,
                          child: (products[index].imageUrl == null ||
                                  products[index].imageUrl == "")
                              ? SizedBox(
                                  width: 50,
                                  height: 50,
                                  child: Container(
                                    decoration: const BoxDecoration(
                                      image: DecorationImage(
                                        image: AssetImage(
                                            "assets/images/add_image.png"),
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                )

                              /* CircleAvatar(
                  
                    backgroundImage: FileImage(File(category.imageUrl)),
                    radius: 10,
                    backgroundColor: Colors.white,
                  )  */ /* Image.network(
                    category.imageUrl,
                    width: MediaQuery.of(context).size.width,
                    height: 150,
                    fit: BoxFit.cover,
                  ) */
                              : /* SizedBox(
                                  width: 50,
                                  height: 50,
                                  child: Container(
                                    decoration: BoxDecoration(
                                      image: DecorationImage(
                                        image: FileImage(
                                            File(products[index].imageUrl)),
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                ) */
                              Image.network(
                                  products[index].imageUrl,
                                  width: 50,
                                  height: 50,
                                  fit: BoxFit.cover,
                                ),

                          /* Image.network(products[index].imageUrl,
                                fit: BoxFit.cover) */
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              products[index].name,
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            SizedBox(
                                width: 275,
                                child: Text(
                                  products[index].description,
                                  style: const TextStyle(fontSize: 14),
                                  overflow: TextOverflow.clip,
                                  maxLines: 2,
                                ))
                          ],
                        )
                      ],
                    ),
                  );
                })),
            const SizedBox(
              height: 10,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    children: [
                      const Text(
                        "Deliver Fee",
                        style: TextStyle(
                            fontSize: 12, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Text(
                        order.deliveryFee.toStringAsFixed(2),
                        style: const TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      const Text(
                        "Total",
                        style: TextStyle(
                            fontSize: 12, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Text(
                        order.total.toStringAsFixed(2),
                        style: const TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    ],
                  )
                ],
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                /*  order.isAccepted
                    ? ElevatedButton(
                        onPressed: () {
                          pendingOrderController.updatePendingOrder(
                              order, 'isDelivered', !order.isDelivered);
                        },
                        style: ElevatedButton.styleFrom(
                            primary: Colors.black,
                            minimumSize: const Size(150, 40)),
                        child: const Text(
                          "Deliver",
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        ))
                    : */
                ElevatedButton(
                    onPressed: () {
                      pendingOrderController.updatePendingOrder(
                          order, 'isAccepted', true);
                      pendingOrderController.updatePendingOrder(
                          order, 'isDelivered', true);
                    },
                    style: ElevatedButton.styleFrom(
                        primary: Colors.black,
                        minimumSize: const Size(150, 40)),
                    child: const Text(
                      "Accept & Deliver",
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    )),
                ElevatedButton(
                    onPressed: () {
                      pendingOrderController.updatePendingOrder(
                          order, 'isCancelled', true);
                    },
                    style: ElevatedButton.styleFrom(
                        primary: Colors.black,
                        minimumSize: const Size(150, 40)),
                    child: const Text(
                      "Cancel",
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    )),
              ],
            )
          ],
        ),
      ),
    );
  }
}
