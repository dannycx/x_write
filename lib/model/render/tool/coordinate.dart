import 'package:flutter/material.dart';

/// 网格背景+坐标轴
@immutable
class Coordinate {
  /// 画板背景：画笔，小格子边长，线宽，线颜色
  final Paint _paint = Paint();
  final double step;
  final double strokeWidth;
  final Color color;

  /// 坐标轴颜色
  final Color axisColor;

  Coordinate(
      {this.step = 20,
      this.strokeWidth = .5,
      this.color = const Color.fromARGB(255, 187, 187, 187),
      this.axisColor = Colors.blue});

  void render(Canvas canvas, Size size) {
    _renderGrid(canvas, size);
    // _renderAxis(canvas, size);
  }

  void _renderGrid(Canvas canvas, Size size) {
    _paint
      ..color = color
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke;

    // 颜色，混合模式：lighten
    canvas.drawColor(Colors.blue, BlendMode.lighten);

    // 网格
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
    for (int i = 0; i < size.height / step; i++) {
      // 画横线，每次下移小格子边长
      canvas.drawLine(const Offset(0, 0), Offset(size.width, 0), _paint);
      canvas.translate(0, step);
    }
    canvas.restore();

    canvas.save();
    for (int i = 0; i < size.width / step; i++) {
      // 画竖线，每次右移小格子边长
      canvas.drawLine(const Offset(0, 0), Offset(0, size.height), _paint);
      canvas.translate(step, 0);
    }
    canvas.restore();
  }

  void _renderAxis(Canvas canvas, Size size) {
    _paint..color = axisColor..strokeWidth = 1.5;
    canvas.drawLine(const Offset(0, 0), Offset(size.width, 0), _paint);
    canvas.drawLine(const Offset(0, 0), Offset(0, size.height), _paint);
    
    canvas.drawLine(Offset(size.width, 0), Offset(size.width - 10, 7), _paint);
    canvas.drawLine(Offset(size.width, 0), Offset(size.width - 10, -7), _paint);

    canvas.drawLine(Offset(0, size.height), Offset(0 - 7, size.height - 10), _paint);
    canvas.drawLine(Offset(0, size.height), Offset(0 + 7, size.height - 10), _paint);
  }
}
