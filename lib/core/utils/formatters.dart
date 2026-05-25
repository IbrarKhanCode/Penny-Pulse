import 'package:intl/intl.dart';

final _currencyFormatter = NumberFormat.currency(
  symbol: 'PKR ',
  decimalDigits: 2,
);
final _dateFormatter = DateFormat('MMM d, yyyy');
final _dateTimeFormatter = DateFormat('MMM d, yyyy • h:mm a');

String formatCurrency(double amount) => _currencyFormatter.format(amount);

String formatDate(DateTime date) => _dateFormatter.format(date.toLocal());

String formatDateTime(DateTime date) =>
    _dateTimeFormatter.format(date.toLocal());
