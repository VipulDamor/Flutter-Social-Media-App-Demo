import 'package:flutter/material.dart';

class BottomIcons extends StatelessWidget {
  final IconData icon;
  final VoidCallback function;

  BottomIcons(this.icon, this.function);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(40)),
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
