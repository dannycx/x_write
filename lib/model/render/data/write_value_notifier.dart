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
