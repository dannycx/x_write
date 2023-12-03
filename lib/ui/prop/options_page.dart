import 'package:flutter/material.dart';

import '../../model/render/data/paint_state.dart';
import '../../tool/CustomIcon.dart';
import '../data/item_insert_data.dart';

/// 回调
typedef OptionsCallback = void Function(OpType opType);

/// 更多操作项
class OptionsPage extends StatelessWidget {
  OptionsCallback? optionsCallback;

  OptionsPage({Key? key, required this.optionsCallback}) : super(key: key);

  List<ItemInsertData> optionsData() {
    List<ItemInsertData> insertData = [];
    insertData.add(ItemInsertData(title: '截图', iconData: Icons.screenshot, opType: OpType.screenshot));
    insertData.add(ItemInsertData(title: '尺规', iconData: CustomIcon.options_ruler, opType: OpType.ruler));
    insertData.add(ItemInsertData(title: '搜图', iconData: Icons.image_search, opType: OpType.search_image));
    insertData.add(ItemInsertData(title: '录屏', iconData: Icons.emergency_recording_rounded, opType: OpType.recording));
    insertData.add(ItemInsertData(title: '便签', iconData: CustomIcon.options_sticky_note, opType: OpType.sticky_note));
    insertData.add(ItemInsertData(title: '计时器', iconData: Icons.timer_sharp, opType: OpType.timer));
    insertData.add(ItemInsertData(title: '放大器', iconData: CustomIcon.options_magnifier, opType: OpType.magnifier));
    insertData.add(ItemInsertData(title: '扫一扫', iconData: CustomIcon.options_scan, opType: OpType.scan));
    return insertData;
  }

  @override
  Widget build(BuildContext context) {
    List<ItemInsertData> optionsList = optionsData();
    return Container(
      alignment: Alignment.topLeft,
      padding: const EdgeInsets.all(8),
      decoration: const BoxDecoration(
          // 颜色
          color: Colors.white,
          // 圆角
          borderRadius: BorderRadius.all(Radius.circular(4)),
          // 阴影
          boxShadow: [BoxShadow(color: Colors.grey, offset: Offset(1.0, 1.0), blurRadius: 0.5)]),
      child: SizedBox(
          // height: 48,
          child: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 5, // 每行3列
            childAspectRatio: 1.0, // 显示区域宽高等比
            crossAxisSpacing: 5,
            mainAxisSpacing: 5),
        padding: const EdgeInsets.all(5),
        itemCount: optionsList.length,
        itemBuilder: (context, index) {
          return _InsertItem(optionsList[index]);
        },
        // scrollDirection: Axis.horizontal,
        // itemCount: optionsList.length,
        // itemExtent: 48,
        // itemBuilder: (BuildContext context, int index) {
        //   return _InsertItem(optionsList[index]);
        // }),
      )),
    );
  }

  Widget _InsertItem(ItemInsertData item) {
    return SizedBox(
      height: 48,
      width: 48,
      child: GestureDetector(
          onTap: () {
            print('object---------------');
            optionsCallback?.call(item.opType);
          },
          child: Column(
            children: <Widget>[
              Icon(
                item.iconData,
                color: Colors.black54,
                size: 24,
              ),
              const SizedBox(
                height: 2,
              ),
              Text(
                item.title,
                style: const TextStyle(fontSize: 10, color: Color.fromARGB(255, 43, 43, 43)),
              )
            ],
          )),
    );
  }
}
