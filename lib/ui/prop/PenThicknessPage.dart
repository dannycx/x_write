import 'package:flutter/material.dart';

/// 笔粗细属性面板
class PenThicknessPage extends StatefulWidget {
  /// 颜色列表
  final List<Color> colors;

  /// 选中圆圈半径
  final double radius;

  /// 回调
  final ThicknessSelectCallback? onThicknessSelect;

  /// 默认颜色
  final Color? defColor;

  const PenThicknessPage({required this.colors, this.radius = 25,
    required this.defColor, required this.onThicknessSelect});

  @override
  _PenThicknessPageState createState() => _PenThicknessPageState();
}

class _PenThicknessPageState extends State<PenThicknessPage> {
  int _selectIndex = 0;
  Color get activeColor => widget.colors[_selectIndex];

  @override
  void initState() {
    super.initState();
    if (widget.defColor != null) {
      _selectIndex = widget.colors.indexOf(widget.defColor!);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      height: 45,
      child: Wrap(
        spacing: 20,
        children: widget.colors.map((color) => GestureDetector(
          onTap: () => _doSelectColor(color),
          child: _buildColorItem(color),
        )).toList(),
      ),
    );
  }

  // 选中回调
  _doSelectColor(Color color) {
    int index = widget.colors.indexOf(color);
    if (index == _selectIndex) return;

    setState(() {
      _selectIndex = index;
    });

    widget.onThicknessSelect?.call(0);
  }

  // 构建颜色圆圈
  Widget _buildColorItem(Color color) => Container(
    width: widget.radius,
    height: widget.radius,
    alignment: Alignment.center,
    decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: color
    ),
    child: activeColor == color ? _buildActiveIndicator() : null,
  );

  // 构建选中指示器
  Widget _buildActiveIndicator() => Container(
    width: widget.radius * 0.6,
    height: widget.radius * 0.6,
    decoration: const BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.white
    ),
  );
}

/// 回调
typedef ThicknessSelectCallback = void Function(double thickness);
