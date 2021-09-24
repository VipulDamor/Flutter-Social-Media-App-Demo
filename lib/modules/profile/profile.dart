import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fdsr/component/circle_Image.dart';
import 'package:fdsr/modules/editProfile/edit_profile.dart';
import 'package:fdsr/utils/constant.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class Profile extends StatelessWidget {
  final sharedPrefarance = GetStorage();

  @override
  Widget build(BuildContext context) {
    var userID = sharedPrefarance.read(Constant.KEY_USERID);
    var UserEmail = sharedPrefarance.read(Constant.KEY_USEREMAIL);

    final Stream<QuerySnapshot> dataStream = FirebaseFirestore.instance
        .collection('posts')
        .orderBy(
          '${Constant.KEY_POST_DATE}',
          descending: true,
        )
        .where('userID', isEqualTo: userID)
        .snapshots(includeMetadataChanges: true);

    return SafeArea(
        child: Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
              onPressed: () {
                Get.to(EditProfile());
              },
              icon: Icon(Icons.edit))
        ],
        title: Text('Profile'),
      ),
      body: Container(
        padding: EdgeInsets.all(14),
        child: ListView(
          physics: BouncingScrollPhysics(),
          children: [
            Center(
              child: Stack(
                children: [
                  CirCleImage(
                    height: 130,
                    width: 130,
                    borderRadious: 110,
                  ),
                  Positioned(
                      bottom: 0,
                      right: 10,
                      child: CircleAvatar(
                        backgroundColor: Colors.grey.shade300,
                        child: Icon(
                          Icons.camera_alt,
                          size: 20,
                        ),
                      ))
                ],
              ),
            ),
            Center(
              child: Text(
                'User Name',
                style: kRegularStyle16.copyWith(
                    fontWeight: FontWeight.w700, fontSize: 20),
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
              onTap: () {},
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
    ));
  }
}
