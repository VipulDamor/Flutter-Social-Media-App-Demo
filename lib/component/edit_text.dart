import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class EditText extends StatelessWidget {
  final String hintText;
  final bool isPasswordFeild;
  final IconData data;
  final Null Function(String data) param3;
  final TextEditingController textController;

  EditText(this.hintText, this.isPasswordFeild, this.data, this.param3,
      this.textController);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(
          data,
        ),
        SizedBox(width: 8.w),
        Expanded(
          child: TextField(
            controller: textController,
            obscureText: isPasswordFeild,
            decoration:
                InputDecoration(hintText: hintText, border: InputBorder.none),
            onChanged: param3,
          ),
        ),
      ],
    );
  }
}
