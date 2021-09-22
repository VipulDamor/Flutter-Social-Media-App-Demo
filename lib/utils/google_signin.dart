import 'package:fdsr/modules/dashboard/dashboard.dart';
import 'package:fdsr/modules/login/login.dart';
import 'package:fdsr/utils/signin_config.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_sign_in/google_sign_in.dart';

import 'constant.dart';

class AppGoogleSignIn {
  GoogleSignIn _signIn = GoogleSignIn();
  final sharedPrefarance = GetStorage();

  Future<void> handleGooleSignIn() async {
    try {
      GoogleSignInAccount? googleSignInAccount = await _signIn.signIn();
      print(googleSignInAccount!.email);

      //todo for external use
      /*GoogleSignInAuthentication googleSignInAuthentication =
          await googleSignInAccount!.authentication;

      AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleSignInAuthentication.accessToken,
        idToken: googleSignInAuthentication.idToken,
      );

      UserCredential authResult =
          await FirebaseAuth.instance.signInWithCredential(credential);

      User? _user = authResult.user;

      print("User Name: ${_user!.displayName}");
      print("User Email ${_user.email}");*/

    } catch (error) {
      print(error);
    }
  }

  Future<void> handleGooleSignInd() async {
    try {
      _signIn.signIn();
    } catch (error) {
      print(error);
    }
  }

  Future<void> handleGoogleSignOut() => _signIn.signOut();

  Future<void> isSignin() async {
    if (await _signIn.isSignedIn()) {
      print('yes sign in');

      GoogleSignInAccount? googleSignInAccount = _signIn.currentUser;

      if (googleSignInAccount != null) {
        //print('user not null ${googleSignInAccount()}');
        sharedPrefarance.write(
            Constant.GOOGLE_SIGNIN_EMAIL, googleSignInAccount.email);
        sharedPrefarance.write(
            Constant.GOOGLE_SIGNIN_ID, googleSignInAccount.id);

        Get.off(() => DashBoardScreen(), arguments: [
          SignInConfig.GOOGLE,
          googleSignInAccount.email,
          googleSignInAccount.id,
        ]);
      } else {
        var email = sharedPrefarance.read(Constant.GOOGLE_SIGNIN_EMAIL);
        var id = sharedPrefarance.read(Constant.GOOGLE_SIGNIN_ID);

        print(email.runtimeType);

        if (email.runtimeType == String) {
          Get.off(() => DashBoardScreen(), arguments: [
            SignInConfig.GOOGLE,
            email,
            id,
          ]);
        } else {
          print('user   ${googleSignInAccount}');
          if (!Get.currentRoute.endsWith('Login')) {
            Get.off(() => Login());
          }
        }
      }
      //todo this method is not working like email login
      /*_signIn.onCurrentUserChanged.listen((GoogleSignInAccount? account) {
        if (account != null) {
          Get.off(() => DashBoardScreen(), arguments: [
            SignInConfig.GOOGLE,
            _signIn.currentUser!.email,
            _signIn.currentUser!.id,
          ]);
        } else {
          if (!Get.currentRoute.endsWith('Login')) {
            Get.off(() => Login());
          }
        }
      });*/
    } else {
      print('yes sign out');
      if (!Get.currentRoute.endsWith('Login')) {
        Get.off(() => Login());
      }
    }
  }
}
