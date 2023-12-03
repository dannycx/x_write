import 'dart:typed_data';

import 'package:flutter/material.dart';

/// 显示image组件
class ImagePage extends StatefulWidget {
  const ImagePage({Key? key, this.bytes}): super(key: key);

  final Uint8List? bytes;

  @override
  State<ImagePage> createState() => _ImagePageState();
}

class _ImagePageState extends State<ImagePage> {
  @override
  Widget build(BuildContext context) {
    if (widget.bytes != null) return Image.memory(widget.bytes!, fit: BoxFit.cover,);
    return Container();
  }
}
