import 'package:fdsr/component/bottom_icons.dart';
import 'package:fdsr/component/edit_text.dart';
import 'package:fdsr/component/rounded_button.dart';
import 'package:fdsr/modules/register/register_controller.dart';
import 'package:fdsr/utils/facebook_signin.dart';
import 'package:fdsr/utils/google_signin.dart';
import 'package:fdsr/utils/twitter_signin.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

class Register extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final getRegisterController = Get.put(RegisterController());
    Size size = Get.size;

    return SafeArea(
        child: Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Container(
          height: size.height *
              (size.height > 770
                  ? 0.7
                  : size.height > 670
                      ? 0.8
                      : 0.9),
          width: 500,
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.fromLTRB(21, 0, 21, 0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Image.asset(
                    "images/logo.jpg",
                    width: 160,
                    height: 160,
                  ),
                  Text(
                    'Register',
                    style: TextStyle(fontSize: 31, fontWeight: FontWeight.w700),
                  ),
                  SizedBox(height: 8),
                  EditText(
                    'Email',
                    false,
                    Icons.alternate_email,
                    (data) {
                      print(data);
                    },
                    getRegisterController.loginController,
                    textInputType: TextInputType.emailAddress,
                  ),
                  Divider(
                    color: Colors.black,
                    height: 18,
                    thickness: 1,
                  ),
                  EditText(
                    'Password',
                    true,
                    Icons.lock_outlined,
                    (data) {
                      print(data);
                    },
                    getRegisterController.passwordController,
                  ),
                  Divider(
                    color: Colors.black,
                    height: 18,
                    thickness: 1,
                  ),
                  EditText(
                    'Confirm password',
                    true,
                    Icons.lock_outlined,
                    (data) {
                      print(data);
                    },
                    getRegisterController.confirmPasswordController,
                  ),
                  Divider(
                    color: Colors.black,
                    height: 18,
                    thickness: 1,
                  ),
                  SizedBox(height: 10),
                  RoundedButton('Register', () async {
                    String message =
                        await getRegisterController.performRegister();
                    if (message.isNotEmpty) {
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
                  }),
                  SizedBox(height: 10),
                  Row(
                    children: [
                      Expanded(
                        child: Divider(
                          color: Colors.black,
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
                          color: Colors.black,
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
                        await AppTwitterSignin().performTwitterSignin();
                      }),
                      /*SizedBox(width: 20),
                      BottomIcons(FontAwesomeIcons.apple, () {}),*/
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    ));
  }
}
