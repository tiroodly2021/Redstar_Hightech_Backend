import 'package:get/get.dart';
import 'package:redstar_hightech_backend/app/modules/category/models/category_model.dart';

import '../../../services/database_service.dart';

class CategoryController extends GetxController {
  DatabaseService database = DatabaseService();
  var categories = <Category>[].obs;
  var newCategory = {}.obs;
  //RxString imageUrl = ''.obs;

  @override
  void onInit() {
    super.onInit();
    categories.bindStream(database.getCategories());
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {}
}
