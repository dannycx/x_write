import 'dart:html';

import 'package:flutter/material.dart';
import 'package:x_write/model/render/data/paint_state.dart';
import 'package:x_write/tool/CustomIcon.dart';
import 'package:x_write/ui/data/pen_prop.dart';
import 'package:x_write/ui/prop/pen_color_page.dart';
import 'package:x_write/ui/prop/pen_thickness_page.dart';

/// 回调
typedef PenPropCallback = Function(OpType penType, PenProp penProp);

/// 笔属性
class PenPropPage extends StatefulWidget {
  final PenPropCallback? onToolPenProp;
  final PenProp penProp;
  final PenProp pencilProp;
  final PenProp brushProp;
  final PenProp highlightProp;
  OpType defOpType;

  PenPropPage(
      {Key? key,
      required this.onToolPenProp,
      this.defOpType = OpType.pencil,
      required this.penProp,
      required this.pencilProp,
      required this.brushProp,
      required this.highlightProp})
      : super(key: key);

  @override
  State<PenPropPage> createState() => _PenPropPageState();
}

class _PenPropPageState extends State<PenPropPage> {
  Color get _defColor {
    switch (widget.defOpType) {
      case OpType.pen:
        return widget.penProp.color;
      case OpType.brush:
        return widget.brushProp.color;
      case OpType.highlight:
        return widget.highlightProp.color;
      default:
        return widget.pencilProp.color;
    }
  }

  _setColor(color) {
    switch (widget.defOpType) {
      case OpType.pen:
        widget.penProp.color = color;
        break;
      case OpType.brush:
        widget.brushProp.color = color;
        break;
      case OpType.highlight:
        widget.highlightProp.color = color;
        break;
      default:
        widget.pencilProp.color = color;
        break;
    }
  }

  double get _defThickness {
    switch (widget.defOpType) {
      case OpType.pen:
        return widget.penProp.thickness;
      case OpType.brush:
        return widget.brushProp.thickness;
      case OpType.highlight:
        return widget.highlightProp.thickness;
      default:
        return widget.pencilProp.thickness;
    }
  }

  _setThickness(thickness) {
    switch (widget.defOpType) {
      case OpType.pen:
        widget.penProp.thickness = thickness;
        break;
      case OpType.brush:
        widget.brushProp.thickness = thickness;
        break;
      case OpType.highlight:
        widget.highlightProp.thickness = thickness;
        break;
      default:
        widget.pencilProp.thickness = thickness;
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
                widget.onToolPenProp?.call(widget.defOpType, widget.pencilProp);
                setState(() {});
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
                widget.onToolPenProp?.call(widget.defOpType, widget.penProp);
                setState(() {});
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
                widget.onToolPenProp?.call(widget.defOpType, widget.brushProp);
                setState(() {});
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
                widget.onToolPenProp?.call(widget.defOpType, widget.highlightProp);
                setState(() {});
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
    widget.onToolPenProp?.call(widget.defOpType, _penProp());
  }

  void _onThicknessSelect(double thickness) {
    _setThickness(thickness);
    widget.onToolPenProp?.call(widget.defOpType, _penProp());
  }

  _penProp() {
    switch (widget.defOpType) {
      case OpType.pencil:
        return widget.pencilProp;
      case OpType.pen:
        return widget.penProp;
      case OpType.brush:
        return widget.brushProp;
      default:
        return widget.highlightProp;
    }
  }
}

const List<Color> _kColorList = [Colors.black, Colors.red, Colors.orange, Colors.blue, Colors.purple];
const List<double> _kThicknessList = [2.0, 4.0, 6.0, 8.0, 12.0];
