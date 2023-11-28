import 'dart:ui' as ui;

import 'package:flutter/material.dart';

/// 插入图片
class Image {
  Offset offset;
  ui.Image? _image;

  Image({required this.offset});

  void render(Canvas canvas, Paint paint) {
    if (_image == null) return;
    canvas.drawImage(_image!, offset, paint);
  }
}
