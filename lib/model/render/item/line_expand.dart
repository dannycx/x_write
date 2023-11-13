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

class Bezier {
  // 控制点
  final controlPoint = Point(x: 0, y: 0);

  // 距离
  final destinationPoint = Point(x: 0, y: 0);

  // 下一个控制点
  final nextPoint = Point(x: 0, y: 0);

  // 资源的点
  final source = Point(x: 0, y: 0);

  /// 初始化两个点，
  ///
  /// @param last 最后的点的信息
  /// @param cur  当前点的信息,当前点的信息，当前点的是根据事件获得，同时这个当前点的宽度是经过计算的得出的
  void init(Point last, Point cur) {
    _init(last.x, last.y, last.press, cur.x, cur.y, cur.press);
  }

  void _init(double lastX, double lastY, double lastWidth, double x, double y, double width) {
    // 资源点设置，最后的点的为资源点
    source.setPointXY(lastX, lastY, lastWidth);
    double xMid = getMid(lastX, x);
    double yMid = getMid(lastY, y);
    double wMid = getMid(lastWidth, width);

    // 距离点为平均点
    destinationPoint.setPointXY(xMid, yMid, wMid);

    // 控制点为当前的距离点
    controlPoint.setPointXY(getMid(lastX, xMid), getMid(lastY, yMid), getMid(lastWidth, wMid));

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
    destinationPoint.setPointXY(getMid(nextPoint.x, x), getMid(nextPoint.y, y), getMid(nextPoint.press, width));
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
    return getValue(source.x.toDouble(), controlPoint.x.toDouble(), destinationPoint.x.toDouble(), t);
  }

  double getY(double t) {
    return getValue(source.y.toDouble(), controlPoint.y.toDouble(), destinationPoint.y.toDouble(), t);
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
