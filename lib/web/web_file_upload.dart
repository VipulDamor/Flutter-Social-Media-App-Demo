import 'dart:convert';

import 'package:fdsr/modules/profile/profile_controller.dart';
import 'package:fdsr/utils/app_firestore.dart';
import 'package:get/get.dart';
import 'package:universal_html/html.dart';

class WebFileUpload {
  static ProfileController get profileController => Get.find();

  static uploadWebFile(String userID, String refID) {
    FileUploadInputElement uploadInput = FileUploadInputElement();
    uploadInput.multiple = false;
    uploadInput.draggable = true;
    uploadInput.accept = 'image/*';
    uploadInput.click();
    document.body!.append(uploadInput);

    uploadInput.onChange.listen((e) {
      final file = uploadInput.files!.first;
      final reader = new FileReader();

      reader.onLoadEnd.listen((e) async {
        var _bytesData = await Base64Decoder()
            .convert(reader.result.toString().split(",").last);
        await AppFireStore.uploadorUpdateWebUserImage(
            userID, refID, _bytesData);

        profileController.getUser(userID);

        profileController.userPhoto.update((val) {
          profileController.userPhoto = ''.obs;
        });

        profileController.imagePath.update((val) async {
          profileController.imagePath = await _bytesData.obs;
        });
      });
      reader.readAsDataUrl(file);
    });
    uploadInput.remove();
  }
}
