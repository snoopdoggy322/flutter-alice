import 'package:flutter/material.dart';
import 'package:flutter_alice/alice.dart';
import 'package:flutter_alice/core/alice_core.dart';
import 'package:flutter_alice/ui/utils/alice_constants.dart';

class AliceLogListScreen extends StatelessWidget {
  final AliceCore aliceCore;

  const AliceLogListScreen({Key? key, required this.aliceCore}) : super(key: key);

  Color logColors(int level) {
    return {
          0: Colors.greenAccent[100],
          1: Colors.yellow[100],
          2: Colors.red[100],
        }[level] ??
        Colors.yellow.shade50;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Logs'),
      ),
      body: StreamBuilder<List<AliceLog>>(
        stream: aliceCore.logsSubject,
        builder: (context, snapshot) {
          List<AliceLog> events = snapshot.data ?? [];
          if (events.isNotEmpty) {
            return ListView.separated(
              itemCount: events.length,
              itemBuilder: (context, index) {
                return ExpansionTile(
                  title: Text(events[index].title),
                  collapsedBackgroundColor: logColors(events[index].level),
                  backgroundColor: logColors(events[index].level),
                  collapsedShape: Border.fromBorderSide(BorderSide.none),
                  shape: Border.fromBorderSide(BorderSide.none),
                  subtitle: events[index].error != null ? Text(events[index].error.toString()) : null,
                  trailing: events[index].stackTrace != null ? null : Icon(Icons.minimize),
                  children: [if (events[index].stackTrace != null) SelectableText(events[index].stackTrace.toString())],
                );
              },
              separatorBuilder: (BuildContext context, int index) {
                return Divider();
              },
            );
          } else {
            return _buildEmptyWidget();
          }
        },
      ),
    );
  }

  Widget _buildEmptyWidget() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 32),
      child: Center(
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          Icon(
            Icons.error_outline,
            color: AliceConstants.orange,
          ),
          const SizedBox(height: 6),
          Text(
            "There are no events to show",
            style: TextStyle(fontSize: 18),
          ),
          const SizedBox(height: 12),
          Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(
              "• Check if you send any socket events",
              style: TextStyle(fontSize: 12),
              textAlign: TextAlign.center,
            ),
            Text(
              "• Check your Alice configuration",
              style: TextStyle(fontSize: 12),
              textAlign: TextAlign.center,
            ),
          ])
        ]),
      ),
    );
  }
}
