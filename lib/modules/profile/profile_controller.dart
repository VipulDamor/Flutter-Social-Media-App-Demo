import 'dart:io';

import 'package:fdsr/models/user.dart';
import 'package:fdsr/utils/app_firestore.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class ProfileController extends GetxController {
  static ProfileController get profileController => Get.find();

  var userName = ''.obs;
  final ImagePicker _picker = ImagePicker();
  var imagepath = 'images/logo.jpg'.obs;
  var userPhoto = ''.obs;
  User controllerUser = User();

  void getUser(String userID) async {
    User user = await AppFireStore.getUsersInfo(userID);
    controllerUser = user;

    userName.update((val) {
      userName = user.userName.obs;
    });
    userPhoto.update((val) {
      userPhoto = user.userPhoto.obs;
    });
  }

  getImage(String userID, String refID) async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    imagepath.update((val) {
      imagepath = image!.path.obs;
    });
    AppFireStore.uploadorUpdateUserImage(File(image!.path), userID, refID);
  }
}
