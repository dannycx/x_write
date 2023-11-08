import 'package:flutter/material.dart';
import 'package:x_write/model/render/data/Point.dart';
import 'package:x_write/model/render/item/Line.dart';
import 'package:x_write/model/render/model/PaintModel.dart';
import 'package:x_write/model/render/painter/LinePainter.dart';

/// 书写组件
class WritingPage extends StatefulWidget {
  const WritingPage({super.key});

  @override
  _WritingPageState createState() => _WritingPageState();
}

class _WritingPageState extends State<WritingPage> {
  final PaintModel model = PaintModel();

  Color lineColor = Colors.black;

  double strokeWidth = 1;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onPanDown: _initLineDate, /// 按下
      onPanUpdate: _collectPoint, /// 拖动收集点
      onPanEnd: _doneLine, /// 拖动结束
      onPanCancel: _cancel, /// 拖动取消
      onDoubleTap: _clear, /// 双击清除
      child: CustomPaint(
        size: MediaQuery.of(context).size,
        painter: LinePainter(model: model),
      ),
    );
  }

  @override
  void dispose() {
    // 释放可监听对象PaintModel
    model.dispose();
    super.dispose();
  }

  // 创建Line,pushLine添加至PaintModel中
  void _initLineDate(DragDownDetails details) {
    Line line = Line(color: lineColor, strokeWidth: strokeWidth);
    model.pushLine(line);
  }

  /// 拖动时收集点，将点加入doing状态Line中
  void _collectPoint(DragUpdateDetails details) {
    model.pushPoint(Point.fromOffset(details.localPosition));
  }

  /// 结束，doing状态改为done,当前只有一个活动线条
  void _doneLine(DragEndDetails details) {
    model.doneLine();
  }

  /// 立即抬起时，会执行onPanCancel，而onPanEnd不会执行，需对点集为空的线进行清理
  void _cancel() {
    model.removeEmpty();
  }

  void _clear() {
  }
}
