import 'dart:math';

import 'package:alice_example/http_client.dart';
import 'package:flutter/material.dart';
import 'package:flutter_alice/alice.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late HttpService _httpService;
  late Alice _alice;

  @override
  void initState() {
    _alice = Alice(
      darkTheme: false,
    );
    _httpService = HttpService(_alice);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(primarySwatch: Colors.blue),
      navigatorKey: _alice.getNavigatorKey(),
      debugShowCheckedModeBanner: false,
      builder: (context, child) {
        return AliceAppWrapper(isActive: true, alice: _alice, child: child);
      },
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Alice HTTP Inspector - Example'),
        ),
        body: Container(
          padding: EdgeInsets.all(16),
          child: ListView(
            children: [
              const SizedBox(height: 8),
              _getTextWidget(
                  "Welcome to example of Alice Http Inspector. Click buttons below to generate sample data."),
              ElevatedButton(
                child: Text("Run http/http HTTP Requests"),
                onPressed: _runHttpHttpRequests,
              ),
              ElevatedButton(
                child: Text("Add socket event"),
                onPressed: () {
                  _alice.addEvent(AliceEvent(
                      channel: 'ch1',
                      event: 'event 123123',
                      eventPayload: 'reververververmvlermvoimrb',
                      timestamp: DateTime.now()));
                },
              ),
              ElevatedButton(
                child: Text("Add log"),
                onPressed: () {
                  _alice.addLog(AliceLog(
                      title: '123', error: Exception('wedwed'), stackTrace: StackTrace.fromString('fjergnekjrgn'),level: Random().nextInt(50)));
                },
              ),
              const SizedBox(height: 24),
              _getTextWidget("After clicking on buttons above, you should receive notification."
                  " Click on it to show inspector. You can also shake your device or click button below."),
              ElevatedButton(
                child: Text("Run HTTP Insepctor"),
                onPressed: _runHttpInspector,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _getTextWidget(String text) {
    return Text(
      text,
      style: TextStyle(fontSize: 14),
      textAlign: TextAlign.center,
    );
  }

  void _runHttpHttpRequests() async {
    _runHttpInspector();
    Map<String, dynamic> body = {"title": "foo", "body": "bar", "userId": "1"};
    _httpService.post('https://httpbin.org/status/500', body: body, headers: {'123': '123123'});
    _httpService.post('https://httpbin.org/status/400', body: body, headers: {});
    _httpService.post('https://httpbin.org/status/300', body: body, headers: {});
    _httpService.post('https://httpbin.org/status/200', body: body, headers: {});
    _httpService.post('https://httpbin.org/status/201', body: body, headers: {});
    _httpService.post('https://httpbin.org/status/202', body: body, headers: {});
    _httpService.get('https://jsonplaceholder.typicode.com/posts/1', body: body, headers: {});
    _httpService.put('https://jsonplaceholder.typicode.com/posts/1', body: body, headers: {});
    _httpService.post('https://httpbin.org/status/202', body: body, headers: {});
  }

  void _runHttpInspector() {
    _alice.showInspector();
  }
}
