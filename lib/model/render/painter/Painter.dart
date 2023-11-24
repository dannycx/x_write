import 'package:flutter/material.dart';
import 'package:x_write/model/render/model/PaintModel.dart';

/// 画板
class Painter extends CustomPainter {
  /// 画板与model绑定，model发出更新通知时，画板响应绘制
  final PaintModel model;
  final Paint _paint = Paint();

  /// 画板背景：画笔，小格子边长，线宽，线颜色
  late Paint _patternPaint;
  final double patternStep = 20;
  final double patternStrokeWidth = .5;
  final Color patternColor = const Color.fromARGB(255, 187, 187, 187);

  Painter({required this.model}): super(repaint: model) {
    _patternPaint = Paint()..color = patternColor..strokeWidth = patternStrokeWidth..style = PaintingStyle.stroke;
  }

  @override
  void paint(Canvas canvas, Size size) {
    _renderPattern(canvas, size);
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

  void _renderPattern(Canvas canvas, Size size) {
    _drawBottomRight(canvas, size);

    // 镜像处理：x轴镜像
    // canvas.save();
    // canvas.scale(1, -1);
    // _drawBottomRight(canvas, size);
    // canvas.restore();

    // 镜像处理：y轴镜像
    // canvas.save();
    // canvas.scale(-1, 1);
    // _drawBottomRight(canvas, size);
    // canvas.restore();

    // 镜像处理：原点镜像
    // canvas.save();
    // canvas.scale(-1, -1);
    // _drawBottomRight(canvas, size);
    // canvas.restore();
  }

  void _drawBottomRight(Canvas canvas, Size size) {
    canvas.save();
    for (int i = 0; i < size.height / patternStep; i++) {
      // 画横线，每次下移小格子边长
      canvas.drawLine(const Offset(0, 0), Offset(size.width, 0), _patternPaint);
      canvas.translate(0, patternStep);
    }
    canvas.restore();

    canvas.save();
    for (int i = 0; i < size.width / patternStep; i++) {
      // 画竖线，每次右移小格子边长
      canvas.drawLine(const Offset(0, 0), Offset(0, size.height), _patternPaint);
      canvas.translate(patternStep, 0);
    }
    canvas.restore();
  }
}
