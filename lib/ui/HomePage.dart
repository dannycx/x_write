import 'package:flutter/material.dart';
import 'package:x_write/model/render/data/paint_state.dart';
import 'package:x_write/tool/CommonTool.dart';
import 'package:x_write/tool/CustomIcon.dart';
import 'package:x_write/ui/WritingPage.dart';
import 'package:x_write/ui/tool_bar.dart';

import '../model/render/data/write_value_notifier.dart';

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
        width: 330,
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
                } else if (_x > width - 480) {
                  _x = width - 480;
                }
              });
            },
            child: Container(
              alignment: Alignment.center,
              padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
              decoration: const BoxDecoration(
                  color: Colors.white, // 颜色
                  borderRadius:
                      BorderRadiusDirectional.all(Radius.circular(10)), // 圆角
                  boxShadow: [
                    // 阴影
                    BoxShadow(
                        color: Colors.grey,
                        offset: Offset(1.0, 1.0),
                        blurRadius: 0.3)
                  ]),
              child: Row(
                children: [
                  Container(
                    width: 20,
                    height: 20,
                    child: GestureDetector(
                      onTap: () => bus.emit('opType', OpType.pen),
                      child: const Icon(CustomIcon.tool_stylus),
                    ),
                  ),
                  // const Icon(CustomIcon.tool_stylus),
                  const SizedBox(
                    width: 10,
                  ),
                  const Icon(CustomIcon.tool_ai),
                  const SizedBox(
                    width: 10,
                  ),
                  Container(
                    width: 20,
                    height: 20,
                    child: GestureDetector(
                      onTap: () => bus.emit('opType', OpType.shape),
                      child: const Icon(CustomIcon.tool_shape),
                    ),
                  ),
                  // const Icon(CustomIcon.tool_shape),
                  const SizedBox(
                    width: 10,
                  ),
                  const Icon(CustomIcon.tool_lasso),
                  const SizedBox(
                    width: 10,
                  ),
                  const Icon(CustomIcon.tool_layer),
                  const SizedBox(
                    width: 7,
                  ),
                  Container(
                    height: 16,
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        border: Border.all(
                            color: const Color.fromARGB(255, 106, 106, 106),
                            width: 0.5),
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 7,
                  ),
                  const Icon(CustomIcon.tool_eraser),
                  const SizedBox(
                    width: 10,
                  ),
                  const Icon(CustomIcon.tool_undo),
                  const SizedBox(
                    width: 10,
                  ),
                  const Icon(CustomIcon.tool_redo),
                  const SizedBox(
                    width: 7,
                  ),
                  Container(
                    height: 16,
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        border: Border.all(
                            color: const Color.fromARGB(255, 106, 106, 106),
                            width: 0.5),
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 7,
                  ),
                  const Icon(CustomIcon.tool_function)
                ],
              ),
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
}
