import 'dart:convert';
import 'dart:html' as dh;
import 'dart:io';

import 'package:fdsr/models/user.dart';
import 'package:fdsr/utils/app_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class ProfileController extends GetxController {
  static ProfileController get profileController => Get.find();

  var userName = ''.obs;
  final ImagePicker _picker = ImagePicker();
  dynamic imagePath = ''.obs;
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
    if (kIsWeb) {
      dh.FileUploadInputElement uploadInput = dh.FileUploadInputElement();
      uploadInput.multiple = false;
      uploadInput.draggable = true;
      uploadInput.accept = 'image/*';
      uploadInput.click();
      dh.document.body!.append(uploadInput);

      uploadInput.onChange.listen((e) {
        final file = uploadInput.files!.first;
        final reader = new dh.FileReader();

        reader.onLoadEnd.listen((e) async {
          var _bytesData = await Base64Decoder()
              .convert(reader.result.toString().split(",").last);
          await AppFireStore.uploadorUpdateWebUserImage(
              userID, refID, _bytesData);

          getUser(userID);

          userPhoto.update((val) {
            userPhoto = ''.obs;
          });

          imagePath.update((val) async {
            imagePath = await _bytesData.obs;
          });
        });
        reader.readAsDataUrl(file);
      });
      uploadInput.remove();
    } else {
      final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
      userPhoto.update((val) {
        userPhoto = ''.obs;
      });
      imagePath.update((val) async {
        imagePath = image!.path.obs;
        print('photo ${imagePath.value}');
      });

      AppFireStore.uploadorUpdateUserImage(
          File(imagePath.value), userID, refID);
    }
  }
}
