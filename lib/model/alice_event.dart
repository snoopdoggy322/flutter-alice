class AliceEvent {
  final String channel;
  final String event;
  final String eventPayload;
  final DateTime timestamp;

  AliceEvent({
    required this.channel,
    required this.event,
    required this.eventPayload,
    required this.timestamp,
  });
}
