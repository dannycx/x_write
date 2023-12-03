import 'package:intl/intl.dart';

class DateTimeTool {
  static final DateFormat defaultFormat = DateFormat('yyyyMMddhhmmss');

  static String getCurrentTime(DateFormat? format) {
    DateTime now = DateTime.now();
    return (format?? defaultFormat).format(now);
  }
}
