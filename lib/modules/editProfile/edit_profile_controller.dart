import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class EditProfileController extends GetxController {
  static EditProfileController get i => Get.find();

  var userNameController = TextEditingController();
  var addressController = TextEditingController();
  var mobileController = TextEditingController();
}
