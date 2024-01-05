import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:redstar_hightech_backend/app/config/responsive.dart';
import 'package:redstar_hightech_backend/app/constants/app_theme.dart';
import 'package:redstar_hightech_backend/app/modules/authentication/controllers/authentication_controller.dart';
import 'package:redstar_hightech_backend/app/modules/common/navigation_drawer.dart';
import 'package:redstar_hightech_backend/app/modules/finance/account_category/views/dialog_add_cateory.dart';
import 'package:redstar_hightech_backend/app/modules/finance/widgets/empty_view.dart';
import 'package:redstar_hightech_backend/app/shared/app_bar_widget.dart';
import 'package:redstar_hightech_backend/app/shared/app_search_delegate.dart';
import 'package:redstar_hightech_backend/app/shared/button_optional_menu.dart';
import 'package:redstar_hightech_backend/util.dart';

import '../controllers/account_category_controller.dart';

import 'package:flutter/material.dart';

import 'package:redstar_hightech_backend/app/modules/finance/account_category/models/account_category.dart'
    as financeCategory;

class AccountCategoryView extends StatefulWidget {
  const AccountCategoryView({Key? key}) : super(key: key);

  @override
  State<AccountCategoryView> createState() => _AccountCategoryViewState();
}

class _AccountCategoryViewState extends State<AccountCategoryView>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  int currType = 0;
  @override
  void initState() {
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(() {
      setState(() {
        currType = _tabController.index;
      });
    });
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _tabController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    bool keyboardIsOpen = MediaQuery.of(context).viewInsets.bottom != 0;
    return Scaffold(
      drawer: !Responsive.isDesktop(context) ? NavigationDrawer() : Container(),
      appBar: /*  !Responsive.isDesktop(context)
          ?  */
          AppBarWidget(
        title: 'Redstar Management',
        icon: Icons.search,
        bgColor: Colors.black,
        onPressed: () {
          showSearch(context: context, delegate: AppSearchDelegate());
        },
        authenticationController: Get.find<AuthenticationController>(),
        menuActionButton: ButtonOptionalMenu(),
        tooltip: 'Search',
      ),
      floatingActionButton: Visibility(
        visible: !keyboardIsOpen,
        child: FloatingActionButton(
          onPressed: () async {
            showDialog(
                context: context,
                builder: (context) => AddCateoryDialog(
                      type: currType,
                    ));
          },
          tooltip: 'New Category',
          child: const Icon(Icons.add),
        ),
      ),
      resizeToAvoidBottomInset: false,
      body: SizedBox(
        width: size.width,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Column(
            children: [
              Container(
                height: 35,
                width: size.width * .8,
                margin: const EdgeInsets.only(top: 25, bottom: 15),
                padding: const EdgeInsets.all(3),
                decoration: BoxDecoration(
                  color: Colors.grey.shade400,
                  borderRadius: BorderRadius.circular(25.0),
                ),
                child: TabBar(
                  controller: _tabController,
                  indicator: BoxDecoration(
                      borderRadius: BorderRadius.circular(25.0),
                      gradient: LinearGradient(colors: [
                        Colors.white,
                        _tabController.index == 0
                            ? const Color(0xFFEBFFE3)
                            : const Color(0xFFFCE5E5)
                      ])),
                  labelColor: Colors.black,
                  unselectedLabelColor: Colors.black54,
                  labelStyle: const TextStyle(fontWeight: FontWeight.bold),
                  tabs: const [
                    Tab(text: 'Income'),
                    Tab(text: 'Expense'),
                  ],
                ),
              ),
              const Divider(thickness: 1),
              Expanded(
                  child:
                      TabBarView(controller: _tabController, children: const [
                CategoryList(type: financeCategory.AccountCategoryType.income),
                CategoryList(type: financeCategory.AccountCategoryType.expense)
              ]))
            ],
          ),
        ),
      ),
    );
  }
}

class CategoryList extends StatelessWidget {
  final int type;
  const CategoryList({Key? key, required this.type}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    /* return GetBuilder<CategoryController>(builder: (controller) {
      List<Category> categoriesList = controller.getActiveCategories(type);
      return ListView.separated(
          padding: const EdgeInsets.fromLTRB(15, 5, 15, 15),
          itemCount: categoriesList.length,
          itemBuilder: (context, index) {
            Category currCat = categoriesList[index];
            return Card(
              child: ListTile(
                leading: Util.getCatIcon(type),
                contentPadding:
                    const EdgeInsets.symmetric(vertical: 0, horizontal: 25),
                visualDensity: const VisualDensity(horizontal: 0, vertical: 0),
                title: Text(
                  currCat.categoryName,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                        onPressed: () {
                          showDialog(
                              context: context,
                              builder: (context) => AddCateoryDialog(
                                  type: type, category: currCat));
                        },
                        icon: const Icon(
                          Icons.edit,
                          color: AppTheme.darkGray,
                        )),
                    IconButton(
                        onPressed: () {
                          showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                    content: const Text(
                                      'Are you sure to delete this Category? ',
                                      style: TextStyle(
                                          fontWeight: FontWeight.w500),
                                    ),
                                    actions: [
                                      TextButton(
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                          },
                                          child: const Text('No')),
                                      TextButton(
                                          onPressed: () {
                                            CategoryController()
                                                .deleteCategory(currCat);
                                            Navigator.of(context).pop();
                                          },
                                          child: const Text('Yes'))
                                    ],
                                  ));
                        },
                        icon: const Icon(
                          Icons.delete,
                          color: AppTheme.darkGray,
                        ))
                  ],
                ),
              ),
            );
          },
          separatorBuilder: (context, index) => const SizedBox());
    });*/
    return ValueListenableBuilder(
        valueListenable: Hive.box<financeCategory.AccountCategory>('categories')
            .listenable(),
        builder: (context, Box<financeCategory.AccountCategory> box, index) {
          List<financeCategory.AccountCategory> categoriesList =
              box.values.where((element) => element.type == type).toList();
          if (categoriesList.isEmpty) {
            return SizedBox(
              height: MediaQuery.of(context).size.height * 0.5,
              child: const EmptyView(
                icon: Icons.category,
                label: 'No Categories',
                color: Color.fromARGB(249, 26, 93, 148),
              ),
            );
          }
          return ListView.separated(
              padding: const EdgeInsets.fromLTRB(15, 5, 15, 15),
              itemCount: categoriesList.length,
              itemBuilder: (context, index) {
                financeCategory.AccountCategory currCat = categoriesList[index];
                return ListTile(
                  leading: Util.getCatIcon(type),
                  title: Text(
                    currCat.categoryName,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                          onPressed: () {
                            showDialog(
                                context: context,
                                builder: (context) => AddCateoryDialog(
                                    type: type, category: currCat));
                          },
                          icon: const Icon(
                            Icons.edit,
                            color: AppTheme.darkGray,
                          )),
                      IconButton(
                          onPressed: () {
                            showDialog(
                                context: context,
                                builder: (context) => AlertDialog(
                                      content: const Text(
                                        'Are you sure to delete this Category? ',
                                        style: TextStyle(
                                            fontWeight: FontWeight.w500),
                                      ),
                                      actions: [
                                        TextButton(
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                            },
                                            child: const Text('No')),
                                        TextButton(
                                            onPressed: () {
                                              AccountCategoryController()
                                                  .deleteCategory(currCat);
                                              Navigator.of(context).pop();
                                            },
                                            child: const Text('Yes'))
                                      ],
                                    ));
                          },
                          icon: const Icon(
                            Icons.delete,
                            color: AppTheme.darkGray,
                          ))
                    ],
                  ),
                );
              },
              separatorBuilder: (context, index) => const Divider());
        });
  }
}
