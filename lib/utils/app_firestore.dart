import 'dart:io';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fdsr/models/user.dart';
import 'package:fdsr/modules/profile/profile_controller.dart';
import 'package:fdsr/utils/constant.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:get/get.dart';

class AppFireStore {
  static final profileController = Get.put(ProfileController());

  static CollectionReference posts =
      FirebaseFirestore.instance.collection('posts');
  static CollectionReference user =
      FirebaseFirestore.instance.collection('user');

  //add post collection
  static final String POST_COMMENT = 'comment';
  static final String POST_LIKES = 'likes';
  static final String POST = 'post';
  static final String POST_DATE = 'postDate';
  static final String POST_SHARES = 'shares';
  static final String POST_USERID = 'userID';
  static final String POST_USERNAME = 'userName';

  //users collection
  static final String USER_ID = 'uID';
  static final String USER_NAME = 'uName';
  static final String USER_ADDRESS = 'uAddress';
  static final String USER_MOBILE = 'uMobile';
  static final String USER_ABOUT = 'uAbout';
  static final String USER_CREATED_AT = 'uCreatedat';
  static final String USER_PHOTO = 'uPhoto';

  static Future<void> addPostToFirebase(
      String post, String userID, String userName) async {
    Constant.getLoaderDialog();
    await posts.add({
      '$POST_COMMENT': "",
      '$POST_LIKES': "",
      '$POST': post,
      '$POST_DATE': DateTime.now(),
      '$POST_SHARES': "",
      '$POST_USERID': userID,
      '$POST_USERNAME': userName
    }).then((value) {
      Get.back();
    }).catchError((error) {
      print("Failed to add user: $error");
      Get.back();
    });
  }

  static Future<void> updateUserProfile(
      {String refID = '',
      String uID = '',
      String uName = '',
      String uAbout = '',
      String uMobile = '',
      String uPhoto = '',
      String uAddress = ''}) async {
    Constant.getLoaderDialog();

    //await _user.where('$USER_ID', isEqualTo: uID).get().update({
    if (refID.isNotEmpty) {
      await user.doc(refID).update({
        //await _user.add({
        '$USER_NAME': uName,
        '$USER_ADDRESS': uAddress,
        '$USER_MOBILE': uMobile,
        '$USER_ABOUT': uAbout,
        '$USER_PHOTO': uPhoto,
        '$USER_CREATED_AT': DateTime.now(),
        '$USER_ID': uID
      }).then((value) {
        Get.back();
      }).catchError((error) {
        print("Failed to add user: $error");
        Get.back();
      });
    } else {
      await user.add({
        '$USER_NAME': uName,
        '$USER_ADDRESS': uAddress,
        '$USER_MOBILE': uMobile,
        '$USER_ABOUT': uAbout,
        '$USER_PHOTO': uPhoto,
        '$USER_CREATED_AT': DateTime.now(),
        '$USER_ID': uID
      }).then((value) {
        Get.back();
      }).catchError((error) {
        print("Failed to add user: $error");
        Get.back();
      });
    }
  }

  static updateUserProfilePhoto(
      String refID, String uPhoto, String userID) async {
    Constant.getLoaderDialog(message: 'Updating...');
    await user.doc(refID).update({
      '$USER_PHOTO': uPhoto,
    }).then((value) {
      Get.back();
      Constant.showMessageAlertDialog('Image Uploaded Successfully..!!!');
      profileController.getUser(userID);
    }).catchError((error) {
      print("Failed to add user: $error");
      Get.back();
    });
  }

  //get user data
  static Future<User> getUsersInfo(String uID) async {
    User userData = User();
    await user.where('$USER_ID', isEqualTo: uID).get().then((value) {
      value.docs.forEach((element) {
        userData.refID = element.reference.id;
        userData.userName = element.get(AppFireStore.USER_NAME);
        userData.userAbout = element.get(AppFireStore.USER_ABOUT);
        userData.userMobile = element.get(AppFireStore.USER_MOBILE);
        userData.userAddress = element.get(AppFireStore.USER_ADDRESS);
        userData.userPhoto = element.get(AppFireStore.USER_PHOTO);

        //print(userData);
      });
    });
    return userData;
  }

  static Future<User> getUsersInfoList(String uID) async {
    User userData = User();
    await user.where('$USER_ID', isEqualTo: uID).get().then((value) {
      value.docs.forEach((element) {
        userData.refID = element.reference.id;
        userData.userName = element.get(AppFireStore.USER_NAME);
        userData.userPhoto = element.get(AppFireStore.USER_PHOTO);
        //print(userData);
      });
    });
    return userData;
  }

  static uploadorUpdateUserImage(
      File? image, String userID, String refID) async {
    String fileName = '$userID.jpg';
    Constant.getLoaderDialog(message: 'Uploading...');
    FirebaseStorage storage = FirebaseStorage.instance;

    UploadTask uploadTask =
        storage.ref().child('userprofile').child(fileName).putFile(image!);

    TaskSnapshot taskSnapshot = await uploadTask.whenComplete(() => {});

    taskSnapshot.ref.getDownloadURL().then((value) async {
      String downloadURL = await taskSnapshot.ref.getDownloadURL();
      Get.back();
      updateUserProfilePhoto(refID, value, userID);
    });
  }

  static uploadorUpdateWebUserImage(
      String userID, String refID, Uint8List bytesData) async {
    String fileName = '$userID.jpg';

    Constant.getLoaderDialog(message: 'Uploading...');
    FirebaseStorage storage = FirebaseStorage.instance;

    UploadTask uploadTask =
        storage.ref().child('userprofile').child(fileName).putData(bytesData);

    TaskSnapshot taskSnapshot = await uploadTask.whenComplete(() => {});
    Get.back();
    taskSnapshot.ref.getDownloadURL().then((value) async {
      String downloadURL = await taskSnapshot.ref.getDownloadURL();
      updateUserProfilePhoto(refID, value, userID);
    });
  }
}
