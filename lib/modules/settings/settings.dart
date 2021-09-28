import 'package:fdsr/modules/login/login.dart';
import 'package:fdsr/utils/constant.dart';
import 'package:fdsr/utils/facebook_signin.dart';
import 'package:fdsr/utils/google_signin.dart';
import 'package:fdsr/utils/signin_config.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class SettingsScreen extends StatelessWidget {
  final sharedPrefarance = GetStorage();

  @override
  Widget build(BuildContext context) {
    var logintype = sharedPrefarance.read(Constant.LOGIN_WITH);
    Size size = Get.size;

    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(title: Text('Settings')),
        body: Center(
          child: (Container(
            height: size.height *
                (size.height > 770
                    ? 0.7
                    : size.height > 670
                        ? 0.8
                        : 0.9),
            width: 500,
            child: ListView(
              children: [
                ListTile(
                  leading: Icon(FontAwesomeIcons.affiliatetheme),
                  title: Text('Change Theme'),
                  subtitle: Text('eg. dark,light Theme'),
                  onTap: () {},
                ),
                Divider(
                  thickness: 1,
                ),
                ListTile(
                  leading: Icon(FontAwesomeIcons.signOutAlt),
                  title: Text('Logout'),
                  subtitle: Text('User Logout'),
                  onTap: () async {
                    if (logintype.runtimeType == String) {
                      await sharedPrefarance.erase();
                      if (logintype == SignInConfig.GOOGLE.toString()) {
                        AppGoogleSignIn appGoogleSignIn = AppGoogleSignIn();
                        await appGoogleSignIn.handleGoogleSignOut();
                        await appGoogleSignIn.isSignin();
                      }
                      if (logintype == SignInConfig.FACEBOOK.toString()) {
                        AppFacebookSignin appGoogleSignIn = AppFacebookSignin();
                        await appGoogleSignIn.performFacebookLogout();
                        await appGoogleSignIn.isFacebookLogin();
                      }
                      if (logintype == SignInConfig.EMAIL.toString()) {
                        await FirebaseAuth.instance.signOut();
                        await Constant.isLoggedIn();
                      }
                      if (logintype == SignInConfig.TWITTER.toString()) {
                        if (kIsWeb) {
                          FirebaseAuth.instance.signOut();
                        }
                        Get.offAll(() => Login());
                      }
                    }
                  },
                ),
                Divider(
                  thickness: 1,
                ),
              ],
            ),
          )),
        ),
      ),
    );
  }
}
