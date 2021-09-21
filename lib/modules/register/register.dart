import 'package:fdsr/component/bottom_icons.dart';
import 'package:fdsr/component/edit_text.dart';
import 'package:fdsr/component/rounded_button.dart';
import 'package:fdsr/modules/register/register_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

class Register extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final getRegisterController = Get.put(RegisterController());

    return ScreenUtilInit(
      designSize: Size(Get.width, Get.height),
      builder: () => SafeArea(
        child: Scaffold(
          backgroundColor: Colors.white,
          body: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.fromLTRB(21.w, 0, 21.w, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Image.asset(
                    "images/logo.jpg",
                  ),
                  Text(
                    'Register',
                    style:
                        TextStyle(fontSize: 31.sp, fontWeight: FontWeight.w700),
                  ),
                  SizedBox(height: 8.h),
                  EditText('Email', false, Icons.alternate_email, (data) {
                    print(data);
                  }, getRegisterController.loginController),
                  Divider(
                    color: Colors.black,
                    height: 18.h,
                    thickness: 1,
                  ),
                  EditText('Password', true, Icons.lock_outlined, (data) {
                    print(data);
                  }, getRegisterController.passwordController),
                  Divider(
                    color: Colors.black,
                    height: 18.h,
                    thickness: 1,
                  ),
                  EditText('Confirm password', true, Icons.lock_outlined,
                      (data) {
                    print(data);
                  }, getRegisterController.confirmPasswordController),
                  Divider(
                    color: Colors.black,
                    height: 18.h,
                    thickness: 1,
                  ),
                  SizedBox(height: 10.h),
                  RoundedButton('Register', () async {
                    String message =
                        await getRegisterController.performRegister();
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
                  }),
                  SizedBox(height: 10.h),
                  Row(
                    children: [
                      Expanded(
                        child: Divider(
                          color: Colors.black,
                          height: 18.h,
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
                          height: 18.h,
                          thickness: 1,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 20.h),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      BottomIcons(FontAwesomeIcons.google, () {}),
                      SizedBox(width: 20.w),
                      BottomIcons(FontAwesomeIcons.facebook, () {}),
                      SizedBox(width: 20.w),
                      BottomIcons(FontAwesomeIcons.twitter, () {}),
                      SizedBox(width: 20.w),
                      BottomIcons(FontAwesomeIcons.apple, () {}),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
