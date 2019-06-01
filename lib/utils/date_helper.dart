
import 'package:intl/intl.dart';

class DateHelper {

  ///
  /// check is date is current date or not
  ///
  static bool isToday(DateTime date) {
    if (date.day == DateTime.now().day &&
        DateTime.now().month == date.month &&
        DateTime.now().year == date.year) {
      return true;
    } else {
      return false;
    }
  }

  ///
  ///  change date format like (yyyy-MM-dd)
  ///
  static String chnageFormate(String outputPattren, String date) {
    return DateFormat()
        .addPattern(outputPattren, "")
        .format(DateTime.parse(date));
  }

  ///
  /// change time format HH:mm:ss
  ///
  static String changeTime(String outputPattren, String time) {
    return DateHelper.chnageFormate(outputPattren,
        "${DateHelper.chnageFormate("yyyy-MM-dd HH:mm:ss", DateTime.now().toString())} $time");
  }

  ///
  /// Get date list between two date
  ///
  List<DateTime> getDatesBetweenTwoDate(String dateString1, String dateString2) {
    var dates = List<DateTime>();
    DateTime date1;
    DateTime date2;
    try {
      date1 = DateTime.parse(dateString1);
      date2 = DateTime.parse(dateString2);
    } catch (exception) {
      print("exception"+exception);
    }
    while (date2.isAfter(date1) || date2 == date1) {
      dates.add(date1);
      date1 = date1.add(Duration(days: 1));
    }
    return dates;
  }
}
