import 'package:fdsr/modules/login/login.dart';
import 'package:fdsr/utils/app_firestore.dart';
import 'package:fdsr/utils/constant.dart';
import 'package:fdsr/utils/facebook_signin.dart';
import 'package:fdsr/utils/google_signin.dart';
import 'package:fdsr/utils/signin_config.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import 'list_data.dart';

class DashBoardScreen extends StatefulWidget {
  @override
  State<DashBoardScreen> createState() => _DashBoardScreenState();
}

class _DashBoardScreenState extends State<DashBoardScreen> {
  String email = '', signInType = '', userID = '';

  var config = Get.arguments;
  final sharedPrefarance = GetStorage();

  @override
  void initState() {
    config = Get.arguments;
    print('arguments : $config');

    sharedPrefarance.write(Constant.LOGIN_WITH, config[0].toString());

    signInType = config[0].toString().split('.').last;
    email = config[1];
    userID = config[2];

    //todo may need in future work
    /*switch (config[0]) {
      case SignInConfig.EMAIL:

        break;
      case SignInConfig.GOOGLE:
        email = config[1];
        // TODO: Handle this case.
        break;
      case SignInConfig.FACEBOOK:
        email = config[1];
        // TODO: Handle this case.
        break;
      case SignInConfig.TWITTER:
        email = config[1];
        // TODO: Handle this case.
        break;
    }*/
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            createPost(userID);
          },
          child: Icon(FontAwesomeIcons.plus),
        ),
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: (Text('Login With $signInType')),
          actions: [
            IconButton(
                onPressed: () async {
                  if (config[0] == SignInConfig.EMAIL) {
                    await FirebaseAuth.instance.signOut();
                    await Constant.isLoggedIn();
                  } else if (config[0] == SignInConfig.GOOGLE) {
                    AppGoogleSignIn appGoogleSignIn = AppGoogleSignIn();
                    await appGoogleSignIn.handleGoogleSignOut();
                    await appGoogleSignIn.isSignin();
                  } else if (config[0] == SignInConfig.FACEBOOK) {
                    AppFacebookSignin appGoogleSignIn = AppFacebookSignin();
                    await appGoogleSignIn.performFacebookLogout();
                    await appGoogleSignIn.isFacebookLogin();
                  } else if (config[0] == SignInConfig.APPLE) {
                  } else if (config[0] == SignInConfig.TWITTER) {
                    await sharedPrefarance.erase();
                    Get.off(() => Login());
                  }
                },
                icon: Icon(FontAwesomeIcons.signOutAlt))
          ],
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: Colors.indigo,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: EdgeInsets.all(8),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(60),
                          child: Image.asset(
                            'images/logo.jpg',
                            width: 48,
                            height: 48,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 2,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              email,
                              style:
                                  TextStyle(fontSize: 16, color: Colors.white),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
                ListData(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void createPost(String userID) {
    String post = '';
    showModalBottomSheet(
        context: context,
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(25.0)),
        ),
        builder: (BuildContext context) {
          return Padding(
            padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom),
            child: SingleChildScrollView(
              padding: EdgeInsets.all(24),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                    ),
                    height: 5 * 24.0,
                    child: TextField(
                      maxLines: 5,
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.all(8),
                        hintText: "Type your awesome Thought here..",
                        border: InputBorder.none,
                      ),
                      onChanged: (value) {
                        post = value;
                      },
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  ActionChip(
                      backgroundColor: Colors.indigo,
                      elevation: 5.0,
                      label: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.send,
                            color: Colors.white,
                          ),
                          SizedBox(
                            width: 18,
                            height: 38,
                          ),
                          Text(
                            'Publish Post',
                            style: TextStyle(color: Colors.white),
                          )
                        ],
                      ),
                      onPressed: () async {
                        if (post.toString().trim() != '') {
                          await AppFireStore().addPostToFirebase(post, userID);
                          Get.back();
                        }
                      }),
                ],
              ),
            ),
          );
        });
  }
}
