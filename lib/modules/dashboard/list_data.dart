import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fdsr/utils/constant.dart';
import 'package:flutter/material.dart';

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
                height: MediaQuery.of(context).size.height - 160,
                child: ListView.builder(
                  padding: EdgeInsets.zero,
                  physics: const BouncingScrollPhysics(
                      parent: AlwaysScrollableScrollPhysics()),
                  shrinkWrap: true,
                  itemCount: dataList.length,
                  itemBuilder: (context, index) {
                    DocumentSnapshot data = dataList[index];

                    return InkWell(
                      onTap: () {},
                      child: Card(
                        elevation: 2,
                        color: Colors.white70,
                        child: Padding(
                          padding: EdgeInsets.all(8.0),
                          child: ListTile(
                            title: Text(data['${Constant.KEY_POST}']),
                            //subtitle: Text(data['${Constant.KEY_POST_DATE}'].toString()),
                          ),
                        ),
                      ),
                    );
                  },
                  /*separatorBuilder: (BuildContext context, int index) {
                    return Divider(
                      thickness: 1,
                    );
                  },*/
                ),
              )
            : Center(child: Text("No Data Found"));
      },
    );
  }
}
