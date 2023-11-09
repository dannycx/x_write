import 'dart:math';

import 'package:flutter/material.dart';

/// 绘制线条：点
class Point {
  final double x;
  final double y;

  const Point({required this.x, required this.y});

  /// 减法运算符重载，使用：point = point1 - point2，三角形直角边（x,y）勾股定理计算间距：@link Point#distance
  Point operator -(Point other) => Point(x: x - other.x, y: y - other.y);

  /// 点的间距
  double get distance => sqrt(x * x + y * y);

  factory Point.fromOffset(Offset offset) {
    return Point(x: offset.dx, y: offset.dy);
  }

  Offset toOffset() => Offset(x, y);
}
