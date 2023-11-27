import 'package:flutter/material.dart';
import 'package:drawerbehavior/drawerbehavior.dart' as drawer;
import 'package:redstar_hightech_backend/app/constants/app_theme.dart';
import 'package:redstar_hightech_backend/app/databases/boxes.dart';
import 'package:redstar_hightech_backend/app/modules/cancelled_order/views/cancelled_order_view.dart';
import 'package:redstar_hightech_backend/app/modules/category/views/category_view.dart';
import 'package:redstar_hightech_backend/app/modules/home/views/home_view.dart';
import 'package:redstar_hightech_backend/app/modules/login/views/login_view.dart';
import 'package:redstar_hightech_backend/app/modules/order/views/order_view.dart';
import 'package:redstar_hightech_backend/app/modules/pending_order/views/pending_order_view.dart';
import 'package:redstar_hightech_backend/app/modules/product/views/product_view.dart';
import 'package:redstar_hightech_backend/app/modules/settings/views/edit_profile.dart';
import 'package:redstar_hightech_backend/app/modules/settings/views/settings_view.dart';
import 'package:redstar_hightech_backend/util.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

class HomeDrawer extends StatefulWidget {
  const HomeDrawer({Key? key}) : super(key: key);
  @override
  State<HomeDrawer> createState() => _HomeDrawerState();
}

class _HomeDrawerState extends State<HomeDrawer> {
  late String selectedMenuItemId;

  final menu = drawer.Menu(
    items: [
      drawer.MenuItem(
        id: 'home',
        icon: Icons.home,
        title: 'Home',
      ),
      drawer.MenuItem(
        id: 'login',
        icon: Icons.login,
        title: 'Login',
      ),
      drawer.MenuItem(
          id: 'products', icon: Icons.shopping_cart, title: 'Products'),
      drawer.MenuItem(
        id: 'categories',
        icon: Icons.category,
        title: 'Categories',
      ),
      drawer.MenuItem(
        id: 'orders',
        icon: Icons.bar_chart,
        title: 'Orders',
      ),
      drawer.MenuItem(
        id: 'pending_orders',
        icon: Icons.pending,
        title: 'Pending Orders',
      ),
      drawer.MenuItem(
        id: 'cancelled_orders',
        icon: Icons.cancel,
        title: 'Cancelled Orders',
      ),
      drawer.MenuItem(id: 'settings', icon: Icons.settings, title: 'Settings')
    ],
  );

  @override
  void initState() {
    selectedMenuItemId = menu.items[0].id;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
        valueListenable: Boxes.getStorageBox().listenable(),
        builder: (context, Box box, _) {
          return drawer.DrawerScaffold(
            drawers: [
              drawer.SideDrawer(
                  percentage: 1,
                  menu: menu,
                  headerView: const HeaderView(),
                  cornerRadius: 0,
                  elevation: 15,
                  selectorColor: Colors.transparent,
                  animation: false,
                  alignment: Alignment.centerLeft,
                  color: const Color(0xffE9E9E9),
                  selectedItemId: selectedMenuItemId,
                  onMenuItemSelected: (itemId) {
                    setState(() {
                      selectedMenuItemId = itemId;
                    });
                  },
                  itemBuilder:
                      (BuildContext context, menuItem, bool isSelected) {
                    return Container(
                      margin: const EdgeInsets.fromLTRB(0, 5, 70, 5),
                      padding: const EdgeInsets.symmetric(
                          vertical: 10, horizontal: 20),
                      decoration: BoxDecoration(
                          color: isSelected
                              ? Colors.blue.withOpacity(0.2)
                              : Colors.transparent,
                          borderRadius: const BorderRadius.horizontal(
                              right: Radius.circular(50))),
                      child: Row(children: [
                        Icon(
                          menuItem.icon,
                          color: isSelected ? Colors.blue : Colors.black,
                        ),
                        const SizedBox(width: 20),
                        Text(
                          menuItem.title,
                          style: Theme.of(context)
                              .textTheme
                              .subtitle1
                              ?.copyWith(
                                  color:
                                      isSelected ? Colors.blue : Colors.black,
                                  fontWeight: FontWeight.bold),
                        )
                      ]),
                    );
                  })
            ],
            builder: (context, id) =>
                DrawerScreen(screen: getScreen(selectedMenuItemId)),
          );
        });
  }

  Widget getScreen(String currentItemId) {
    switch (currentItemId) {
      case 'home':
        return HomeView();
      case 'login':
        return LoginView();
      case 'products':
        return ProductView();
      case 'categories':
        return CategoryView();
      case 'orders':
        return OrderView();
      case 'settings':
        return const SettingsView();
      case 'pending_orders':
        return PendingOrderView();
      case 'cancelled_orders':
        return CancelledOrderView();

      default:
        return HomeView();
    }
  }

  @override
  List<Object?> get props => [selectedMenuItemId, menu];
}

class HeaderView extends StatefulWidget {
  const HeaderView({Key? key}) : super(key: key);

  @override
  State<HeaderView> createState() => _HeaderViewState();
}

class _HeaderViewState extends State<HeaderView> {
  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: Boxes.getStorageBox().listenable(),
      builder: (context, Box box, _) {
        final String imageString = box.get('profilePhoto', defaultValue: '');
        final String userName = box.get('userName', defaultValue: '');
        return Column(
          children: [
            Row(
              children: [
                const Spacer(flex: 1),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                                blurRadius: 5,
                                color: Colors.black,
                                spreadRadius: 0)
                          ],
                        ),
                        child: Padding(
                          padding: const EdgeInsets.only(top: 10.0),
                          child: CircleAvatar(
                              radius: 50,
                              backgroundColor: Colors.transparent,
                              backgroundImage:
                                  Util.getAvatharImage(imageString)),
                        )),
                    const SizedBox(height: 20),
                    Text(
                      userName,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                          color: AppTheme.darkGray,
                          fontWeight: FontWeight.bold,
                          fontSize: 19),
                    ),
                    const SizedBox(height: 15),
                  ],
                ),
                const Spacer(flex: 3)
              ],
            ),
            const Divider(thickness: 1)
          ],
        );
      },
    );
  }
}

class DrawerScreen extends StatefulWidget {
  const DrawerScreen({Key? key, required this.screen}) : super(key: key);
  final Widget screen;
  @override
  State<DrawerScreen> createState() => _DrawerScreenState();
}

class _DrawerScreenState extends State<DrawerScreen> {
  bool isDrawerOpen = false;
  @override
  void initState() {
    drawer.DrawerScaffold.currentController(context);
    drawer.DrawerScaffold.currentController(context).addListener(() {
      setState(() {
        isDrawerOpen =
            drawer.DrawerScaffold.currentController(context).isOpen();
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AbsorbPointer(absorbing: isDrawerOpen, child: widget.screen);
  }
}
