import 'package:cloud_firestore/cloud_firestore.dart' as cloud_firestore;
import 'package:redstar_hightech_backend/app/modules/authentication/models/permission_model.dart';
import 'package:redstar_hightech_backend/app/modules/authentication/models/role_model.dart';
import 'package:redstar_hightech_backend/app/modules/category/models/category_model.dart';
import 'package:redstar_hightech_backend/app/modules/order/models/order_stats_model.dart';

import 'package:redstar_hightech_backend/app/modules/product/models/product_model.dart';

import '../../app/modules/order/models/order_model.dart';
import '../modules/authentication/models/device_model.dart';
import '../modules/authentication/models/user_model.dart';

class DatabaseService {
  final cloud_firestore.FirebaseFirestore _firebaseFirestore =
      cloud_firestore.FirebaseFirestore.instance;

  Stream<List<Category>> getCategories() {
    return _firebaseFirestore.collection('categories').snapshots().map(
        (snapshot) =>
            snapshot.docs.map((doc) => Category.fromSnapShot(doc)).toList());
  }

  Stream<List<String>> getCategoriesByName() {
    return _firebaseFirestore.collection('categories').snapshots().map(
        (snapshot) => snapshot.docs
            .map((doc) => Category.fromSnapShot(doc))
            .toList()
            .map((category) => category.name)
            .toList());
  }

  Stream<List<Product>> getProducts() {
    return _firebaseFirestore.collection('products').snapshots().map(
        (snapshot) =>
            snapshot.docs.map((doc) => Product.fromSnapShot(doc)).toList());
  }

  Future<List<OrderStats>> getOrderStats() {
    return _firebaseFirestore
        .collection('order_stats')
        .orderBy('dateTime')
        .get()
        .then((querySnapshot) => querySnapshot.docs
            .asMap()
            .entries
            .map((entry) => OrderStats.fromSnapshot(entry.value, entry.key))
            .toList());
  }

  Future<void> addProduct(Product product) {
    return _firebaseFirestore.collection('products').add(product.toMap());
  }

  Future<void> addCategory(Category category) {
    return _firebaseFirestore.collection('categories').add(category.toMap());
  }

  void editCategory(Category category) {
    //return _firebaseFirestore.collection('categories').doc('')
  }

  Future<void> updateField(Product product, String field, dynamic newValue) {
    //print(_firebaseFirestore.collection('products').get());

    /*   return _firebaseFirestore
        .collection('products')
        .where('id', isEqualTo: product.id!)
        .get()
        .then((querySnapshot) =>
            querySnapshot.docs.first.reference.update({field: newValue})); */
    return _firebaseFirestore
        .collection('products')
        .doc(product.id)
        .update({field: newValue});
  }

  Stream<List<User>> getUsers() {
    return _firebaseFirestore.collection('users').snapshots().map((snapshot) =>
        snapshot.docs.map((doc) => User.fromSnapShot(doc)).toList());
  }

  Stream<List<Order>> getOrders() {
    return _firebaseFirestore
        .collection('orders')
        .where('isDelivered', isEqualTo: true)
        .where('isAccepted', isEqualTo: true)
        .where('isCancelled', isEqualTo: false)
        .snapshots()
        .map((snapshot) =>
            snapshot.docs.map((doc) => Order.fromSnapShot(doc)).toList());
  }

  Future<List<Device>?> getDeviceByUser(User user) async {
    final userCollection = _firebaseFirestore.collection('users');

    print('user.name: ${user.name} user.uid: ${user.uid}');

    cloud_firestore.QuerySnapshot<Map<String, dynamic>> devicesQuerySnap =
        await userCollection.doc(user.uid).collection('devices').get();

    List<Device> devices = devicesQuerySnap.docs
        .map((device) => Device.fromSnapShot(device))
        .toList();

    return devices;
  }

  Stream<int> getCount(String collectionPath, String controller) {
    switch (controller) {
      case 'UserController':
        return _firebaseFirestore.collection(collectionPath).snapshots().map(
            (snapshot) => snapshot.docs
                .map((doc) => User.fromSnapShot(doc))
                .toList()
                .length);

      case 'OrderController':
        return _firebaseFirestore
            .collection(collectionPath)
            .where('isAccepted', isEqualTo: true)
            .where('isCancelled', isEqualTo: false)
            .snapshots()
            .map((snapshot) => snapshot.docs
                .map((doc) => Order.fromSnapShot(doc))
                .toList()
                .length);
      case 'PendingOrderController':
        return _firebaseFirestore
            .collection(collectionPath)
            .where('isDelivered', isEqualTo: false)
            .where('isCancelled', isEqualTo: false)
            .where('isAccepted', isEqualTo: false)
            .snapshots()
            .map((snapshot) => snapshot.docs
                .map((doc) => Order.fromSnapShot(doc))
                .toList()
                .length);
      case 'CategoryController':
        return _firebaseFirestore.collection(collectionPath).snapshots().map(
            (snapshot) => snapshot.docs
                .map((doc) => Category.fromSnapShot(doc))
                .toList()
                .length);
      case 'ProductController':
        return _firebaseFirestore.collection(collectionPath).snapshots().map(
            (snapshot) => snapshot.docs
                .map((doc) => Product.fromSnapShot(doc))
                .toList()
                .length);
      case 'CancelledOrderController':
        return _firebaseFirestore
            .collection(collectionPath)
            .where('isCancelled', isEqualTo: true)
            .snapshots()
            .map((snapshot) => snapshot.docs
                .map((doc) => Order.fromSnapShot(doc))
                .toList()
                .length);
      case 'getOrderDelivered':
        return _firebaseFirestore
            .collection(collectionPath)
            .where('isDelivered', isEqualTo: true)
            .snapshots()
            .map((snapshot) => snapshot.docs
                .map((doc) => Order.fromSnapShot(doc))
                .toList()
                .length);

      default:
        return _firebaseFirestore
            .collection(collectionPath)
            .where('isAccepted', isEqualTo: true)
            .where('isCancelled', isEqualTo: false)
            .snapshots()
            .map((snapshot) => snapshot.docs
                .map((doc) => Order.fromSnapShot(doc))
                .toList()
                .length);
    }
  }

  Future<void> updateOrder(Order order, String field, bool value) {
    /* return _firebaseFirestore
        .collection('orders')
        .where('id', isEqualTo: order.id)
        .get()
        .then((querySnapshot) =>
            querySnapshot.docs.first.reference.update({field: value})); */
    return _firebaseFirestore
        .collection('orders')
        .doc(order.id)
        .update({field: value});
  }

  Future<void> updatePendingOrder(Order order, String field, bool value) {
    return _firebaseFirestore
        .collection('orders')
        .doc(order.id)
        .update({field: value});

    /* _firebaseFirestore
        .collection('orders')
        .where('id', isEqualTo: order.id)
        .get()
        .then((querySnapshot) =>
            querySnapshot.docs.first.reference.update({field: value})); */
  }

  Future<void> updateCancelledOrder(Order order, String field, bool value) {
    return _firebaseFirestore
        .collection('orders')
        .doc(order.id)
        .update({field: value});

    /* _firebaseFirestore
        .collection('orders')
        .where('id', isEqualTo: order.id)
        .get()
        .then((querySnapshot) =>
            querySnapshot.docs.first.reference.update({field: value})); */
  }

  Future<void> updateOrderDelivered(Order order, String field, bool value) {
    return _firebaseFirestore
        .collection('orders')
        .doc(order.id)
        .update({field: value});

    /* _firebaseFirestore
        .collection('orders')
        .where('id', isEqualTo: order.id)
        .get()
        .then((querySnapshot) =>
            querySnapshot.docs.first.reference.update({field: value})); */
  }

  Stream<List<Order>> getCancelledOrders() {
    return _firebaseFirestore
        .collection('orders')
        .where('isCancelled', isEqualTo: true)
        .snapshots()
        .map((snapshot) =>
            snapshot.docs.map((doc) => Order.fromSnapShot(doc)).toList());
  }

  Stream<List<Order>> getPendingOrders() {
    return _firebaseFirestore
        .collection('orders')
        .where('isDelivered', isEqualTo: false)
        .where('isCancelled', isEqualTo: false)
        .where('isAccepted', isEqualTo: false)
        .snapshots()
        .map((snapshot) =>
            snapshot.docs.map((doc) => Order.fromSnapShot(doc)).toList());
  }

  Stream<List<Order>> getOrderDelivered() {
    return _firebaseFirestore
        .collection('orders')
        .where('isDelivered', isEqualTo: true)
        .snapshots()
        .map((snapshot) =>
            snapshot.docs.map((doc) => Order.fromSnapShot(doc)).toList());
  }

  Future<void> updateCategory(Category category) {
    return _firebaseFirestore
        .collection('categories')
        .doc(category.id)
        .update(category.toMap());

    /* var d = _firebaseFirestore
        .collection('categories')
        .where('id', isEqualTo: category.id)
        .get();*/

    // print(d);

    //return d.then((querySnapshot) => querySnapshot.docs.first.reference
    //     .update({'name': category.name, 'imageUrl': category.imageUrl}));
  }

  Future<void> deleteCategory(Category category) {
    return _firebaseFirestore
        .collection('categories')
        .doc(category.id)
        .delete();
  }

  Future<void> deleteProduct(Product product) {
    return _firebaseFirestore.collection('products').doc(product.id).delete();
  }

  Future<void> updateProduct(Product newProduct) {
    return _firebaseFirestore
        .collection('products')
        .doc(newProduct.id)
        .update(newProduct.toMap());
  }

  Future<void> addUser(User user) {
    return _firebaseFirestore.collection('users').add(user.toMap());
  }

  Future<void> deleteUser(User user) {
    return _firebaseFirestore.collection('users').doc(user.uid).delete();
  }

  Future<void> updateUser(User user) {
    return _firebaseFirestore
        .collection('users')
        .doc(user.uid)
        .update(user.toMap());
  }

  Stream<List<Product>> getProductsByCategory(Category category) {
    String categoryName = 'No'; //category.name;

    return _firebaseFirestore
        .collection('products')
        .where('category', isEqualTo: categoryName)
        .snapshots()
        .map((snapshot) =>
            snapshot.docs.map((doc) => Product.fromSnapShot(doc)).toList());
  }

  Stream<List<Role>> getRoles() {
    return _firebaseFirestore.collection('roles').snapshots().map((snapshot) =>
        snapshot.docs.map((doc) => Role.fromSnapShot(doc)).toList());
  }

  Future<void> addRole(Role role) {
    return _firebaseFirestore.collection('roles').add(role.toMap());
  }

  Future<void> deleteRole(Role role) {
    return _firebaseFirestore.collection('roles').doc(role.id).delete();
  }

  Future<void> updateRole(Role role) {
    return _firebaseFirestore
        .collection('roles')
        .doc(role.id)
        .update(role.toMap());
  }

  Stream<List<Permission>> getPermissions() {
    return _firebaseFirestore.collection('permissions').snapshots().map(
        (snapshot) =>
            snapshot.docs.map((doc) => Permission.fromSnapShot(doc)).toList());
  }

  Future<void> addPermission(Permission permission) {
    return _firebaseFirestore.collection('permissions').add(permission.toMap());
  }

  Future<void> deletePermission(Permission permission) {
    return _firebaseFirestore
        .collection('permissions')
        .doc(permission.id)
        .delete();
  }

  Future<void> updatePermission(Permission permission) {
    return _firebaseFirestore
        .collection('permissions')
        .doc(permission.id)
        .update(permission.toMap());
  }

  Stream<List<String>> getRolesByName() {
    return _firebaseFirestore.collection('roles').snapshots().map((snapshot) =>
        snapshot.docs
            .map((doc) => Role.fromSnapShot(doc))
            .toList()
            .map((role) => role.name)
            .toList());
  }

  Future<void> updateRolePermissions(Role role, String s) {
    print(role.toMap());
    return _firebaseFirestore
        .collection('roles')
        .doc(role.id)
        .update(role.toMap());
  }

  Stream<Role> getRoleById(String value) {
    return _firebaseFirestore
        .collection('roles')
        .doc(value)
        .snapshots()
        .map((role) => Role.fromSnapShot(role));
  }
}
