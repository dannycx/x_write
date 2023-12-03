import 'dart:collection';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:x_write/model/net/sp_tool.dart';

const bool CACHE_ENABLE = false;
const int CACHE_MAXAGE = 24 * 60 * 60 * 1000; // 1天毫秒值
const int CACHE_MAXCOUNT = 1000;

class Http {
  static final Http _instance = Http._internal();

  // 单例模式使用Http类
  factory Http() => _instance;

  static late final Dio dio;
  CancelToken _cancelToken = new CancelToken();

  Http._internal() {
    // BaseOptions、Options、RequestOptions 都可以配置参数，优先级依次递增，且可根据优先级覆盖参数
    BaseOptions options = new BaseOptions();

    dio = Dio();

    // 添加拦截器
    dio.interceptors.add(ReqResInterceptor());

    // 添加error拦截器
    dio.interceptors.add(ErrorInterceptor());

    // 添加cache拦截器
    dio.interceptors.add(CacheInterceptor());

    // 添加retry拦截器
    dio.interceptors.add(RetryInterceptor());

    // 调试模式禁用https证书校验
    // (dio.httpClientAdapter as DefaultHttpClientAdapter).on
  }

  /// 初始化公告参数
  void init({String? baseUrl,
    int connectTimeout = 15000,
    int receiveTimeout = 15000,
    Map<String, String>? headers,
    List<Interceptor>? interceptors}) {
    dio.options = dio.options.copyWith(
        baseUrl: baseUrl,
        connectTimeout: Duration(milliseconds: connectTimeout),
        receiveTimeout: Duration(milliseconds: receiveTimeout),
        headers: headers ?? const {});

    // 初始化Http类时，传入拦截器
    if (interceptors != null && interceptors.isNotEmpty) {
      dio.interceptors.addAll(interceptors);
    }
  }

  /// 关闭dio
  void cancelRequests({required CancelToken token}) {
    _cancelToken.cancel("cancelled");
  }

  /// 添加认证,读取本地配置
  Map<String, dynamic>? getAuthorizationHeader() {
    Map<String, dynamic> headers = {};

    // 缓存取token
    String? accessToken = "";
    if (accessToken != null) {
      headers.putIfAbsent('Authorization', () => 'Bearer $accessToken');
    }
    headers["Content-Type"] = "application/json";
    return headers;
  }

  Future get(String path,
      {Map<String, dynamic>? params,
        Options? options,
        CancelToken? cancelToken,
        bool refresh = false,
        bool noCache = !CACHE_ENABLE,
        String? cacheKey,
        bool cacheDisk = false}) async {
    Options requestOptions = options ?? Options();
    requestOptions = requestOptions
        .copyWith(extra: {'refresh': refresh, 'noCache': noCache, 'cacheKey': cacheKey, 'cacheDisk': cacheDisk});

    Map<String, dynamic>? _authorization = getAuthorizationHeader();
    if (_authorization != null) {
      requestOptions = requestOptions.copyWith(headers: _authorization);
    }
    Response response =
    await dio.get(path, queryParameters: params, options: requestOptions, cancelToken: cancelToken ?? _cancelToken);

    return response.data;
  }

  Future post(String path, {Map<String, dynamic>? params, data, Options? options, CancelToken? cancelToken}) async {
    Options requestOptions = options ?? Options();

    Map<String, dynamic>? _authorization = getAuthorizationHeader();
    if (_authorization != null) {
      requestOptions = requestOptions.copyWith(headers: _authorization);
    }
    Response response = await dio.post(path,
        data: data, queryParameters: params, options: requestOptions, cancelToken: cancelToken ?? _cancelToken);

    return response.data;
  }

  Future put(String path, {Map<String, dynamic>? params, data, Options? options, CancelToken? cancelToken}) async {
    Options requestOptions = options ?? Options();

    Map<String, dynamic>? _authorization = getAuthorizationHeader();
    if (_authorization != null) {
      requestOptions = requestOptions.copyWith(headers: _authorization);
    }
    Response response = await dio.put(path,
        data: data, queryParameters: params, options: requestOptions, cancelToken: cancelToken ?? _cancelToken);

    return response.data;
  }

  Future patch(String path, {Map<String, dynamic>? params, data, Options? options, CancelToken? cancelToken}) async {
    Options requestOptions = options ?? Options();

    Map<String, dynamic>? _authorization = getAuthorizationHeader();
    if (_authorization != null) {
      requestOptions = requestOptions.copyWith(headers: _authorization);
    }
    Response response = await dio.patch(path,
        data: data, queryParameters: params, options: requestOptions, cancelToken: cancelToken ?? _cancelToken);

    return response.data;
  }

  Future delete(String path, {Map<String, dynamic>? params, data, Options? options, CancelToken? cancelToken}) async {
    Options requestOptions = options ?? Options();

    Map<String, dynamic>? _authorization = getAuthorizationHeader();
    if (_authorization != null) {
      requestOptions = requestOptions.copyWith(headers: _authorization);
    }
    Response response = await dio.delete(path,
        data: data, queryParameters: params, options: requestOptions, cancelToken: cancelToken ?? _cancelToken);

    return response.data;
  }
}

/// 请求响应拦截器
class ReqResInterceptor extends InterceptorsWrapper {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    super.onRequest(options, handler);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    super.onResponse(response, handler);
    print("ReqResInterceptor response: ${response.toString()}");
  }
}

/// Socket拦截器:默认不可修改错误信息
class DioSocketException extends SocketException {
  late String msg;

  DioSocketException(message, {osError, address, port})
      : super(message, osError: osError, address: address, port: port);


}

/// 错误拦截器
class ErrorInterceptor extends Interceptor {

  Future<bool> isConnected() async {
    // var connectivityResult = await (Connectivity().checkConnectivity());
    // return connectivityResult != ConnectivityResult.none;
    return true;
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    if (err.error is SocketException) {
      // err.error = DioSocketException(err.message, osError: ((err.error) as SocketException?)?.osError,
      //     address: ((err.error) as SocketException?)?.address, port: ((err.error) as SocketException?)?.port ?? 0);
    }

    if (err.type == DioExceptionType.unknown) {
      bool isConnect = await isConnected();
      if (!isConnect && err.error is DioSocketException) {
        ((err.error) as DioSocketException).msg = 'The current network is unavailable, please check your network';
      }
    }

    // error统一处理
    super.onError(err, handler);
  }
}

/// 缓存拦截器
class CacheInterceptor extends LogInterceptor {
  var cache = LinkedHashMap<String, CacheData>();

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    if (!CACHE_ENABLE) {
      super.onRequest(options, handler);
      return;
    }

    // refresh标记是否是刷新缓存
    bool refresh = options.extra["refresh"] == true;

    // 是否磁盘缓存
    bool cacheDisk = options.extra["cacheDisk"] == true;

    if (refresh) {
      // 删除uri相同的内存缓存
      delete(options.uri.toString());

      // 删除磁盘缓存
      if (cacheDisk) {
        await SpUtil().remove(options.uri.toString());
        return;
      }
    }

    // get请求
    if (options.extra["noCache"] != true && options.method.toLowerCase() == 'get') {
      String key = options.extra['cacheKey'] ?? options.uri.toString();

      // 缓存策略：1.内存缓存优先2.磁盘缓存
      var ob = cache[key];
      if (ob != null) {
        // 缓存可用，返回缓存内容
        if (DateTime.now().millisecondsSinceEpoch - ob.timestamp / 1000 < CACHE_MAXAGE) {
          return;
        } else {
          // 过期清缓存
          cache.remove(key);
        }
      }

      if (cacheDisk) {
        var cacheData = SpUtil().getJSON(key);
        if (cacheData != null) {
          return;
        }
      }
    }

    super.onRequest(options, handler);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) async {
    // 如果启用缓存，将返回结果保存到缓存
    if (CACHE_ENABLE) {
      await _saveCache(response);
    }

    super.onResponse(response, handler);
  }

  _saveCache(Response response) async {
    RequestOptions options = response.requestOptions;

    // 只缓存 get 的请求
    if (options.extra["noCache"] != true && options.method.toLowerCase() == "get") {
      // 策略：内存、磁盘都写缓存
      // 缓存key
      String key = options.extra["cacheKey"] ?? options.uri.toString();

      // 磁盘缓存
      if (options.extra["cacheDisk"] == true) {
        await SpUtil().setJSON(key, response.data);
      }

      // 内存缓存
      // 如果缓存数量超过最大数量限制，则先移除最早的一条记录
      if (cache.length == CACHE_MAXCOUNT) {
        cache.remove(cache[cache.keys.first]);
      }

      cache[key] = CacheData(response);
    }
  }

  void delete(String key) {
    cache.remove(key);
  }
}

/// 缓存数据
class CacheData {
  Response response;
  int timestamp;

  CacheData(this.response) : timestamp = DateTime.now().millisecondsSinceEpoch;

  @override
  bool operator == (other) {
    return response.hashCode == other.hashCode;
  }

  @override
  int get hashCode => response.realUri.hashCode;
}

/// 重试拦截器
class RetryInterceptor extends LogInterceptor {}
