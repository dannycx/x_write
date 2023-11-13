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

  /// 操作类型
  OpType opType = OpType.pencil;

  /// 图形类型
  ShapeType shapeType = ShapeType.circle;

  /// 颜色
  Color lineColor = Colors.black;

  /// 粗细
  double strokeWidth = 1;

  double _forcePress = 0;

  @override
  void initState() {
    //注册eventBus事件，监听到变化的时候调用changeColor(color)
    eventBus.on<OpTypeEvent>().listen((opTypeEvent) {
      _changeOpType(opTypeEvent.opType);
    });
    eventBus.on<ShapeTypeEvent>().listen((shapeTypeEvent) {
      _changeShapeType(shapeTypeEvent.shapeType);
    });
    eventBus.on<PenPropEvent>().listen((penPropEvent) {
      _changePenProp(penPropEvent);
    });
    super.initState();
  }

  _changeOpType(OpType type) {
    if (mounted) {
      // 若不对mounted进行判断，会报错 setState() called after dispose()
      setState(() {
        opType = type;
        print('opType: $opType');
      });
    }
  }

  _changeShapeType(ShapeType type) {
    if (mounted) {
      // 若不对mounted进行判断，会报错 setState() called after dispose()
      setState(() {
        shapeType = type;
        print('shapeType: $shapeType');
      });
    }
  }

  _changePenProp(PenPropEvent penPropEvent) {
    if (mounted) {
      // 若不对mounted进行判断，会报错 setState() called after dispose()
      setState(() {
        lineColor = penPropEvent.color;
        strokeWidth = penPropEvent.thickness;
        print('penPropEvent: $penPropEvent');
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      /// 按下
      onPanDown: _initItemDate,

      /// 拖动收集点
      onPanUpdate: _collectPoint,

      /// 拖动结束
      onPanEnd: _doneItem,

      /// 拖动取消
      onPanCancel: _cancel,

      /// 双击清除
      onDoubleTap: _clearTip,

      /// 笔属性设置
      // onTap: _showPenSettingDialog,

      // 长按开始，激活编辑线条
      onLongPressStart: _activeEdit,

      // 长按移动，移动线条
      onLongPressMoveUpdate: _moveEdit,

      // 长按抬起，取消编辑
      onLongPressUp: _cancelEdit,

      onForcePressUpdate: (details) {
        _forcePress = details.pressure;
      },
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
    eventBus.destroy();
    super.dispose();
  }

  // 创建Line,pushLine添加至PaintModel中
  void _initItemDate(DragDownDetails details) {
    model.pushItem(details, opType, shapeType, lineColor, strokeWidth);
    // Line line = Line(color: lineColor, strokeWidth: strokeWidth);
    // model.pushLine(line);
  }

  /// 拖动时收集点，将点加入doing状态Line中
  void _collectPoint(DragUpdateDetails details) {
    model.pushPointItem(Point.fromOffset(details.localPosition/*, forcePress: _forcePress*/));
  }

  /// 结束，doing状态改为done,当前只有一个活动线条
  void _doneItem(DragEndDetails details) {
    model.doneItem();
  }

  /// 立即抬起时，会执行onPanCancel，而onPanEnd不会执行，需对点集为空的线进行清理
  void _cancel() {
    model.removeEmptyItem();
  }

  void _clearTip() {
    String msg = "您的当前操作会清空绘制内容，是否确定删除!";
    showDialog(
        context: context,
        builder: (context) => ConfirmDialog(
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
    showCupertinoModalPopup(
        context: context,
        builder: (context) => PaintSettingDialog(
              onColorSelect: _selectColor,
              onThicknessSelect: _selectThickness,
              initColor: lineColor,
              initThickness: strokeWidth,
            ));
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
