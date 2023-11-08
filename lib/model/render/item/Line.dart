import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:x_write/model/render/data/Point.dart';

/// Line对象：默认状态：doing，默认颜色：黑色，线宽：1，点集
class Line {
  List<Point> points = [];
  PaintState state;
  double strokeWidth;
  Color color;

  Line(
      {this.color = Colors.black,
      this.strokeWidth = 1,
      this.state = PaintState.doing});

  /// 渲染
  void render(Canvas canvas, Paint paint) {
    paint
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..color = color;

    canvas.drawPoints(
        PointMode.polygon,
        points.map<Offset>((e) => e.toOffset()).toList(),
        paint);
  }
}

/// 三种状态：正在绘制，绘制完成，隐藏
enum PaintState { doing, done, hide }
