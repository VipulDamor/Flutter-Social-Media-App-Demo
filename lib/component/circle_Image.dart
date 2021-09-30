import 'dart:io';
import 'dart:typed_data';

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
  dynamic imagePath;
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
    print('from : $from \n  image path : $imagePath');

    return Padding(
      padding: EdgeInsets.all(padding),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(borderRadious),
        child: getImage(),
      ),
    );
  }

  Widget getImage() {
    if (from == Constant.IMAGE_FROM_NETWORK) {
      return CachedNetworkImage(
        width: width,
        height: height,
        imageUrl: imagePath,
        placeholder: (context, url) => CircularProgressIndicator(),
        errorWidget: (context, url, error) => Icon(Icons.error),
        fit: BoxFit.cover,
      );
    } else if (from == Constant.IMAGE_FROM_STORAGE) {
      return Image.file(
        File(imagePath),
        width: width,
        height: height,
        fit: BoxFit.cover,
      );
    } else if (from == Constant.IMAGE_FROM_DESKTOP) {
      print('Desktop :  $imagePath');
      return Image.memory(
        Uint8List.fromList(imagePath),
        width: width,
        height: height,
        fit: BoxFit.cover,
      );
    }
    return Image.asset(
      'images/logo.jpg',
      width: width,
      height: height,
      fit: BoxFit.cover,
    );
  }
}
