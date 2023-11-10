import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:x_write/model/render/data/Point.dart';
import 'package:x_write/model/render/data/paint_state.dart';
import 'package:x_write/model/render/data/write_value_notifier.dart';
import 'package:x_write/model/render/model/PaintModel.dart';
import 'package:x_write/model/render/painter/Painter.dart';
import 'package:x_write/ui/prop/confirm_dialog.dart';
import 'package:x_write/ui/prop/paint_setting_dialog.dart';

/// 书写组件
class WritingPage extends StatefulWidget {
  const WritingPage({super.key});

  @override
  _WritingPageState createState() => _WritingPageState();
}

class _WritingPageState extends State<WritingPage> {
  final PaintModel model = PaintModel();

  // 操作类型
  OpType opType = OpType.pen;

  // 颜色
  Color lineColor = Colors.black;

  // 粗细
  double strokeWidth = 1;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    bus.on("opTYpe", (type) {
      print('_WritingPageState type: $type');
      print('_WritingPageState type: ${type}');

      // opType = type;
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onPanDown: _initLineDate, /// 按下
      onPanUpdate: _collectPoint, /// 拖动收集点
      onPanEnd: _doneLine, /// 拖动结束
      onPanCancel: _cancel, /// 拖动取消
      onDoubleTap: _clearTip, /// 双击清除
      onTap: _showPenSettingDialog, /// 笔属性设置
      onLongPressStart: _activeEdit, // 长按开始，激活编辑线条
      onLongPressMoveUpdate: _moveEdit, // 长按移动，移动线条
      onLongPressUp: _cancelEdit, // 长按抬起，取消编辑
      child: CustomPaint(
        size: MediaQuery.of(context).size,
        painter: Painter(model: model),
      ),
    );
  }

  @override
  void dispose() {
    // 释放可监听对象PaintModel
    model.dispose();
    bus.off('opType');
    super.dispose();
  }

  // 创建Line,pushLine添加至PaintModel中
  void _initLineDate(DragDownDetails details) {
    model.pushItem(details, opType, lineColor, strokeWidth);
    // Line line = Line(color: lineColor, strokeWidth: strokeWidth);
    // model.pushLine(line);
  }

  /// 拖动时收集点，将点加入doing状态Line中
  void _collectPoint(DragUpdateDetails details) {
    model.pushPointItem(Point.fromOffset(details.localPosition));
  }

  /// 结束，doing状态改为done,当前只有一个活动线条
  void _doneLine(DragEndDetails details) {
    model.doneItem();
  }

  /// 立即抬起时，会执行onPanCancel，而onPanEnd不会执行，需对点集为空的线进行清理
  void _cancel() {
    model.removeEmptyItem();
  }

  void _clearTip() {
    String msg = "您的当前操作会清空绘制内容，是否确定删除!";
    showDialog(context: context, builder: (context) => ConfirmDialog(
      title: "清空",
      firstBtnText: '',
      secondBtnText: '取消',
      thirdBtnText: '确定',
      msg: msg,
      onConfirm: _clear,
    ));
  }

  void _activeEdit(LongPressStartDetails details) {
    model.activeEditItem(Point.fromOffset(details.localPosition));
  }

  void _moveEdit(LongPressMoveUpdateDetails details) {
    model.moveEditItem(details.offsetFromOrigin);
  }

  void _cancelEdit() {
    model.cancelEditItem();
  }

  void _showPenSettingDialog() {
    showCupertinoModalPopup(context: context, builder: (context) => PaintSettingDialog(onColorSelect: _selectColor,
      onThicknessSelect: _selectThickness, initColor: lineColor, initThickness: strokeWidth,));
  }

  void _selectColor(Color color) {
    lineColor = color;
  }

  void _selectThickness(double thickness) {
    strokeWidth = thickness;
  }

  void _opType(OpType type) {
    opType = type;
  }

  void _clear() {
    model.clearItem();
  }
}
