import 'package:flutter/material.dart';
import 'package:flutter_alice/alice.dart';
import 'package:flutter_alice/helper/alice_alert_helper.dart';

class AliceAppWrapper extends StatefulWidget {
  final bool isActive;
  final Alice alice;
  final Widget? child;

  const AliceAppWrapper({Key? key, required this.isActive, required this.alice, required this.child}) : super(key: key);

  @override
  State<AliceAppWrapper> createState() => _AliceAppWrapperState();
}

class _AliceAppWrapperState extends State<AliceAppWrapper> {
  bool isHidden = false;
  Offset _offset = Offset(0, 200);

  @override
  Widget build(BuildContext context) {
    if (widget.child == null) return SizedBox();
    if (!widget.isActive || isHidden) return widget.child!;
    return Stack(
      children: [
        widget.child!,
        Positioned(
          left: _offset.dx,
          top: _offset.dy,
          child: GestureDetector(
            onDoubleTap: () {
              AliceAlertHelper.showAlert(
                widget.alice.getNavigatorKey()?.currentContext ?? context,
                "Hide button?",
                'The hidden button will only work when you reopen the application',
                firstButtonTitle: "No",
                firstButtonAction: () => {},
                secondButtonTitle: "Yes",
                secondButtonAction: () => setState(() {
                  isHidden = true;
                }),
              );
            },
            onPanUpdate: (d) => setState(() => _offset += Offset(d.delta.dx, d.delta.dy)),
            child: FloatingActionButton(
              mini: true,
              onPressed: () {
                widget.alice.showInspector();
              },
              backgroundColor: Colors.purpleAccent,
              child: Icon(
                Icons.insert_chart_outlined,
                size: 32,
                color: Colors.greenAccent,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
