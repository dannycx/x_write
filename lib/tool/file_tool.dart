import 'dart:io';
import 'dart:typed_data';

import 'package:path_provider/path_provider.dart';
import 'package:x_write/tool/date_time_tool.dart';

/// 文件操作工具类
class FileTool {
  Future<String> get _localPath async {
    final _path = await getTemporaryDirectory();
    return _path.path;
  }

  get _pngFileName => '${DateTimeTool.getCurrentTime(null)}.png';

  Future<File?> imagePath(String fileName, Uint8List? bytes) async {
    final path = await _localPath;
    File file = File('$path/$fileName');
    if (bytes != null) {
      file.writeAsBytes(bytes.toList());
    }
    print('imagePath file: ${file.path}');
    return file;
  }

  /// 图片写入文件
  Future<Null> imageByteWrite(ByteData byteData) async {
    Uint8List sourceBytes = byteData.buffer.asUint8List();
    await imageUint8ListWrite(sourceBytes);
  }

  /// 图片写入文件
  Future<Null> imageUint8ListWrite(Uint8List? uint8list) async {
    if (uint8list == null) return;
    Directory tempDir = await getTemporaryDirectory();
    String storagePath = tempDir.path;
    File file = File('$storagePath/$_pngFileName');

    if (!file.existsSync()) {
      file.createSync();
    }
    file.writeAsBytesSync(uint8list!);

    print('imageUint8ListWrite file: ${file.path}');
  }
}
