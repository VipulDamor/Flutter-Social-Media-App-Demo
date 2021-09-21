import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/route_manager.dart';

import '../login/login.dart';

class SplashScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    print('height:  ${Get.height.toInt()} width : ${Get.width.toInt()}');
    callSecondScreen();
    return ScreenUtilInit(
      designSize: Size(Get.width, Get.height),
      builder: () => SafeArea(
        child: Scaffold(
          body: Center(
            child: Container(
                height: 140.h,
                width: 140.w,
                child: Image.asset('images/logo_flutter.png')),
          ),
        ),
      ),
    );
  }

  callSecondScreen() {
    Timer(Duration(seconds: 3), () => Get.off(() => Login()));
  }
}
