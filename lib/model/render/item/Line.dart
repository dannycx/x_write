import 'package:flutter/material.dart';
import 'package:x_write/model/render/data/Point.dart';
import 'package:x_write/model/render/item/line_expand.dart';

import '../data/paint_state.dart';

/// Line对象：默认状态：doing，默认颜色：黑色，线宽：1，点集
class Line {
  List<Point> points = [];
  PaintState state;
  double strokeWidth;
  Color color;
  AbsLineRender lineRender;

  // 记录该线进入编辑状态时的路径，通过record()赋值，translate()通过偏移量offset更新路径，实现移动效果
  Path? _recordPath;

  // 绘制路径
  Path _linePath = Path();

  Line(
      {this.color = Colors.black,
      this.strokeWidth = 1,
      this.state = PaintState.doing,
      this.lineRender = const Pen()});

  // 赋值_recordPath
  void record() {
    _recordPath = _linePath.shift(Offset.zero);
  }

  // 通过偏移量offset更新路径，实现移动效果
  void translate(Offset offset) {
    if (_recordPath == null) return;
    _linePath = _recordPath!.shift(offset);
  }

  Path path() => _linePath;

  /// 渲染
  void render(Canvas canvas, Paint paint) {
    paint
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round
      ..strokeWidth = strokeWidth
      ..color = color;

    if (state == PaintState.doing) {
      _linePath = fromPath();
    }

    if (state == PaintState.edit) {
      Paint editPaint = Paint()
        ..strokeWidth = 1
        ..color = Colors.deepOrangeAccent
        ..style = PaintingStyle.stroke;

      canvas.drawRect(
          Rect.fromCenter(
              center: _linePath.getBounds().center,
              width: _linePath.getBounds().width + strokeWidth,
              height: _linePath.getBounds().height + strokeWidth),
          editPaint);
    }

    /// 贝塞尔绘制
    // canvas.drawPath(_linePath, paint);
    lineRender.drawLine(canvas, paint, points);

    // 辅助线
    Path p1 = _linePath.shift(Offset(paint.strokeWidth / 2, paint.strokeWidth / 2));
    Path p2 = _linePath.shift(Offset(-paint.strokeWidth / 2, -paint.strokeWidth / 2));
    // Path p3 = p2 - p1;
    Paint auxiliaryPaint = Paint()
      ..strokeWidth = 1
      ..style = PaintingStyle.stroke;
    // canvas.drawPath(p1, auxiliaryPaint);
    // canvas.drawPath(p2, auxiliaryPaint);

    /// 普通绘制
    // canvas.drawPoints(
    //     PointMode.polygon, /// 绘制模式：polygon：整个点序列绘制一条线，points：点(strokeCap.round时为圆)，lines：每两个点线段，奇数忽略最后一点
    //     points.map<Offset>((e) => e.toOffset()).toList(),
    //     paint);
  }

  /// 二阶贝塞尔，拟合线条，更平滑
  Path fromPath() {
    Path path = Path();

    for (int i = 0; i < points.length - 1; i++) {
      Point current = points[i];
      Point next = points[i + 1];
      if (i == 0) {
        /// 第一个点
        path.moveTo(current.x, current.y);
        path.lineTo(next.x, next.y);
      } else if (i <= points.length - 2) {
        double xc = (current.x + next.x) / 2;
        double yc = (current.y + next.y) / 2;
        // Point p2 = points[i];
        // path.quadraticBezierTo(p2.x, p2.y, xc, yc);
        path.quadraticBezierTo(current.x, current.y, xc, yc);
      } else {
        /// 最后一个点处理
        // path.moveTo(current.x, current.y);
        // path.lineTo(next.x, next.y);
      }
    }

    return path;
  }
}
