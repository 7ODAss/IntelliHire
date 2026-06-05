import 'package:intl/intl.dart';

extension DateFormatter on String {
  String toFormattedData() {
    if (trim().isEmpty) return 'No Date';

    try {
      final DateTime parsedDate = DateTime.parse(this);
      return DateFormat('dd MMM yyyy, hh:mm a').format(parsedDate);
    } catch (e) {
      return this;
    }
  }
}

extension TimeAgoExtension on String {
  String toTimeAgo() {
    try {
      // تحويل النص اللي جاي من الـ API لـ DateTime وتعديله على توقيت الموبايل
      DateTime parsedDate = DateTime.parse(this).toLocal();
      DateTime now = DateTime.now();
      Duration diff = now.difference(parsedDate);

      // 1. لو الإشعار وصل النهاردة (يعرض الوقت بس مثلا 10:30 AM)
      if (now.year == parsedDate.year &&
          now.month == parsedDate.month &&
          now.day == parsedDate.day) {
        int hour = parsedDate.hour > 12
            ? parsedDate.hour - 12
            : (parsedDate.hour == 0 ? 12 : parsedDate.hour);
        String amPm = parsedDate.hour >= 12 ? 'PM' : 'AM';
        String minute = parsedDate.minute.toString().padLeft(2, '0');

        return '$hour:$minute $amPm'; // النتيجة: 10:30 AM
      }

      // 2. لو عدى سنين
      if (diff.inDays >= 365) {
        int years = (diff.inDays / 365).floor();
        return years == 1 ? '1 year ago' : '$years years ago';
      }

      // 3. لو عدى شهور
      if (diff.inDays >= 30) {
        int months = (diff.inDays / 30).floor();
        return months == 1 ? '1 month ago' : '$months months ago';
      }

      // 4. لو عدى أسابيع
      if (diff.inDays >= 7) {
        int weeks = (diff.inDays / 7).floor();
        return weeks == 1 ? '1 week ago' : '$weeks weeks ago';
      }

      // 5. لو عدى أيام
      if (diff.inDays > 0) {
        return diff.inDays == 1 ? '1 day ago' : '${diff.inDays} days ago';
      }

      // لو فرق الساعات عدى نص الليل بس لسه مكملش 24 ساعة
      return '1 day ago';
    } catch (e) {
      return 'Now'; // لو حصل أي خطأ يرجع Now كاحتياطي
    }
  }
}
