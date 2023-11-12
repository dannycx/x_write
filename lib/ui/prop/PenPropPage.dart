import 'package:flutter/material.dart';
import 'package:x_write/model/render/data/paint_state.dart';
import 'package:x_write/tool/CustomIcon.dart';

/// 回调
typedef PenPropCallback = Function(OpType penType);

/// 笔属性
class PenPropPage extends StatefulWidget {
  final PenPropCallback? onToolPenProp;

  const PenPropPage({Key? key, required this.onToolPenProp}) : super(key: key);

  @override
  State<PenPropPage> createState() => _PenPropPageState();
}

class _PenPropPageState extends State<PenPropPage> {
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
      child: Row(
        children: <Widget>[
          GestureDetector(
              onTap: widget.onToolPenProp?.call(OpType.pencil),
              child: Container(
                alignment: Alignment.center,
                height: 36,
                child: const Icon(
                  CustomIcon.tool_pencil,
                  color: Colors.black54,
                ),
              )),
          const SizedBox(
            width: 8,
          ),
          GestureDetector(
              onTap: widget.onToolPenProp?.call(OpType.pen),
              child: Container(
                alignment: Alignment.center,
                height: 36,
                child: const Icon(
                  CustomIcon.tool_pen,
                  color: Colors.black54,
                ),
              )),
          const SizedBox(
            width: 8,
          ),
          GestureDetector(
              onTap: widget.onToolPenProp?.call(OpType.brush),
              child: Container(
                alignment: Alignment.center,
                height: 36,
                child: const Icon(
                  CustomIcon.tool_writing_brush,
                  color: Colors.black54,
                ),
              )),
          const SizedBox(
            width: 8,
          ),
          GestureDetector(
              onTap: widget.onToolPenProp?.call(OpType.highlight),
              child: Container(
                alignment: Alignment.center,
                height: 36,
                child: const Icon(
                  CustomIcon.tool_highlight,
                  color: Colors.black54,
                ),
              )),
          const SizedBox(
            width: 8,
          ),
          GestureDetector(
              onTap: widget.onToolPenProp?.call(OpType.pen),
              child: Container(
                alignment: Alignment.center,
                height: 36,
                child: const Icon(
                  CustomIcon.tool_pencil,
                ),
              )),
          const SizedBox(
            width: 8,
          ),
        ],
      ),
    );
  }
}
