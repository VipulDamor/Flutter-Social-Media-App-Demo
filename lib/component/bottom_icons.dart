import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class BottomIcons extends StatelessWidget {
  final IconData icon;
  final VoidCallback function;

  BottomIcons(this.icon, this.function);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(40.r)),
        border: Border.all(color: Colors.indigo),
      ),
      child: IconButton(
        onPressed: function,
        icon: Icon(
          icon,
          color: Colors.indigo,
        ),
      ),
    );
  }
}
