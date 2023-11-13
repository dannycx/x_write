import 'dart:math';

import 'package:flutter/material.dart';
import 'package:x_write/model/render/data/Point.dart';
import 'package:x_write/model/render/item/line_expand.dart';

import '../data/paint_state.dart';
import '../item/Line.dart';
import '../item/Shape.dart';

/// 整合线集,可监听对象（ChangeNotifier）
class PaintModel extends ChangeNotifier {
  /// 点距差过滤阈值：比较point与正在画最后一点距离差，大于阈值添加，小于过滤
  final double tolerance = 18.0;

  OpType opType = OpType.pen;
  ShapeType shapeType = ShapeType.circle;

  PaintModel({this.opType = OpType.pen, this.shapeType = ShapeType.circle});

  // 笔锋处理
  Point lastPoint = Point(x: 0, y: 0);
  Point curPoint = Point(x: 0, y: 0);
  double lastVel = 0.0;
  double lastWidth = 0.0;

  /// 线集
  final List<Line?> _lines = [];

  /// 获取线集
  List<Line?> get lines => _lines;

  /// 当前绘制点，按下时添加一个doing状态line，抬手置为done
  Line? get activeLine => _lines.singleWhere((line) => line?.state == PaintState.doing, orElse: () => null);

  /// 当前edit状态线
  Line? get editLine => _lines.singleWhere((line) => line?.state == PaintState.edit, orElse: () => null);

  /// 图形集
  final List<Shape?> _shapes = [];

  /// 获取图形集
  List<Shape?> get shapes => _shapes;

  /// 当前绘制点，按下时添加一个doing状态shape，抬手置为done
  Shape? get activeShape => _shapes.singleWhere((shape) => shape?.state == PaintState.doing, orElse: () => null);

  /// 当前edit状态线
  Shape? get editShape => _shapes.singleWhere((shape) => shape?.state == PaintState.edit, orElse: () => null);

  /// 追加子项
  void pushItem(DragDownDetails details, OpType oType, ShapeType sType, Color color, double strokeWidth) {
    opType = oType;
    shapeType = sType;
    switch (opType) {
      case OpType.pen:
        // 钢笔画线
        Line line = Line(color: color, strokeWidth: strokeWidth, lineRender: const Pen());
        _lines.add(line);
        lastPoint = Point.fromOffset(details.localPosition);
        pushPointSteelLine(lastPoint);
        break;
      case OpType.highlight:
        // 荧光笔画线
        Line line = Line(color: color, strokeWidth: strokeWidth, lineRender: const Highlight());
        _lines.add(line);
        lastPoint = Point.fromOffset(details.localPosition);
        pushPointLine(lastPoint);
        break;
      case OpType.pencil:
        // 铅笔画线
        Line line = Line(color: color, strokeWidth: strokeWidth, lineRender: const Pencil());
        _lines.add(line);
        lastPoint = Point.fromOffset(details.localPosition);
        pushPointLine(lastPoint);
        break;
      case OpType.brush:
        // 毛笔画线
        Line line = Line(color: color, strokeWidth: strokeWidth, lineRender: const Brush());
        _lines.add(line);
        lastPoint = Point.fromOffset(details.localPosition);
        pushPointLine(lastPoint);
        break;
      case OpType.shape:
        // 收集形状
        Shape shape = Shape(color: color, shapeType: shapeType);
        _shapes.add(shape);
        break;
      default:
        break;
    }
  }

  /// 追加点至子项
  void pushPointItem(Point point, {bool force = false}) {
    switch (opType) {
      case OpType.pen:
      case OpType.highlight:
      case OpType.pencil:
      case OpType.brush:
        pushPointLine(point, force: force);
        break;
      case OpType.shape:
        pushPointShape(point, force: force);
        break;
      default:
        break;
    }
  }

  /// 编辑子项
  void activeEditItem(Point point) {
    switch (opType) {
      case OpType.pen:
      case OpType.highlight:
      case OpType.pencil:
      case OpType.brush:
        activeEditLine(point);
        break;
      case OpType.shape:
        activeEditShape(point);
        break;
      default:
        break;
    }
  }

  /// 取消编译子项
  void cancelEditItem() {
    switch (opType) {
      case OpType.pen:
      case OpType.highlight:
      case OpType.pencil:
      case OpType.brush:
        cancelEditLine();
        break;
      case OpType.shape:
        cancelEditShape();
        break;
      default:
        break;
    }
  }

  /// 移动编译子项
  void moveEditItem(Offset offset) {
    switch (opType) {
      case OpType.pen:
      case OpType.highlight:
      case OpType.pencil:
      case OpType.brush:
        moveEditLine(offset);
        break;
      case OpType.shape:
        moveEditShape(offset);
        break;
      default:
        break;
    }
  }

  /// 完成子项
  void doneItem() {
    switch (opType) {
      case OpType.pen:
      case OpType.highlight:
      case OpType.pencil:
      case OpType.brush:
        doneLine();
        break;
      case OpType.shape:
        doneShape();
        break;
      default:
        break;
    }
  }

  /// 清屏
  void clearItem() {
    for (var line in _lines) {
      line?.points.clear();
    }
    _lines.clear();

    for (var shape in _shapes) {
      shape?.points.clear();
    }
    _shapes.clear();

    /// 通知画板重绘，避免setState对组件重构
    notifyListeners();
  }

  /// 移除空点集子项
  void removeEmptyItem() {
    _lines.removeWhere((line) => line?.points.isEmpty ?? true);
    _shapes.removeWhere((shape) => shape?.points.isEmpty ?? true);
  }

  /// 收集线
  void pushLine(Line line) {
    _lines.add(line);
  }

  /// 移动中收集 Point 放入activeLine，force控制是否过滤点，默认过滤，避免点密集绘制线条不圆滑
  void pushPointLine(Point point, {bool force = false}) {
    if (activeLine == null) return;

    if (activeLine!.points.isNotEmpty && !force) {
      if ((point - activeLine!.points.last).distance < tolerance) return;
    }

    activeLine!.points.add(point);

    /// 通知画板重绘，避免setState对组件重构
    notifyListeners();
  }

  /// 移动中收集 Point 放入activeLine，force控制是否过滤点，默认过滤，避免点密集绘制线条不圆滑
  /// 硬笔轨迹
  void pushPointSteelLine(Point point, {bool force = false}) {
    if (activeLine == null) return;

    if (activeLine!.points.isNotEmpty && !force) {
      if ((point - activeLine!.points.last).distance < tolerance) return;
    }

    curPoint = point;
    double deltaX = curPoint.x - lastPoint.x;
    double deltaY = curPoint.y - lastPoint.y;

    // deltaX 和 deltaY平方和的二次方根 想象一个例子 1+1的平方根为1.4 （x²+y²）开根号
    // 同理，当滑动的越快的话，deltaX + deltaY的值越大，这个越大的话，curDis也越大
    double curDis = sqrt(deltaX * deltaX + deltaY * deltaY);

    // 我们求出的这个值越小，画的点或者是绘制椭圆形越多，这个值越大的话，绘制的越少，笔就越细，宽度越小
    double curVel = curDis * DIS_VEL_CAL_FACTOR;
    final double curWidth;

    if (activeLine!.points.length < 2) {
      curWidth = _calcNewWidth(curVel, lastVel, curDis, 1.7, lastWidth);
      point.press = curWidth;
    } else {
      lastVel = curVel;
      curWidth = _calcNewWidth(curVel, lastVel, curDis, 1.7, lastWidth);
      point.press = curWidth;
    }
    activeLine!.points.add(point);

    lastWidth = curWidth;
    lastPoint = curPoint;

    /// 通知画板重绘，避免setState对组件重构
    notifyListeners();
  }

  /// 计算新的宽度信息
  double _calcNewWidth(double curVel, double lastVel, double curDis, double factor, double lastWidth) {
    double calVel = curVel * 0.6 + lastVel * (1 - 0.6);
    double vfac = log(factor * 2.0) * -calVel;
    return activeLine!.strokeWidth * exp(vfac);
  }

  /// 通过路径矩形区域判断是否需要把线置为edit状态，重叠取第一个
  void activeEditLine(Point point) {
    List<Line?> lines = _lines.where((line) => line?.path().getBounds().contains(point.toOffset()) ?? false).toList();
    print('lines.length: ${lines.length}');
    if (lines.isNotEmpty) {
      lines[0]?.state = PaintState.edit;
      lines[0]?.record();
      notifyListeners();
    }
  }

  /// 降edit状态改为done
  void cancelEditLine() {
    for (var line in _lines) {
      line?.state = PaintState.done;
    }
    notifyListeners();
  }

  /// 使用translate移动路径
  void moveEditLine(Offset offset) {
    if (editLine == null) return;
    editLine?.translate(offset);
    notifyListeners();
  }

  void doneLine() {
    if (activeLine == null) return;

    activeLine?.state = PaintState.done;

    /// 通知画板重绘，避免setState对组件重构
    notifyListeners();
  }

  /// 收集线
  void pushShape(Shape shape) {
    _shapes.add(shape);
  }

  /// 移动中收集 Point 放入activeShape，force控制是否过滤点，默认过滤，避免点过密，计算增加
  void pushPointShape(Point point, {bool force = false}) {
    if (activeShape == null) return;

    if (activeShape!.points.isNotEmpty && !force) {
      if ((point - activeShape!.points.last).distance < tolerance) return;
    }

    activeShape!.points.add(point);

    /// 通知画板重绘，避免setState对组件重构
    notifyListeners();
  }

  /// 通过路径矩形区域判断是否需要把线置为edit状态，重叠取第一个
  void activeEditShape(Point point) {
    List<Shape?> shapes = _shapes.where((shape) => shape?.rect()?.contains(point.toOffset()) ?? false).toList();
    print('shapes.length: ${shapes.length}');
    if (shapes.isNotEmpty) {
      shapes[0]?.state = PaintState.edit;
      shapes[0]?.record();
      notifyListeners();
    }
  }

  /// 降edit状态改为done
  void cancelEditShape() {
    for (var shape in _shapes) {
      shape?.state = PaintState.done;
    }
    notifyListeners();
  }

  /// 使用translate移动路径
  void moveEditShape(Offset offset) {
    if (editShape == null) return;
    editShape?.translate(offset);
    notifyListeners();
  }

  void doneShape() {
    if (activeShape == null) return;

    activeShape?.state = PaintState.done;

    /// 通知画板重绘，避免setState对组件重构
    notifyListeners();
  }
}
