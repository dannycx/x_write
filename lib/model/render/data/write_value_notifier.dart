import 'package:event_bus/event_bus.dart';
import 'package:flutter/material.dart';
import 'package:x_write/model/render/data/paint_state.dart';

/// 操作类型变更通知器
class OpTypeValueNotifier extends ValueNotifier<OpType> {
  OpTypeValueNotifier(super.value);
}

/// event_bus
EventBus eventBus = EventBus();

/// 操作类型事件
class OpTypeEvent {
  OpType opType;

  OpTypeEvent({required this.opType});
}

/// 图形类型事件
class ShapeTypeEvent {
  ShapeType shapeType;

  ShapeTypeEvent({required this.shapeType});
}

/// 图形类型事件
class PenPropEvent {
  Color color;
  double thickness;

  PenPropEvent({required this.color, this.thickness = 3.0});
}

/// 通用类型事件
class CommonTypeEvent {
  CommonType commonType;

  CommonTypeEvent({required this.commonType});
}
