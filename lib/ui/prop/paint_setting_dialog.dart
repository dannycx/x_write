import 'package:flutter/material.dart';
import 'package:x_write/ui/prop/pen_color_page.dart';
import 'package:x_write/ui/prop/pen_thickness_page.dart';

/// 笔属性弹框
class PaintSettingDialog extends StatelessWidget {
  final ColorSelectCallback onColorSelect;
  final ThicknessSelectCallback onThicknessSelect;
  final initColor;
  final initThickness;

  const PaintSettingDialog({required this.onColorSelect, required this.onThicknessSelect, this.initColor = Colors.black,
    this.initThickness = 1, super.key});

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Container(
        color: Colors.white,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildColorSelect(),
            const Divider(height: 1,),
            _buildThicknessSelect(),
            Container(
              color: const Color(0xffE5E3E4).withOpacity(0.3),
              height: 10,
            ),
            _buildCancel(context)
          ],
        ),
      ),
    );
  }

  Widget _buildColorSelect() => PenColorPage(colors: _kColorList, onColorSelect: onColorSelect, defColor: initColor,);

  Widget _buildThicknessSelect() => PenThicknessPage(thicknessList: _kThicknessList, defThickness: initThickness,
      onThicknessSelect: onThicknessSelect);

  Widget _buildCancel(BuildContext context) => Material(
    child: InkWell(
      onTap: () => Navigator.of(context).pop(),
      child: Ink(
        width: MediaQuery.of(context).size.width / 2,
        height: 50,
        color: Colors.white,
        child: const Center(
          child: Text('取消', style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),),
        ),
      ),
    ),
  );
}

const List<Color> _kColorList = [
  Colors.black, Colors.red, Colors.orange, Colors.yellow,
  Colors.green, Colors.blue, Colors.indigo, Colors.purple
];

const List<double> _kThicknessList = [
  1.0, 3.0, 5.0, 6.0, 8.0, 9.0, 12.0, 15.0
];
