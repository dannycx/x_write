import 'package:flutter/material.dart';
import 'package:x_write/model/render/data/paint_state.dart';
import 'package:x_write/model/render/data/write_value_notifier.dart';
import 'package:x_write/tool/CommonTool.dart';
import 'package:x_write/ui/WritingPage.dart';
import 'package:x_write/ui/prop/PenPropPage.dart';
import 'package:x_write/ui/prop/ShapePropPage.dart';
import 'package:x_write/ui/tool_bar.dart';

class HomePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _HomePageState();
  }
}

class _HomePageState extends State<HomePage> {
  double _x = (CommonTool.width - 260) / 2;
  double _y = 0;
  double width = CommonTool.width;
  double height = CommonTool.height;

  /// 是否显示工具属性page
  bool _penPropPageVisible = false;
  bool _shapePropPageVisible = false;

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Overlay.of(context).insert(_enetry());
    });
    return Scaffold(
      body: ConstrainedBox(
        constraints: const BoxConstraints.expand(),
        // 通过ConstrainedBox来确保Stack占满屏幕
        child: Stack(
          children: [
            const WritingPage(),
            _leftTool(),
            _rightTool(),
            _penPropPage(),
            _shapePropPage(),
          ],
        ),
      ),
    );
  }

  Widget _leftTool() {
    return Positioned(
      // width: 96,
      height: 36,
      left: 16,
      top: height - 48,
      child: FunctionMenu(
        onToolMenu: _onToolMenu,
        onToolDecoration: _onToolDecoration,
      ),
    );
  }

  Widget _rightTool() {
    return Positioned(
      // width: 192,
      height: 36,
      right: 16,
      top: height - 48,
      child: PageMenu(
        onToolAdd: () {},
        onToolPre: () {},
        onToolNum: () {},
        onToolNext: () {},
      ),
    );
  }

  OverlayEntry _enetry() {
    return OverlayEntry(builder: (context) {
      return Positioned(
        // width: 316,
        height: 36,
        left: _x,
        top: height - 48,
        child: GestureDetector(
            onPanUpdate: (details) {
              setState(() {
                _x += details.delta.dx;
                // _y += details.delta.dy;
                if (_x < 124) {
                  _x = 124;
                } else if (_x > width - 484) {
                  _x = width - 484;
                }
              });
            },
            child: ToolMenu(
              onToolStylus: _onToolStylus,
              onToolAi: _onToolAi,
              onToolShape: _onToolShape,
              onToolLasso: _onToolLasso,
              onToolLayer: _onToolLayer,
              onToolEraser: _onToolEraser,
              onToolUndo: _onToolUndo,
              onToolRedo: _onToolRedo,
              onToolFunction: _onToolFunction,
            )),
      );
    });
  }

  Widget _penPropPage() {
    return Visibility(
        // 显示隐藏
        visible: _penPropPageVisible,
        // 隐藏时是否保持占位
        maintainState: false,
        // 隐藏时是否保存动态状态
        maintainAnimation: false,
        // 隐藏时是否保存子组件所占空间大小，不会消耗过多的性能
        maintainSize: false,
        child: Positioned(
          // width: 316,
          height: 36,
          left: _x,
          top: height - 90,
          child: PenPropPage(
            onToolPenProp: (penType, color, thickness) {
              eventBus.fire(OpTypeEvent(opType: penType));
              eventBus.fire(PenPropEvent(color: color, thickness: thickness));
            },
          ),
        ));
  }

  Widget _shapePropPage() {
    return Visibility(
        // 显示隐藏
        visible: _shapePropPageVisible,
        // 隐藏时是否保持占位
        maintainState: false,
        // 隐藏时是否保存动态状态
        maintainAnimation: false,
        // 隐藏时是否保存子组件所占空间大小，不会消耗过多的性能
        maintainSize: false,
        child: Positioned(
          width: 316,
          height: 36,
          left: _x,
          top: height - 90,
          child: ShapePropPage(
            onToolShapeProp: _onToolShapeProp,
          ),
        ));
  }

  void _onToolMenu() {
    print('_onToolMenu');
  }

  void _onToolDecoration() {
    print('_onToolDecoration');
  }

  void _onToolStylus() {
    _hidePropPage();
    setState(() {
      _penPropPageVisible = true;
    });
    eventBus.fire(OpTypeEvent(opType: OpType.pen));
  }

  void _onToolAi() {
    print('_onToolDecoration');
  }

  void _onToolShape() {
    _hidePropPage();
    setState(() {
      _shapePropPageVisible = true;
    });
    eventBus.fire(OpTypeEvent(opType: OpType.shape));
  }

  void _onToolLasso() {
    eventBus.fire(OpTypeEvent(opType: OpType.shape));
  }

  void _onToolLayer() {
    eventBus.fire(OpTypeEvent(opType: OpType.shape));
  }

  void _onToolEraser() {
    eventBus.fire(OpTypeEvent(opType: OpType.shape));
  }

  void _onToolUndo() {
    eventBus.fire(OpTypeEvent(opType: OpType.shape));
  }

  void _onToolRedo() {
    eventBus.fire(OpTypeEvent(opType: OpType.shape));
  }

  void _onToolFunction() {
    eventBus.fire(OpTypeEvent(opType: OpType.shape));
  }

  _onToolShapeProp(ShapeType shapeType) {
    eventBus.fire(ShapeTypeEvent(shapeType: shapeType));
  }

  void _hidePropPage() {
    setState(() {
      _penPropPageVisible = false;
      _shapePropPageVisible = false;
    });
  }
}
