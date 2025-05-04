import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:iPocket/pages/summary/bar_chart.dart';
import 'package:iPocket/pages/summary/pie_chart.dart';
import 'package:iPocket/pages/summary/summary_logic.dart';
import 'package:iPocket/utils/transaction_helpers.dart';

class SummaryPage extends StatefulWidget {
  const SummaryPage({super.key});

  @override
  _SummaryPageState createState() => _SummaryPageState();
}

class _SummaryPageState extends State<SummaryPage> {
  String selectedTimePeriod = 'Month';
  String selectedChartType = 'Pie Chart';
  bool showPercentages = false;
  bool state=true;

  final Map<String, Color> categoryColors = {
    'Housing': getCategoryColor('Housing'),
    'Utilities': getCategoryColor('Utilities'),
    'Food': getCategoryColor('Food'),
    'Subscription': getCategoryColor('Subscription'),
    'Groceries': getCategoryColor('Groceries'),
    'Shopping': getCategoryColor('Shopping'),
    'Healthcare': getCategoryColor('Healthcare'),
    'Transportation': getCategoryColor('Transportation'),
    'Miscellaneous': getCategoryColor('Miscellaneous'),
  };

  List<String> get timePeriods =>
      selectedChartType == 'Pie Chart' ? ['Day', 'Week', 'Month', 'Year', 'All'] : ['Day', 'Week', 'Month', 'Year'];

  Map<String, DateTime> getDateRangeForSelectedPeriod() {
    final now = DateTime.now();
    late DateTime startDate;
    late DateTime endDate;

    switch (selectedTimePeriod) {
      case 'Day':
        startDate = DateTime(now.year, now.month, now.day);
        endDate = startDate.add(const Duration(days: 1));
        break;
      case 'Week':
        final today = DateTime(now.year, now.month, now.day);
        final int currentWeekday = today.weekday;
        startDate = today.subtract(Duration(days: currentWeekday - 1));
        endDate = startDate.add(const Duration(days: 7));
        break;
      case 'Month':
        startDate = DateTime(now.year, now.month, 1);
        endDate = DateTime(now.year, now.month + 1, 1);
        break;
      case 'Year':
        startDate = DateTime(now.year, 1, 1);
        endDate = DateTime(now.year + 1, 1, 1);
        break;
      case 'All':
      default:
        startDate = DateTime(2000);
        endDate = now.add(const Duration(days: 1));
        break;
    }

    return {'start': startDate, 'end': endDate};
  }

  Query getTransactionsQuery(final user) {
    final range = getDateRangeForSelectedPeriod();
    return FirebaseFirestore.instance
        .collection('users')
        .doc(user.email)
        .collection('transactions')
        .where('dateTime', isGreaterThanOrEqualTo: range['start'])
        .where('dateTime', isLessThan: range['end'])
        .orderBy('dateTime', descending: true);
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Summary'),
        centerTitle: true,
        backgroundColor: Colors.white,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: getTransactionsQuery(user).snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text('No transactions found.'));
          }

          List<Map<String, dynamic>> transactions = snapshot.data!.docs.map((doc) {
            var data = doc.data() as Map<String, dynamic>;
            return {
              'id': doc.id,
              'category': data['category'],
              'description': data['description'],
              'amount': (data['amount'] as num).toDouble(),
              'dateTime': (data['dateTime'] as Timestamp).toDate(),
            };
          }).toList();

          Map<String, double> categoryData = {
            'Housing': 0,
            'Utilities': 0,
            'Food': 0,
            'Subscription': 0,
            'Groceries': 0,
            'Shopping': 0,
            'Healthcare': 0,
            'Transportation': 0,
            'Miscellaneous': 0,
          };

          for (var txn in transactions) {
            String category = txn['category'];
            double amount = txn['amount'];
            categoryData[category] = (categoryData[category] ?? 0) + amount;
          }

          return FutureBuilder<DocumentSnapshot>(
            future: FirebaseFirestore.instance.collection('users').doc(user!.email).get(),
            builder: (context, userSnapshot) {
              if (userSnapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }

              if (userSnapshot.hasError || !userSnapshot.hasData) {
                return const Center(child: Text('Error loading user data'));
              }

              final userData = userSnapshot.data!.data() as Map<String, dynamic>;
              final monthlyBudget = double.tryParse(userData['budget'].toString()) ?? 0.0;
              final barChartData = generateBarChartData(transactions, monthlyBudget, selectedTimePeriod);
              final sortedCategoryData = Map.fromEntries(
                categoryData.entries.toList()..sort((a, b) => b.value.compareTo(a.value)),
              );

              return SingleChildScrollView(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    ToggleButtons(
                      isSelected: timePeriods.map((period) => period == selectedTimePeriod).toList(),
                      onPressed: (index) {
                        setState(() {
                          selectedTimePeriod = timePeriods[index];
                        });
                      },
                      borderRadius: BorderRadius.circular(8),
                      selectedColor: Colors.black,
                      fillColor: const Color(0xffdda520),
                      children: timePeriods.map((period) => Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        child: Text(period),
                      )).toList(),
                    ),
                    const SizedBox(height: 16),
                    
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Checkbox(
                          value: state,
                          activeColor: Color(0xffdaa520),
                          onChanged: (bool? newValue) { // Corrected onChanged 
                            if (newValue != null) { // Handle null case
                              setState(() {
                                state = newValue; // Update state with the new value
                              });
                            }
                          },
                        ),
                        Align(
                          child: DropdownButton<String>(
                            dropdownColor: Colors.white,
                            value: selectedChartType,
                            items: ['Pie Chart', 'Bar Chart'].map((type) => DropdownMenuItem(
                              value: type,
                              child: Text(type),
                            )).toList(),
                            onChanged: (value) {
                              setState(() {
                                selectedChartType = value!;
                                if (selectedChartType == 'Pie Chart') {}
                                if (selectedChartType == 'Line Chart') showPercentages = false;
                              });
                            },
                            focusColor: Colors.white,
                          ),
                        )
                      ],
                    ),
                    const SizedBox(height: 16),
                    if (selectedChartType == 'Pie Chart') ...[
                      SizedBox(
                        height: 200,
                        child: PieChartWidget(
                          data: categoryData,
                          colors: categoryColors,
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          IconButton(
                            icon: Icon(
                              Icons.percent,
                              color: showPercentages ? const Color(0xffdaa520) : Colors.grey,
                            ),
                            onPressed: () {
                              setState(() {
                                showPercentages = !showPercentages;
                              });
                            },
                          ),
                        ],
                      ),
                    ] else
                      SizedBox(
                        height: 200,
                        child: BarChartWidget(data: barChartData),
                      ),
                    const SizedBox(height: 16),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        selectedChartType == 'Pie Chart' ? 'Categories' : 'Top Spending',
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Color.fromARGB(255, 0, 0, 0),
                        ),
                      ),
                    ),
                    selectedChartType == 'Pie Chart'
                      ? CategoryListWidget(
                          categories: sortedCategoryData,
                          colors: categoryColors,
                          showPercentages: showPercentages,
                        )
                      : TransactionListWidget(transactions: transactions),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
