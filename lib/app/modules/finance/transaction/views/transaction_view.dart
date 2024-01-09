import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

import 'package:get/get.dart';
import 'package:redstar_hightech_backend/app/config/responsive.dart';
import 'package:redstar_hightech_backend/app/modules/authentication/controllers/authentication_controller.dart';
import 'package:redstar_hightech_backend/app/modules/common/navigation_drawer.dart';
import 'package:redstar_hightech_backend/app/modules/finance/account/models/account_model.dart';
import 'package:redstar_hightech_backend/app/modules/finance/transaction/models/transaction_model.dart';

import 'package:redstar_hightech_backend/app/modules/finance/transaction/views/add_transaction_view.dart';
import 'package:redstar_hightech_backend/app/modules/finance/widgets/empty_view.dart';
import 'package:redstar_hightech_backend/app/modules/finance/widgets/tile_transaction.dart';
import 'package:redstar_hightech_backend/app/routes/app_pages.dart';
import 'package:redstar_hightech_backend/app/shared/app_bar_widget.dart';
import 'package:redstar_hightech_backend/app/shared/app_search_delegate.dart';
import 'package:redstar_hightech_backend/app/shared/button_optional_menu.dart';

import '../controllers/transaction_controller.dart';

class TransactionView extends StatefulWidget {
  Account? account;
  TransactionView({Key? key, this.account}) : super(key: key);

  @override
  State<TransactionView> createState() => _TransactionViewState();
}

class _TransactionViewState extends State<TransactionView>
    with SingleTickerProviderStateMixin {
  final TransactionController transactionController = Get.find();
  final scrollController = ScrollController();
  bool showFAB = true;

  @override
  void initState() {
    scrollController.addListener(() {
      if (scrollController.position.userScrollDirection ==
              ScrollDirection.reverse &&
          showFAB) {
        setState(() {
          showFAB = false;
        });
      } else if (scrollController.position.userScrollDirection ==
              ScrollDirection.forward &&
          !showFAB) {
        setState(() {
          showFAB = true;
        });
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    widget.account = ModalRoute.of(context)?.settings.arguments as Account;

    print(widget.account!.toMap());

    return Scaffold(
      drawer: !Responsive.isDesktop(context) ? NavigationDrawer() : Container(),
      appBar: /*  !Responsive.isDesktop(context)
          ?  */
          AppBarWidget(
        title: 'Transactions',
        icon: Icons.search,
        bgColor: Colors.black,
        onPressed: () {
          showSearch(context: context, delegate: AppSearchDelegate());
        },
        authenticationController: Get.find<AuthenticationController>(),
        menuActionButton: ButtonOptionalMenu(),
        tooltip: 'Search',
      ),
      backgroundColor: const Color(0xFFF3f3f3),
      floatingActionButton: AnimatedSlide(
        offset: showFAB ? Offset.zero : const Offset(0, 1.5),
        duration: const Duration(milliseconds: 300),
        child: AnimatedOpacity(
          opacity: showFAB ? 1 : 0,
          duration: const Duration(milliseconds: 300),
          child: FloatingActionButton(
            onPressed: () {
              /*   Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return const AddTransactionView();
                })); */
              Get.toNamed(AppPages.FINANCE_ADD_TRANSACTION);
            },
            tooltip: 'New transaction',
            child: const Icon(Icons.add),
          ),
        ),
      ),
      body: Column(
        children: [
          Container(
            height: 60,
            decoration: const BoxDecoration(
                boxShadow: [
                  BoxShadow(
                      color: Color.fromARGB(255, 189, 207, 216),
                      offset: Offset(0, 1))
                ],
                color: Color.fromARGB(255, 232, 234, 239),
                /* border: Border.all(
                    width: 10,
                    color:  Color.fromARGB(255, 232, 234, 239),
                  ), */
                borderRadius: BorderRadius.horizontal(
                    left: const Radius.circular(4),
                    right: const Radius.circular(4))),
            // color: Color.fromARGB(255, 232, 234, 239),
            //  padding: const EdgeInsets.only(left: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  child: Row(
                    children: [
                      widget.account != null
                          ? Row(
                              children: [
                                widget.account!.photoURL == ""
                                    ? SizedBox(
                                        width: 50,
                                        height: 50,
                                        child: Container(
                                          decoration: const BoxDecoration(
                                            image: DecorationImage(
                                              image: AssetImage(
                                                  "assets/images/no_image.jpg"),
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                        ),
                                      )
                                    : Image.network(widget.account!.photoURL!,
                                        width: 50,
                                        height: 50,
                                        fit: BoxFit.cover, errorBuilder:
                                            (context, exception, stackTrace) {
                                        return Container(
                                          width: 50,
                                          height: 50,
                                          decoration: const BoxDecoration(
                                            image: DecorationImage(
                                              image: AssetImage(
                                                  "assets/images/no_image.jpg"),
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                        );
                                      }),
                                const SizedBox(
                                  width: 10,
                                ),
                                Text(
                                  widget.account!.name,
                                  style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            )
                          : const Text(
                              'All',
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: GetBuilder<TransactionController>(builder: (controller) {
              // if (controller.box.isEmpty) {
              //   return const Center(
              //     child: Text('No transactions Found'),
              //   );
              // }

              if (widget.account != null) {
                transactionController.isFilterByAccountEnabled.value = true;
                transactionController
                    .setFilterByAccount(widget.account!.number);
              }

              if (controller.filterdList.isEmpty) {
                return const EmptyView(
                    icon: Icons.receipt_long, label: 'No transactions found');
              }
              // return Obx(() {
              return SlidableAutoCloseBehavior(
                child: ListView.builder(
                    padding: const EdgeInsets.only(bottom: 10),
                    controller: scrollController,
                    itemCount: controller.filterdList.length,
                    itemBuilder: (context, index) {
                      Transaction currItem = controller.filterdList[index];

                      return TransactionTile(
                        transaction: currItem,
                        transactionController: transactionController,
                      );
                    }),
              );
              // });
            }),
          ),
        ],
      ),

      /* GetBuilder<TransactionController>(builder: (controller) {
        // if (controller.box.isEmpty) {
        //   return const Center(
        //     child: Text('No transactions Found'),
        //   );
        // }

        if (controller.filterdList.isEmpty) {
          return const EmptyView(
              icon: Icons.receipt_long, label: 'No transactions found');
        }
        return Obx(() {
          return SlidableAutoCloseBehavior(
            child: ListView.builder(
                padding: const EdgeInsets.symmetric(vertical: 10),
                controller: scrollController,
                itemCount: controller.filterdList.length,
                itemBuilder: (context, index) {
                  Transaction currItem = controller.filterdList[index];

                  return TransactionTile(
                    transaction: currItem,
                    transactionController: transactionController,
                  );
                }),
          );
        });
      }), */
    );
  }
}