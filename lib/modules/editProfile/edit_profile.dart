import 'package:fdsr/component/edit_text.dart';
import 'package:fdsr/modules/editProfile/edit_profile_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class EditProfile extends StatelessWidget {
  final editprofileController = Get.put(EditProfileController());

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      appBar: AppBar(
        title: Text(
          'Update Info',
        ),
      ),
      body: Container(
        child: Column(
          children: [
            Container(
              margin: EdgeInsets.only(top: 10),
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.blue,
                borderRadius: BorderRadius.circular(0),
              ),
              padding: EdgeInsets.all(6),
              child: Text(
                'ⓘ Personal info.',
                style:
                    TextStyle(color: Colors.white, fontWeight: FontWeight.w500),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Padding(
              padding: EdgeInsets.all(10),
              child: Column(
                children: [
                  EditText('Enter Your Awesome Name', false, Icons.person,
                      (value) {}, editprofileController.userNameController),
                  Divider(
                    thickness: 1,
                  ),
                  EditText('Enter Mobile', false, Icons.phone_android,
                      (value) {}, editprofileController.mobileController),
                  Divider(
                    thickness: 1,
                  ),
                  EditText('Enter Address', false, Icons.location_on_outlined,
                      (value) {}, editprofileController.addressController),
                  Divider(
                    thickness: 1,
                  )
                ],
              ),
            )
          ],
        ),
      ),
    ));
  }
}
