import 'dart:ui';

import 'package:flutter/material.dart';

/// 虚线可以看成画线段，线段再分段：线、间距
class DashPainter {
  /// step
  /// ————  ————  ————  ————  ————
  ///    span
  /// step：单线长
  /// span：间距
  final double step;
  final double span;

  ///   pointCount（3）
  /// —————— --- —————— —— —— —— ——————  ——————  ——————
  ///                 pointLength
  /// pointCount ：点画线个数
  /// pointLength：点画线长度
  final int pointCount;
  final double? pointLength;

  // 直线：span = 0
  const DashPainter({this.step = 2, this.span = 2, this.pointCount = 0, this.pointLength});

  void paint(Canvas canvas, Paint paint, Path path) {
    // 把path拆分成多个片段
    final PathMetrics metrics = path.computeMetrics();
    final double pointLineLength = pointLength ?? paint.strokeWidth;

    // 虚线可以看作画一段段线段，每个线段长度
    final double partLength = step + span * (pointCount + 1) + pointCount * pointLineLength;

    metrics.forEach((metric) {
      final int count = metric.length ~/ partLength;
      for (int i = 0; i < count; i++) {
        // 线段
        canvas.drawPath(metric.extractPath(partLength * i, partLength * i + step), paint);
        for (int j = 1; j <= pointCount; j++) {
          // 点画线起点
          final start = partLength * i + step + span * j + pointLineLength * (j - 1);
          canvas.drawPath(metric.extractPath(start, start + pointLineLength), paint);
        }
      }

      // 尾
      final double tail = metric.length % partLength;
      canvas.drawPath(metric.extractPath(metric.length - tail, metric.length), paint);
    });
  }
}

// ignore: slash_for_doc_comments
/**
 *  Container(
      width: 100,
      height: 100,
      decoration: DashDecoration(
        pointWidth: 2,
        step: 5,
        pointCount: 1,
        radius: Radius.circular(15),
        gradient: const SweepGradient(colors: [
          Colors.blue,
          Colors.red,
          Colors.yellow,
          Colors.green
        ])),
      child: const Icon(
        Icons.add,
        color: Colors.orangeAccent,
        size: 40,
      ),
    ),
 */
/// 装饰类
class DashDecoration extends Decoration {
  final Gradient? gradient;
  final Color? color;
  final double step;
  final double span;
  final int pointCont;
  final double? pointLength;
  final Radius? radius;
  final double strokeWidth;

  const DashDecoration(
      {this.gradient,
      this.color,
      this.step = 2,
      this.strokeWidth = 1,
      this.span = 2,
      this.pointCont = 0,
      this.pointLength,
      this.radius});

  @override
  BoxPainter createBoxPainter([VoidCallback? onChanged]) => DashBoxPainter(this);
}

class DashBoxPainter extends BoxPainter {
  final DashDecoration _dashDecoration;

  DashBoxPainter(this._dashDecoration);

  @override
  void paint(Canvas canvas, Offset offset, ImageConfiguration configuration) {
    if (configuration.size == null) return;

    Radius radius = _dashDecoration.radius ?? Radius.zero;
    canvas.save();
    final Paint paint = Paint()
      ..style = PaintingStyle.stroke
      ..color = Colors.orangeAccent
      ..strokeWidth = _dashDecoration.strokeWidth;
    final Path path = Path();

    canvas.translate(offset.dx + (configuration.size!.width) / 2, offset.dy + (configuration.size!.height) / 2);
    final Rect zone =
        Rect.fromCenter(center: Offset.zero, width: configuration.size!.width, height: configuration.size!.height);
    if (_dashDecoration.color != null) {
      final Paint rectPaint = Paint()..color = _dashDecoration.color!;
      canvas.drawRRect(RRect.fromRectAndRadius(zone, radius), rectPaint);
    }

    path.addRRect(RRect.fromRectAndRadius(zone, radius));

    if (_dashDecoration.gradient != null) {
      paint.shader = _dashDecoration.gradient!.createShader(zone);
    }

    DashPainter(
            span: _dashDecoration.span,
            step: _dashDecoration.step,
            pointCount: _dashDecoration.pointCont,
            pointLength: _dashDecoration.pointLength)
        .paint(canvas, paint, path);
    canvas.restore();
  }
}
