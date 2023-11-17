import 'dart:math';

import 'package:flutter/material.dart';
import 'package:x_write/model/render/data/paint_state.dart';
import 'package:x_write/model/render/data/Point.dart';

/// 路径抽象类，生产路径
abstract class AbsPath {
  Path fromPath();
}

/// 箭头路径
class PortPath extends AbsPath {
  final Offset center; // 点
  final Size size;
  AbsPortPathBuilder portPath;

  PortPath({required this.center, required this.size, this.portPath = const TrianglePortPath()});

  @override
  Path fromPath() {
    Rect zone = Rect.fromCenter(center: center, width: size.width, height: size.height);
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

  TrianglePath({required this.fixedPoint, required this.leftPoint, required this.rightPoint});

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
      path.lineTo(halfWidth + wingRadius * cos(step), halfWidth + wingRadius * sin(step));
      path.lineTo(
          halfWidth + radius * cos(step + halfDegreePreStep), halfWidth + radius * sin(step + halfDegreePreStep));
    }

    path.close();
    return path;
  }
}

/// 图形绘制及圆中取形
class ShapeFromCircular extends AbsPath {
  final ShapeType shapeType;
  final Point first;
  final Point last;

  // 多边形边数
  int polygonCount;

  ShapeFromCircular(
      {this.shapeType = ShapeType.circle, required this.first, required this.last, this.polygonCount = 5});

  @override
  Path fromPath() {
    // 首尾点
    double firstX = first.x;
    double firstY = first.y;
    double lastX = last.x;
    double lastY = last.y;

    // x,y间距
    double spaceX = lastX - firstX;
    double spaceY = lastY - firstY;

    // 中心点
    Offset center = Offset(firstX + spaceX / 2, firstY + spaceY / 2);
    switch (shapeType) {
      case ShapeType.oval:
        return _oval(center, spaceX.abs(), spaceY.abs());
      case ShapeType.square:
        return _square(center, spaceX.abs(), spaceY.abs());
      // return _square2(center, sqrt(spaceX.abs() * spaceX.abs() + spaceY.abs() * spaceY.abs()) / 2);
      case ShapeType.regularTriangle:
        return _triangle(Offset(firstX + spaceX / 2, firstY), Offset(firstX, lastY), Offset(lastX, lastY));
      case ShapeType.rightTriangle:
        return _triangle(Offset(firstX, firstY), Offset(firstX, lastY), Offset(lastX, lastY));
      case ShapeType.star:
        return _polygon(sqrt(spaceX.abs() * spaceX.abs() + spaceY.abs() * spaceY.abs()) / 2);
      case ShapeType.polygon:
        return _polygon(sqrt(spaceX.abs() * spaceX.abs() + spaceY.abs() * spaceY.abs()) / 2);
      case ShapeType.arrow:
        return _arrow();
      case ShapeType.line:
        return _line();
      default:
        return _circle(center, sqrt(spaceX.abs() * spaceX.abs() + spaceY.abs() * spaceY.abs()) / 2);
    }
  }

  // 椭圆
  Path _oval(Offset center, double width, double height) {
    Path path = Path();
    Rect oval = Rect.fromCenter(center: center, width: width, height: height);
    path.addOval(oval);
    return path;
  }

  // 矩形
  Path _square(Offset center, double width, double height) {
    Path path = Path();
    Rect square = Rect.fromCenter(center: center, width: width, height: height);
    path.addRect(square);
    return path;
  }

  // 圆角矩形
  Path _square2(Offset center, double radius) {
    Path path = Path();
    RRect square = RRect.fromRectAndRadius(Rect.fromCircle(center: center, radius: radius), const Radius.circular(10));
    path.addRRect(square);
    return path;
  }

  // 三角形
  Path _triangle(Offset fixed, Offset left, Offset right) => Path()
    ..moveTo(fixed.dx, fixed.dy)
    ..lineTo(left.dx, left.dy)
    ..lineTo(right.dx, right.dy)
    ..close();

  // 箭头
  Path _arrow() {
    Size portSize = const Size(10, 10);
    ArrowPath arrowPath = ArrowPath(
        head: PortPath(center: Offset(first.x, first.y), size: portSize, portPath: const NullPortPath()),
        tail: PortPath(center: Offset(last.x, last.y), size: portSize, portPath: const ThreeAnglePortPath()));
    Path path = Path();
    path.addPath(arrowPath.fromPath(), Offset.zero);
    return path;
  }

  // 线
  Path _line() => Path()
    ..moveTo(first.x, first.y)
    ..lineTo(last.x, last.y);

  // 圆
  Path _circle(Offset center, double radius) {
    Path path = Path();
    Rect circle = Rect.fromCircle(center: center, radius: radius);
    path.addOval(circle);
    return path;
  }

  /// 多边形
  /// sin(0) = 0       cos(0) = 1       tan(0) = 0       cot0 = error
  /// sin(30) = 0.5    cos(30) = √3/2   tan(30) = √3/3   cot30 = √3
  /// sin(45) = √2/2   cos(45) = √2/2   tan(45) = 1      cot45 = 1
  /// sin(60) = √3/2   cos(60) = 1/2    tan(60) = √3     cot60 = √3/3
  Path _polygon(double radius) {
    // 默认上下对称，奇数多边形视觉效果不对称，逆时针旋转90°保证视觉对称
    bool isOdd = polygonCount % 2 == 1;
    double rotate = -pi / 2;
    List<Offset> points = [];
    for (int i = 0; i < polygonCount; i++) {
      double perRad = 2 * pi / polygonCount * i;

      // 计算时加旋转量保证视觉对称(奇数)，偶数不需要
      double x = isOdd ? radius * cos(perRad + rotate) : radius * cos(perRad);
      double y = isOdd ? radius * sin(perRad + rotate) : radius * sin(perRad);
      points.add(Offset(x, y));
    }
    Path path = Path();
    path.moveTo(points[0].dx, points[0].dy);
    for (int i = 1; i < points.length; i++) {
      path.lineTo(points[i].dx, points[i].dy);
    }
    path.close();
    return path;
  }
}
