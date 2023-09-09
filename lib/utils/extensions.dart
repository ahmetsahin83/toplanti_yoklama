extension DateTimeEx on DateTime {
  String get toShortString => "$day/$month/$year";
  DateTime get toShortDateTime => DateTime(year, month, day);
}
