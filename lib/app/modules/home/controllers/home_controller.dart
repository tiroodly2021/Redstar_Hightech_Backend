import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:get/get.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:firebase_auth/firebase_auth.dart';

class HomeController extends GetxController {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  final Rxn<User> _firebaseUser = Rxn<User>();

  PackageInfo _packageInfo = PackageInfo(
      appName: 'Unknown',
      packageName: 'Unknown',
      version: 'Unknown',
      buildNumber: 'Unknown',
      buildSignature: 'Unknown');

  static final DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();
  Map<String, dynamic> _deviceData = <String, dynamic>{};

  @override
  void onInit() {
    _firebaseUser.bindStream(_auth.authStateChanges());
    //_initPackageInfo();

    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {}

/*   saveOrUpdateUser() async {
    CollectionReference reference =
        FirebaseFirestore.instance.collection("users");

    var user = _firebaseUser.value;

    final userRef = reference.doc(user!.uid);

    print('user exit = ' + (await userRef.get()).exists.toString());

    if ((await userRef.get()).exists) {
      print("User already exist!");
      await userRef.update({
        "lastSignInTime":
            user.metadata.lastSignInTime!.microsecondsSinceEpoch.toString(),
        "buildNumber": _packageInfo.buildNumber
      });
    }
    await _saveDevice(user);
  } */

  /*  Future<void> _initPackageInfo() async {
    _packageInfo = await PackageInfo.fromPlatform();
  } */

}
