import 'package:flutter/material.dart';

class CommonTool {
  static double width = 0;
  static double height = 0;

  static init(BuildContext context) {
    MediaQueryData date = MediaQuery.of(context);
    width = date.size.width;
    height = date.size.height;
  }
}
