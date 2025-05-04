// summary_logic.dart
import 'package:intl/intl.dart';

List<String> getTimePeriodLabels(
  String selectedTimePeriod,
  List<Map<String, dynamic>> transactions,
) {
  switch (selectedTimePeriod) {
    case 'Day':
      return ['00–06', '06–12', '12–18', '18–24'];
    case 'Week':
      return ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    case 'Month':
      return [
        'Jan',
        'Feb',
        'Mar',
        'Apr',
        'May',
        'Jun',
        'Jul',
        'Aug',
        'Sep',
        'Oct',
        'Nov',
        'Dec',
      ];
    case 'Year':
      final years =
          transactions
              .map((txn) => txn['dateTime'].year.toString())
              .toSet()
              .toList()
            ..sort();
      return years;
    default:
      return [];
  }
}

double calculateExpectedSlot(String selectedTimePeriod, double monthlyBudget) {
      int daysInMonth = DateTime.now().month + 1;
  switch (selectedTimePeriod) {
    case 'Day':
      return monthlyBudget / DateTime(DateTime.now().year, daysInMonth, 0).day / 4;
    case 'Week':
      return monthlyBudget / DateTime(DateTime.now().year, daysInMonth, 0).day;
    case 'Month':
      return monthlyBudget;
    case 'Year':
      return monthlyBudget * 12;
    default:
      return 0;
  }
}

String getTransactionKey(String selectedTimePeriod, DateTime date) {
  switch (selectedTimePeriod) {
    case 'Day':
      final hour = date.hour;
      if (hour >= 0 && hour < 6) return '00–06';
      if (hour >= 6 && hour < 12) return '06–12';
      if (hour >= 12 && hour < 18) return '12–18';
      return '18–24';
    case 'Week':
      return DateFormat('EEE').format(date);
    case 'Month':
      return DateFormat('MMM').format(date);
    case 'Year':
      return date.year.toString();
    default:
      return 'Unknown';
  }
}

List<Map<String, dynamic>> generateBarChartData(
  List<Map<String, dynamic>> transactions,
  double monthlyBudget,
  String selectedTimePeriod,
) {
  Map<String, double> barData = {};

  for (var txn in transactions) {
    DateTime date = txn['dateTime'];
    String key = getTransactionKey(selectedTimePeriod, date);
    final amount = (txn['amount'] as num).toDouble();
    barData[key] = (barData[key] ?? 0) + amount;
  }

  List<String> labels = getTimePeriodLabels(selectedTimePeriod, transactions);
  double expectedPerSlot = calculateExpectedSlot(
    selectedTimePeriod,
    monthlyBudget,
  );

  return labels.map((label) {
    return {
      'label': label,
      'total': barData[label] ?? 0,
      'expected': expectedPerSlot,
    };
  }).toList();
}
