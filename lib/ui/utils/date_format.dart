import 'package:intl/intl.dart';

String formatDate(String dateString) {
  DateTime dateTime = DateTime.parse(dateString).toLocal();
  return DateFormat('dd MMM yyyy, hh:mm a').format(dateTime);
}