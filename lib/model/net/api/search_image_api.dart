import 'package:dio/dio.dart';
import 'dart:core';

import '../data/search_image_resp.dart';

/// 图片搜索
class SearchImageApi {
  final Dio _client = Dio(BaseOptions());
  final String USER_AGENT = "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) "
      "Chrome/90.0"
      ".4430.212 Safari/537.36";

  Future<List<String>> obtainImage(String searchKey, int count) async {
    String url = "https://www.google.com/search?tbm=isch&q==$searchKey";

    // width=1920&height=1080&istype=2 分辨率大于1920*1080
    String url2 =
        "https://image.baidu.com/search/acjson?tn=resultjson_com&ipn=rj&ct=201326592&fp=result&queryWord=$searchKey"
        "&cl=2&lm=-1&ie=utf-8&oe=utf-8&st=-1&ic=0&word=$searchKey&face=0&istype=2nc=1&rn=$count&pn=$count&width=1920"
        "&height=1080&istype=2";

    Map<String, String> headers = {
      "User-Agent": USER_AGENT,
      "Accept-Language": "zh-CN,zh;q=0.8,zh-TW;q=0.7,zh-HK;q=0.5,en-US;q=0.3,en;q=0.2",
      "Connection": "keep-alive",
      "Upgrade-Insecure-Requests": "1",

      // 跨域问题：XMLHttpRequest失败
      "Access-Control-Allow-Origin": "*",
      "Access-Control-Allow-Credentials": 'true',
      "Access-Control-Allow-Headers":
          "Origin,Content-Type,X-Amz-Date,Authorization,X-Api-Key,X-Amz-Security-Token,locale,x-requested-with",
      "Access-Control-Allow-Methods": "POST,OPTIONS,GET,DELETE",
      "Access-Control-Max-Age": "3600"
    };
    _client.options.headers = headers;
    final resp = await _client.get(url2);

    Map<String, dynamic> body = resp.data;
    List list = body["data"];

    int pageCount = count ~/ 2;
    print('obtainImage pageCount: $pageCount list: ${list.length}');
    List<String> urlList = [];
    for (int index = 0; index < list.length; index++) {
      Map<String, dynamic> json = list[index];
      if (json.isEmpty) {
        continue;
      }
      String thumbURL = SearchImageResp.fromJson(json).thumbURL ?? "";
      print('obtainImage thumbURL: $thumbURL');
      if (thumbURL.isEmpty) {
        continue;
      }

      if (urlList.length > pageCount) {
        break;
      }
      urlList.add(thumbURL);
    }

    /// test
    // var dio = Dio();
    // var baseUrl = "https://api.github.com/";
    // var operate = "users/";
    // var api=baseUrl+operate+"dannycx";
    // dio.get(api, queryParameters: {"Access-Control-Allow-Origin": "*"}).then((rep) => print(rep.data));
    return urlList;
  }
}
