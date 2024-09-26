import 'package:dio/dio.dart';

class HttpUtil {
  static final Dio dio = Dio();

  static Future<T> request<T>(String url,
      {String method = "",
        required Map<String, dynamic> params,
        Interceptor? inter}) async {
    // 1、创建单独配置
    final options = Options(method: method);
    // 全局拦截器
    // 创建默认的全局拦截器
    // 2.添加第一个拦截器
    Interceptor dInter = InterceptorsWrapper(onRequest: (options, handler) {
      print("请求拦截");
      print(options);
      // Do something before request is sent
      return handler.next(options); //continue
      // 如果你想完成请求并返回一些自定义数据，你可以resolve一个Response对象 `handler.resolve(response)`。
      // 这样请求将会被终止，上层then会被调用，then中返回的数据将是你的自定义response.
      //
      // 如果你想终止请求并触发一个错误,你可以返回一个`DioError`对象,如`handler.reject(error)`，
      // 这样请求将被中止并触发异常，上层catchError会被调用。
    }, onResponse: (response, handler) {
      print("响应拦截");
      return handler.next(response); // continue
      // 如果你想终止请求并触发一个错误,你可以 reject 一个`DioError`对象,如`handler.reject(error)`，
      // 这样请求将被中止并触发异常，上层catchError会被调用。
    }, onError: (DioError e, handler) {

      print("请求发生错误");
      // Do something with response error
      return handler.next(e); //continue
      // 如果你想完成请求并返回一些自定义数据，可以resolve 一个`Response`,如`handler.resolve(response)`。
      // 这样请求将会被终止，上层then会被调用，then中返回的数据将是你的自定义response.
    });

    List<Interceptor> inters = [dInter];
    if (inter != null) {
      inters.add(inter);
    }
    //加入请求头
    // dio.options.headers = httpHeaders;
    dio.interceptors.addAll(inters);
    // 2、发送网络请求    get请求使用queryParameters   post使用data  否则数据丢失
    try {
      Response response =
      await dio.request(url, data: params, options: options);
      print("JHY：$response");
      return response.data;
    } on DioError catch (e) {
      return Future.error(e);
    }
  }
}

const httpHeaders = {
  'token': '',
};
