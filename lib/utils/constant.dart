import 'package:fdsr/modules/dashboard/dashboard.dart';
import 'package:fdsr/modules/login/login.dart';
import 'package:fdsr/utils/signin_config.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class Constant {
  static FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  static const String LOGIN_WITH = 'loginWith';
  static const String GOOGLE_SIGNIN_EMAIL = 'googleAuthEmail';
  static const String GOOGLE_SIGNIN_ID = 'googleAuthID';

  //fireStoreKeys
  static const String KEY_POSTS = 'posts';
  static const String KEY_POST = 'post';
  static const String KEY_POST_DATE = 'postDate';

  static Future<User?> getFirebaseuser() async {
    return _firebaseAuth.currentUser;
  }

  static void getloaderDialog() {
    Get.dialog(AlertDialog(
      content: new Row(
        children: [
          CircularProgressIndicator(),
          SizedBox(
            width: 10.w,
          ),
          Container(
              margin: EdgeInsets.only(left: 5), child: Text("Loading...")),
        ],
      ),
    ));
  }

  //todo signin check for email login
  static Future<void> isLoggedIn() async {
    _firebaseAuth.userChanges().listen((User? user) async {
      if (user == null) {
        //print('User is currently signed out!');
        if (!Get.currentRoute.endsWith('Login')) {
          Get.off(() => Login());
        }
      } else {
        //print('User is signed in!');
        Get.off(() => DashBoardScreen(),
            arguments: [SignInConfig.EMAIL, user.email, user.uid]);
      }
    });
  }
}
