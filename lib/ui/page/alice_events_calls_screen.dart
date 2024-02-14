import 'package:flutter/material.dart';
import 'package:flutter_alice/core/alice_core.dart';
import 'package:flutter_alice/model/alice_event.dart';
import 'package:flutter_alice/ui/utils/alice_constants.dart';

class AliceEventsCallsScreen extends StatelessWidget {
  final AliceCore aliceCore;

  const AliceEventsCallsScreen({Key? key, required this.aliceCore}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:Text('Socket events'),
      ),
      body:StreamBuilder<List<AliceEvent>>(
        stream: aliceCore.eventsSubject,
        builder: (context, snapshot) {
          List<AliceEvent> events = snapshot.data ?? [];
          if (events.isNotEmpty) {

            return ListView.builder(
              itemCount: events.length,
              itemBuilder: (context, index) {
                return InkWell(
                  onTap: () => {},
                  child: Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Flexible(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SelectableText(events[index].channel,style: TextStyle(color: Colors.green,fontSize: 24),),
                                  const SizedBox(height: 4),
                                  SelectableText('Channel: '+events[index].event,style: TextStyle(fontSize: 16)),
                                  const SizedBox(height: 4),
                                  SelectableText('Payload: '+events[index].eventPayload),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(height: 1, color: AliceConstants.grey)
                    ],
                  ),
                );
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
