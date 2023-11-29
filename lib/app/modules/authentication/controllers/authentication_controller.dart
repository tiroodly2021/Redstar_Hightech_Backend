import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../../home/views/home_view.dart';
import '../views/login_view.dart';

class AuthenticationController extends GetxController {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  GoogleSignIn googleSignIn = GoogleSignIn(scopes: ['email']);
  // static final FacebookLogin facebookSsignIn = new FacebookLogin();
  Rxn<User> _firebaseUser = Rxn<User>();

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
    CollectionReference reference =
        FirebaseFirestore.instance.collection("Users");

    Map<String, String> userdata = {
      "First Name": firstname,
      "Last Name": lastname,
      "Email": email
    };

    await _auth
        .createUserWithEmailAndPassword(email: email, password: password)
        .then((value) {
      reference.add(userdata).then((value) => Get.offAll(() => LoginView()));
    }).catchError(
      (onError) =>
          Get.snackbar("Error while creating account ", onError.message),
    );
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

    print(" Auth Change :   ${_auth.currentUser}");

    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {}
}
