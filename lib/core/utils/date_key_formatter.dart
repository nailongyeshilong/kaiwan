String buildDateKey(DateTime dateTime) {
  final localDateTime = dateTime.toLocal();
  final month = localDateTime.month.toString().padLeft(2, '0');
  final day = localDateTime.day.toString().padLeft(2, '0');

  return '${localDateTime.year}-$month-$day';
}
