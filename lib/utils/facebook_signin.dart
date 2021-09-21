import 'package:fdsr/modules/dashboard/dashboard.dart';
import 'package:fdsr/modules/login/login.dart';
import 'package:fdsr/utils/signin_config.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:get/get.dart';

class AppFacebookSignin {
  void performFacebookLogin() async {
    final LoginResult result = await FacebookAuth.instance.login(
      permissions: [
        'public_profile',
        'email',
      ],
    );
    if (result.status == LoginStatus.success) {
      await isFacebookLogin();
    }
  }

  Future<void> isFacebookLogin() async {
    if (await FacebookAuth.instance.accessToken != null) {
      print(await FacebookAuth.instance.accessToken);
      // user is logged
      var userData = await FacebookAuth.instance.getUserData();
      print(userData);
      String email = userData['name'];
      String id = userData['id'];
      Get.off(DashBoardScreen(), arguments: [SignInConfig.FACEBOOK, email, id]);
    } else {
      if (!Get.currentRoute.endsWith('Login')) {
        Get.off(() => Login());
      }
    }
  }

  Future<void> performFacebookLogout() async {
    await FacebookAuth.instance.logOut();
  }
}
