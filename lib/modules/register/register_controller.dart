import 'package:fdsr/modules/dashboard/dashboard.dart';
import 'package:fdsr/utils/constant.dart';
import 'package:fdsr/utils/signin_config.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class RegisterController extends GetxController {
  static RegisterController get i => Get.find();

  FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  // ↓ place the text editing controller inside your... controller :)
  var loginController = TextEditingController();
  var passwordController = TextEditingController();
  var confirmPasswordController = TextEditingController();

  Future<String> performRegister() async {
    String message = '';
    try {
      Constant.getloaderDialog();
      UserCredential userCredential =
          await _firebaseAuth.createUserWithEmailAndPassword(
              email: loginController.text, password: passwordController.text);
      if (userCredential.user != null) {
        //message = 'Account Created Successfully..!!';
        User? user = userCredential.user;
        Get.back();
        Get.to(DashBoardScreen(),
            arguments: [SignInConfig.EMAIL, user!.email, user.uid]);
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        message = 'The password provided is too weak.';
      } else if (e.code == 'email-already-in-use') {
        message = 'The account already exists for that email.';
      }
    } catch (e) {
      message = e.toString();
    }
    Get.back();
    return message;
  }
}
