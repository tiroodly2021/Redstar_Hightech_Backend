import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:package_info_plus/package_info_plus.dart';

import '../../home/views/home_view.dart';
import '../views/login_view.dart';

class AuthenticationController extends GetxController {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  GoogleSignIn googleSignIn = GoogleSignIn(scopes: ['email']);
  // static final FacebookLogin facebookSsignIn = new FacebookLogin();
  Rxn<User> _firebaseUser = Rxn<User>();
  PackageInfo _packageInfo = PackageInfo(
      appName: 'Unknown',
      packageName: 'Unknown',
      version: 'Unknown',
      buildNumber: 'Unknown',
      buildSignature: 'Unknown');

  String? get userFirstName => _firebaseUser.value?.displayName;
  String? get email => _firebaseUser.value?.email;
  User? get user => _firebaseUser.value;
  String? get imageurl => _firebaseUser.value?.photoURL;

  void login(String email, String password) async {
    await _auth
        .signInWithEmailAndPassword(email: email, password: password)
        .then((value) => Get.offAll(() => HomeView()))
        .catchError(
            (onError) => Get.snackbar("Error while sign in ", onError.message));
  }

  void signout() async {
    await _auth.signOut().then(
        (value) => Get.offAll(() => HomeView()) /*Get.offAll(LoginView())*/

        );
  }

  void createUser(
      String firstname, String lastname, String email, String password) async {
    final reference = FirebaseFirestore.instance.collection("users");

    Map<String, String> userdata = {
      "buildNumber": _packageInfo.buildNumber,
      "createdAt": DateTime.now().toString(),
      "email": email,
      "lastSignInTime": DateTime.now().toString(),
      "displayName": firstname + ' ' + lastname,
      "role": 'user',
    };

    bool testUser =
        await reference.where('email', isEqualTo: email).snapshots().isEmpty;

    if (testUser) {
      await _auth
          .createUserWithEmailAndPassword(email: email, password: password)
          .then((value) {
        reference.add(userdata).then((value) {
          _saveDevice(user!);

          Get.offAll(() => HomeView());
        });
      }).catchError(
        (onError) =>
            Get.snackbar("Error while creating account ", onError.message),
      );
    } else {
      final userRef = reference.doc(user!.uid);

      print('user exit = ' + (await userRef.get()).exists.toString());

      if ((await userRef.get()).exists) {
        print("User already exist!");
        await userRef.update({
          "lastSignInTime":
              user!.metadata.lastSignInTime!.microsecondsSinceEpoch.toString(),
          "buildNumber": _packageInfo.buildNumber
        });
      }

      _saveDevice(user!);

      Get.offAll(() => HomeView());
    }
  }

  void google_signIn() async {
    try {
      final GoogleSignInAccount? googleUser = await googleSignIn.signIn();

      print(googleUser);

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
  void onInit() {
    _firebaseUser.bindStream(_auth.authStateChanges());

    _initPackageInfo();

    print(" Auth Change :   ${_auth.currentUser}");

    super.onInit();
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

  _saveDevice(User user) async {
    DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();
    String deviceId = '';
    Map<String, dynamic> deviceData = {};

    if (Platform.isAndroid) {
      final deviceInfo = await deviceInfoPlugin.androidInfo;
      deviceId =
          deviceInfo.androidId != null ? deviceInfo.androidId! : 'unknown';
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

    final nowMl = DateTime.now().millisecondsSinceEpoch.toString();
    final deviceReference = FirebaseFirestore.instance
        .collection("users")
        .doc(user.uid)
        .collection("devices")
        .doc(deviceId);

    if ((await deviceReference.get()).exists) {
      await deviceReference.update({'updatedAt': nowMl, 'uninstalled': false});
    } else {
      deviceReference.set({
        'updatedAt': nowMl,
        'createdAt': nowMl,
        'uninstalled': false,
        'id': deviceId,
        'deviceInfo': deviceData
      });
    }
  }
}
