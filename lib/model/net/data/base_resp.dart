import 'dart:convert';

class BaseResp<T> {
  T? data; // data对象
  List<T>? dataList; // data是list
  BasePage<T>? dataPage; // data是分页数据
  int? code;
  String? msg;

  BaseResp.fromJson(dynamic json) {
    code = json['code'];
    msg = json['msg'];
    if (json['data'] != null && json['data'] != 'null') {
      try {
        if (json['data'] is List) {
          if (json['data'].toString().contains('{')) {
            // dataList = JsonConvert
          } else {
            List list = json['data'];
            dataList = list.cast<T>();
          }
        } else {}
      } catch (Exception) {}
    }
  }
}

class BasePage<T> {
  T? data; // data对象
  List<T>? list; // data是list
  int? total;
  int? page;
  int? pageSize;
}
