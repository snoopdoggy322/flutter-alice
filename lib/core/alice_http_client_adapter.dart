import 'dart:convert';

import 'package:flutter_alice/core/alice_core.dart';
import 'package:flutter_alice/model/alice_http_call.dart';
import 'package:flutter_alice/model/alice_http_request.dart';
import 'package:flutter_alice/model/alice_http_response.dart';
import 'package:http/http.dart';

class AliceHttpClientAdapter {
  /// AliceCore instance
  final AliceCore aliceCore;

  /// Creates alice http client adapter
  AliceHttpClientAdapter(this.aliceCore);

  /// Handles httpClientRequest and creates http alice call from it
  void onRequest(BaseRequest request,) {
    AliceHttpCall call = AliceHttpCall(request.hashCode);
    call.loading = true;
    call.client = "HttpClient (io package)";
    call.method = request.method;
    call.uri = request.url.toString();

    var path = request.url.path;
    if (path.length == 0) {
      path = "/";
    }

    call.endpoint = path;
    call.server = request.url.host;
    if (request.url.scheme == "https") {
      call.secure = true;
    }
    AliceHttpRequest httpRequest = AliceHttpRequest();
    if (request is! Request) {
      httpRequest.size = 0;
      httpRequest.body = "";
    } else {
      var body=request.body;
      httpRequest.size = utf8.encode(body.toString()).length;
      httpRequest.body = body;
    }
    httpRequest.time = DateTime.now();
    Map<String, dynamic> headers = Map();
    request.headers.forEach((header, value) {
      headers[header] = value;
    });

    httpRequest.headers = headers;
    String? contentType = "unknown";
    if (headers.containsKey("Content-Type")) {
      contentType = headers["Content-Type"];
    }

    httpRequest.contentType = contentType;

    call.request = httpRequest;
    call.response = AliceHttpResponse();
    aliceCore.addCall(call);
  }

  /// Handles httpClientRequest and adds response to http alice call
  void onResponse(BaseResponse response) async {
    AliceHttpResponse httpResponse = AliceHttpResponse();
    httpResponse.status = response.statusCode;
    if (response is Response) {
      var body=response.body;
      httpResponse.body = body;
      httpResponse.size = utf8.encode(body.toString()).length;
    } else {
      httpResponse.body = "";
      httpResponse.size = 0;
    }
    httpResponse.time = DateTime.now();
    Map<String, String> headers = Map();
    response.headers.forEach((header, values) {
      headers[header] = values.toString();
    });
    httpResponse.headers = headers;
    var request=response.request;
    aliceCore.addResponse(httpResponse, request.hashCode);
  }
}
