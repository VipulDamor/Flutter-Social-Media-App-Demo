import 'package:fdsr/modules/dashboard/dashboard.dart';
import 'package:fdsr/modules/login/login.dart';
import 'package:fdsr/utils/signin_config.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

const kBoldStyle = TextStyle(
    fontSize: 15, fontFamily: 'NotoSans-Bold', fontWeight: FontWeight.w700);
const kRegularStyle16 = TextStyle(fontSize: 16, fontFamily: 'NotoSans-Regular');
const kRegularStyle14 =
    TextStyle(fontSize: 14, fontFamily: 'NotoSans-Regular', color: Colors.grey);

class Constant {
  static FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  static const String LOGIN_WITH = 'loginWith';
  static const String GOOGLE_SIGNIN_EMAIL = 'googleAuthEmail';
  static const String GOOGLE_SIGNIN_ID = 'googleAuthID';

  //fireStoreKeys
  static const String KEY_POSTS = 'posts';
  static const String KEY_POST = 'post';
  static const String KEY_POST_DATE = 'postDate';
  static const String KEY_USERID = 'userID';

  static Future<User?> getFirebaseuser() async {
    return _firebaseAuth.currentUser;
  }

  static void getloaderDialog() {
    Get.dialog(AlertDialog(
      content: new Row(
        children: [
          CircularProgressIndicator(),
          SizedBox(
            width: 10,
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

  static String readTimestamp(int timestamp) {
    var now = DateTime.now();
    var format = DateFormat('HH:mm a');
    var format2 = DateFormat('DD-MMM-yyyy:HH:mm a');
    var date = DateTime.fromMillisecondsSinceEpoch(timestamp * 1000);
    var diff = now.difference(date);
    var time = '';

    /* if (diff.inSeconds <= 0 || diff.inSeconds > 0 && diff.inMinutes == 0 ||
        diff.inMinutes > 0 && diff.inHours == 0 ||
        diff.inHours > 0 && diff.inDays == 0) {
      time = format.format(date);
    } else if (diff.inDays > 0 && diff.inDays < 7) {
      if (diff.inDays == 1) {
        time = diff.inDays.toString() + ' Day AGO';
      } else {
        time = diff.inDays.toString() + ' Days ago';
      }
    } else {
      if (diff.inDays == 7) {
        time = (diff.inDays / 7).floor().toString() + ' Week ago';
      } else {
        time = (diff.inDays / 7).floor().toString() + ' WEEKS AGO';
      }
    }*/

    if (diff.inSeconds <= 0 ||
        diff.inSeconds > 0 && diff.inMinutes == 0 ||
        diff.inMinutes > 0 && diff.inHours == 0 ||
        diff.inHours > 0 && diff.inDays == 0) {
      time = format.format(date);
    } else if (diff.inMinutes > 0 && diff.inMinutes < 60) {
      time = diff.inDays.toString() + ' Min ago';
    } else if (diff.inDays > 0 && diff.inDays < 7) {
      if (diff.inDays == 1) {
        time = diff.inDays.toString() + ' Day ago';
      } else {
        time = diff.inDays.toString() + ' Days ago';
      }
    } else {
      if (diff.inDays == 7) {
        time = (diff.inDays / 7).floor().toString() + ' Week ago';
      } else {
        //time = (diff.inDays / 7).floor().toString() + ' WEEKS AGO';
        time = format2.format(date);
      }
    }

    return time;
  }
}
