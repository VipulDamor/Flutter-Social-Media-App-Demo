import 'package:fdsr/models/user.dart';
import 'package:fdsr/utils/app_firestore.dart';
import 'package:fdsr/utils/constant.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class EditProfileController extends GetxController {
  static EditProfileController get i => Get.find();

  var userNameController = TextEditingController();
  var addressController = TextEditingController();
  var mobileController = TextEditingController();
  var aboutController = TextEditingController();
  String refID = '';

  updateFirebaseProfile(String userID) async {
    if (userNameController.text.trim() == '') {
      return Constant.showAlertDialog('name is Required.');
    }

    await AppFireStore.updateUserProfile(
        refID: refID,
        uID: userID,
        uName: userNameController.text,
        uAbout: aboutController.text,
        uMobile: mobileController.text,
        uAddress: addressController.text);
    Get.back();
  }

  setText(String userID) async {
    User user = await AppFireStore.getUsersInfo(userID);

    userNameController.text = user.userName;
    aboutController.text = user.userAbout;
    mobileController.text = user.userMobile;
    addressController.text = user.userAddress;
    refID = user.refID;
  }

  getUser(String userID) async {
    return await AppFireStore.getUsersInfo(userID).obs;
  }
}
