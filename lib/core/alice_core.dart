
import 'package:flutter/material.dart';
import 'package:flutter_alice/model/alice_http_call.dart';
import 'package:flutter_alice/model/alice_http_error.dart';
import 'package:flutter_alice/model/alice_http_response.dart';
import 'package:flutter_alice/model/alice_event.dart';
import 'package:flutter_alice/ui/page/alice_calls_list_screen.dart';
import 'package:rxdart/rxdart.dart';

class AliceCore {

  /// Should inspector use dark theme
  final bool darkTheme;

  /// Rx subject which contains all intercepted http calls
  final BehaviorSubject<List<AliceHttpCall>> callsSubject = BehaviorSubject.seeded([]);

  /// Rx subject which contains all intercepted events
  final BehaviorSubject<List<AliceEvent>> eventsSubject = BehaviorSubject.seeded([]);


  GlobalKey<NavigatorState>? _navigatorKey;
  Brightness _brightness = Brightness.light;
  bool _isInspectorOpened = false;

  static AliceCore? _singleton;

  factory AliceCore(
    _navigatorKey,
    darkTheme,
  ) {
    _singleton ??= AliceCore._(
      _navigatorKey,
      darkTheme,
    );
    return _singleton!;
  }

  /// Creates alice core instance
  AliceCore._(
    this._navigatorKey,
    this.darkTheme,
  ) {
    _brightness = darkTheme ? Brightness.dark : Brightness.light;
  }

  /// Dispose subjects and subscriptions
  void dispose() {
    callsSubject.close();
    eventsSubject.close();
  }

  /// Get currently used brightness
  Brightness get brightness => _brightness;


  /// Set custom navigation key. This will help if there's route library.
  void setNavigatorKey(GlobalKey<NavigatorState> navigatorKey) {
    this._navigatorKey = navigatorKey;
  }

  /// Opens Http calls inspector. This will navigate user to the new fullscreen
  /// page where all listened http calls can be viewed.
  void navigateToCallListScreen() {
    var context = getContext();
    if (context == null) {
      print("Cant start Alice HTTP Inspector. Please add NavigatorKey to your application");
      return;
    }
    if (!_isInspectorOpened) {
      _isInspectorOpened = true;
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => AliceCallsListScreen(this),
        ),
      ).then((onValue) => _isInspectorOpened = false);
    }
  }

  /// Get context from navigator key. Used to open inspector route.
  BuildContext? getContext() => _navigatorKey?.currentState?.overlay?.context;


  /// Add alice http call to calls subject
  void addCall(AliceHttpCall call) {
    callsSubject.add([call, ...callsSubject.value]);
  }

  void addEvent(AliceEvent event) {
    eventsSubject.add([event, ...eventsSubject.value]);
  }

  /// Add error to exisng alice http call
  void addError(AliceHttpError error, int requestId) {
    AliceHttpCall? selectedCall = _selectCall(requestId);

    if (selectedCall == null) {
      print("Selected call is null");
      return;
    }

    selectedCall.error = error;
    callsSubject.add([...callsSubject.value]);
  }

  /// Add response to existing alice http call
  void addResponse(AliceHttpResponse response, int requestId) {
    AliceHttpCall? selectedCall = _selectCall(requestId);

    if (selectedCall == null) {
      print("Selected call is null");
      return;
    }
    selectedCall.loading = false;
    selectedCall.response = response;
    selectedCall.duration = response.time.millisecondsSinceEpoch - selectedCall.request!.time.millisecondsSinceEpoch;

    callsSubject.add([...callsSubject.value]);
  }

  /// Add alice http call to calls subject
  void addHttpCall(AliceHttpCall aliceHttpCall) {
    assert(aliceHttpCall.request != null, "Http call request can't be null");
    assert(aliceHttpCall.response != null, "Http call response can't be null");
    callsSubject.add([...callsSubject.value, aliceHttpCall]);
  }

  /// Remove all calls from calls subject
  void removeCalls() {
    callsSubject.add([]);
    eventsSubject.add([]);

  }

  AliceHttpCall? _selectCall(int requestId) => callsSubject.value.firstWhereOrNull((call) => call.id == requestId);

  bool isShowedBubble = false;

}

extension IterableExtension<T> on Iterable<T> {
  T? firstWhereOrNull(bool Function(T element) test) {
    for (var element in this) {
      if (test(element)) return element;
    }
    return null;
  }
}
