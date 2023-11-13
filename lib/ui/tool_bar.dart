import 'package:flutter/material.dart';

import '../tool/CustomIcon.dart';

const BoxConstraints cts = BoxConstraints(minHeight: 24, minWidth: 24);

class FunctionMenu extends StatelessWidget {
  final VoidCallback onToolMenu;
  final VoidCallback onToolDecoration;

  const FunctionMenu(
      {Key? key, required this.onToolMenu, required this.onToolDecoration})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        alignment: Alignment.center,
        padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
        decoration: const BoxDecoration(
            color: Colors.white,
            // 颜色
            borderRadius: BorderRadiusDirectional.all(Radius.circular(4)),
            // 圆角
            boxShadow: [
              // 阴影
              BoxShadow(
                  color: Colors.grey, offset: Offset(1.0, 1.0), blurRadius: 0.5)
            ]),
        child: Wrap(
          alignment: WrapAlignment.center,
          children: [
            GestureDetector(
                onTap: onToolMenu,
                child: Container(
                  alignment: Alignment.center,
                  height: 36,
                  child: const Icon(
                    CustomIcon.tool_menu,
                    color: Colors.black,
                  ),
                )),
            const SizedBox(
              width: 8,
            ),
            GestureDetector(
                onTap: onToolMenu,
                child: Container(
                  alignment: Alignment.center,
                  height: 36,
                  child: const Icon(
                    CustomIcon.tool_decoration,
                    color: Colors.black,
                  ),
                ))
          ],
        ));
  }
}

class ToolMenu extends StatelessWidget {
  final VoidCallback onToolStylus;
  final VoidCallback onToolAi;
  final VoidCallback onToolShape;
  final VoidCallback onToolLasso;
  final VoidCallback onToolLayer;
  final VoidCallback onToolEraser;
  final VoidCallback onToolUndo;
  final VoidCallback onToolRedo;
  final VoidCallback onToolFunction;

  const ToolMenu(
      {Key? key,
      required this.onToolStylus,
      required this.onToolAi,
      required this.onToolShape,
      required this.onToolLasso,
      required this.onToolLayer,
      required this.onToolEraser,
      required this.onToolUndo,
      required this.onToolRedo,
      required this.onToolFunction})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
      decoration: const BoxDecoration(
          color: Colors.white, // 颜色
          borderRadius: BorderRadiusDirectional.all(Radius.circular(4)), // 圆角
          boxShadow: [
            // 阴影
            BoxShadow(
                color: Colors.grey, offset: Offset(1.0, 1.0), blurRadius: 0.3)
          ]),
      child: Row(
        // alignment: WrapAlignment.center,
        children: [
          GestureDetector(
              onTap: onToolStylus,
              child: Container(
                alignment: Alignment.center,
                height: 36,
                child: const Icon(
                  CustomIcon.tool_stylus,
                  color: Colors.black,
                ),
              )),
          const SizedBox(
            width: 8,
          ),
          GestureDetector(
              onTap: onToolAi,
              child: Container(
                alignment: Alignment.center,
                height: 36,
                child: const Icon(
                  CustomIcon.tool_ai,
                  color: Colors.black,
                ),
              )),
          const SizedBox(
            width: 8,
          ),
          GestureDetector(
              onTap: onToolShape,
              child: Container(
                alignment: Alignment.center,
                height: 36,
                child: const Icon(
                  CustomIcon.tool_shape,
                  color: Colors.black,
                ),
              )),
          // const Icon(CustomIcon.tool_shape),
          const SizedBox(
            width: 8,
          ),
          GestureDetector(
              onTap: onToolLasso,
              child: Container(
                alignment: Alignment.center,
                height: 36,
                child: const Icon(
                  CustomIcon.tool_lasso,
                  color: Colors.black,
                ),
              )),
          // const SizedBox(
          //   width: 8,
          // ),
          // GestureDetector(
          //     onTap: onToolLayer,
          //     child: Container(
          //       alignment: Alignment.center,
          //       height: 36,
          //       child: const Icon(
          //         CustomIcon.tool_layer,
          //         color: Colors.black,
          //       ),
          //     )),
          const SizedBox(
            width: 8,
          ),
          SizedBox(
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
            width: 8,
          ),
          GestureDetector(
              onTap: onToolEraser,
              child: Container(
                alignment: Alignment.center,
                height: 36,
                child: const Icon(
                  CustomIcon.tool_eraser,
                  color: Colors.black,
                ),
              )),
          const SizedBox(
            width: 8,
          ),
          GestureDetector(
              onTap: onToolUndo,
              child: Container(
                alignment: Alignment.center,
                height: 36,
                child: const Icon(
                  CustomIcon.tool_undo,
                  color: Colors.black,
                ),
              )),
          const SizedBox(
            width: 8,
          ),
          GestureDetector(
              onTap: onToolRedo,
              child: Container(
                alignment: Alignment.center,
                height: 36,
                child: const Icon(
                  CustomIcon.tool_redo,
                  color: Colors.black,
                ),
              )),
          const SizedBox(
            width: 8,
          ),
          SizedBox(
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
            width: 8,
          ),
          GestureDetector(
              onTap: onToolFunction,
              child: Container(
                alignment: Alignment.center,
                height: 36,
                child: const Icon(
                  CustomIcon.tool_function,
                  color: Colors.black,
                ),
              )),
        ],
      ),
    );
  }
}

class PageMenu extends StatefulWidget {
  final VoidCallback onToolAdd;
  final VoidCallback onToolPre;
  final VoidCallback onToolNum;
  final VoidCallback onToolNext;

  const PageMenu(
      {Key? key,
      required this.onToolAdd,
      required this.onToolPre,
      required this.onToolNum,
      required this.onToolNext})
      : super(key: key);

  @override
  _PageMenuState createState() => _PageMenuState();
}

class _PageMenuState extends State<PageMenu> {
  @override
  Widget build(BuildContext context) {
    return Container(
        alignment: Alignment.center,
        padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
        decoration: const BoxDecoration(
            color: Colors.white,
            // 颜色
            borderRadius: BorderRadiusDirectional.all(Radius.circular(4)),
            // 圆角
            boxShadow: [
              // 阴影
              BoxShadow(
                  color: Colors.grey, offset: Offset(1.0, 1.0), blurRadius: 0.5)
            ]),
        child: Wrap(
          alignment: WrapAlignment.center,
          children: [
            // IconButton(
            //     constraints: cts,
            //     onPressed: widget.onToolAdd,
            //     icon: const Icon(
            //       Icons.add_circle_outline,
            //       color: Colors.black,
            //     )),
            GestureDetector(
                onTap: widget.onToolAdd,
                child: Container(
                  alignment: Alignment.center,
                  height: 36,
                  child: const Icon(
                    Icons.add_circle_outline,
                    color: Colors.black,
                  ),
                )),
            const SizedBox(
              width: 8,
            ),
            GestureDetector(
                onTap: widget.onToolPre,
                child: Container(
                  alignment: Alignment.center,
                  height: 36,
                  child: const Icon(
                    Icons.arrow_back_ios,
                    color: Colors.black,
                  ),
                )),
            const SizedBox(
              width: 8,
            ),
            GestureDetector(
              onTap: widget.onToolNum,
              child: Container(
                alignment: Alignment.center,
                height: 36,
                child: const Text('100/999',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 16, color: Color.fromARGB(255, 43, 43, 43))),
              ),
            ),
            const SizedBox(
              width: 8,
            ),
            GestureDetector(
                onTap: widget.onToolNext,
                child: Container(
                  alignment: Alignment.center,
                  height: 36,
                  child: const Icon(
                    Icons.arrow_forward_ios,
                    color: Colors.black,
                  ),
                )),
          ],
        ));
  }
}
