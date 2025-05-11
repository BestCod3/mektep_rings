String calculateExitTime(String entryTime) {
  final parts = entryTime.split(':');
  int hour = int.parse(parts[0]);
  int minute = int.parse(parts[1]) + 45;
  if (minute >= 60) {
    hour += 1;
    minute -= 60;
  }
  return '${hour.toString().padLeft(2, '0')}:${minute.toString().padLeft(2, '0')}';
}
