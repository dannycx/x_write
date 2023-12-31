import 'dart:math';

import 'package:flutter/material.dart';
import 'package:x_write/model/render/data/Point.dart';
import 'package:x_write/model/render/data/dash_painter.dart';
import 'package:x_write/model/render/data/write_path.dart';

import '../data/paint_state.dart';

/// Shape对象：默认颜色：黑色，点集，默认状态：doing，线宽：1，填充状态：未填充，形状类型：圆
class Shape {
  final double strokeWidth = 1;
  List<Point> points = [];
  PaintState state;
  Color color;
  PaintingStyle paintingStyle;
  ShapeType shapeType;

  // 记录该线进入编辑状态时的路径，通过record()赋值，translate()通过偏移量offset更新路径，实现移动效果
  Path? _recordPath;

  // 绘制路径
  Rect _shapeRect = Rect.fromCenter(center: const Offset(0, 0), width: 0, height: 0);

  // 绘制路径
  final Path _path = Path();

  Shape(
      {this.color = Colors.black,
      this.state = PaintState.doing,
      this.paintingStyle = PaintingStyle.stroke,
      this.shapeType = ShapeType.circle});

  // 赋值_recordPath
  void record() {
    _recordPath = _path.shift(Offset.zero);
  }

  // 通过偏移量offset更新路径，实现移动效果
  void translate(Offset offset) {
    if (_recordPath == null) return;
    _path.reset();
    _path.addPath(_recordPath!.shift(offset), Offset.zero);
    // _shapeRect = _path.getBounds();
  }

  Rect? rect() => _shapeRect;

  /// 渲染
  void render(Canvas canvas, Paint paint) {
    if (points.isEmpty) return;
    paint
      ..style = paintingStyle
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round
      ..strokeWidth = strokeWidth
      ..color = color;

    // 首尾点
    Point firstPoint = points[0];
    Point lastPoint = points[points.length - 1];
    double fixedX = firstPoint.x;
    double fixedY = firstPoint.y;
    double lastX = lastPoint.x;
    double lastY = lastPoint.y;

    // x,y间距
    double spaceX = lastX - fixedX;
    double spaceY = lastY - fixedY;

    if (state == PaintState.doing) {
      // _shapeRect = fromRect();
      _path.reset();
      ShapeFromCircular shapeFromCircular = ShapeFromCircular(shapeType: shapeType, first: firstPoint, last: lastPoint);
      _path.addPath(shapeFromCircular.fromPath(), Offset.zero);
    }
    _shapeRect = _path.getBounds();

    switch (shapeType) {
      case ShapeType.circle: // 圆
      case ShapeType.oval: // 椭圆
      case ShapeType.square: // 矩形
      case ShapeType.regularTriangle: // 等腰三角
      case ShapeType.rightTriangle: // 直角三角
        canvas.drawPath(_path, paint);
        break;
      case ShapeType.star: // 五角星
        canvas.save();
        canvas.translate(fixedX + spaceX / 2, fixedY + spaceY / 2);
        // _path.reset();
        // StarPath starPath = StarPath(first: Offset(fixedX, fixedY), size: Size(width, height));
        // _path.addPath(starPath.fromPath(), Offset.zero);
        canvas.drawPath(_path, paint);
        _shapeRect = _shapeRect.shift(Offset(fixedX + spaceX / 2, fixedY + spaceY / 2));
        canvas.restore();
        break;
      case ShapeType.polygon: // 多边形
        // PolygonPath polygonPath = PolygonPath(first: Offset(fixedX, fixedY), size: Size(spaceX, spaceY), factor: 3);
        // _path.addPath(polygonPath.fromPath(), Offset.zero);
        canvas.save();
        canvas.translate(fixedX + spaceX / 2, fixedY + spaceY / 2);
        _shapeRect = _shapeRect.shift(Offset(fixedX + spaceX / 2, fixedY + spaceY / 2));
        canvas.drawPath(_path, paint);
        canvas.restore();
        break;
      case ShapeType.arrow: // 箭头
        paint.style = PaintingStyle.fill;
        canvas.drawPath(_path, paint);
        break;
      case ShapeType.line: // 线
        DashPainter dashPainter = const DashPainter(step: 10, span: 2, pointCount: 3, pointLength: 1);
        dashPainter.paint(canvas, paint, _path);
        break;
      default:
        break;
    }

    double width = _shapeRect.width;
    double height = _shapeRect.height;
    if (width == 0 || height == 0) return;

    double left = _shapeRect.left;
    double top = _shapeRect.top;
    double radius = width / 2;

    if (state == PaintState.edit) {
      Paint editPaint = Paint()
        ..strokeWidth = 1
        ..color = Colors.deepOrangeAccent
        ..style = PaintingStyle.stroke;

      double editWidth = width;
      double editHeight = height;
      switch (shapeType) {
        case ShapeType.circle:
          double maxValue = max(editWidth, editHeight);
          editWidth = maxValue;
          editHeight = maxValue;
          break;
        default:
          break;
      }

      Rect rect = Rect.fromCenter(
          center: Offset(left + radius, top + radius),
          width: editWidth + strokeWidth,
          height: editHeight + strokeWidth);
      // canvas.drawRect(rect, editPaint);

      Path editPath = Path();
      editPath.addRect(rect);
      DashPainter dashPainter = const DashPainter(step: 3, span: 3, pointCount: 1, pointLength: 1);
      dashPainter.paint(canvas, editPaint, editPath);
    }
  }

  /// 图形绘制区域
  Rect? fromRect() {
    if (points.isEmpty) return null;

    double firstX = points[0].x;
    double firstY = points[0].y;
    double lastX = points[points.length - 1].x;
    double lastY = points[points.length - 1].y;

    return Rect.fromLTRB(min(firstX, lastX), min(firstY, lastY), max(firstX, lastX), max(firstY, lastY));
  }

  /// 最大最小点图形绘制区域
  Rect? fromRectMax() {
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
