import 'package:flutter/material.dart';
import 'package:x_write/model/render/data/Point.dart';

import '../item/Line.dart';

/// 整合线集,可监听对象（ChangeNotifier）
class PaintModel extends ChangeNotifier {
  /// 线集
  final List<Line?> _lines = [];

  /// 获取线集
  List<Line?> get lines => _lines;

  /// 当前绘制点，按下时添加一个doing状态line，抬手置为done
  Line? get activeLine =>
      _lines.singleWhere((line) => line?.state == PaintState.doing,
          orElse: () => null);

  /// 收集线
  void pushLine(Line line) {
    _lines.add(line);
  }

  /// 移动中收集 Point 放入activeLine
  void pushPoint(Point point) {
    if (activeLine == null) {
      return;
    }

    activeLine?.points.add(point);

    /// 通知画板重绘，避免setState对组件重构
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
