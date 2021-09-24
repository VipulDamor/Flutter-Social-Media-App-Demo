import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class CirCleImage extends StatelessWidget {
  double padding;
  double borderRadious;
  double width;
  double height;
  String imagePath;
  IconData iconData;

  CirCleImage(
      {this.padding = 8,
      this.borderRadious = 60,
      this.width = 48,
      this.height = 48,
      this.iconData = FontAwesomeIcons.user,
      this.imagePath = 'images/logo.jpg'});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(padding),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(borderRadious),
        child: imagePath == 'icon'
            ? Icon(
                iconData,
              )
            : Image.asset(
                imagePath,
                width: width,
                height: height,
                fit: BoxFit.cover,
              ),
      ),
    );
  }
}
