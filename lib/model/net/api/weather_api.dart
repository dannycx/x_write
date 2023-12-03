import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:dio/dio.dart';

import '../data/weather_data.dart';

class WeatherApi {
  // 心知天气v4 api
  static const String kWeatherBaseUrl = "https://api.seniverse.com/v4";
  static const String key = "PtiPwx8rGKq2YZNkS";

  // final Dio _client = Dio(BaseOptions(baseUrl: kWeatherBaseUrl));
  final Dio _client = Dio(BaseOptions());

  Future<WeatherData?> obtainWeather(String fields, String location) async {
    String baseParams = 'fields=air_daily&locations=22.547:114.085947&public_key=$key&ts=${DateTime.now()
        .millisecondsSinceEpoch}&ttl=300';
    String sig = hmacSha1('SY7HBHeSFS5W7uRgZ', baseParams);

    print('obtainWeather sig: $sig');
    print('obtainWeather urlEncode sig: ${Uri.encodeFull(sig)}');
    String path = 'https://api.seniverse.com/v4?$baseParams&sig=$Uri.encodeFull(sig)';
    var rep = await _client.get(path);
    if (rep.statusCode == 200 && rep.data != null) {
      print('obtainWeather rep: $rep');
      var data = rep.data['weather_daily'][0]['data'];
      print('obtainWeather data: $data');
      return data;
    }

    return null;
  }

  /// 使用crypto库中的Hmac和sha1类来实现HMAC-SHA1哈希运算，并使用base64库来进行Base64编码。
  String hmacSha1(String key, String msg) {
    // 将密钥转换为字节数组
    var bytes = utf8.encode(key);

    // 创建HMAC-SHA1哈希对象
    var hmacSha1 = new Hmac(sha1, bytes);

    // 计算哈希值
    var digest = hmacSha1.convert(utf8.encode(msg));

    // 将哈希值进行Base64编码并返回
    return base64.encode(digest.bytes);
  }
}
