import 'package:flutter/material.dart';
import 'package:x_write/model/render/data/paint_state.dart';
import 'package:x_write/tool/CustomIcon.dart';
import 'package:x_write/ui/prop/pen_color_page.dart';
import 'package:x_write/ui/prop/pen_thickness_page.dart';

/// 回调
typedef PenPropCallback = Function(OpType penType, Color color, double thickness);

/// 笔属性
class PenPropPage extends StatefulWidget {
  final PenPropCallback? onToolPenProp;
  final List<Color> defColor = [Colors.black, Colors.black, Colors.black, Colors.black];
  final List<double> defThickness = [2.0, 2.0, 2.0, 2.0];
  OpType defOpType;

  PenPropPage({Key? key, required this.onToolPenProp, this.defOpType = OpType.pencil}) : super(key: key);

  @override
  State<PenPropPage> createState() => _PenPropPageState();
}

class _PenPropPageState extends State<PenPropPage> {
  Color get _defColor {
    switch (widget.defOpType) {
      case OpType.pen:
        return widget.defColor[1];
      case OpType.brush:
        return widget.defColor[2];
      case OpType.highlight:
        return widget.defColor[3];
      default:
        return widget.defColor[0];
    }
  }

  _setColor(color) {
    switch (widget.defOpType) {
      case OpType.pen:
        widget.defColor[1] = color;
        break;
      case OpType.brush:
        widget.defColor[2] = color;
        break;
      case OpType.highlight:
        widget.defColor[3] = color;
        break;
      default:
        widget.defColor[0] = color;
        break;
    }
  }

  double get _defThickness {
    switch (widget.defOpType) {
      case OpType.pen:
        return widget.defThickness[1];
      case OpType.brush:
        return widget.defThickness[2];
      case OpType.highlight:
        return widget.defThickness[3];
      default:
        return widget.defThickness[0];
    }
  }

  _setThickness(thickness) {
    switch (widget.defOpType) {
      case OpType.pen:
        widget.defThickness[1] = thickness;
        break;
      case OpType.brush:
        widget.defThickness[2] = thickness;
        break;
      case OpType.highlight:
        widget.defThickness[3] = thickness;
        break;
      default:
        widget.defThickness[0] = thickness;
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
      decoration: const BoxDecoration(
          color: Colors.white,
          // 颜色
          borderRadius: BorderRadius.all(Radius.circular(4)),
          // BorderRadiusDirectional.only(
          //     topStart: Radius.circular(4),
          //     topEnd: Radius.circular(4),
          //     bottomStart: Radius.zero,
          //     bottomEnd: Radius.zero),
          // 圆角
          boxShadow: [
            // 阴影
            BoxShadow(color: Colors.grey, offset: Offset(1.0, 1.0), blurRadius: 0.5)
          ]),
      child: Row(
        children: <Widget>[
          GestureDetector(
              onTap: () {
                widget.defOpType = OpType.pencil;
                widget.onToolPenProp?.call(widget.defOpType, widget.defColor[0], widget.defThickness[0]);
              },
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
              onTap: () {
                widget.defOpType = OpType.pen;
                widget.onToolPenProp?.call(widget.defOpType, widget.defColor[1], widget.defThickness[1]);
              },
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
              onTap: () {
                widget.defOpType = OpType.brush;
                widget.onToolPenProp?.call(widget.defOpType, widget.defColor[2], widget.defThickness[2]);
              },
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
              onTap: () {
                widget.defOpType = OpType.highlight;
                widget.onToolPenProp?.call(widget.defOpType, widget.defColor[3], widget.defThickness[3]);
              },
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
          SizedBox(
            height: 16,
            child: DecoratedBox(
              decoration: BoxDecoration(
                border: Border.all(color: const Color.fromARGB(255, 106, 106, 106), width: 0.5),
              ),
            ),
          ),
          const SizedBox(
            width: 8,
          ),
          PenColorPage(
            colors: _kColorList,
            onColorSelect: _onColorSelect,
            defColor: _defColor,
          ),
          const SizedBox(
            width: 8,
          ),
          SizedBox(
            height: 16,
            child: DecoratedBox(
              decoration: BoxDecoration(
                border: Border.all(color: const Color.fromARGB(255, 106, 106, 106), width: 0.5),
              ),
            ),
          ),
          const SizedBox(
            width: 8,
          ),
          PenThicknessPage(
            thicknessList: _kThicknessList,
            onThicknessSelect: _onThicknessSelect,
            defThickness: _defThickness,
          ),
        ],
      ),
    );
  }

  void _onColorSelect(Color color) {
    _setColor(color);
    widget.onToolPenProp?.call(widget.defOpType, _defColor, _defThickness);
  }

  void _onThicknessSelect(double thickness) {
    _setThickness(thickness);
    widget.onToolPenProp?.call(widget.defOpType, _defColor, _defThickness);
  }
}

const List<Color> _kColorList = [Colors.black, Colors.red, Colors.orange, Colors.blue, Colors.purple];
const List<double> _kThicknessList = [2.0, 4.0, 6.0, 8.0, 12.0];
