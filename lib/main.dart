import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:x_write/model/net/http_util.dart';
import 'package:x_write/model/net/sp_tool.dart';
import 'package:x_write/tool/CommonTool.dart';

import 'ui/HomePage.dart';

Future<void> main() async {
  // 确定初始化
  WidgetsFlutterBinding.ensureInitialized();

  // 设备横屏显示
  SystemChrome.setPreferredOrientations([DeviceOrientation.landscapeLeft, DeviceOrientation.landscapeRight]);

  // 全屏
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark);
  // await initStore();
  runApp(const MyApp());
}

Future<void> initStore() async {
  await SpUtil().init();
  HttpUtils.init(baseUrl: '');
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    CommonTool.init(context);
    return MaterialApp(
      color: const Color.fromARGB(242, 255, 242, 242),
      debugShowCheckedModeBanner: false,
      home: HomePage(),
    );
  }
}
