import 'package:flutter/material.dart';
import 'package:x_write/model/render/data/paint_state.dart';
import 'package:x_write/tool/CustomIcon.dart';

/// 回调
typedef ShapePropCallback = void Function(ShapeType shapeType);

/// 笔属性
class ShapePropPage extends StatefulWidget {
  final ShapePropCallback? onToolShapeProp;

  const ShapePropPage({Key? key, required this.onToolShapeProp}) : super(key: key);

  @override
  State<ShapePropPage> createState() => _ShapePropPageState();
}

class _ShapePropPageState extends State<ShapePropPage> {
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
            BoxShadow(color: Colors.grey, offset: Offset(1.0, 1.0), blurRadius: 0.5)
          ]),
      child: Row(
        children: <Widget>[
          GestureDetector(
              onTap: () {
                widget.onToolShapeProp?.call(ShapeType.circle);
              },
              child: Container(
                alignment: Alignment.center,
                height: 36,
                child: const Icon(
                  CustomIcon.tool_shape_circle,
                  color: Colors.black,
                ),
              )),
          const SizedBox(
            width: 8,
          ),
          GestureDetector(
              onTap: () {
                widget.onToolShapeProp?.call(ShapeType.oval);
              },
              child: Container(
                alignment: Alignment.center,
                height: 36,
                child: const Icon(
                  CustomIcon.tool_shape_oval,
                  color: Colors.black,
                ),
              )),
          const SizedBox(
            width: 8,
          ),
          GestureDetector(
              onTap: () {
                widget.onToolShapeProp?.call(ShapeType.square);
              },
              child: Container(
                alignment: Alignment.center,
                height: 36,
                child: const Icon(
                  CustomIcon.tool_shape_square,
                  color: Colors.black,
                ),
              )),
          const SizedBox(
            width: 8,
          ),
          GestureDetector(
              onTap: () {
                widget.onToolShapeProp?.call(ShapeType.regularTriangle);
              },
              child: Container(
                alignment: Alignment.center,
                height: 36,
                child: const Icon(
                  CustomIcon.tool_shape_regular_triangle,
                  color: Colors.black,
                ),
              )),
          const SizedBox(
            width: 8,
          ),
          GestureDetector(
              onTap: () {
                widget.onToolShapeProp?.call(ShapeType.rightTriangle);
              },
              child: Container(
                alignment: Alignment.center,
                height: 36,
                child: const Icon(
                  CustomIcon.tool_shape_right_triangle,
                  color: Colors.black,
                ),
              )),
          const SizedBox(
            width: 8,
          ),
          GestureDetector(
              onTap: () {
                widget.onToolShapeProp?.call(ShapeType.star);
              },
              child: Container(
                alignment: Alignment.center,
                height: 36,
                child: const Icon(
                  CustomIcon.tool_shape_star,
                  color: Colors.black,
                ),
              )),
          const SizedBox(
            width: 8,
          ),
          GestureDetector(
              onTap: () {
                widget.onToolShapeProp?.call(ShapeType.arrow);
              },
              child: Container(
                alignment: Alignment.center,
                height: 36,
                child: const Icon(
                  CustomIcon.tool_shape_polygon,
                  color: Colors.black,
                ),
              )),
          const SizedBox(
            width: 8,
          ), GestureDetector(
              onTap: () {
                widget.onToolShapeProp?.call(ShapeType.arrow);
              },
              child: Container(
                alignment: Alignment.center,
                height: 36,
                child: const Icon(
                  CustomIcon.tool_shape_arrow,
                  color: Colors.black,
                ),
              )),
          const SizedBox(
            width: 8,
          ),
          GestureDetector(
              onTap: () {
                widget.onToolShapeProp?.call(ShapeType.line);
              },
              child: Container(
                alignment: Alignment.center,
                height: 36,
                child: const Icon(
                  CustomIcon.tool_shape_line,
                  color: Colors.black,
                ),
              )),
        ],
      ),
    );
  }
}
