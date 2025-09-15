

import 'dart:convert';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter/services.dart' show rootBundle;

class DioClient{

  final Dio dio;

  DioClient._internal(this.dio) {
    dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options,handler) async {
      options.headers['X-Request-ID'] = DateTime.now().millisecondsSinceEpoch.toString();
      handler.next(options);
      }
    ));

    dio.httpClientAdapter = _LocalAssetsAdapter(dio.httpClientAdapter);
  }

  factory DioClient(){
    final d =Dio();
    d.options = BaseOptions(
      connectTimeout: const Duration(seconds: 5),
      receiveTimeout: const Duration(seconds: 5),
    );
   return DioClient._internal(d);
  }
}

class _LocalAssetsAdapter implements HttpClientAdapter{
  final HttpClientAdapter _inner;
  _LocalAssetsAdapter(this._inner);

  @override
  void close({bool force = false}) {
 _inner.close(force: force);
  }

  @override
  Future<ResponseBody> fetch(RequestOptions options, Stream<Uint8List>? requestStream, Future<void>? cancelFuture) async {
    if(options.uri.toString().contains('/local/businesses')){
      final jsonStr = await rootBundle.loadString('assets/businesses.json');
      final bytes = utf8.encode(jsonStr);
      return ResponseBody.fromBytes(bytes, 200,headers: {
        Headers.contentTypeHeader:[Headers.jsonContentType],
      });
    }
    return _inner.fetch(options, requestStream, cancelFuture);
  }
  
}