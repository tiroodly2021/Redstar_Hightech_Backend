import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart' as cloud_firestore;

import '../../../services/database_service.dart';
import '../models/user_model.dart';

class UserController extends GetxController {
  final cloud_firestore.FirebaseFirestore _firebaseFirestore =
      cloud_firestore.FirebaseFirestore.instance;

  late cloud_firestore.CollectionReference<Map<String, dynamic>>
      collectionReference;

  DatabaseService database = DatabaseService();
  var users = <User>[].obs;
  var count = 0.obs;

  var imageLocalPath = ''.obs;
  var newUser = {}.obs;

  UserController() {
    // collectionReference = _firebaseFirestore.collection('categories');
  }

  /*  Stream<List<dynamic>> getUsers() {
    return collectionReference.snapshots().map((snapshot) =>
        snapshot.docs.map((doc) => User.fromSnapShot(doc)).toList());
  } */

  @override
  void onInit() {
    users.bindStream(database.getUsers());

    count.bindStream(database.getCount('users', 'UserController'));

    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {}
}
