import 'dart:io';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:package_info_plus/package_info_plus.dart';

import 'package:redstar_hightech_backend/app/modules/authentication/models/user_model.dart'
    as localModel;
import 'package:redstar_hightech_backend/app/services/database_service.dart';

import '../../home/views/home_view.dart';
import '../models/permission_model.dart';
import '../models/role_model.dart';
import '../views/login_view.dart';

import 'package:crypto/crypto.dart' as crypto;
import 'dart:convert';

class AuthenticationController extends GetxController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  DatabaseService databaseService = DatabaseService();
  RxList<Role> roles = <Role>[].obs;
  Role _role = Role(name: '', description: '', id: '');

  RxList<Permission> _permissions = <Permission>[].obs;

  GoogleSignIn googleSignIn = GoogleSignIn(scopes: ['email']);
  // static final FacebookLogin facebookSsignIn = new FacebookLogin();
  Rxn<User> _firebaseUser = Rxn<User>();
  PackageInfo _packageInfo = PackageInfo(
      appName: 'Unknown',
      packageName: 'Unknown',
      version: 'Unknown',
      buildNumber: 'Unknown',
      buildSignature: 'Unknown');

  final _authenticated = false.obs;
  RxString _username = ''.obs;

  String? get userFirstName => _firebaseUser.value?.displayName;

  String? get email => _firebaseUser.value?.email;

  User? get user =>
      _auth.currentUser ?? _firebaseUser.value; //_firebaseUser.value;

  String? get imageurl => _firebaseUser.value?.photoURL;

  bool get authenticated => user != null ? true : false;

  Role get userRole => _role;

  set userRole(value) => _role = value;

  RxList<Permission> get userPermission => _permissions;

  set userPermission(value) => _permissions = value;

  set authenticated(value) => _authenticated.value = value;

  @override
  onInit() {
    _firebaseUser.bindStream(_auth.authStateChanges());

    _initPackageInfo();

    checkUserRolePermission();

    super.onInit();
  }

  checkUserRolePermission() async {
    final referenceUser = FirebaseFirestore.instance.collection("users");

    /*  print("user uid email is: ${email}");

    final ftLocalUser =
        referenceUser.where('email', isEqualTo: email).get().then((value) {
      print('user from authController:  ${value.docs.length} ');

      if (value.docs.isNotEmpty) {
        localModel.User user = localModel.User.fromSnapShot(value.docs.first);
      }
    });
 */
    final ftLocalUser = await referenceUser
        .where('email', isEqualTo: email)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => localModel.User.fromSnapShot(doc))
            .toList())
        .first;

    if (ftLocalUser.isNotEmpty) {
      String? uid = ftLocalUser[0].uid;

      final _role = await referenceUser
          .doc(uid)
          .collection('roles')
          .snapshots()
          .map((snapshot) =>
              snapshot.docs.map((doc) => Role.fromSnapShot(doc)).toList())
          .first;

      final referenceRole = FirebaseFirestore.instance.collection("roles");

      if (_role.isNotEmpty) {
        _permissions.value = (await referenceRole
                .doc(_role[0].id)
                .collection('permissions')
                .get())
            .docs
            .map((e) => Permission.fromSnapShot(e))
            .toList();
      }
    }
  }

  void login(String email, String password) async {
    await _auth
        .signInWithEmailAndPassword(email: email, password: password)
        .then((value) => Get.offAll(() => HomeView()))
        // ignore: invalid_return_type_for_catch_error
        .catchError((onError) => Get.snackbar(
            "Error while sign in ", onError.message,
            margin: const EdgeInsets.all(10),
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.orange));
  }

  void signout() async {
    await _auth.signOut().then(
        (value) => Get.offAll(() => HomeView()) /*Get.offAll(LoginView())*/

        );
  }

  void createUser(
      String firstname, String lastname, String email, String password) async {
    final reference = FirebaseFirestore.instance.collection("users");

    Map<String, dynamic> mmp = {
      "description": "Simple user",
      "id": "any",
      "name": "Staff",
      "permissionIds": []
    };

    Map<String, dynamic> userdata = {
      "buildNumber": _packageInfo.buildNumber,
      "createdAt": DateTime.now().toString(),
      "email": email.toLowerCase(),
      "lastSignInTime": DateTime.now().toString(),
      "displayName": firstname + ' ' + lastname,
      "roles": Map.castFrom(mmp),
      "photoURL": "",
      "password": generateMd5(password)
    };

    final ftLocalUser = await reference
        .where('email', isEqualTo: email.toLowerCase())
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => localModel.User.fromSnapShot(doc))
            .toList())
        .first;

    if (ftLocalUser.length == 0) {
      await _auth
          .createUserWithEmailAndPassword(
              email: email.toLowerCase(), password: password)
          .then((value) {
        reference.add(userdata).then((value) async {
          await _saveDevice(user);

          Get.offAll(() => HomeView());
        });
      }).catchError(
        (onError) =>
            Get.snackbar("Error while creating account ", onError.message),
      );
    } else {
      final userRef = reference.doc(ftLocalUser.first.uid);

      if ((await userRef.get()).exists) {
        await userRef.update({
          "lastSignInTime": DateTime.now().toString(),
          "buildNumber": _packageInfo.buildNumber
        });
      }

      _saveDevice(ftLocalUser.first);

      Get.offAll(() => HomeView());
    }
  }

  void google_signIn() async {
    try {
      final GoogleSignInAccount? googleUser = await googleSignIn.signIn();

      final GoogleSignInAuthentication googleAuth =
          await googleUser!.authentication;

      final AuthCredential credential = GoogleAuthProvider.credential(
          idToken: googleAuth.idToken, accessToken: googleAuth.accessToken);

      final user = (await _auth
          .signInWithCredential(credential)
          .then((value) => Get.offAll(() => HomeView())));
    } on Exception catch (e) {
      print(e);
    }
  }

  void google_signOut() async {
    await googleSignIn.signOut().then((value) => Get.offAll(() => LoginView()));
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {}

  Future<void> _initPackageInfo() async {
    _packageInfo = await PackageInfo.fromPlatform();
  }

  _saveDevice(dynamic user) async {
    DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();
    String deviceId = '';
    Map<String, dynamic> deviceData = {};

    if (Platform.isAndroid) {
      final deviceInfo = await deviceInfoPlugin.androidInfo;

      deviceId = deviceInfo.hardware!;
      deviceData = {
        'os_version': deviceInfo.version.sdkInt.toString(),
        'platform': "android",
        'model': deviceInfo.model,
        'device': deviceInfo.device,
      };
    }

    if (Platform.isIOS) {
      final deviceInfo = await deviceInfoPlugin.iosInfo;
      deviceId = deviceInfo.identifierForVendor!;
      deviceData = {
        'os_version': deviceInfo.systemVersion,
        'platform': "ios",
        'model': deviceInfo.model,
        'device': deviceInfo.name,
      };
    }

    final nowMl = DateTime.now().toString();

    final deviceReference = FirebaseFirestore.instance
        .collection("users")
        .doc(user.uid)
        .collection("devices");

    if ((await deviceReference.doc(deviceId).get()).exists) {
      await deviceReference
          .doc(deviceId)
          .update({'updatedAt': nowMl, 'uninstalled': false});
    } else {
      deviceReference.doc(deviceId).set({
        'updatedAt': nowMl,
        'createdAt': nowMl,
        'uninstalled': false,
        'id': deviceId,
        'deviceInfo': deviceData
      });
    }
  }

  String getRandomString(int length) {
    const characters =
        'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz01234567890';
    Random random = Random();
    return String.fromCharCodes(Iterable.generate(length,
        (_) => characters.codeUnitAt(random.nextInt(characters.length))));
  }

  ///Generate MD5 hash
  String generateMd5(String input) {
    return crypto.md5.convert(utf8.encode(input)).toString();
  }
}
