import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fdsr/utils/constant.dart';
import 'package:flutter/material.dart';
import 'package:timeago/timeago.dart' as timeago;

class ListData extends StatelessWidget {
  final Stream<QuerySnapshot> fireStoreData = FirebaseFirestore.instance
      .collection(Constant.KEY_POSTS)
      .orderBy(
        '${Constant.KEY_POST_DATE}',
        descending: true,
      )
      .snapshots(includeMetadataChanges: true);

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
                //height: MediaQuery.of(context).size.height - 180,
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
                    return Column(
                      children: [
                        Row(
                          children: [
                            CircleAvatar(
                              backgroundColor: Colors.blue,
                              radius: 25,
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
                            SizedBox(
                              width: 16,
                            ),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    data['${Constant.KEY_USERID}'].toString(),
                                    style: kBoldStyle,
                                  ),
                                  Text(
                                    timeago.format(date, locale: 'en_short'),
                                    style: kRegularStyle14,
                                  ),
                                  //Text('hello') //)
                                ],
                              ),
                            )
                          ],
                        ),
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
}
