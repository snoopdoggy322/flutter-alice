
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_alice/core/alice_core.dart';
import 'package:flutter_alice/core/alice_http_adapter.dart';
import 'package:flutter_alice/core/alice_http_client_adapter.dart';
import 'package:flutter_alice/model/alice_event.dart';
import 'package:flutter_alice/model/alice_http_call.dart';
import 'package:flutter_alice/model/alice_http_error.dart';
import 'package:flutter_alice/model/alice_log.dart';
import 'package:http/http.dart' as http;
export 'package:flutter_alice/ui/widget/alice_app_wrapper.dart';
export 'package:flutter_alice/model/alice_event.dart';
export 'package:flutter_alice/model/alice_log.dart';

class Alice {

  /// Should inspector use dark theme
  final bool darkTheme;


  GlobalKey<NavigatorState>? _navigatorKey;
  late AliceCore _aliceCore;
  late AliceHttpClientAdapter _httpClientAdapter;
  late AliceHttpAdapter _httpAdapter;

  /// Creates alice instance.
  Alice(
      {GlobalKey<NavigatorState>? navigatorKey,
      this.darkTheme = false}) {
    _navigatorKey = navigatorKey ?? GlobalKey<NavigatorState>();
    _aliceCore = AliceCore(
      _navigatorKey,
      darkTheme
    );
    _httpClientAdapter = AliceHttpClientAdapter(_aliceCore);
    _httpAdapter = AliceHttpAdapter(_aliceCore);
  }

  /// Set custom navigation key. This will help if there's route library.
  void setNavigatorKey(GlobalKey<NavigatorState> navigatorKey) {
    _aliceCore.setNavigatorKey(navigatorKey);
  }

  /// Get currently used navigation key
  GlobalKey<NavigatorState>? getNavigatorKey() {
    return _navigatorKey;
  }

  /// Handle request from HttpClient
  void onHttpClientRequest(http.BaseRequest request) {
    _httpClientAdapter.onRequest(request);
  }

  /// Handle response from HttpClient
  void onHttpClientResponse(
      http.BaseResponse response) {
    _httpClientAdapter.onResponse(response);
  }

  /// Handle both request and response from http package
  void onHttpResponse(http.Response response, {dynamic body}) {
    _httpAdapter.onResponse(response, body: body);
  }

  /// Opens Http calls inspector. This will navigate user to the new fullscreen
  /// page where all listened http calls can be viewed.
  void showInspector() {
    _aliceCore.navigateToCallListScreen();
  }

  /// Handle generic http call. Can be used to any http client.R
  void addHttpCall(AliceHttpCall aliceHttpCall) {
    assert(aliceHttpCall.request != null, "Http call request can't be null");
    assert(aliceHttpCall.response != null, "Http call response can't be null");
    _aliceCore.addCall(aliceHttpCall);
  }

  /// Adds new log to Alice logger.
  void addEvent(AliceEvent event) {
    _aliceCore.addEvent(event);
  }

  /// Adds new log to Alice logger.
  void addError(AliceHttpError error, int requestId) {
    _aliceCore.addError(error,requestId);
  }

  /// Adds new log to Alice logger.
  void addLog(AliceLog log) {
    _aliceCore.addLog(log);
  }

}
