
/// 绘制状态：正在绘制，绘制完成，隐藏，编辑
enum PaintState { doing, done, hide, edit }

/// 形状类型：圆，椭圆，正方形，等腰三角形，直角三角形，五角星，箭头，线
enum ShapeType {
  circle, oval, square, regularTriangle, rightTriangle, star, polygon, arrow, line
}

/// 操作类型：
enum OpType {
  // 工具：钢笔，铅笔，荧光笔，毛笔，图形，AI，套索，板擦，反撤销，撤销
  pen, pencil, highlight, brush, shape, ai, lasso, eraser, undo, redo,

  // 多媒体：图片，文本，文档，视频
  image, text, doc, video,

  // options：尺子，截屏，搜图，录屏，便签，计时器，放大镜，扫一扫
  ruler, screenshot, search_image, recording, sticky_note, timer, magnifier, scan
}

/// 通用事件类型
enum CommonType {
  touch_down
}
