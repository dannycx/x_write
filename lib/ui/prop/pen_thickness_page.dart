import 'package:flutter/material.dart';

/// 笔粗细属性面板
class PenThicknessPage extends StatefulWidget {
  /// 颜色列表
  final List<double> thicknessList;

  /// 选中圆圈半径
  final double radius;

  /// 回调
  final ThicknessSelectCallback? onThicknessSelect;

  /// 默认粗细
  final double? defThickness;

  const PenThicknessPage({required this.thicknessList, this.radius = 25,
    required this.defThickness, required this.onThicknessSelect});

  @override
  _PenThicknessPageState createState() => _PenThicknessPageState();
}

class _PenThicknessPageState extends State<PenThicknessPage> {
  int _selectIndex = 0;
  double get activeThickness => widget.thicknessList[_selectIndex];

  @override
  void initState() {
    super.initState();
    if (widget.defThickness != null) {
      _selectIndex = widget.thicknessList.indexOf(widget.defThickness!);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      height: 36,
      child: Row(
        // alignment: WrapAlignment.center,
        // runAlignment: WrapAlignment.center,
        // spacing: 8,
        children: widget.thicknessList.map((thickness) => GestureDetector(
          onTap: () => _doSelectThickness(thickness),
          child: _buildThicknessItem(thickness),
        )).toList(),
      ),
    );
  }

  // 选中回调
  _doSelectThickness(double thickness) {
    int index = widget.thicknessList.indexOf(thickness);
    if (index == _selectIndex) return;

    setState(() {
      _selectIndex = index;
    });

    widget.onThicknessSelect?.call(thickness);
  }

  // 构建颜色圆圈
  Widget _buildThicknessItem(double thickness) => Container(
    margin: const EdgeInsets.only(right: 8),
    width: thickness * 1.5,
    height: thickness * 1.5,
    alignment: Alignment.center,
    decoration: const BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.grey
    ),
    child: activeThickness == thickness ? _buildActiveIndicator() : null,
  );

  // 构建选中指示器
  Widget _buildActiveIndicator() => Container(
    width: activeThickness * 1.5 * 0.7,
    height: activeThickness * 1.5 * 0.7,
    decoration: const BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.white
    ),
  );
}

/// 回调
typedef ThicknessSelectCallback = void Function(double thickness);
