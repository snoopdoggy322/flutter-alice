class AliceLog {
  final String title;
  final Object? error;
  final StackTrace? stackTrace;
  final int level;

  AliceLog({
    required this.title,
    this.error,
    this.stackTrace,
    this.level = 0,
  });
}
