import 'package:flutter/material.dart';
import 'package:x_write/tool/CommonTool.dart';

import 'ui/HomePage.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    CommonTool.init(context);
    return MaterialApp(
      title: 'Flutter Demo',
      color: const Color.fromARGB(242, 255, 242, 242),
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: HomePage(),
    );
  }
}
