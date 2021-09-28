import 'package:fdsr/component/circle_Image.dart';
import 'package:fdsr/models/user.dart';
import 'package:fdsr/modules/editProfile/edit_profile.dart';
import 'package:fdsr/modules/profile/profile.dart';
import 'package:fdsr/modules/profile/profile_controller.dart';
import 'package:fdsr/modules/settings/settings.dart';
import 'package:fdsr/utils/app_firestore.dart';
import 'package:fdsr/utils/constant.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
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
  final profileController = Get.put(ProfileController());

  @override
  void initState() {
    config = Get.arguments;

    signInType = config[0].toString().split('.').last;
    email = config[1];
    userID = config[2];
    profileController.getUser(userID);

    sharedPrefarance.write(Constant.LOGIN_WITH, config[0].toString());
    sharedPrefarance.write(Constant.KEY_USERID, userID);
    sharedPrefarance.write(Constant.KEY_USEREMAIL, email);

    getUser();

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
    Size size = Get.size;

    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            createPost(userID);
          },
          child: Icon(FontAwesomeIcons.plus),
        ),
        backgroundColor: Colors.blue,
        appBar: AppBar(
          title: (Text('Login With $signInType')),
          actions: [
            IconButton(
                onPressed: () {
                  Get.to(SettingsScreen());
                },
                icon: Icon(Icons.settings))
          ],
        ),
        body: Center(
          child: Container(
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.all(4),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      InkWell(
                        onTap: () {
                          Get.to(() => Profile());
                        },
                        child: Container(
                          margin: EdgeInsets.only(top: 4),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            color: Colors.indigo,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Obx(
                                () => profileController.userPhoto != ''
                                    ? CirCleImage(
                                        imagePath:
                                            '${profileController.userPhoto.value}',
                                        from: Constant.IMAGE_FROM_NETWORK)
                                    : CirCleImage(),
                              ),
                              Expanded(
                                flex: 2,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Obx(() => Text(
                                          '${profileController.userName}',
                                          style: TextStyle(
                                              fontSize: 16,
                                              color: Colors.white,
                                              fontWeight: FontWeight.w700),
                                        )),
                                    Text(
                                      email,
                                      style: TextStyle(
                                          fontSize: 14, color: Colors.white),
                                    ),
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  flex: 10,
                  child: Container(
                    padding: EdgeInsets.fromLTRB(21, 10, 21, 30),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(color: Colors.grey),
                      //borderRadius: BorderRadius.all(Radius.circular(30)),
                      borderRadius: BorderRadius.only(
                          topRight: Radius.circular(30),
                          topLeft: Radius.circular(30)),
                    ),
                    child: ListData(),
                  ),
                ),
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
                          await AppFireStore.addPostToFirebase(
                              post, userID, profileController.userName.value);
                          Get.back();
                        }
                      }),
                ],
              ),
            ),
          );
        });
  }

  void getUser() async {
    User user = await AppFireStore.getUsersInfo(userID);
    print('aaafreshUser : ${user.userName}');
    if (user.userName.isEmpty) {
      Get.to(() => EditProfile());
    }
  }
}

class TopChipCategory extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: ListView.builder(
        shrinkWrap: true,
        scrollDirection: Axis.horizontal,
        itemCount: 10,
        itemBuilder: (context, index) {
          return Row(
            children: [
              ActionChip(
                backgroundColor: Colors.white,
                label: Text('category $index'),
                onPressed: () {
                  print('$index got clicked');
                },
              ),
              SizedBox(
                width: 8,
              )
            ],
          );
        },
      ),
    );
  }
}
