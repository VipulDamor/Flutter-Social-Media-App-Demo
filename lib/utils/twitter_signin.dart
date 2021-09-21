import 'package:fdsr/modules/dashboard/dashboard.dart';
import 'package:fdsr/utils/constant.dart';
import 'package:fdsr/utils/signin_config.dart';
import 'package:flutter/scheduler.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:twitter_login/twitter_login.dart';

class AppTwitterSignin {
  final API_KEY = 'gGIuXDhDUaPT09TDcoKF0WpX6';
  final API_SECRET_KEY = 't00Swzubrp09HBA0Pd9ZhuamEJWyULP1KHKOu8m0rzmH7z5lbW';
  final sharedPrefarance = GetStorage();

  Future<void> performTwitterSignin() async {
    final twitterLogin = TwitterLogin(
      apiKey: API_KEY,
      apiSecretKey: API_SECRET_KEY,
      redirectURI: 'fdsr://',
    );
    final authResult = await twitterLogin.login();

    print(authResult);
    switch (authResult.status) {
      case TwitterLoginStatus.loggedIn:
        /*print(authResult.user!.email);
        print(authResult.user!.name);*/
        // success
        String email = authResult.user!.email.toString();
        String id = authResult.user!.id.toString();

        sharedPrefarance.write(Constant.GOOGLE_SIGNIN_EMAIL, email);
        sharedPrefarance.write(Constant.GOOGLE_SIGNIN_ID, id);

        Get.off(() => DashBoardScreen(),
            arguments: [SignInConfig.TWITTER, email, id]);

        print('====== Login success ======');
        break;
      case TwitterLoginStatus.cancelledByUser:
        // cancel
        print('====== Login cancel ======');
        break;
      case TwitterLoginStatus.error:
      case null:
        // error
        print('====== Login error ======');
        break;
    }
  }

  Future<void> isAppTwitterSignin() async {
    try {
      final id = sharedPrefarance.read(Constant.GOOGLE_SIGNIN_ID);
      final email = sharedPrefarance.read(Constant.GOOGLE_SIGNIN_EMAIL);

      print('twitter data : $id and  $email');

      SchedulerBinding.instance!.addPostFrameCallback((_) {
        Get.off(() => DashBoardScreen(),
            arguments: [SignInConfig.TWITTER, email, id]);
      });
    } catch (error) {
      print(error);
    }
  }
}
