import 'dart:math';

import 'package:flutter/material.dart';

/// 路径抽象类，生产路径
abstract class AbsPath {
  Path fromPath();
}

/// 箭头路径
class PortPath extends AbsPath {
  final Offset center; // 点
  final Size size;
  AbsPortPathBuilder portPath;

  PortPath(
      {required this.center,
      required this.size,
      this.portPath = const TrianglePortPath()});

  @override
  Path fromPath() {
    Rect zone =
        Rect.fromCenter(center: center, width: size.width, height: size.height);
    // return pathExpand(zone);
    return portPath.fromPathByRect(zone);
  }
}

/// 抽象端点路径，通过fromPathByRect区域生成路径
abstract class AbsPortPathBuilder {
  const AbsPortPathBuilder();

  Path fromPathByRect(Rect zone);
}

/// 三角形箭头：triangle
class TrianglePortPath extends AbsPortPathBuilder {
  const TrianglePortPath();

  @override
  Path fromPathByRect(Rect zone) {
    Path path = Path();

    //    *********** p2
    //    *         *
    // p0 *         *
    //    *         *
    //    *********** p1
    Offset p0 = zone.centerLeft;
    Offset p1 = zone.bottomRight;
    Offset p2 = zone.topRight;
    path
      ..moveTo(p0.dx, p0.dy)
      ..lineTo(p1.dx, p1.dy)
      ..lineTo(p2.dx, p2.dy)
      ..close();
    return path;
  }
}

/// 三个箭头
class ThreeAnglePortPath extends AbsPortPathBuilder {
  final double rate;

  const ThreeAnglePortPath({this.rate = 0.8});

  @override
  Path fromPathByRect(Rect zone) {
    Path path = Path();

    //    *********** p2
    //    *         *
    // p0 *    * p3 *
    //    *         *
    //    *********** p1
    Offset p0 = zone.centerLeft;
    Offset p1 = zone.bottomRight;
    Offset p2 = zone.topRight;
    Offset p3 = p0.translate(rate * zone.width, 0);
    path
      ..moveTo(p0.dx, p0.dy)
      ..lineTo(p1.dx, p1.dy)
      ..lineTo(p3.dx, p3.dy)
      ..lineTo(p2.dx, p2.dy)
      ..close();
    return path;
  }
}

/// 圆点
class CirclePortPath extends AbsPortPathBuilder {
  const CirclePortPath();

  @override
  Path fromPathByRect(Rect zone) {
    Path path = Path();
    path.addOval(zone);
    return path;
  }
}

/// 空：实现单向箭头
class NullPortPath extends AbsPortPathBuilder {
  const NullPortPath();

  @override
  Path fromPathByRect(Rect zone) {
    return Path();
  }
}

/// 箭头路径：封装箭头跟随直线旋转逻辑
class ArrowPath extends AbsPath {
  final PortPath head; // 头
  final PortPath tail; // 尾

  ArrowPath({required this.head, required this.tail});

  @override
  Path fromPath() {
    Offset line = tail.center - head.center;
    Offset center = head.center + line / 2;
    double length = line.distance;
    Rect lineZone = Rect.fromCenter(center: center, width: length, height: 2);
    Path linePath = Path()..addRect(lineZone);

    /// 通过矩阵变换，让 linePath 以 center 为中心 旋转两点间角度（两点不在同一水平线处理）
    // 1.将变换中心变为center
    Matrix4 matrix4 = Matrix4.translationValues(center.dx, center.dy, 0);
    matrix4.multiply(Matrix4.rotationZ(line.direction));
    // 2.反向平移，抵消 1 处平移影响
    matrix4.multiply(Matrix4.translationValues(-center.dx, -center.dy, 0));
    linePath = linePath.transform(matrix4.storage);

    /// 尺寸校正：箭头在两端点处，合成路径前通过偏移对首尾断点校正
    // 沿线方向平移，保证该直线过端点矩形区域圆心
    Path headPath = head.fromPath();
    double fixDx = head.size.width / 2 * cos(line.direction);
    double fixDy = head.size.height / 2 * sin(line.direction);

    Matrix4 headMatrix4 = Matrix4.translationValues(fixDx, fixDy, 0);

    // 头箭头根据线的倾角添加旋转变换,先变换矩阵中心
    center = head.center;
    headMatrix4.multiply(Matrix4.translationValues(center.dx, center.dy, 0));
    headMatrix4.multiply(Matrix4.rotationZ(line.direction));
    headMatrix4.multiply(Matrix4.translationValues(-center.dx, -center.dy, 0));
    headPath = headPath.transform(headMatrix4.storage);

    Path tailPath = tail.fromPath();
    Matrix4 tailMatrix4 = Matrix4.translationValues(-fixDx, -fixDy, 0);

    // 尾箭头根据线的倾角添加旋转变换，再旋转180°，调整方向,先变换矩阵中心
    center = tail.center;
    tailMatrix4.multiply(Matrix4.translationValues(center.dx, center.dy, 0));
    tailMatrix4.multiply(Matrix4.rotationZ(line.direction - pi));
    tailMatrix4.multiply(Matrix4.translationValues(-center.dx, -center.dy, 0));

    // 尾部箭头平移箭头大小一半，避免线条突出
    tailMatrix4.multiply(Matrix4.translationValues(-head.size.width / 2, 0, 0));
    tailPath = tailPath.transform(tailMatrix4.storage);

    // PathOperation.union：路径并集
    Path temp = Path.combine(PathOperation.union, linePath, headPath);
    return Path.combine(PathOperation.union, temp, tailPath);
  }
}

/// 三角形
class TrianglePath extends AbsPath {
  Offset fixedPoint;
  Offset leftPoint;
  Offset rightPoint;

  TrianglePath(
      {required this.fixedPoint,
      required this.leftPoint,
      required this.rightPoint});

  @override
  Path fromPath() => Path()
    ..moveTo(fixedPoint.dx, fixedPoint.dy)
    ..lineTo(leftPoint.dx, leftPoint.dy)
    ..lineTo(rightPoint.dx, rightPoint.dy)
    ..close();
}

/// 多边形Polygon：平行四边形(1)，菱形(2)，六边形(3)
class PolygonPath extends AbsPath {
  Offset first;
  Size size;
  int factor;

  PolygonPath({required this.first, required this.size, this.factor = 2});

  @override
  Path fromPath() {
    switch (factor) {
      case 1:
        return _parallelogram();
      case 2:
        return _diamond();
      default:
        return _hexagon();
    }
  }

  // 平行四边形
  Path _parallelogram() => Path()
    ..moveTo(first.dx, first.dy)
    ..lineTo(first.dx + size.width / 2, first.dy)
    ..lineTo(first.dx + size.width, first.dy + size.height)
    ..lineTo(first.dx + size.width / 2, first.dy + size.height)
    ..close();

  // 菱形
  Path _diamond() => Path()
    ..moveTo(first.dx + size.width / 2, first.dy)
    ..lineTo(first.dx + size.width, first.dy + size.height / 2)
    ..lineTo(first.dx + size.width / 2, first.dy + size.height)
    ..lineTo(first.dx, first.dy + size.height / 2)
    ..close();

  // 六边形
  Path _hexagon() => Path()
    ..moveTo(first.dx + size.width / 3, first.dy)
    ..lineTo(first.dx + size.width / 3 * 2, first.dy)
    ..lineTo(first.dx + size.width, first.dy + size.height / 3)
    ..lineTo(first.dx + size.width, first.dy + size.height / 3 * 2)
    ..lineTo(first.dx + size.width / 3 * 2, first.dy + size.height)
    ..lineTo(first.dx + size.width / 3, first.dy + size.height)
    ..lineTo(first.dx, first.dy + size.height / 3 * 2)
    ..lineTo(first.dx, first.dy + size.height / 3)
    ..close();
}

/// 五角星
class StarPath extends AbsPath {
  Offset first;
  Size size;
  int count;

  StarPath({required this.first, required this.size, this.count = 5});

  double _degreeToRadius(double degree) => degree * (pi / 180.0);

  @override
  Path fromPath() {
    Path path = Path();

    double max = 2 * pi;

    double width = size.width;
    // double halfWidth = first.dx + width / 2;
    double halfWidth = width / 2;

    double wingRadius = halfWidth;
    double radius = halfWidth / 2;

    double degreePreStep = _degreeToRadius(360 / count);
    double halfDegreePreStep = degreePreStep / 2;

    path.moveTo(width, halfWidth);

    for (double step = 0; step < max; step += degreePreStep) {
      path.lineTo(halfWidth + wingRadius * cos(step),
          halfWidth + wingRadius * sin(step));
      path.lineTo(halfWidth + radius * cos(step + halfDegreePreStep),
          halfWidth + radius * sin(step + halfDegreePreStep));
    }

    path.close();
    return path;
  }
}
