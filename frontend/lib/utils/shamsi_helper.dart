class ShamsiHelper {
  // Converts English digits to Persian digits
  static String toPersianDigits(dynamic input) {
    if (input == null) return '';
    const english = ['0', '1', '2', '3', '4', '5', '6', '7', '8', '9'];
    const persian = ['۰', '۱', '۲', '۳', '۴', '۵', '۶', '۷', '۸', '۹'];
    String result = input.toString();
    for (int i = 0; i < english.length; i++) {
      result = result.replaceAll(english[i], persian[i]);
    }
    return result;
  }

  // Built-in Shamsi/Jalali conversion algorithm without external dependency requirement
  static Map<String, int> gregorianToJalali(int gy, int gm, int gd) {
    final gDaysInMonth = [31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31];
    final jDaysInMonth = [31, 31, 31, 31, 31, 31, 30, 30, 30, 30, 30, 29];

    int gy2 = (gm > 2) ? (gy + 1) : gy;
    int gDayNo = 355666 + (365 * gy) + ((gy2 + 3) ~/ 4) - ((gy2 + 99) ~/ 100) + ((gy2 + 399) ~/ 400) + gd;
    for (int i = 0; i < gm - 1; ++i) {
      gDayNo += gDaysInMonth[i];
    }

    int jDayNo = gDayNo - 73787;
    int jNp = jDayNo ~/ 12053;
    jDayNo %= 12053;

    int jy = 979 + 33 * jNp + 4 * (jDayNo ~/ 1461);
    jDayNo %= 1461;

    if (jDayNo >= 366) {
      jy += (jDayNo - 1) ~/ 365;
      jDayNo = (jDayNo - 1) % 365;
    }

    int jm = 0;
    for (int i = 0; i < 11 && jDayNo >= jDaysInMonth[i]; ++i) {
      jDayNo -= jDaysInMonth[i];
      jm = i + 1;
    }
    int jd = jDayNo + 1;

    return {'year': jy, 'month': jm + 1, 'day': jd};
  }

  // Returns formatted Shamsi date like "1405-07-04"
  static String getTodayShamsiIso() {
    final now = DateTime.now();
    final j = gregorianToJalali(now.year, now.month, now.day);
    final m = j['month']!.toString().padLeft(2, '0');
    final d = j['day']!.toString().padLeft(2, '0');
    return '${j['year']}-$m-$d';
  }

  // Returns friendly Persian date like "شنبه ۴ مهر ۱۴۰۵"
  static String formatFriendlyShamsi(String shamsiIso) {
    try {
      final parts = shamsiIso.split('-');
      if (parts.length != 3) return shamsiIso;

      final year = parts[0];
      final monthIndex = int.tryParse(parts[1]) ?? 1;
      final day = parts[2];

      const monthNames = [
        'فروردین', 'اردیبهشت', 'خرداد', 'تیر', 'مرداد', 'شهریور',
        'مهر', 'آبان', 'آذر', 'دی', 'بهمن', 'اسفند'
      ];

      final monthName = (monthIndex >= 1 && monthIndex <= 12) 
          ? monthNames[monthIndex - 1] 
          : '';

      return '${toPersianDigits(int.tryParse(day) ?? day)} $monthName ${toPersianDigits(year)}';
    } catch (_) {
      return shamsiIso;
    }
  }

  static String getStatusLabel(String status) {
    switch (status) {
      case 'present':
        return 'حاضر';
      case 'absent_unexcused':
        return 'غایب غیرموجه';
      case 'absent_excused':
        return 'غایب موجه';
      case 'late':
        return 'تأخیر';
      default:
        return 'نامشخص';
    }
  }
}
