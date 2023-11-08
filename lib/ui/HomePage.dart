import 'package:flutter/material.dart';
import 'package:x_write/tool/CommonTool.dart';
import 'package:x_write/tool/CustomIcon.dart';

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
        constraints: const BoxConstraints.expand(), // 通过ConstrainedBox来确保Stack占满屏幕
        child: Stack(
          children: [
            const ListTile(
              title: Text('chat'),
              trailing: Icon(Icons.arrow_forward_ios_rounded),
            ),
            _leftTool(),
            _rightTool()
          ],
        ),
      ),
    );
  }

  Widget _leftTool() {
    return Positioned(
        width: 88,
        height: 48,
        left: 16,
        top: height - 56,
        child: Container(
            alignment: Alignment.center,
            padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
            decoration: const BoxDecoration(
                color: Colors.white, // 颜色
                borderRadius: BorderRadiusDirectional.all(Radius.circular(10)), // 圆角
                boxShadow: [
                  // 阴影
                  BoxShadow(color: Colors.grey, offset: Offset(1.0, 1.0), blurRadius: 0.5)
                ]),
            child: const Row(
              children: [
                Icon(CustomIcon.tool_function),
                SizedBox(
                  width: 16,
                ),
                Icon(CustomIcon.tool_decoration),
              ],
            )
        )
    );
  }

  Widget _rightTool() {
    return Positioned(
        width: 170,
        height: 48,
        right: 16,
        top: height - 56,
        child: Container(
            alignment: Alignment.center,
            padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
            decoration: const BoxDecoration(
                color: Colors.white, // 颜色
                borderRadius: BorderRadiusDirectional.all(Radius.circular(10)), // 圆角
                boxShadow: [
                  // 阴影
                  BoxShadow(color: Colors.grey, offset: Offset(1.0, 1.0), blurRadius: 0.5)
                ]),
            child: const Row(
              children: [
                Icon(Icons.add_circle_outline),
                SizedBox(
                  width: 16,
                ),
                Icon(Icons.arrow_back_ios),
                SizedBox(
                  width: 16,
                ),
                Text(
                  '1/1',
                  style: TextStyle(
                      fontSize: 18,
                      color: Color.fromARGB(255, 43, 43, 43)
                  ),
                ),
                SizedBox(
                  width: 16,
                ),
                Icon(Icons.arrow_forward_ios),
              ],
            )
        )
    );
  }

  OverlayEntry _enetry() {
    return OverlayEntry(builder: (context) {
      return Positioned(
        width: 260,
        height: 48,
        left: _x,
        top: height - 56,
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
                  borderRadius: BorderRadiusDirectional.all(Radius.circular(10)), // 圆角
                  boxShadow: [
                    // 阴影
                    BoxShadow(color: Colors.grey, offset: Offset(1.0, 1.0), blurRadius: 0.3)
                  ]),
              child: Row(
                children: [
                  const Icon(CustomIcon.tool_stylus),
                  const SizedBox(
                    width: 10,
                  ),
                  const Icon(CustomIcon.tool_ai),
                  const SizedBox(
                    width: 10,
                  ),
                  const Icon(CustomIcon.tool_shape),
                  const SizedBox(
                    width: 7,
                  ),
                  Container(
                    height: 16,
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        border: Border.all(color: const Color.fromARGB(255, 106, 106, 106), width: 0.5),
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
                        border: Border.all(color: const Color.fromARGB(255, 106, 106, 106), width: 0.5),
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
}
