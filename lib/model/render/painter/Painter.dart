import 'package:flutter/material.dart';
import 'package:x_write/model/render/model/PaintModel.dart';

/// 画板
class Painter extends CustomPainter {
  /// 画板与model绑定，model发出更新通知时，画板响应绘制
  final PaintModel model;
  final Paint _paint = Paint();

  Painter({required this.model}): super(repaint: model);

  @override
  void paint(Canvas canvas, Size size) {
    for (var line in model.lines) {
      line?.render(canvas, _paint);
    }
    for (var line in model.shapes) {
      line?.render(canvas, _paint);
    }
  }

  @override
  bool shouldRepaint(covariant Painter oldDelegate) =>
      oldDelegate.model != model;
}
