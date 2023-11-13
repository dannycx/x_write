import 'dart:math';

import 'package:flutter/material.dart';

/// 绘制线条：点
class Point {
  double x;
  double y;
  double press = 0;

  Point({this.x = 0, this.y = 0, this.press = 0});

  /// 减法运算符重载，使用：point = point1 - point2，三角形直角边（x,y）勾股定理计算间距：@link Point#distance
  Point operator -(Point other) => Point(x: x - other.x, y: y - other.y);

  /// 点的间距
  double get distance => sqrt(x * x + y * y);

  factory Point.fromOffset(Offset offset, {double forcePress = 0}) {
    return Point(x: offset.dx, y: offset.dy, press: forcePress);
  }

  Offset toOffset() => Offset(x, y);

  void setPoint(Point point) {
    x = point.x;
    y = point.y;
    press = point.press;
  }

  void setPointXY(double dx, double dy, double dPress) {
    x = dx;
    y = dy;
    press = dPress;
  }
}
