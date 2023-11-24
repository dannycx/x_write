import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:x_write/tool/CommonTool.dart';

import 'ui/HomePage.dart';

void main() {
  // 确定初始化
  WidgetsFlutterBinding.ensureInitialized();

  // 设备横屏显示
  SystemChrome.setPreferredOrientations([DeviceOrientation.landscapeLeft, DeviceOrientation.landscapeRight]);

  // 全屏
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark);
  runApp(const MyApp());
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
