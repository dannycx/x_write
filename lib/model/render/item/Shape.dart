import 'dart:math';

import 'package:flutter/material.dart';
import 'package:x_write/model/render/data/Point.dart';

import '../data/paint_state.dart';

/// Shape对象：默认颜色：黑色，点集，默认状态：doing，线宽：1，填充状态：未填充，形状类型：圆
class Shape {
  final double strokeWidth = 1;
  List<Point> points = [];
  PaintState state;
  Color color;
  PaintingStyle paintingStyle;
  ShapeType shapeType = ShapeType.circle;

  // 记录该线进入编辑状态时的路径，通过record()赋值，translate()通过偏移量offset更新路径，实现移动效果
  Rect? _recordRect;

  // 绘制路径
  Rect? _shapeRect = Rect.fromCenter(center: const Offset(0, 0), width: 0, height: 0);

  Shape({this.color = Colors.black, this.state = PaintState.doing, this.paintingStyle = PaintingStyle.stroke});

  // 赋值_recordPath
  void record() {
    _recordRect = _shapeRect?.shift(Offset.zero);
  }

  // 通过偏移量offset更新路径，实现移动效果
  void translate(Offset offset) {
    if (_recordRect == null) return;
    _shapeRect = _recordRect!.shift(offset);
  }

  Rect? rect() => _shapeRect;

  /// 渲染
  void render(Canvas canvas, Paint paint) {
    paint
      ..style = paintingStyle
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round
      ..strokeWidth = strokeWidth
      ..color = color;

    if (state == PaintState.doing) {
      _shapeRect = fromRect();
    }

    double width = _shapeRect?.width ?? 0;
    double height = _shapeRect?.height ?? 0;
    if (width == 0 || height == 0) return;

    double left = _shapeRect?.left ?? 0;
    double top = _shapeRect?.top ?? 0;
    double radius = width / 2;
    switch(shapeType) {
      case ShapeType.circle:
        canvas.drawCircle(Offset(left + radius, top + radius), radius, paint);
        break;
      default:
        break;
    }

    if (state == PaintState.edit) {
      Paint editPaint = Paint()
        ..strokeWidth = 1
        ..color = Colors.deepOrangeAccent
        ..style = PaintingStyle.stroke;

      double editWidth = width;
      double editHeight = height;
      switch(shapeType) {
        case ShapeType.circle:
          double maxValue = max(editWidth, editHeight);
          editWidth = maxValue;
          editHeight = maxValue;
          break;
        default:
          break;
      }

      canvas.drawRect(Rect.fromCenter(
          center: Offset(left + radius, top + radius),
          width: editWidth + strokeWidth,
          height: editHeight + strokeWidth), editPaint);
    }
  }

  /// 图形绘制区域
  Rect? fromRect() {
    if (points.isEmpty) return null;

    double left = points[0].x;
    double top = points[0].y;
    double right = points[0].x;
    double bottom = points[0].y;
    for (int i = 1; i < points.length; i++) {
      Point point = points[i];
      double x = point.x;
      double y = point.y;
      if (left > x) {
        left = x;
      }
      if (right < x) {
        right = x;
      }
      if (top > y) {
        top = y;
      }
      if (bottom < y) {
        bottom = y;
      }
    }

    double width = right - left;
    double height = bottom - top;
    double radiusX = width / 2;
    double radiusY = height / 2;
    return Rect.fromCenter(center: Offset(left + radiusX, top + radiusY), width: width, height: height);
  }
}
