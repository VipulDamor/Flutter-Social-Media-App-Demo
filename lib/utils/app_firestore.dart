import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fdsr/utils/constant.dart';
import 'package:get/get.dart';

class AppFireStore {
  CollectionReference posts = FirebaseFirestore.instance.collection('posts');

  final String COMMENT = 'comment';
  final String LIKES = 'likes';
  final String POST = 'post';
  final String POSTDATE = 'postDate';
  final String SHARES = 'shares';
  final String USERID = 'userID';

  Future<void> addPostToFirebase(String post, String userID) async {
    Constant.getloaderDialog();
    await posts.add({
      '$COMMENT': "",
      '$LIKES': "",
      '$POST': post,
      '$POSTDATE': DateTime.now(),
      '$SHARES': "",
      '$USERID': userID
    }).then((value) {
      Get.back();
    }).catchError((error) {
      print("Failed to add user: $error");
      Get.back();
    });
  }
}
