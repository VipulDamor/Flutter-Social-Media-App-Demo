import 'package:fdsr/modules/dashboard/dashboard.dart';
import 'package:fdsr/utils/constant.dart';
import 'package:fdsr/utils/signin_config.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LoginController extends GetxController {
  FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  static LoginController get i => Get.find();

  var loginEmailController = TextEditingController();
  var loginPasswordController = TextEditingController();

  Future<User?> getFirebaseuser() async {
    return _firebaseAuth.currentUser;
  }

  Future<String> performEmailLogin() async {
    String message = '';
    Constant.getloaderDialog();
    try {
      UserCredential userCredential =
          await _firebaseAuth.signInWithEmailAndPassword(
              email: loginEmailController.text.trim(),
              password: loginPasswordController.text);

      if (userCredential.user != null) {
        message = '';
        Get.back();
        Get.off(() => DashBoardScreen(), arguments: [
          SignInConfig.EMAIL,
          userCredential.user!.email.toString(),
          userCredential.user!.uid.toString()
        ]);
      } else {
        message = 'Login Failed';
      }
    } on FirebaseAuthException catch (e) {
      print(e);
      print(e.code);
      if (e.code == 'user-not-found') {
        message = 'No user found for that email.';
      } else if (e.code == 'wrong-password') {
        message = 'Wrong password provided for that user.';
      } else {
        message = e.toString();
      }
      Get.back();
    }
    return message;
  }
}
