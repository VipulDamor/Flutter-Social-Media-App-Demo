import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fdsr/component/circle_Image.dart';
import 'package:fdsr/utils/app_firestore.dart';
import 'package:fdsr/utils/constant.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:timeago/timeago.dart' as timeago;

class ListData extends StatelessWidget {
  final Stream<QuerySnapshot> fireStoreData = AppFireStore.posts
      .orderBy(
        '${Constant.KEY_POST_DATE}',
        descending: true,
      )
      .snapshots();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: fireStoreData,
      builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return Text('Something went wrong');
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Text("Loading");
        }
        List<QueryDocumentSnapshot<dynamic>> dataList = snapshot.data!.docs;
        return dataList.isNotEmpty
            ? Container(
                child: ListView.builder(
                  padding: EdgeInsets.zero,
                  physics: BouncingScrollPhysics(
                      parent: AlwaysScrollableScrollPhysics()),
                  shrinkWrap: true,
                  itemCount: dataList.length,
                  itemBuilder: (context, index) {
                    DocumentSnapshot data = dataList[index];

                    Timestamp timestamp = data['${Constant.KEY_POST_DATE}'];
                    DateTime date = Timestamp.fromMillisecondsSinceEpoch(
                            timestamp.millisecondsSinceEpoch)
                        .toDate();

                    String userID = data['${Constant.KEY_USERID}'].toString();

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        getUserData(userID, date),
                        SizedBox(
                          height: 10,
                        ),
                        Text(
                          data['${Constant.KEY_POST}'],
                          style: kRegularStyle16,
                        ),
                        Divider(
                          color: Colors.grey,
                          thickness: 0.5,
                        ),
                      ],
                    );
                  },
                ),
              )
            : Center(child: Text("No Data Found"));
      },
    );
  }

  getRowData(String imageUrl, String userName, DateTime date) {
    return Row(
      children: [
        imageUrl == ''
            ? CirCleImage(
                width: 36,
                height: 36,
              )
            : CirCleImage(
                width: 36,
                height: 36,
                imagePath: imageUrl,
                from: Constant.IMAGE_FROM_NETWORK,
              ),
        SizedBox(
          width: 16,
        ),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                userName,
                style: kBoldStyle,
              ),
              Text(
                timeago.format(date, locale: 'en_short'),
                style: kRegularStyle14,
              ),
            ],
          ),
        )
      ],
    );
  }

  getUserData(String userID, DateTime date) {
    return StreamBuilder(
        stream: AppFireStore.user.where('uID', isEqualTo: userID).snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshotuser) {
          switch (snapshotuser.connectionState) {
            case ConnectionState.waiting:
              return SizedBox();
            case ConnectionState.active:
              //print(snapshotuser.data!.docs.toString());
              break;
            default:
              break;
          }
          if (snapshotuser.hasError) {
            print('come in error');
          }
          String imageurl = '';
          String userName = '';
          try {
            if (snapshotuser.data!.docs.isNotEmpty) {
              DocumentSnapshot user = snapshotuser.data!.docs[0];
              if (user.exists) {
                try {
                  imageurl = user['${AppFireStore.USER_PHOTO}'];
                } catch (error) {
                  imageurl = '';
                }
                try {
                  userName = user['${AppFireStore.USER_NAME}'];
                } catch (error) {
                  userName = 'App User';
                }
              } else {
                imageurl = '';
                userName = 'App User';
              }
            } else {
              imageurl = '';
              userName = 'App User';
            }
          } catch (error) {
            imageurl = '';
            userName = 'App User';
          }
          String name = '';
          if (userName == 'App User') {
            name = '$userName ' + '${userID.substring(userID.length - 5)}';
          } else {
            name = userName;
          }
          return getRowData(imageurl, name, date);
        });
  }
}
