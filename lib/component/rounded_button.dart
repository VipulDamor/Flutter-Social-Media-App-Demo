import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class RoundedButton extends StatelessWidget {
  final String buttonText;
  final VoidCallback function;

  RoundedButton(this.buttonText, this.function);

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      width: double.infinity,
      height: 48.h,
      decoration: BoxDecoration(
          border: Border.all(color: Colors.indigo),
          color: Colors.indigo,
          borderRadius: BorderRadius.all(Radius.circular(18.r))),
      child: TextButton(
        onPressed: function,
        child: SizedBox(
          width: double.infinity,
          child: Text(
            buttonText,
            style: TextStyle(
              fontSize: 18.sp,
              color: Colors.white,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}
