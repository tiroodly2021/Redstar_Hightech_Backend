import 'package:cloud_firestore/cloud_firestore.dart' as cloud_firestore;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:redstar_hightech_backend/app/modules/authentication/models/permission_model.dart';
import 'package:redstar_hightech_backend/app/modules/authentication/models/role_model.dart';
import 'package:redstar_hightech_backend/app/modules/category/models/category_model.dart';
import 'package:redstar_hightech_backend/app/modules/finance/account/models/account_model.dart';
import 'package:redstar_hightech_backend/app/modules/finance/transaction/models/transaction_model.dart';
import 'package:redstar_hightech_backend/app/modules/order/models/order_stats_model.dart';

import 'package:redstar_hightech_backend/app/modules/product/models/product_model.dart';

import '../../app/modules/order/models/order_model.dart';
import '../modules/authentication/models/device_model.dart';
import '../modules/authentication/models/user_model.dart';
import 'package:redstar_hightech_backend/app/modules/finance/transaction/models/transaction_model.dart'
    as financeModel;

class DatabaseService {
  final cloud_firestore.FirebaseFirestore _firebaseFirestore =
      cloud_firestore.FirebaseFirestore.instance;

  Stream<List<Account>> getAccounts() {
    return _firebaseFirestore.collection('accounts').snapshots().map(
        (snapshot) =>
            snapshot.docs.map((doc) => Account.fromSnapShot(doc)).toList());
  }

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

  Future<void> addProductWithCategory(
      Product product, Category category) async {
    String categoryId = category.id!;
    String categoryName = category.name;
    String categoryImageUrl = category.imageUrl;
    Map<String, dynamic> categoryMap = {
      'name': categoryName,
      'imageUrl': categoryImageUrl
    };

    print('product is: ${product.toMap()}');
    print('category with id: ${categoryId} is: ${category.toMap()}');

    if (categoryId != "") {
      if (categoryId != "" && categoryName != "") {
        String id = (await _firebaseFirestore
                .collection('products')
                .add(product.toMap()))
            .id;

        return _firebaseFirestore
            .collection('products')
            .doc(id)
            .collection('categories')
            .doc(categoryId)
            .set(categoryMap);
      }
    } else {
      String uid =
          (await _firebaseFirestore.collection('products').add(product.toMap()))
              .id;
    }

    // return _firebaseFirestore.collection('products').add(product.toMap());
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

    cloud_firestore.QuerySnapshot<Map<String, dynamic>> devicesQuerySnap =
        await userCollection.doc(user.uid).collection('devices').get();

    List<Device> devices = devicesQuerySnap.docs
        .map((device) => Device.fromSnapShot(device))
        .toList();

    return devices;
  }

  Future<List<Role>?> getRoleByUser(User user) async {
    final userCollection = _firebaseFirestore.collection('users');

    cloud_firestore.QuerySnapshot<Map<String, dynamic>> devicesQuerySnap =
        await userCollection.doc(user.uid).collection('roles').get();

    List<Role> roles =
        devicesQuerySnap.docs.map((role) => Role.fromSnapShot(role)).toList();

    return roles;
  }

  Stream<List<Role>> getRoleByUserASStream(User user) {
    final userCollection = _firebaseFirestore.collection('users');
    final roles = userCollection
        .doc(user.uid)
        .collection('roles')
        .snapshots()
        .map((event) => event.docs.map((e) => Role.fromSnapShot(e)).toList());

    return roles;

    /*   final userCollection = _firebaseFirestore.collection('users');

    cloud_firestore.QuerySnapshot<Map<String, dynamic>> devicesQuerySnap =
        await userCollection.doc(user.uid).collection('roles').get();

    List<Role> roles =
        devicesQuerySnap.docs.map((role) => Role.fromSnapShot(role)).toList();

    return roles; */
  }

  Future<List<Permission>?> getPermissionByRole(Role role) async {
    final userCollection = _firebaseFirestore.collection('roles');

    cloud_firestore.QuerySnapshot<Map<String, dynamic>> devicesQuerySnap =
        await userCollection.doc(role.id).collection('permissions').get();

    List<Permission> permissions = devicesQuerySnap.docs
        .map((permission) => Permission.fromSnapShot(permission))
        .toList();

    return permissions;
  }

  Future<List<Permission>> getPermissionByRoleAsStream(Role role) async {
    final userCollection = _firebaseFirestore.collection('roles');

    cloud_firestore.QuerySnapshot<Map<String, dynamic>> devicesQuerySnap =
        await userCollection.doc(role.id).collection('permissions').get();

    List<Permission> permissions = devicesQuerySnap.docs
        .map((permission) => Permission.fromSnapShot(permission))
        .toList();

    return permissions;
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
    _firebaseFirestore.collection('categories').doc(category.id).delete();

    return _firebaseFirestore.collection('products').get().then((products) {
      products.docs.forEach((productDoc) {
        Product product = Product.fromSnapShot(productDoc);

        _firebaseFirestore
            .collection('products')
            .doc(product.id)
            .collection('categories')
            .doc(category.id)
            .delete();
      });
    });

    /*    return _firebaseFirestore
        .collection('categories')
        .doc(category.id)
        .delete(); */
  }

  Future<void> deleteProduct(Product product) {
    return _firebaseFirestore.collection('products').doc(product.id).delete();
  }

  Future<void> updateProduct(Product newProduct, Category category) async {
    String id = newProduct.id!;
    String categoryId = category.id!;
    String categoryName = category.name;
    String categoryImageUrl = category.imageUrl;
    Map<String, dynamic> categoryMap = {
      'name': categoryName,
      'imageUrl': categoryImageUrl
    };

    await _firebaseFirestore
        .collection('products')
        .doc(newProduct.id)
        .update(newProduct.toMap());

    if (categoryId != "" && categoryName != "") {
      await _firebaseFirestore
          .collection('products')
          .doc(id)
          .collection('categories')
          .get()
          .then((value) {
        value.docs.forEach((element) {
          _firebaseFirestore
              .collection('products')
              .doc(id)
              .collection('categories')
              .doc(element.id)
              .delete()
              .then((value) {
            print("success");
          });
        });
      });

      return await _firebaseFirestore
          .collection('products')
          .doc(id)
          .collection('categories')
          .doc(categoryId)
          .set(categoryMap);
    } else {
      await _firebaseFirestore
          .collection('products')
          .doc(id)
          .collection('categories')
          .get()
          .then((value) {
        value.docs.forEach((element) {
          _firebaseFirestore
              .collection('products')
              .doc(id)
              .collection('categories')
              .doc(element.id)
              .delete()
              .then((value) {
            print("success");
          });
        });
      });
    }

    /*   return _firebaseFirestore
        .collection('products')
        .doc(newProduct.id)
        .update(newProduct.toMap()); */
  }

  Future<void> addUserRole(User user, Role role) async {
    String roleId = role.id!;
    String roleName = role.name;
    String roleDescription = role.description;
    Map<String, dynamic> roleMap = {
      'name': roleName,
      'description': roleDescription
    };

    if (roleId != "") {
      if (roleId != "" && roleName != "" && roleDescription != "") {
        String uid =
            (await _firebaseFirestore.collection('users').add(user.toMap())).id;

        return _firebaseFirestore
            .collection('users')
            .doc(uid)
            .collection('roles')
            .doc(roleId)
            .set(roleMap);
      }
    } else {
      String uid =
          (await _firebaseFirestore.collection('users').add(user.toMap())).id;
    }
  }

  Future<void> deleteUser(User user) {
    return _firebaseFirestore.collection('users').doc(user.uid).delete();
  }

  Future<void> updateUser(User user, Role role) async {
    String uid = user.uid!;
    String roleId = role.id!;
    String roleName = role.name;
    String roleDescription = role.description;
    Map<String, dynamic> roleMap = {
      'name': roleName,
      'description': roleDescription
    };

    await _firebaseFirestore
        .collection('users')
        .doc(user.uid)
        .update(user.toMap());

    if (roleId != "" && roleName != "" && roleDescription != "") {
      await _firebaseFirestore
          .collection('users')
          .doc(uid)
          .collection('roles')
          .get()
          .then((value) {
        value.docs.forEach((element) {
          _firebaseFirestore
              .collection('users')
              .doc(uid)
              .collection('roles')
              .doc(element.id)
              .delete()
              .then((value) {
            print("success");
          });
        });
      });

      return await _firebaseFirestore
          .collection('users')
          .doc(uid)
          .collection('roles')
          .doc(roleId)
          .set(roleMap);
    } else {
      await _firebaseFirestore
          .collection('users')
          .doc(uid)
          .collection('roles')
          .get()
          .then((value) {
        value.docs.forEach((element) {
          _firebaseFirestore
              .collection('users')
              .doc(uid)
              .collection('roles')
              .doc(element.id)
              .delete()
              .then((value) {
            print("success");
          });
        });
      });
    }
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
    _firebaseFirestore.collection('roles').doc(role.id).delete();

    return _firebaseFirestore.collection('users').get().then((users) {
      users.docs.forEach((userDoc) {
        User user = User.fromSnapShot(userDoc);

        _firebaseFirestore
            .collection('users')
            .doc(user.uid)
            .collection('roles')
            .doc(role.id)
            .delete();
      });
    });

    // return
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
    _firebaseFirestore.collection('permissions').doc(permission.id).delete();

    return _firebaseFirestore.collection('roles').get().then((roles) {
      roles.docs.forEach((roleDoc) {
        Role role = Role.fromSnapShot(roleDoc);

        _firebaseFirestore
            .collection('roles')
            .doc(role.id)
            .collection('permissions')
            .get()
            .then((value) {
          value.docs.forEach((element) {
            _firebaseFirestore
                .collection('roles')
                .doc(role.id)
                .collection('permissions')
                .doc(permission.id)
                .delete();
          });
        });
      });
    });
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
    return _firebaseFirestore
        .collection('roles')
        .doc(role.id)
        .update(role.toMap());
  }

  Future<void> addPermissionbyRole(Role role, Permission permission) async {
    final permssionReference = FirebaseFirestore.instance
        .collection("roles")
        .doc(role.id)
        .collection("devices");

    return _firebaseFirestore
        .collection('roles')
        .doc(role.id)
        .collection('permissions')
        .doc(permission.id)
        .set(permission.toMap());
  }

  Future<void> removePermissionbyRole(Role role, Permission permission) {
    return _firebaseFirestore
        .collection('roles')
        .doc(role.id)
        .collection('permissions')
        .doc(permission.id)
        .delete();
  }

  Future<Role> getRoleById(String value) async {
    return await _firebaseFirestore
        .collection('roles')
        .doc(value)
        .snapshots()
        .map((role) => Role.fromSnapShot(role))
        .first;
  }

  Future<List<Category>?> getCategoryByProduct(Product product) {
    final userCollection = _firebaseFirestore.collection('products');

    /*   cloud_firestore.QuerySnapshot<Map<String, dynamic>>  */ final categoriesQuerySnap =
        userCollection.doc(product.id).collection('categories').get();

    return categoriesQuerySnap.then((value) => value.docs
        .map((category) => Category.fromSnapShot(category))
        .toList()); /*  categoriesQuerySnap.docs
        .map((category) => Category.fromSnapShot(category))
        .toList(); */
  }

  Future<void> updateAccount(Account account) {
    return _firebaseFirestore
        .collection('accounts')
        .doc(account.id)
        .update(account.toMap());
  }

  void deleteAccount(Account account) {
    _firebaseFirestore.collection('accounts').doc(account.id).delete();
  }

  Future<void> addAccount(Account account) {
    return _firebaseFirestore.collection('accounts').add(account.toMap());
  }

  void addTransaction(financeModel.Transaction transaction) {}

  Future<void> updateTransaction(
      String key, financeModel.Transaction transaction) {
    return _firebaseFirestore
        .collection('transactions')
        .doc(key)
        .update(transaction.toMap());
  }

  void deleteTransaction(financeModel.Transaction transaction) {
    _firebaseFirestore.collection('transactions').doc(transaction.id).delete();
  }

  Stream<List<financeModel.Transaction>> getTransactions() {
    return _firebaseFirestore.collection('transactions').snapshots().map(
        (snapshot) => snapshot.docs
            .map((doc) => financeModel.Transaction.fromSnapShot(doc))
            .toList());
  }
}
