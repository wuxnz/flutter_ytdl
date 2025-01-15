import 'package:yt_downloader/core/values/regex_patterns.dart';

int _monthToNumber(String month) {
  switch (month.toLowerCase()) {
    case "january" || "jan":
      return 1;
    case "february" || "feb":
      return 2;
    case "march" || "mar":
      return 3;
    case "april" || "apr":
      return 4;
    case "may":
      return 5;
    case "june" || "jun":
      return 6;
    case "july" || "jul":
      return 7;
    case "august" || "aug":
      return 8;
    case "september" || "sep":
      return 9;
    case "october" || "oct":
      return 10;
    case "november" || "nov":
      return 11;
    case "december" || "dec":
      return 12;
    default:
      return 0;
  }
}

DateTime? dateStringSpacesToDateTime(String? dateString) {
  if (dateString == "Unknown" || dateString == null) {
    return null;
  }
  var dateMatch = dateRegExp.firstMatch(dateString);
  if (dateMatch == null) {
    return null;
  }
  var day = int.tryParse(dateMatch.group(1) ?? "0");
  var month = dateMatch.group(2);
  var year = int.tryParse(dateMatch.group(3) ?? "0");
  if (day == null || month == null || year == null) {
    return null;
  }
  var monthNumber = _monthToNumber(month);
  if (monthNumber == 0) {
    return null;
  }
  return DateTime(year, monthNumber, day);
}

Duration durationStringColonsToDuration(String? durationString) {
  if (durationString == null) {
    return Duration.zero;
  }
  var durationItems = durationString.split(":");
  if (durationItems.length == 1) {
    return Duration(
      seconds: int.tryParse(durationItems[0]) ?? 0,
    );
  } else if (durationItems.length == 2) {
    return Duration(
      minutes: int.tryParse(durationItems[0]) ?? 0,
      seconds: int.tryParse(durationItems[1]) ?? 0,
    );
  } else if (durationItems.length == 3) {
    return Duration(
      hours: int.tryParse(durationItems[0]) ?? 0,
      minutes: int.tryParse(durationItems[1]) ?? 0,
      seconds: int.tryParse(durationItems[2]) ?? 0,
    );
  } else {
    return Duration.zero;
  }
}
