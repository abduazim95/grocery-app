import 'package:intl/intl.dart';

String formatSum(double amount) {
  final formatted = NumberFormat('#,###', 'ru').format(amount.toInt());
  return '${formatted.replaceAll(',', ' ')} тг';
}

String formatDate(DateTime dt) => DateFormat('d MMM, HH:mm', 'ru').format(dt);

String formatDateOnly(DateTime dt) => DateFormat('d MMM yyyy', 'ru').format(dt);

String formatPhone(String phone) => phone;
