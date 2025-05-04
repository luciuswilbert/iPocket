// 📄 transaction_page.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:iPocket/pages/add_expense/add_expense.dart';
import 'package:iPocket/utils/transaction_helpers.dart';
import 'package:iPocket/widgets/filter_dialog_widget.dart';
import 'package:intl/intl.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'transaction_card.dart';
import 'rounded_rect_clipper.dart';
import 'description_dialog.dart';

class TransactionPage extends StatefulWidget {
  const TransactionPage({Key? key}) : super(key: key);

  @override
  TransactionPageState createState() => TransactionPageState();
}

class TransactionPageState extends State<TransactionPage> {
  String selectedDuration = 'Month';
  String selectedSort = 'Newest';
  List<String> selectedCategories = [];

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'Transactions History',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        backgroundColor: const Color(0xffDAA520),
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list, color: Colors.black),
            onPressed: () => _showFilterDialog(),
          ),
        ],
        automaticallyImplyLeading: false,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: getTransactionsQuery(user).snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: \${snapshot.error}'));
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text('No transactions found.'));
          }

          List<Map<String, dynamic>> transactions =
              snapshot.data!.docs.map((doc) {
                var data = doc.data() as Map<String, dynamic>;
                return {
                  'id': doc.id,
                  'category': data['category'],
                  'description': data['description'],
                  'amount': (data['amount'] as num).toDouble(),
                  'dateTime': (data['dateTime'] as Timestamp).toDate(),
                };
              }).toList();

          return ListView.builder(
            padding: const EdgeInsets.only(
              top: 8.0,
              bottom: 80.0,
              left: 8.0,
              right: 8.0,
            ),
            itemCount: transactions.length,
            itemBuilder: (context, index) {
              final transaction = transactions[index];
              return Container(
                margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                child: ClipPath(
                  clipper: RoundedRectClipper(radius: 24.0),
                  child: Slidable(
                    closeOnScroll: true,
                    key: Key(transaction['id']),
                    endActionPane: ActionPane(
                      motion: const StretchMotion(),
                      children: [
                        CustomSlidableAction(
                          onPressed: (context) {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder:
                                    (context) => AddExpensePage(
                                      expenseCategory: transaction['category'],
                                      totalAmount: transaction['amount'],
                                      description: transaction['description'],
                                      transactionId: transaction['id'],
                                    ),
                              ),
                            );
                          },
                          backgroundColor: const Color(0xffdaa520),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: const [
                              Icon(Icons.edit, color: Colors.white, size: 26),
                              SizedBox(height: 4),
                            ],
                          ),
                        ),
                        CustomSlidableAction(
                          onPressed: (context) {
                            deleteTransaction(user, transaction['id']);
                          },
                          backgroundColor: Colors.red,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: const [
                              Icon(Icons.delete, color: Colors.white, size: 26),
                              SizedBox(height: 4),
                            ],
                          ),
                        ),
                      ],
                    ),
                    child: TransactionCard(
                      icon: Icon(
                        getCategoryIcon(transaction['category']),
                        color: getCategoryColor(transaction['category']),
                      ),
                      category: transaction['category'],
                      amount: transaction['amount'],
                      dateTime: formatDateTime(transaction['dateTime']),
                      onTap:
                          () => showDescriptionDialog(
                            context,
                            transaction['category'],
                            transaction['description'],
                            getBgCategoryColor(transaction['category']),
                            getCategoryColor(transaction['category']),
                          ),
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  Query getTransactionsQuery(final user) {
    Query query = FirebaseFirestore.instance
        .collection('users')
        .doc(user.email)
        .collection('transactions');

    DateTime now = DateTime.now();
    DateTime startDate;

    switch (selectedDuration) {
      case 'Day':
        startDate = DateTime(now.year, now.month, now.day);
        break;
      case 'Week':
        final today = DateTime(now.year, now.month, now.day);
        int weekday = today.weekday;
        startDate = today.subtract(Duration(days: weekday - 1));
        break;
      case 'Month':
        startDate = DateTime(now.year, now.month, 1);
        break;
      case 'Year':
        startDate = DateTime(now.year, 1, 1);
        break;
      case 'All Time':
      default:
        startDate = DateTime(2000);
        break;
    }

    query = query.where(
      'dateTime',
      isGreaterThanOrEqualTo: Timestamp.fromDate(startDate),
    );

    if (selectedCategories.isNotEmpty) {
      query = query.where('category', whereIn: selectedCategories);
    }

    if (selectedSort == 'Newest') {
      query = query.orderBy('dateTime', descending: true);
    } else if (selectedSort == 'Oldest') {
      query = query.orderBy('dateTime', descending: false);
    } else if (selectedSort == 'Highest') {
      query = query.orderBy('amount', descending: true);
    } else if (selectedSort == 'Lowest') {
      query = query.orderBy('amount', descending: false);
    }

    return query;
  }

  void deleteTransaction(final user, String transactionId) async {
    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(user.email)
          .collection('transactions')
          .doc(transactionId)
          .delete();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to delete transaction: \$e")),
      );
    }
  }

  void _showFilterDialog() {
    showDialog(
      context: context,
      builder:
          (context) => FilterDialog(
            initialDuration: selectedDuration,
            initialSort: selectedSort,
            initialSelectedCategories: selectedCategories,
            onApply: (duration, sort, categories) {
              setState(() {
                selectedDuration = duration;
                selectedSort = sort;
                selectedCategories = categories;
              });
            },
          ),
    );
  }

  String formatDateTime(DateTime dateTime) {
    return DateFormat('dd MMM @ hh:mm a').format(dateTime);
  }
}
