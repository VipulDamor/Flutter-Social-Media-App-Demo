import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fdsr/component/circle_Image.dart';
import 'package:fdsr/modules/editProfile/edit_profile.dart';
import 'package:fdsr/modules/profile/profile_controller.dart';
import 'package:fdsr/utils/app_firestore.dart';
import 'package:fdsr/utils/constant.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

/*class Profile extends StatefulWidget {
  const Profile({Key? key}) : super(key: key);

  @override
  _ProfileState createState() => _ProfileState();
}*/

/*class _ProfileState extends State<Profile> {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}*/

class Profile extends StatelessWidget {
  final sharedPrefarance = GetStorage();
  String _userName = '';
  final profileController = Get.put(ProfileController());

  @override
  Widget build(BuildContext context) {
    var userID = sharedPrefarance.read(Constant.KEY_USERID);
    var UserEmail = sharedPrefarance.read(Constant.KEY_USEREMAIL);
    Size size = Get.size;
    profileController.getUser(userID);

    final Stream<QuerySnapshot> dataStream = AppFireStore.posts
        .orderBy(
          '${Constant.KEY_POST_DATE}',
          descending: true,
        )
        .where('${Constant.KEY_USERID}', isEqualTo: userID)
        .snapshots(includeMetadataChanges: true);

    return SafeArea(
        child: Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
      ),
      body: Center(
        child: Container(
          height: size.height *
              (size.height > 770
                  ? 0.7
                  : size.height > 670
                      ? 0.8
                      : 0.9),
          width: 500,
          padding: EdgeInsets.all(14),
          child: ListView(
            physics: BouncingScrollPhysics(),
            children: [
              Center(
                child: Stack(
                  children: [
                    Obx(
                      () => profileController.userPhoto != ''
                          ? CirCleImage(
                              height: 130,
                              width: 130,
                              borderRadious: 110,
                              imagePath: '${profileController.userPhoto.value}',
                              from: Constant.IMAGE_FROM_NETWORK)
                          : CirCleImage(
                              height: 130,
                              width: 130,
                              borderRadious: 110,
                              imagePath: '${profileController.imagepath.value}',
                              from: Constant.IMAGE_FROM_STORAGE,
                            ),
                    ),
                    Positioned(
                        bottom: 0,
                        right: 10,
                        child: InkWell(
                          onTap: () async {
                            profileController.getImage(
                                userID, profileController.controllerUser.refID);
                          },
                          child: CircleAvatar(
                            backgroundColor: Colors.grey.shade300,
                            child: Icon(
                              Icons.camera_alt,
                              size: 20,
                            ),
                          ),
                        ))
                  ],
                ),
              ),
              Center(
                child: Obx(
                  () => Text(
                    '${profileController.userName}',
                    style: kRegularStyle16.copyWith(
                        fontWeight: FontWeight.w700, fontSize: 20),
                  ),
                ),
              ),
              Center(
                child: Text(
                  UserEmail,
                  style: kRegularStyle14,
                ),
              ),
              Divider(
                thickness: 1,
              ),
              InkWell(
                onTap: () {
                  Get.to(() => EditProfile());
                },
                child: Row(
                  children: [
                    Icon(Icons.more_horiz_outlined),
                    SizedBox(
                      width: 20,
                    ),
                    Text(
                      'Update About Info.',
                      style: kRegularStyle16,
                    )
                  ],
                ),
              ),
              Divider(
                thickness: 2,
              ),
              StreamBuilder(
                stream: dataStream,
                builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.hasError) {
                    return Text('Something went wrong');
                  }
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Text("Loading");
                  }
                  List<QueryDocumentSnapshot<dynamic>> dataList =
                      snapshot.data!.docs;

                  return ListView.builder(
                    physics: BouncingScrollPhysics(
                        parent: AlwaysScrollableScrollPhysics()),
                    shrinkWrap: true,
                    itemCount: dataList.length,
                    itemBuilder: (BuildContext context, int index) {
                      DocumentSnapshot data = dataList[index];

                      return Padding(
                        padding: EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              data['${Constant.KEY_POST}'],
                              style: kRegularStyle16,
                            ),
                            Divider(
                              color: Colors.grey,
                              thickness: 0.5,
                            ),
                          ],
                        ),
                      );
                    },
                  );
                },
              )
            ],
          ),
        ),
      ),
    ));
  }

/*void getUser(String userID) async {
    User user = await AppFireStore.getUsersInfo(userID);
    profileController.userName = user.userName.obs;
    _userName = user.userName;
  }*/
}
