import 'package:flutter/material.dart';
import 'package:x_write/model/render/data/paint_state.dart';

/// 插入项
class ItemInsertData {
  String title;
  IconData iconData;
  OpType opType;

  ItemInsertData({required this.title, required this.iconData, this.opType = OpType.text});
}
