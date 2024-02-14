import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart';
import 'package:http_interceptor/http/intercepted_http.dart';
import 'package:http_interceptor/models/interceptor_contract.dart';
import 'package:flutter_alice/alice.dart';
import 'package:uuid/uuid.dart';

class LoggerInterceptor extends InterceptorContract {
  final Alice alice;

  LoggerInterceptor(this.alice);

  @override
  Future<BaseRequest> interceptRequest({
    required BaseRequest request,
  }) async {
    alice.onHttpClientRequest(request);
    return request;
  }

  @override
  Future<BaseResponse> interceptResponse({
    required BaseResponse response,
  }) async {
    alice.onHttpClientResponse(response);
    return response;
  }
}

class HttpService {
  final Alice _alice;
  late InterceptedHttp client;

  HttpService(this._alice) {
     client = InterceptedHttp.build(interceptors: [
      LoggerInterceptor(_alice),
    ]);
  }

  Future<Response> post(String url, {required Map<String, String> headers, body, Encoding? encoding}) async {
    final response = await client.post(Uri.parse(url),
        headers: headers
          ..addAll({
            'Idempotency-Key': const Uuid().v4(),
          }),
        body: body,
        encoding: encoding);
    return response;
  }
  Future<Response> get(String url, {required Map<String, String> headers, body, Encoding? encoding}) async {
    final response = await client.get(Uri.parse(url),
        headers: headers
          ..addAll({
            'Idempotency-Key': const Uuid().v4(),
          }));
    return response;
  }
  Future<Response> put(String url, {required Map<String, String> headers, body, Encoding? encoding}) async {
    final response = await client.put(Uri.parse(url),
        headers: headers
          ..addAll({
            'Idempotency-Key': const Uuid().v4(),
          }),
        body: body,
        encoding: encoding);
    return response;
  }
}
