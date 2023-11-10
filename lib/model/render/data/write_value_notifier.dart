import 'package:flutter/material.dart';
import 'package:x_write/model/render/data/paint_state.dart';

/// 操作类型变更通知器
class OpTypeValueNotifier extends ValueNotifier<OpType> {
  OpTypeValueNotifier(super.value);
}

/// event_bus
typedef void EventCallback(arg);

class WriteEventBus {
  WriteEventBus._internal();

  static final WriteEventBus _singleton = WriteEventBus._internal();

  factory WriteEventBus() => _singleton;

  final _emap = Map<Object, List<EventCallback>?>();

  void on(eventName, EventCallback f) {
    _emap[eventName] ??= <EventCallback>[];
    _emap[eventName]?.add(f);
  }

  void off(eventName, [EventCallback? f]) {
    var list = _emap[eventName];
    if (eventName == null || list == null) {
      return;
    }

    if (f == null) {
      _emap[eventName] = null;
    } else {
      list.remove(f);
    }
  }

  void emit(eventName, [arg]) {
    var list = _emap[eventName];
    if (list == null) {
      return;
    }

    int len = list.length - 1;
    for (int i = len; i >= 0; --i) {
      list[i](arg);
    }
  }
}

var bus = WriteEventBus();
