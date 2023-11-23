import 'package:flutter/material.dart';
import 'package:x_write/model/render/data/paint_state.dart';

import '../../tool/CustomIcon.dart';
import '../data/ItemInsertData.dart';

/// 回调
typedef InsertPropCallback = void Function(OpType opType);

class InsertPropPage extends StatelessWidget {
  final InsertPropCallback? onToolInsertProp;

  List<ItemInsertData> insertData() {
    List<ItemInsertData> insertData = [];
    insertData.add(ItemInsertData(title: '文本', iconData: CustomIcon.tool_function_text));
    insertData.add(ItemInsertData(title: '文档', iconData: CustomIcon.tool_function_doc, opType: OpType.doc));
    insertData.add(ItemInsertData(title: '图像', iconData: CustomIcon.tool_function_image, opType: OpType.image));
    return insertData;
  }

  const InsertPropPage({Key? key, required this.onToolInsertProp}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<ItemInsertData> insertDataList = insertData();
    print('insertDataList: ${insertDataList.length}');
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
        height: 48,
        child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: insertDataList.length,
            itemExtent: 48,
            itemBuilder: (BuildContext context, int index) {
              return _InsertItem(insertDataList[index]);
            }),
      ),
    );
  }

  Widget _InsertItem(ItemInsertData item) {
    return SizedBox(
      child: GestureDetector(
          onTap: () {
            print('object---------------');
            onToolInsertProp?.call(item.opType);
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
