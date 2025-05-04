import 'package:flutter/material.dart';

/// ✅ Function to dynamically assign icons based on category
IconData getCategoryIcon(String category) {
  switch (category) {
    case 'Groceries': return Icons.shopping_cart;
    case 'Subscription': return Icons.subscriptions;
    case 'Food': return Icons.fastfood;
    case 'Shopping': return Icons.shopping_bag;
    case 'Miscellaneous': return Icons.category_outlined;
    case 'Healthcare': return Icons.health_and_safety_outlined;
    case 'Transportation': return Icons.directions_car;
    case 'Utilities': return Icons.build_circle_outlined;
    case 'Housing': return Icons.home;
    default: return Icons.category;
  }
}

/// ✅ Function to dynamically assign colors based on category
Color getCategoryColor(String category) {
  switch (category) {
    case 'Groceries': return const Color(0xffFCAC12);
    case 'Subscription': return const Color(0xff8B4513);
    case 'Food': return const Color(0xff556B2F);
    case 'Shopping': return const Color(0xffFF2D55);
    case 'Miscellaneous': return const Color(0xffD4AF37);
    case 'Healthcare': return const Color(0xffFF1493);
    case 'Transportation': return const Color(0xff4682B4);
    case 'Utilities': return const Color(0xff9370DB);
    case 'Housing': return const Color(0xffFF6347);
    default: return Colors.grey;
  }
}

/// ✅ Function to dynamically assign background colors based on category
Color getBgCategoryColor(String category) {
  switch (category) {
    case 'Groceries': return const Color(0xFFFCEED4);
    case 'Subscription': return const Color(0xFFEADDCB);
    case 'Food': return const Color(0xFFE1DEBC);
    case 'Shopping': return const Color(0xFFFFD8D1);
    case 'Miscellaneous': return const Color(0xFFFAFAD2);
    case 'Healthcare': return const Color(0xFFFFE1F0);
    case 'Transportation': return const Color(0xFFB0E0E6);
    case 'Utilities': return const Color(0xFFD8BFD8);
    case 'Housing': return const Color(0xFFFFA07A);
    default: return Colors.grey;
  }
}
