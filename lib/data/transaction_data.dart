import 'package:flutter/material.dart';

/// Transaction Data File (Can be replaced with Database in the future)
/// ✅ Transaction Data File (For now, acts as local data, will be replaced with MySQL in the future)
final List<Map<String, dynamic>> transactions = [
  {
    'category': 'Groceries',
    'description': 'Buy some grocery items from the supermarket',
    'amount': 120.00,
    'dateTime': '28 Feb @ 10:00 AM',
    'color': const Color(0xFFFCEED4), // Background color of the card
  },
  {
    'category': 'Subscription',
    'description': 'Disney+ Annual subscription renewal',
    'amount': 80.00,
    'dateTime': '28 Feb @ 03:30 PM',
    'color': const Color(0xFFEADDCB), // Light beige
  },
  {
    'category': 'Food',
    'description': 'Buy a ramen from the local restaurant',
    'amount': 32.00,
    'dateTime': '28 Feb @ 07:30 PM',
    'color': const Color(0xFFE1DEBC), // Light green
  },
  {
    'category': 'Shopping',
    'description': 'Buy a pair of shoes from the mall',
    'amount': 32.00,
    'dateTime': '28 Feb @ 07:30 PM',
    'color': const Color(0xFFFFD8D1), // Light pink
  },
  {
    'category': 'Miscellaneous',
    'description': 'Pay Barbershop',
    'amount': 120.00,
    'dateTime': '28 Feb @ 10:00 AM',
    'color': const Color(0xFFFAFAD2), // Light yellow
  },
  {
    'category': 'Healthcare',
    'description': 'Buy Vitamin',
    'amount': 80.00,
    'dateTime': '28 Feb @ 03:30 PM',
    'color': const Color(0xFFFFE1F0), // Light pinkish
  },
  {
    'category': 'Transportation',
    'description': 'Buy Petrol',
    'amount': 32.00,
    'dateTime': '28 Feb @ 07:30 PM',
    'color': const Color(0xFFB0E0E6), // Light blue
  },
  {
    'category': 'Utilities',
    'description': 'Pay Electricity',
    'amount': 32.00,
    'dateTime': '28 Feb @ 07:30 PM',
    'color': const Color(0xFFD8BFD8), // Light purple
  },
  {
    'category': 'Housing',
    'description': 'Pay Monthly Rent',
    'amount': 32.00,
    'dateTime': '28 Feb @ 07:30 PM',
    'color': const Color(0xFFFFA07A), // Light orange
  },
];
