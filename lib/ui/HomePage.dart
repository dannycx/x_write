import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
// import 'package:x_write/model/net/ui/weather_page.dart';
import 'package:x_write/model/render/data/paint_state.dart';
import 'package:x_write/model/render/data/write_value_notifier.dart';
import 'package:x_write/tool/CommonTool.dart';
import 'package:x_write/ui/WritingPage.dart';
import 'package:x_write/ui/prop/insert_prop_page.dart';
import 'package:x_write/ui/prop/PenPropPage.dart';
import 'package:x_write/ui/prop/ShapePropPage.dart';
import 'package:x_write/ui/tool_bar.dart';

class HomePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _HomePageState();
  }
}

class _HomePageState extends State<HomePage> {
  double _x = (CommonTool.width - 260) / 2;
  double _y = 0;
  double width = CommonTool.width;
  double height = CommonTool.height;

  /// 是否显示工具属性page
  bool _penPropPageVisible = false;
  bool _shapePropPageVisible = false;
  bool _insertPropPageVisible = false;

  @override
  void initState() {
    // 横屏
    // SystemChrome.setPreferredOrientations([DeviceOrientation.landscapeLeft, DeviceOrientation.landscapeRight]);

    // 全屏显示
    // SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark);

    eventBus.on<CommonTypeEvent>().listen((commonType) { _commonTypeEvent(commonType.commonType); });
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
            const WritingPage(),
            _leftTool(),
            _rightTool(),
            _penPropPage(),
            _shapePropPage(),
            _insertPropPage(),
            _weatherWidget(),
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

  _weatherWidget() {
    return const Visibility(
      // 显示隐藏
        visible: true,
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
          child: Text('data'),
        ));
  }

  void _onToolMenu() {
    print('_onToolMenu');
  }

  void _onToolDecoration() {
    print('_onToolDecoration');
  }

  void _onToolStylus() {
    _hidePropPage();
    setState(() {
      _penPropPageVisible = true;
    });
    eventBus.fire(OpTypeEvent(opType: OpType.pencil));
  }

  void _onToolAi() {
    print('_onToolDecoration');
    _pickFile();
  }

  void _onToolShape() {
    _hidePropPage();
    setState(() {
      _shapePropPageVisible = true;
    });
    eventBus.fire(OpTypeEvent(opType: OpType.shape));
  }

  void _onToolLasso() {
    eventBus.fire(OpTypeEvent(opType: OpType.shape));
  }

  void _onToolLayer() {
    _hidePropPage();
    setState(() {
      _insertPropPageVisible = true;
    });
  }

  void _onToolEraser() {
    eventBus.fire(OpTypeEvent(opType: OpType.shape));
  }

  void _onToolUndo() {
    eventBus.fire(OpTypeEvent(opType: OpType.shape));
  }

  void _onToolRedo() {
    eventBus.fire(OpTypeEvent(opType: OpType.shape));
  }

  void _onToolFunction() {
    eventBus.fire(OpTypeEvent(opType: OpType.shape));
  }

  _onToolShapeProp(ShapeType shapeType) {
    eventBus.fire(ShapeTypeEvent(shapeType: shapeType));
  }

  _onToolInsertProp(OpType opType) {
    print('_onToolInsertProp opType: $opType');
    eventBus.fire(OpTypeEvent(opType: opType));
  }

  void _hidePropPage() {
    setState(() {
      _penPropPageVisible = false;
      _shapePropPageVisible = false;
      _insertPropPageVisible = false;
    });
  }

  void _pickFile() async {
    //打开存储以拾取文件和拾取的一个或多个文件
    //被分配到结果中，如果没有选择文件，则结果为null。
    //您还可以根据需要切换“allowMultiple”true或false
    final result = await FilePicker.platform.pickFiles(allowMultiple: false);

    //如果未拾取文件
    if (result == null) return;

    //我们将记录
    //第一个拾取的文件（如果选择了多个）
    print('name: ${result.files.first.name}');
    print('size: ${result.files.first.size}');
    print('path: ${result.files.first.path}');
  }

  void _commonTypeEvent(CommonType commonType) {
    switch(commonType) {
      case CommonType.touch_down:
        _hidePropPage();
        break;
      default:
        break;
    }
  }
}
