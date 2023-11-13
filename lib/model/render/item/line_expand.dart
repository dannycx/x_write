import 'dart:math';

import 'package:flutter/material.dart';
import 'package:x_write/model/render/data/Point.dart';

/// 线条抽象类，画线
abstract class AbsLineRender {
  const AbsLineRender();

  void drawLine(Canvas canvas, Paint paint, List<Point> point);
}

/// 铅笔
class Pencil extends AbsLineRender {
  const Pencil();

  @override
  void drawLine(Canvas canvas, Paint paint, List<Point> points) {
    Path path = fromPath(points);
    canvas.drawPath(path, paint);
  }
}

/// 钢笔
class Pen extends AbsLineRender {
  const Pen();

  @override
  void drawLine(Canvas canvas, Paint paint, List<Point> points) {
    Path path = fromPath(points);
    canvas.drawPath(path, paint);
    // points = _handlePoint(points);
    // Point curPoint = points[0];
    // for (int index = 1; index < points.length; index++) {
    //   Point point = points[index];
    //   drawLine2(canvas, curPoint.x, curPoint.y, curPoint.press, point.x,
    //       point.y, point.press, paint);
    //   curPoint = point;
    // }
  }

  /// 绘制方法，实现笔锋效果
  void drawLine2(Canvas canvas, double x0, double y0, double w0, double x1,
      double y1, double w1, Paint paint) {
    // 求两个数字的平方根 x的平方+y的平方在开方记得X的平方+y的平方=1，这就是一个园
    double curDis = sqrt((x0 - x1) * (x0 - x1) + (y0 - y1) * (y0 - y1));

    // 绘制的笔的宽度是多少，绘制多少个椭圆
    final int steps;
    if (paint.strokeWidth < 6) {
      steps = (1 + curDis / 2) as int;
    } else if (paint.strokeWidth > 60) {
      steps = (1 + (curDis / 4)) as int;
    } else {
      steps = (1 + (curDis / 3)) as int;
    }
    double deltaX = (x1 - x0) / steps;
    double deltaY = (y1 - y0) / steps;
    double deltaW = (w1 - w0) / steps;
    double x = x0;
    double y = y0;
    double w = w0;
    int index = 0;
    while (index < steps) {
      double top = (y - w / 2.0);
      double left = (x - w / 4.0);
      double right = (x + w / 4.0);
      double bottom = (y + w / 2.0);
      Rect oval = Rect.fromLTRB(left, top, right, bottom);
      canvas.drawOval(oval, paint);
      x += deltaX;
      y += deltaY;
      w += deltaW;
      index++;
    }
  }

  List<Point> _handlePoint(List<Point> points) {
    List<Point> pointList = [];
    Point lastPoint = points[0];
    double lastVel = 0.0;
    double lastWidth = 3 * 0.7;
    for (int index = 1; index < points.length; index++) {
      Point curPoint = points[index];
      double deltaX = (curPoint.x - lastPoint.x);
      double deltaY = (curPoint.y - lastPoint.y);

      // deltaX 和 deltaY平方和的二次方根 想象一个例子 1+1的平方根为1.4 （x²+y²）开根号
      // 同理，当滑动的越快的话，deltaX + deltaY的值越大，这个越大的话，curDis也越大
      double curDis = sqrt(deltaX * deltaX + deltaY * deltaY);

      // 我们求出的这个值越小，画的点或者是绘制椭圆形越多，这个值越大的话，绘制的越少，笔就越细，宽度越小
      double curVel = curDis * DIS_VEL_CAL_FACTOR;
      double curWidth;
      if (index < 2) {
        curWidth = _calcNewWidth(curVel, lastVel, curDis, 1.7, lastWidth);
        curPoint.press = curWidth;
        pointList.add(curPoint);
      } else {
        lastVel = curVel;
        curWidth = _calcNewWidth(curVel, lastVel, curDis, 1.7, lastWidth);
        curPoint.press = curWidth;
        pointList.add(curPoint);
      }
      lastPoint = curPoint;
      lastWidth = curWidth;
    }

    return pointList;
  }

  /// 计算新的宽度信息
  double _calcNewWidth(double curVel, double lastVel, double curDis,
      double factor, double lastWidth) {
    double calVel = curVel * 0.6 + lastVel * (1 - 0.6);
    double vfac = log(factor * 2.0) * -calVel;
    return 3 * exp(vfac);
  }
}

/// 毛笔
class Brush extends AbsLineRender {
  const Brush();

  @override
  void drawLine(Canvas canvas, Paint paint, List<Point> points) {
    Path path = fromPath(points);
    canvas.drawPath(path, paint);
  }
}

/// 荧光笔
class Highlight extends AbsLineRender {
  final int opacity;

  const Highlight({this.opacity = 140});

  @override
  void drawLine(Canvas canvas, Paint paint, List<Point> points) {
    Color handleColor = paint.color;
    int r = handleColor.red;
    int g = handleColor.green;
    int b = handleColor.blue;
    paint.color = Color.fromARGB(opacity, r, g, b);
    Path path = fromPath(points);
    canvas.drawPath(path, paint);
  }
}

/// 二阶贝塞尔，拟合线条，更平滑
Path fromPath(List<Point> points) {
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

/// 三阶贝塞尔，绘制波浪线
Path fromPath2(List<Point> points) {
  Path path = Path();

  for (int i = 0; i < points.length - 1; i++) {
    Point current = points[i];
    Point next = points[i + 1];
    if (i == 0) {
      path.moveTo(current.x, current.y);

      /// 控制点
      double ctrlX = current.x + (next.x - current.x) / 2;
      double ctrlY = next.y;
      path.quadraticBezierTo(ctrlX, ctrlY, next.x, next.y);
    } else if (i < points.length - 2) {
      /// 控制点1
      double ctrlX1 = current.x + (next.x - current.x) / 2;
      double ctrlY1 = current.y;

      /// 控制点2
      double ctrlX2 = ctrlX1;
      double ctrlY2 = next.y;

      double xc = (current.x + next.x) / 2;
      double yc = (current.y + next.y) / 2;
      // Point p2 = points[i];
      // path.quadraticBezierTo(p2.x, p2.y, xc, yc);
      path.cubicTo(ctrlX1, ctrlY1, ctrlX2, ctrlY2, next.x, next.y);
    } else {
      path.moveTo(current.x, current.y);

      /// 控制点
      double ctrlX = current.x + (next.x - current.x) / 2;
      double ctrlY = current.y;
      path.quadraticBezierTo(ctrlX, ctrlY, next.x, next.y);
    }
  }

  return path;
}

/// 贝塞尔操作工具类，对点的位置和宽度控制的bezier曲线，主要是两个点，都包含了宽度和点的坐标
class Bezier {
  // 控制点
  final controlPoint = Point();

  // 距离
  final destinationPoint = Point();

  // 下一个控制点
  final nextPoint = Point();

  // 资源的点
  final source = Point();

  /// 初始化两个点，
  ///
  /// @param last 最后的点的信息
  /// @param cur  当前点的信息,当前点的信息，当前点的是根据事件获得，同时这个当前点的宽度是经过计算的得出的
  void init(Point last, Point cur) {
    _init(last.x, last.y, last.press, cur.x, cur.y, cur.press);
  }

  void _init(double lastX, double lastY, double lastWidth, double x, double y,
      double width) {
    // 资源点设置，最后的点的为资源点
    source.setPointXY(lastX, lastY, lastWidth);
    double xMid = getMid(lastX, x);
    double yMid = getMid(lastY, y);
    double wMid = getMid(lastWidth, width);

    // 距离点为平均点
    destinationPoint.setPointXY(xMid, yMid, wMid);

    // 控制点为当前的距离点
    controlPoint.setPointXY(
        getMid(lastX, xMid), getMid(lastY, yMid), getMid(lastWidth, wMid));

    // 下个控制点为当前点
    nextPoint.setPointXY(x, y, width);
  }

  void addNode(Point cur) {
    _addNode(cur.x, cur.y, cur.press);
  }

  /// 替换旧的点，原来的距离点变换为资源点，控制点变为原来的下一个控制点，距离点取原来控制点的和新的的一半
  /// 下个控制点为新的点
  ///
  /// @param x     新的点的坐标
  /// @param y     新的点的坐标
  /// @param width
  void _addNode(double x, double y, double width) {
    source.setPoint(destinationPoint);
    controlPoint.setPoint(nextPoint);
    destinationPoint.setPointXY(getMid(nextPoint.x, x), getMid(nextPoint.y, y),
        getMid(nextPoint.press, width));
    nextPoint.setPointXY(x, y, width);
  }

  /// 结合手指抬起来的动作，告诉现在的曲线控制点也必须变化，其实在这里也不需要结合着up事件使用
  /// 因为在down的事件中，所有点都会被重置，然后设置这个没有多少意义，但是可以改变下个事件的朝向改变
  /// 先留着，因为后面如果需要控制整个颜色的改变的话，我的依靠这个方法，还有按压的时间的变化
  void end() {
    source.setPoint(destinationPoint);
    double x = getMid(nextPoint.x, source.x);
    double y = getMid(nextPoint.y, source.y);
    double w = getMid(nextPoint.press, source.press);
    controlPoint.setPointXY(x, y, w);
    destinationPoint.setPoint(nextPoint);
  }

  /// 获取两个数平均值
  ///
  /// @param x1 一个点的x
  /// @param x2 一个点的x
  double getMid(double x1, double x2) {
    return ((x1 + x2) / 2.0);
  }

  /// 获取点信息
  Point getPoint(double t) {
    double x = getX(t);
    double y = getY(t);
    double w = getW(t);
    return Point(x: x, y: y, press: w);
  }

  double getX(double t) {
    return getValue(source.x, controlPoint.x, destinationPoint.x, t);
  }

  double getY(double t) {
    return getValue(source.y, controlPoint.y, destinationPoint.y, t);
  }

  double getW(double t) {
    return getWidth(source.press, destinationPoint.press, t);
  }

  /// 三阶曲线的控制点
  double getValue(double p0, double p1, double p2, double t) {
    double a = p2 - 2 * p1 + p0;
    double b = 2 * (p1 - p0);
    return a * t * t + b * t + p0;
  }

  double getWidth(double w0, double w1, double t) {
    return w0 + (w1 - w0) * t;
  }
}

/// 笔锋控制值,越小笔锋越粗,越不明显
const double DIS_VEL_CAL_FACTOR = 0.008;

/// 绘制计算的次数，数值越小计算的次数越多
const int STEP_FACTOR = 20;
