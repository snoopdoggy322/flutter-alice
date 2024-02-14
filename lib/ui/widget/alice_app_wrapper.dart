import 'package:flutter/material.dart';
import 'package:flutter_alice/alice.dart';

class AliceAppWrapper extends StatefulWidget {
  final bool isActive;
  final Alice alice;
  final Widget? child;

  const AliceAppWrapper({Key? key, required this.isActive, required this.alice, required this.child}) : super(key: key);

  @override
  State<AliceAppWrapper> createState() => _AliceAppWrapperState();
}

class _AliceAppWrapperState extends State<AliceAppWrapper> {

  Offset _offset = Offset(0,200);

  @override
  Widget build(BuildContext context) {
    if(widget.child==null)return SizedBox();
    if(!widget.isActive)return widget.child!;
    return  Stack(
      children: [
        widget.child!,
        Positioned(
          left: _offset.dx,
          top: _offset.dy,
          child: GestureDetector(
            onPanUpdate: (d) => setState(() => _offset += Offset(d.delta.dx, d.delta.dy)),
            child: FloatingActionButton(
              mini: true,
              onPressed: () {
                widget.alice.showInspector();
              },
              backgroundColor: Colors.purpleAccent,

              child: Icon(Icons.insert_chart_outlined,size: 32,color: Colors.greenAccent,),
            ),
          ),
        ),
      ],
    );
  }
}
