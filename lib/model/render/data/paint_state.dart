
/// 绘制状态：正在绘制，绘制完成，隐藏，编辑
enum PaintState { doing, done, hide, edit }

/// 形状类型：圆，椭圆，正方形，正三角形，直角三角形，五角星，箭头，线
enum ShapeType {
  circle, oval, square, regularTriangle, rightTriangle, star, arrow, line
}

/// 操作类型：
enum OpType {
  pen, pencil, highlight, brush, shape
}