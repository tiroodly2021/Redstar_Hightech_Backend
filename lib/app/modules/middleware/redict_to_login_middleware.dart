import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:redstar_hightech_backend/app/modules/authentication/controllers/authentication_controller.dart';

import '../../routes/app_pages.dart';


class RedirectToLoginMiddleware extends GetMiddleware {
  AuthenticationController authenticationController= Get.put(AuthenticationController());


  RedirectToLoginMiddleware(){
    if(Get.find<AuthenticationController>().user==null){
      isAuthenticated =false;
    }else{
      isAuthenticated = true;
    }

  }

  @override
  int? get priority => 2;

  static bool isAuthenticated = false;

  @override
  RouteSettings? redirect(String? route) {
    if (isAuthenticated == false) {
     // Get.to(() => LoginView());
      return const RouteSettings(name: Routes.LOGIN);
    }
  }

  //This function will be called  before anything created we can use it to
  // change something about the page or give it new page
  @override
  GetPage? onPageCalled(GetPage? page) {
    return super.onPageCalled(page);
  }

  //This function will be called right before the Bindings are initialized.
  // Here we can change Bindings for this page.
  @override
  List<Bindings>? onBindingsStart(List<Bindings>? bindings) {
    return super.onBindingsStart(bindings);
  }

  //This function will be called right after the Bindings are initialized.
  // Here we can do something after  bindings created and before creating the page widget.
  @override
  GetPageBuilder? onPageBuildStart(GetPageBuilder? page) {
    return super.onPageBuildStart(page);
  }

  // Page build and widgets of page will be shown
  @override
  Widget onPageBuilt(Widget page) {
    return super.onPageBuilt(page);
  }

  //This function will be called right after disposing all the related objects
  // (Controllers, views, ...) of the page.
  @override
  void onPageDispose() {
    super.onPageDispose();
  }
}