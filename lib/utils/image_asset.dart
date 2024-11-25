import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class AppVector extends SizedBox {
  AppVector(
    String path, {
    Color? color,
    BoxFit fit = BoxFit.contain,
    super.key,
    super.height,
    super.width,
  }) : super(
            child: SvgPicture.asset(
          path,
          fit: fit,
          width: width,
          height: height,
        ));
}

class AppImage extends SizedBox {
  AppImage(String path,
      {BoxFit fit = BoxFit.cover, super.key, super.height, super.width})
      : super(
            child: Image.asset(
          path,
          fit: fit,
          height: height,
          width: width,
        ));
}
