import 'package:flutter/material.dart';
import 'package:x_write/model/render/data/paint_state.dart';
import 'package:x_write/model/render/data/write_value_notifier.dart';
import 'package:x_write/tool/CommonTool.dart';
import 'package:x_write/ui/WritingPage.dart';
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

  @override
  Widget build(BuildContext context) {
    // MediaQueryData date = MediaQuery.of(context);
    // width = date.size.width;
    // height = date.size.height;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Overlay.of(context).insert(_enetry());
    });
    return Scaffold(
      body: ConstrainedBox(
        constraints: const BoxConstraints.expand(),
        // 通过ConstrainedBox来确保Stack占满屏幕
        child: Stack(
          children: [const WritingPage(), _leftTool(), _rightTool()],
        ),
      ),
    );
  }

  Widget _leftTool() {
    return Positioned(
      width: 96,
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
        onToolAdd: _onToolMenu,
        onToolPre: _onToolMenu,
        onToolNum: _onToolMenu,
        onToolNext: _onToolMenu,
      ),
    );
  }

  OverlayEntry _enetry() {
    return OverlayEntry(builder: (context) {
      return Positioned(
        width: 316,
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
                } else if (_x > width - 530) {
                  _x = width - 530;
                }
              });
            },
            child: ToolMenu(
              onToolStylus: _onToolStylus,
              onToolAi: _onToolAi,
              onToolShape: _onToolShape,
              onToolLasso: _onToolMenu,
              onToolLayer: _onToolMenu,
              onToolEraser: _onToolMenu,
              onToolUndo: _onToolMenu,
              onToolRedo: _onToolMenu,
              onToolFunction: _onToolMenu,
            )),
      );
    });
  }

  void _onToolMenu() {
    print('_onToolMenu');
  }

  void _onToolDecoration() {
    print('_onToolDecoration');
  }

  void _onToolStylus() {
    eventBus.fire(OpTypeEvent(opType: OpType.pen));
  }

  void _onToolAi() {
    print('_onToolDecoration');
  }

  void _onToolShape() {
    eventBus.fire(OpTypeEvent(opType: OpType.shape));
  }
}
