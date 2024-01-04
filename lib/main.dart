import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:get/get.dart';
import 'package:redstar_hightech_backend/app/modules/authentication/bindings/authentication_binding.dart';
import 'package:redstar_hightech_backend/app/modules/authentication/controllers/authentication_controller.dart';
import 'package:redstar_hightech_backend/app/modules/authentication/views/admin/roles/add_role_view.dart';

import 'app/routes/app_pages.dart';
import 'firebase_options.dart';

import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'forms.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Hive.initFlutter();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  await Hive.openBox('storage');

  runApp(
    GetMaterialApp(
      title: "Application",

      initialRoute: AppPages.INITIAL,
      getPages: AppPages.routes,

      //  home: const HomePage(),
      //home: AddRoleView(),
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        appBarTheme: const AppBarTheme(backgroundColor: Color(0xff26384f)),
        floatingActionButtonTheme: const FloatingActionButtonThemeData(
            backgroundColor: Color(0xff26384f)),
      ),
    ),
  );
}


/*import 'package:flutter/material.dart';
import 'package:get/get.dart';

class GlobalMiddleware extends GetMiddleware {
  final authController = Get.find<AuthController>();

  @override
  RouteSettings? redirect(String? route) {
    return authController.authenticated || route == '/login'
        ? null
        : RouteSettings(name: '/login');
  }

  //This function will be called  before anything created we can use it to
  // change something about the page or give it new page
  @override
  GetPage? onPageCalled(GetPage? page) {
    print('>>> Page ${page!.name} called');
    print('>>> User ${authController.username} logged');
    authController.username != null
        ? page.copyWith(arguments: {'user': authController.username})
        : page;
    return super.onPageCalled(page);
  }

  //This function will be called right before the Bindings are initialized.
  // Here we can change Bindings for this page.
  @override
  List<Bindings>? onBindingsStart(List<Bindings>? bindings) {
    bindings = [OtherBinding()];

    return super.onBindingsStart(bindings);
  }

  //This function will be called right after the Bindings are initialized.
  // Here we can do something after  bindings created and before creating the page widget.
  @override
  GetPageBuilder? onPageBuildStart(GetPageBuilder? page) {
    print('Bindings of ${page.toString()} are ready');

    return super.onPageBuildStart(page);
  }

  // Page build and widgets of page will be shown
  @override
  Widget onPageBuilt(Widget page) {
    print('Widget ${page.toStringShort()} will be showed');

    return super.onPageBuilt(page);
  }

  //This function will be called right after disposing all the related objects
  // (Controllers, views, ...) of the page.
  @override
  void onPageDispose() {
    print('PageDisposed');

    super.onPageDispose();
  }
}



void main() {
  Get.put(AuthController());
  runApp(GetMaterialApp(
    initialRoute: '/home',
    getPages: [
      GetPage(
        name: '/home',
        page: () => HomePage(),
        middlewares: [GlobalMiddleware()],
      ),
      GetPage(
        name: '/login',
        page: () => LoginPage(),
        binding: LoginBinding(),
        middlewares: [GlobalMiddleware()],
      ),
    ],
  ));
}

class AuthController extends GetxController {
  final _authenticated = false.obs;
  RxString _username = ''.obs;

  bool get authenticated => _authenticated.value;
  set authenticated(value) => _authenticated.value = value;
  String get username => _username.value;
  set username(value) => _username.value = value;

  @override
  void onInit() {
    ever(_authenticated, (bool value) {
      if (value) {
        username = 'Eduardo';
      }
    });
    super.onInit();
  }
}

class OtherBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(OtherController());
  }
}

class OtherController extends GetxController {
  @override
  void onInit() {
    print('>>> OtherController started');
    super.onInit();
  }
}

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('HOME')),
      body: Center(
        child: Text('User: ${Get.parameters['user']}'),
      ),
    );
  }
}

class LoginBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(AuthController());
    Get.put(LoginController());
  }
}

class LoginController extends GetxController {
  @override
  void onInit() {
    print('>>> LoginController started');
    super.onInit();
  }

  AuthController get authController => Get.find<AuthController>();
}

class LoginPage extends GetView<LoginController> {
  LoginController loginController = Get.put(LoginController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Login')),
      body: Center(
        child: RaisedButton(
          child: Text('Login'),
          onPressed: () {
            loginController.authController.authenticated = true;
            Get.offNamed('/home');
          },
        ),
      ),
    );
  }
}*/

