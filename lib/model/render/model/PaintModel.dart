import 'package:flutter/material.dart';
import 'package:x_write/model/render/data/Point.dart';

import '../item/Line.dart';

/// 整合线集,可监听对象（ChangeNotifier）
class PaintModel extends ChangeNotifier {
  /// 点距差过滤阈值：比较point与正在画最后一点距离差，大于阈值添加，小于过滤
  final double tolerance = 18.0;

  /// 线集
  final List<Line?> _lines = [];

  /// 获取线集
  List<Line?> get lines => _lines;

  /// 当前绘制点，按下时添加一个doing状态line，抬手置为done
  Line? get activeLine =>
      _lines.singleWhere((line) => line?.state == PaintState.doing,
          orElse: () => null);

  /// 当前edit状态线
  Line? get editLine =>
      _lines.singleWhere((line) => line?.state == PaintState.edit,
          orElse: () => null);

  /// 收集线
  void pushLine(Line line) {
    _lines.add(line);
  }

  /// 移动中收集 Point 放入activeLine，force控制是否过滤点，默认过滤，避免点密集绘制线条不圆滑
  void pushPoint(Point point, { bool force = false }) {
    if (activeLine == null) return;

    if (activeLine!.points.isNotEmpty && !force) {
      if ((point - activeLine!.points.last).distance < tolerance) return;
    }

    activeLine!.points.add(point);

    /// 通知画板重绘，避免setState对组件重构
    notifyListeners();
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
    for (var line in _lines) { line?.state = PaintState.done; }
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

  /// 清除线集
  void clear() {
    for (var line in _lines) {line?.points.clear();}
    _lines.clear();

    /// 通知画板重绘，避免setState对组件重构
    notifyListeners();
  }

  /// 移除空点集线
  void removeEmpty() {
    _lines.removeWhere((line) => line?.points.isEmpty ?? true);
  }
}
