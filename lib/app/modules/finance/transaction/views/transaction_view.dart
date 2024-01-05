import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

import 'package:get/get.dart';
import 'package:redstar_hightech_backend/app/config/responsive.dart';
import 'package:redstar_hightech_backend/app/modules/authentication/controllers/authentication_controller.dart';
import 'package:redstar_hightech_backend/app/modules/common/navigation_drawer.dart';
import 'package:redstar_hightech_backend/app/modules/finance/transaction/models/transaction.dart';
import 'package:redstar_hightech_backend/app/modules/finance/transaction/views/add_transaction_view.dart';
import 'package:redstar_hightech_backend/app/modules/finance/widgets/empty_view.dart';
import 'package:redstar_hightech_backend/app/modules/finance/widgets/tile_transaction.dart';
import 'package:redstar_hightech_backend/app/shared/app_bar_widget.dart';
import 'package:redstar_hightech_backend/app/shared/app_search_delegate.dart';
import 'package:redstar_hightech_backend/app/shared/button_optional_menu.dart';

import '../controllers/transaction_controller.dart';

class TransactionView extends StatefulWidget {
  const TransactionView({Key? key}) : super(key: key);

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
    return Scaffold(
        drawer:
            !Responsive.isDesktop(context) ? NavigationDrawer() : Container(),
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
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return const AddTransactionView();
                }));
              },
              tooltip: 'New transaction',
              child: const Icon(Icons.add),
            ),
          ),
        ),
        body: GetBuilder<TransactionController>(
          builder: (controller) {
            // if (controller.box.isEmpty) {
            //   return const Center(
            //     child: Text('No transactions Found'),
            //   );
            // }
            if (controller.filterdList.isEmpty) {
              return const EmptyView(
                  icon: Icons.receipt_long, label: 'No transactions found');
            }
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
          },
        ));
  }
}
