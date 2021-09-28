import 'package:flutter/material.dart';

class EditText extends StatelessWidget {
  final String hintText;
  final bool isPasswordFeild;
  final IconData data;
  final Null Function(String data) param3;
  final TextEditingController textController;
  TextInputType textInputType;

  EditText(this.hintText, this.isPasswordFeild, this.data, this.param3,
      this.textController,
      {this.textInputType = TextInputType.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(
          data,
        ),
        SizedBox(width: 8),
        Expanded(
          child: TextField(
            controller: textController,
            obscureText: isPasswordFeild,
            keyboardType: textInputType,
            decoration: InputDecoration(
                hintText: 'Enter $hintText',
                hintStyle: TextStyle(color: Colors.grey),
                border: InputBorder.none),
            onChanged: param3,
          ),
        ),
      ],
    );
  }
}
