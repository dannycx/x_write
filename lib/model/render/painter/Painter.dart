import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:x_write/model/render/model/PaintModel.dart';

import '../tool/coordinate.dart';

/// 画板
class Painter extends CustomPainter {
  /// 画板与model绑定，model发出更新通知时，画板响应绘制
  final PaintModel model;
  final Paint _paint = Paint();

  /// 背景
  final Coordinate coordinate = Coordinate();

  Painter({required this.model}): super(repaint: model);

  @override
  void paint(Canvas canvas, Size size) {
    coordinate.render(canvas, size);
    // _renderOther(canvas, size);
    for (var line in model.lines) {
      line?.render(canvas, _paint);
    }
    for (var line in model.shapes) {
      line?.render(canvas, _paint);
    }
  }

  @override
  bool shouldRepaint(covariant Painter oldDelegate) => oldDelegate.model != model;

  void _renderOther(Canvas canvas, Size size) {
    /// 背景特效
    var patternColors = [
      Color(0xFFF60C0C),
      Color(0xFFF3B913),
      Color(0xFFE7F716),
      Color(0xFF3DF30B),
      Color(0xFF0DF6EF),
      Color(0xFF0829FB),
      Color(0xFFB709F4)
    ];
    var pos = [1.0 / 7, 2.0 / 7, 3.0 / 7, 4.0 / 7, 5.0 / 7, 6.0 / 7, 1.0];

    // 绘制画笔
    _paint..strokeWidth =.5..style = PaintingStyle.fill..color = Colors.blue;
    _paint.shader = ui.Gradient.linear(const Offset(0, 0), Offset(size.width, 0), patternColors, pos, TileMode.clamp);
    _paint.blendMode = BlendMode.lighten;
    canvas.drawPaint(_paint);
  }
}
