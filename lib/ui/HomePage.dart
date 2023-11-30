import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:x_write/model/net/ui/weather_page.dart';
import 'package:x_write/model/options/ui/timer.dart';
import 'package:x_write/model/render/data/paint_state.dart';
import 'package:x_write/model/render/data/write_value_notifier.dart';
import 'package:x_write/tool/CommonTool.dart';
import 'package:x_write/tool/file_tool.dart';
import 'package:x_write/ui/WritingPage.dart';
import 'package:x_write/ui/prop/insert_prop_page.dart';
import 'package:x_write/ui/prop/PenPropPage.dart';
import 'package:x_write/ui/prop/ShapePropPage.dart';
import 'package:x_write/ui/prop/options_page.dart';
import 'package:x_write/ui/tool_bar.dart';

import '../model/net/ui/search_image.dart';

class HomePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _HomePageState();
  }
}

class _HomePageState extends State<HomePage> {
  double _x = (CommonTool.width - 260) / 2;
  double _y = 0;
  final double width = CommonTool.width;
  final double height = CommonTool.height;

  // 操作类型
  OpType curOpType = OpType.pen;

  // 放大镜参数：大小，位置，是否显示
  final Size magnifierSize = const Size(120, 120);
  Offset _dragMagnifierPostion = Offset.zero;
  bool _magnifierVisible = false;

  /// 是否显示工具属性page
  bool _penPropPageVisible = false;
  bool _shapePropPageVisible = false;
  bool _insertPropPageVisible = false;
  bool _optionsPageVisible = false;
  bool _searchImagePageVisible = false;
  bool _timerPageVisible = false;

  FileTool fileTool = FileTool();

  @override
  void initState() {
    // 横屏
    // SystemChrome.setPreferredOrientations([DeviceOrientation.landscapeLeft, DeviceOrientation.landscapeRight]);

    // 全屏显示
    // SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark);

    eventBus.on<CommonTypeEvent>().listen((commonType) {
      _commonTypeEvent(commonType.commonType);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Overlay.of(context).insert(_enetry());
    });
    return Scaffold(
      body: ConstrainedBox(
        constraints: const BoxConstraints.expand(),
        // 通过ConstrainedBox来确保Stack占满屏幕
        child: Stack(
          children: [
            WritingPage(_panDown, _panUpdate, _panEnd),
            _leftTool(),
            _rightTool(),
            _penPropPage(),
            _shapePropPage(),
            _insertPropPage(),
            _optionsPage(), // 更多操作项
            _weatherWidget(), // 天气
            _searchImageWidget(), // 搜图
            _timerWidget(), // 计时器
            _magnifier(), // 放大镜
          ],
        ),
      ),
    );
  }

  Widget _leftTool() {
    return Positioned(
      // width: 96,
      height: 36,
      left: 16,
      top: height - 48,
      child: FunctionMenu(
        onToolMenu: _onToolMenu,
        onToolDecoration: _onToolDecoration,
      ),
    );
  }

  Widget _rightTool() {
    return Positioned(
      // width: 192,
      height: 36,
      right: 16,
      top: height - 48,
      child: PageMenu(
        onToolAdd: () {},
        onToolPre: () {},
        onToolNum: () {},
        onToolNext: () {},
      ),
    );
  }

  OverlayEntry _enetry() {
    return OverlayEntry(builder: (context) {
      return Positioned(
        // width: 316,
        height: 36,
        left: _x,
        top: height - 48,
        child: GestureDetector(
            onPanUpdate: (details) {
              setState(() {
                _x += details.delta.dx;
                // _y += details.delta.dy;
                if (_x < 124) {
                  _x = 124;
                } else if (_x > width - 484) {
                  _x = width - 484;
                }
              });
            },
            child: ToolMenu(
              onToolStylus: _onToolStylus,
              onToolAi: _onToolAi,
              onToolShape: _onToolShape,
              onToolLasso: _onToolLasso,
              onToolLayer: _onToolLayer,
              onToolEraser: _onToolEraser,
              onToolUndo: _onToolUndo,
              onToolRedo: _onToolRedo,
              onToolFunction: _onToolFunction,
            )),
      );
    });
  }

  Widget _penPropPage() {
    return Visibility(
        // 显示隐藏
        visible: _penPropPageVisible,
        // 隐藏时是否保持占位
        maintainState: false,
        // 隐藏时是否保存动态状态
        maintainAnimation: false,
        // 隐藏时是否保存子组件所占空间大小，不会消耗过多的性能
        maintainSize: false,
        child: Positioned(
          // width: 316,
          height: 36,
          left: _x,
          top: height - 90,
          child: PenPropPage(
            onToolPenProp: (penType, color, thickness) {
              eventBus.fire(OpTypeEvent(opType: penType));
              eventBus.fire(PenPropEvent(color: color, thickness: thickness));
            },
          ),
        ));
  }

  Widget _shapePropPage() {
    return Visibility(
        // 显示隐藏
        visible: _shapePropPageVisible,
        // 隐藏时是否保持占位
        maintainState: false,
        // 隐藏时是否保存动态状态
        maintainAnimation: false,
        // 隐藏时是否保存子组件所占空间大小，不会消耗过多的性能
        maintainSize: false,
        child: Positioned(
          width: 316,
          height: 36,
          left: _x,
          top: height - 90,
          child: ShapePropPage(
            onToolShapeProp: _onToolShapeProp,
          ),
        ));
  }

  Widget _insertPropPage() {
    return Visibility(
        // 显示隐藏
        visible: _insertPropPageVisible,
        // 隐藏时是否保持占位
        maintainState: false,
        // 隐藏时是否保存动态状态
        maintainAnimation: false,
        // 隐藏时是否保存子组件所占空间大小，不会消耗过多的性能
        maintainSize: false,
        child: Positioned(
          width: 316,
          height: 60,
          left: _x,
          top: height - 116,
          child: InsertPropPage(
            onToolInsertProp: _onToolInsertProp,
          ),
        ));
  }

  Widget _optionsPage() {
    return Visibility(
        // 显示隐藏
        visible: _optionsPageVisible,
        // 隐藏时是否保持占位
        maintainState: false,
        // 隐藏时是否保存动态状态
        maintainAnimation: false,
        // 隐藏时是否保存子组件所占空间大小，不会消耗过多的性能
        maintainSize: false,
        child: Positioned(
          width: 248,
          height: 122,
          left: _x + 124,
          top: height - 196,
          child: OptionsPage(
            optionsCallback: _onToolOptions,
          ),
        ));
  }

  _weatherWidget() {
    return const Visibility(
        // 显示隐藏
        visible: false,
        // 隐藏时是否保持占位
        maintainState: false,
        // 隐藏时是否保存动态状态
        maintainAnimation: false,
        // 隐藏时是否保存子组件所占空间大小，不会消耗过多的性能
        maintainSize: false,
        child: Positioned(
          width: 200,
          height: 200,
          right: 0,
          top: 0,
          child: WeatherPage(),
        ));
  }

  _searchImageWidget() {
    return Visibility(
        // 显示隐藏
        visible: _searchImagePageVisible,
        // 隐藏时是否保持占位
        maintainState: false,
        // 隐藏时是否保存动态状态
        maintainAnimation: false,
        // 隐藏时是否保存子组件所占空间大小，不会消耗过多的性能
        maintainSize: false,
        child: const Positioned(
          width: 300,
          height: 640,
          bottom: 60,
          child: SearchImage(),
        ));
  }

  _timerWidget() {
    return Visibility(
        // 显示隐藏
        visible: _timerPageVisible,
        // 隐藏时是否保持占位
        maintainState: false,
        // 隐藏时是否保存动态状态
        maintainAnimation: false,
        // 隐藏时是否保存子组件所占空间大小，不会消耗过多的性能
        maintainSize: false,
        child: Positioned(
          width: 300,
          height: 200,
          left: (width - 300) / 2,
          top: (height - 200) / 2,
          child: const TimerPage(),
        ));
  }

  _magnifier() {
    return Visibility(
      // 显示隐藏
        visible: _magnifierVisible,
        // 隐藏时是否保持占位
        maintainState: false,
        // 隐藏时是否保存动态状态
        maintainAnimation: false,
        // 隐藏时是否保存子组件所占空间大小，不会消耗过多的性能
        maintainSize: false,
        child: Positioned(
          left: _dragMagnifierPostion.dx,
          top: _dragMagnifierPostion.dy,
          child: RawMagnifier(
            decoration: const MagnifierDecoration(
                shape: CircleBorder(side: BorderSide(color: Colors.blue, width: 2))
            ),
            size: magnifierSize,
            magnificationScale: 2, // 放大倍数
          ),
        ));
  }

  void _onToolMenu() {
    print('_onToolMenu');
  }

  void _onToolDecoration() {
    print('_onToolDecoration');
  }

  void _onToolStylus() {
    curOpType = OpType.pencil;
    _hidePropPage();
    setState(() {
      _penPropPageVisible = true;
    });
    eventBus.fire(OpTypeEvent(opType: OpType.pencil));
  }

  void _onToolAi() {
    print('_onToolAi');
    curOpType = OpType.ai;
  }

  void _onToolShape() {
    curOpType = OpType.shape;
    _hidePropPage();
    setState(() {
      _shapePropPageVisible = true;
    });
    eventBus.fire(OpTypeEvent(opType: OpType.shape));
  }

  void _onToolLasso() {
    curOpType = OpType.lasso;
    eventBus.fire(OpTypeEvent(opType: OpType.lasso));
  }

  void _onToolLayer() {
    curOpType = OpType.lasso;
    _hidePropPage();
    setState(() {
      _insertPropPageVisible = true;
    });
  }

  void _onToolEraser() {
    curOpType = OpType.eraser;
    eventBus.fire(OpTypeEvent(opType: OpType.eraser));
  }

  void _onToolUndo() {
    curOpType = OpType.undo;
    eventBus.fire(OpTypeEvent(opType: OpType.undo));
  }

  void _onToolRedo() {
    curOpType = OpType.redo;
    eventBus.fire(OpTypeEvent(opType: OpType.redo));
  }

  void _onToolFunction() {
    _hidePropPage();
    setState(() {
      _optionsPageVisible = true;
    });
  }

  _onToolShapeProp(ShapeType shapeType) {
    eventBus.fire(ShapeTypeEvent(shapeType: shapeType));
  }

  _onToolInsertProp(OpType opType) {
    print('_onToolInsertProp opType: $opType');
    eventBus.fire(OpTypeEvent(opType: opType));
    switch (opType) {
      case OpType.image:
        curOpType = OpType.image;
        _pickFile();
        break;
      default:
        break;
    }
  }

  _onToolOptions(OpType opType) {
    print('_onToolInsertProp opType: $opType');
    curOpType = opType;
    eventBus.fire(OpTypeEvent(opType: curOpType));
    switch (opType) {
      case OpType.search_image:
        _searchImageState();
        break;
      case OpType.timer:
        _timerState();
        break;
      case OpType.magnifier:
        _magnifierState();
        break;
      default:
        break;
    }
  }

  void _searchImageState() {
    _hidePropPage();
    setState(() {
      _searchImagePageVisible = true;
    });
  }

  void _timerState() {
    _hidePropPage();
    setState(() {
      _timerPageVisible = true;
    });
  }

  void _magnifierState() {
    _hidePropPage();
    setState(() {
      _magnifierVisible = true;
    });
  }

  void _hidePropPage() {
    setState(() {
      _penPropPageVisible = false;
      _shapePropPageVisible = false;
      _insertPropPageVisible = false;
      _optionsPageVisible = false;
      _searchImagePageVisible = false;
      _timerPageVisible = false;
      _magnifierVisible = false;
    });
  }

  /// 拖拽按下事件
  void _panDown(DragDownDetails details) {
    switch (curOpType) {
      case OpType.magnifier:
        _dragMagnifierPostion = details.localPosition - Offset(magnifierSize.width / 2, magnifierSize.height / 2);
        _magnifierVisible = true;
        setState(() {});
        break;
      default:
        break;
    }
  }

  /// 拖拽更新事件
  void _panUpdate(DragUpdateDetails details) {
    switch (curOpType) {
      case OpType.magnifier:
        _dragMagnifierPostion = details.localPosition - Offset(magnifierSize.width / 2, magnifierSize.height / 2);
        _magnifierVisible = true;
        setState(() {});
        break;
      default:
        break;
    }
  }

  /// 拖拽结束事件
  void _panEnd(DragEndDetails details) {
    switch (curOpType) {
      case OpType.magnifier:
        // setState(() => _magnifierVisible = true);
        break;
      default:
        break;
    }
  }

  void _pickFile() async {
    //打开存储以拾取文件和拾取的一个或多个文件
    //被分配到结果中，如果没有选择文件，则结果为null。
    //您还可以根据需要切换“allowMultiple”true或false
    final result = await FilePicker.platform
        .pickFiles(allowMultiple: false, allowedExtensions: ['jpg', 'png', 'webp'], type: FileType.custom);

    //如果未拾取文件
    if (result == null || result.files.isEmpty) return;

    //我们将记录
    //第一个拾取的文件（如果选择了多个）
    print('name: ${result.files.first.name}');
    print('size: ${result.files.first.size}');
    File? file = await fileTool.imagePath(result.files.first.name, result.files.first.bytes);
    print('path: ${file?.path ?? 'null'}');
  }

  void _commonTypeEvent(CommonType commonType) {
    switch (commonType) {
      case CommonType.touch_down:
        _hidePropPage();
        break;
      default:
        break;
    }
  }
}
