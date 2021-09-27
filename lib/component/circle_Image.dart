import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:fdsr/utils/constant.dart';
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
  String from;

  CirCleImage(
      {this.padding = 8,
      this.borderRadious = 60,
      this.width = 48,
      this.height = 48,
      this.iconData = FontAwesomeIcons.user,
      this.imagePath = 'images/logo.jpg',
      this.from = 'local'});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(padding),
      child: ClipRRect(
          borderRadius: BorderRadius.circular(borderRadious),
          child: from == Constant.IMAGE_FROM_NETWORK
              ? imagePath == '' || imagePath == 'images/logo.jpg'
                  ? Image.asset(
                      'images/logo.jpg',
                      width: width,
                      height: height,
                      fit: BoxFit.cover,
                    )
                  : Image(
                      width: width,
                      height: height,
                      image: CachedNetworkImageProvider(
                        imagePath,
                      ),
                      fit: BoxFit.cover)
              : (from == Constant.IMAGE_FROM_STORAGE
                  ? imagePath == 'images/logo.jpg'
                      ? Image.asset(
                          imagePath,
                          width: width,
                          height: height,
                          fit: BoxFit.cover,
                        )
                      : Image.file(
                          File(imagePath),
                          width: width,
                          height: height,
                          fit: BoxFit.cover,
                        )
                  : Image.asset(
                      imagePath,
                      width: width,
                      height: height,
                      fit: BoxFit.cover,
                    ))),
    );
  }
}
