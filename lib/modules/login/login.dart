import 'package:fdsr/component/bottom_icons.dart';
import 'package:fdsr/component/edit_text.dart';
import 'package:fdsr/component/rounded_button.dart';
import 'package:fdsr/modules/register/register.dart';
import 'package:fdsr/utils/constant.dart';
import 'package:fdsr/utils/facebook_signin.dart';
import 'package:fdsr/utils/google_signin.dart';
import 'package:fdsr/utils/signin_config.dart';
import 'package:fdsr/utils/twitter_signin.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import 'login_controller.dart';

class Login extends StatelessWidget {
  final getLoginController = Get.put(LoginController());
  final sharedPrefarance = GetStorage();

  @override
  build(BuildContext context) {
    var config = sharedPrefarance.read(Constant.LOGIN_WITH);

    print('runtimeType ${config.runtimeType}');
    print('runtimeType $config');

    if (config.runtimeType == String) {
      if (config == SignInConfig.GOOGLE.toString()) {
        AppGoogleSignIn().isSignin();
      }
      if (config == SignInConfig.FACEBOOK.toString()) {
        AppFacebookSignin().isFacebookLogin();
      }
      if (config == SignInConfig.EMAIL.toString()) {
        Constant.isLoggedIn();
      }
      if (config == SignInConfig.TWITTER.toString()) {
        print('coming here');
        AppTwitterSignin().isAppTwitterSignin();
      }
    }

    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.fromLTRB(21, 0, 21, 0),
          child: Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Image.asset("images/logo.jpg"),
                Text(
                  'Login',
                  style: TextStyle(fontSize: 31, fontWeight: FontWeight.w700),
                ),
                SizedBox(height: 8),
                EditText('email', false, Icons.alternate_email, (data) {
                  print(data);
                }, getLoginController.loginEmailController),
                Divider(
                  color: Colors.black,
                  height: 18,
                ),
                EditText('password', true, Icons.lock_outlined, (data) {
                  print(data);
                }, getLoginController.loginPasswordController),
                Divider(
                  color: Colors.black,
                  height: 18,
                ),
                SizedBox(height: 10),
                RoundedButton('Login', () async {
                  //button click
                  String message = await getLoginController.performEmailLogin();
                  showAlertDialog(message);
                }),
                SizedBox(height: 20),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Divider(
                        color: Colors.grey,
                        height: 18,
                        thickness: 1,
                      ),
                    ),
                    Expanded(
                        flex: 2,
                        child: Text(
                          'Or sign in with',
                          textAlign: TextAlign.center,
                        )),
                    Expanded(
                      child: Divider(
                        color: Colors.grey,
                        height: 18,
                        thickness: 1,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    BottomIcons(FontAwesomeIcons.google, () async {
                      AppGoogleSignIn appGoogleSignIn = AppGoogleSignIn();
                      await appGoogleSignIn.handleGooleSignIn();
                      await appGoogleSignIn.isSignin();
                    }),
                    SizedBox(width: 20),
                    BottomIcons(FontAwesomeIcons.facebook, () {
                      AppFacebookSignin().performFacebookLogin();
                    }),
                    SizedBox(width: 20),
                    BottomIcons(FontAwesomeIcons.twitter, () async {
                      AppTwitterSignin().performTwitterSignin();
                    }),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text('New User ?'),
                    TextButton(
                      onPressed: () {
                        Get.to(() => Register());
                      },
                      child: Text(
                        ' Register',
                        style: TextStyle(color: Colors.indigo),
                      ),
                    )
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  void showAlertDialog(String message) {
    if (message != '') {
      Get.dialog(
        AlertDialog(
          content: Text(message),
          actions: [
            TextButton(
                onPressed: () {
                  Get.back();
                },
                child: Text('ok'))
          ],
        ),
      );
    }
  }
}
