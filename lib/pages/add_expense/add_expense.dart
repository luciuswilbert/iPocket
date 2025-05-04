import 'dart:math';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:iPocket/main.dart';
import 'package:iPocket/utils/transaction_helpers.dart';
import 'package:iPocket/widgets/custom_three_dot_menu.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AddExpensePage extends StatefulWidget {
  final String? expenseCategory;
  final double? totalAmount;
  final String? description;
  final String? transactionId;

  const AddExpensePage({
    this.expenseCategory,
    this.totalAmount,
    this.description,
    this.transactionId,
    Key? key,
  }) : super(key: key);

  @override
  _AddExpensePageState createState() => _AddExpensePageState();
}

class _AddExpensePageState extends State<AddExpensePage> {
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  DateTime? _selectedDate;
  String? _selectedCategory;
  final user = FirebaseAuth.instance.currentUser;

  double totalSpending = 0.0;
  double userBudget = 0.0;
  bool isLoading = true;

  // Fetch user's budget and calculate total spending for the current month
  Future<void> _fetchUserBudgetAndTransactions(String? email) async {
    if (user != null) {
      try {
        // Fetch user profile to get the budget
        DocumentSnapshot userDoc = await FirebaseFirestore.instance.collection('users').doc(user!.email).get();
        if (userDoc.exists) {
          var userProfile = userDoc.data() as Map<String, dynamic>;
          userBudget = double.tryParse(userProfile['budget'].toString()) ?? 0.0;  // Get the budget
          
          // Get current month range (start and end date)
          DateTime now = DateTime.now();
          DateTime firstDayOfMonth = DateTime(now.year, now.month, 1);
          DateTime lastDayOfMonth = DateTime(now.year, now.month + 1, 0);
          
          // Fetch transactions for the current month
          QuerySnapshot transactionsSnapshot = await FirebaseFirestore.instance
              .collection('users')
              .doc(user!.email)
              .collection('transactions')
              .where('dateTime', isGreaterThanOrEqualTo: firstDayOfMonth)
              .where('dateTime', isLessThanOrEqualTo: lastDayOfMonth)
              .get();

          // Calculate total spending for the current month
          double total = 0.0;
          transactionsSnapshot.docs.forEach((doc) {
            var data = doc.data() as Map<String, dynamic>;
            total += data['amount'] ?? 0.0;
          });

          setState(() {
            totalSpending = total;
            isLoading = false;
          });
          print("Total Spending: $totalSpending, User Budget: $userBudget");

          // Compare the total spending with the user's budget
          double currentBudget = double.tryParse(userProfile?['budget']?.toString() ?? '0') ?? 0;
          if (currentBudget < 0) {
            _sendNotification(currentBudget);
          }


        }
      } catch (e) {
        setState(() {
          isLoading = false;
        });
        print('Error fetching user profile or transactions: $e');
      }
    }
  }


  // Trigger a notification if spending exceeds the budget
  void _sendNotification(double remainingBudget) async {
    print("Remaining Budget: $remainingBudget");
  
    FirebaseFirestore.instance
        .collection('users')
        .doc(user!.email)
        .collection('notifications')
        .add({
          'title': 'Budget Exceeded',
          'message': 'Your total spending for the month exceeds the budget!',
          'time': FieldValue.serverTimestamp(),
        });
  }

  void addOrUpdateTransaction(final user, Map<String, dynamic> transactionData, {String? transactionId}) async {
    bool success = false;
    try {
      if (transactionId == null) {
        await FirebaseFirestore.instance
            .collection('users')
            .doc(user.email)
            .collection('transactions')
            .add(transactionData);
        success = true; // Set to true on success
      } else {
        await FirebaseFirestore.instance
            .collection('users')
            .doc(user.email)
            .collection('transactions')
            .doc(transactionId)
            .update(transactionData);
        success = true; // Set to true on success
      }
    } catch (error) {
      success = false; // Set to false on error
      print('Error saving transaction: $error'); // Log the error
    }

    if (success) {
      //Only show the dialog when success is true.
      showExpenseAddedDialog(context);
    }
  }

  @override
  void initState() {
    super.initState();
    if (widget.transactionId != null) {
      _fetchTransactionData(widget.transactionId!);
    } else {
      if (widget.totalAmount != null) {
        _amountController.text = widget.totalAmount!.toStringAsFixed(2);
      }
      if (widget.description != null) {
        _descriptionController.text = widget.description!;
      }
      if (widget.expenseCategory != null) {
        _selectedCategory = widget.expenseCategory!;
      }
    }
  }

  void _fetchTransactionData(String transactionId) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final doc = await FirebaseFirestore.instance
        .collection('users')
        .doc(user.email)
        .collection('transactions')
        .doc(transactionId)
        .get();
      if (doc.exists) {
        final data = doc.data() as Map<String, dynamic>;
        setState(() {
         _selectedCategory = data['category'];
        _amountController.text = data['amount'].toStringAsFixed(2);
        _descriptionController.text = data['description'];
        _selectedDate = (data['dateTime'] as Timestamp).toDate();
        });
      }
    }
  }

  Future<void> updateBudget(double txAmount) async {
    if (user == null) {
      print("Error: User is not logged in. Cannot update budget.");
      // Depending on your app flow, you might want to throw an error
      // or handle this differently (e.g., navigate to login).
      return;
    }else {
      final doc =
          await FirebaseFirestore.instance
              .collection('users')
              .doc(user!.email)
              .get();
      try {
        final data = doc.data();
        final double currentBudget = double.parse(data!['budget']);
      

        final double newBudget = currentBudget - txAmount; // Result will be double
        final String formattedNewBudget = newBudget.toStringAsFixed(2); // Round to 2 decimal places


        await FirebaseFirestore.instance
                        .collection('users')
                        .doc(user!.email)
                        .update({
                          'budget': formattedNewBudget,
                        });

        print("Budget successfully updated for ${user!.email} to $formattedNewBudget"); // Optional: Log success


      } catch (e) {
        // Handle any errors during the transaction (network, permissions, thrown exceptions)
        print("Failed to update budget for ${user!.email}: $e");
        // Depending on requirements, you might want to:
        // - Show an error message to the user
        // - Log the error to a monitoring service
        // - Rethrow the error if needed: throw e;
      }
    }
  }

  void _pickDate() async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            dialogBackgroundColor: Colors.white,
            colorScheme: const ColorScheme.light(
              primary: Color(0xffDAA520),
              onPrimary: Colors.white,
              onSurface: Colors.black,
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: Colors.black,
              ),
            ),
          ),
          child: child!,
        );
      },
    );
    if (pickedDate != null) {
      setState(() {
        _selectedDate = pickedDate;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          'Add Expense',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
        ),
        backgroundColor: const Color(0xffDAA520),
        centerTitle: true,
        actions: [
          CustomThreeDotMenu(context: context),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildLabel('Category'),
              _buildDropdown(),
              const SizedBox(height: 12),
              _buildLabel('Amount'),
              _buildTextField(_amountController, TextInputType.number, prefixText: '\$'),
              const SizedBox(height: 12),
              _buildLabel('Date'),
              _buildDateField(),
              const SizedBox(height: 12),
              _buildLabel('Description'),
              _buildTextField(
                _descriptionController,
                TextInputType.text,
                maxLines: 3,
                hintText: 'Buying a Ramen',
              ),
              const SizedBox(height: 20),
              Center(
                child: ElevatedButton(
                  onPressed: () async {
                    if (_selectedCategory == null || _amountController.text.isEmpty || _selectedDate == null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("Please fill all required fields")),
                      );
                      return;
                    }else{updateBudget(double.tryParse(_amountController.text) as double);}

                    
                    
                    Map<String, dynamic> transactionData = {
                      'category': _selectedCategory!,
                      'description': _descriptionController.text,
                      'amount': double.parse(_amountController.text),
                      'dateTime': Timestamp.fromDate(_selectedDate!),
                      'color': getCategoryColor(_selectedCategory!).value,
                    };
                    final user = FirebaseAuth.instance.currentUser;
                    addOrUpdateTransaction(user, transactionData, transactionId: widget.transactionId); 

                    _fetchUserBudgetAndTransactions(user?.email); // Add this line here


                    // ✅ Save notification under user's 'notifications' collection (same level as transactions)
                    await FirebaseFirestore.instance
                        .collection('users')
                        .doc(user?.email)
                        .collection('notifications') // Same level as transactions
                        .add({
                          'title': "Expense Added",
                          'message': "You added \$${transactionData['amount']} for ${transactionData['category']}.",
                          'time': Timestamp.now(), // Stores the current time
                        });

                    print("Expense added & notification stored.");
                    //showExpenseAddedDialog(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xffDAA520),
                    padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    'Submit',
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Keep your existing _buildLabel, _buildDropdown, _buildTextField, and _buildDateField methods unchanged


  /// Reusable label widget
  Widget _buildLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Text(text, style: const TextStyle(fontWeight: FontWeight.bold)),
    );
  }

  /// Custom dropdown to prevent automatic scrolling and ensure consistent styling
  Widget _buildDropdown() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12), // Rounded corners
        border: Border.all(color: Colors.grey),
        color: Colors.white, // Ensures a white background
      ),
      child: PopupMenuButton<String>(
        color: Colors.white, // ✅ Ensures the dropdown background is white
        onSelected: (String value) {
          setState(() {
            _selectedCategory = value;
          });
        },
        itemBuilder:
            (BuildContext context) =>
                [
                  'Groceries',
                  'Subscription',
                  'Food',
                  'Shopping',
                  'Miscellaneous',
                  'Healthcare',
                  'Transportation',
                  'Utilities',
                  'Housing',
                ].map((String category) {
                  return PopupMenuItem<String>(
                    value: category,
                    child: Row(
                      children: [
                        Icon(
                          getCategoryIcon(category),
                          color: getCategoryColor(category),
                        ), // ✅ Icons shown
                        const SizedBox(width: 10),
                        Text(
                          category,
                          style: const TextStyle(
                            color: Colors.black,
                          ), // ✅ Ensures text visibility
                        ),
                      ],
                    ),
                  );
                }).toList(),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _selectedCategory == null
                  ? const Text(
                    'Select a category',
                    style: TextStyle(fontSize: 16, color: Colors.black),
                  )
                  : Row(
                    children: [
                      Icon(
                        getCategoryIcon(_selectedCategory!),
                        color: getCategoryColor(_selectedCategory!),
                      ), // ✅ Show selected icon
                      const SizedBox(width: 10),
                      Text(
                        _selectedCategory!,
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ), // ✅ Keeps selected text visible
                      ),
                    ],
                  ),
              const Icon(Icons.arrow_drop_down, color: Colors.black54),
            ],
          ),
        ),
      ),
    );
  }

  /// Reusable text field with optional prefix (e.g., "$" for amount) and hint text
  Widget _buildTextField(
    TextEditingController controller,
    TextInputType keyboardType, {
    int maxLines = 1,
    String? prefixText,
    String? hintText,
  }) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      maxLines: maxLines,
      decoration: InputDecoration(
        prefixIcon:
            prefixText != null
                ? Padding(
                  padding: const EdgeInsets.only(left: 12, right: 6),
                  child: Text(
                    prefixText,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                )
                : null,
        prefixIconConstraints: const BoxConstraints(minWidth: 0, minHeight: 0),
        hintText: hintText, // ✅ Placeholder text
        hintStyle: const TextStyle(
          color: Colors.grey,
        ), // ✅ Light grey text to match placeholder styling
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12), // Rounded corners
        ),
      ),
    );
  }

  /// Date picker field
  Widget _buildDateField() {
    return GestureDetector(
      onTap: _pickDate,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12), // Rounded corners
          border: Border.all(color: Colors.grey),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              _selectedDate == null
                  ? 'Select a date'
                  : DateFormat('dd/MM/yyyy').format(_selectedDate!),
              style: const TextStyle(color: Colors.black87),
            ),
            const Icon(Icons.calendar_today, color: Colors.black54),
          ],
        ),
      ),
    );
  }
}


void showExpenseAddedDialog(BuildContext context) {
  List<String> motivationalMessages = [
    "Great job! Every penny tracked counts!",
    "You're on your way to financial clarity!",
    "Keep it up! Your future self will thank you.",
    "Small steps lead to big savings!",
    "You're making progress! Stay consistent."
  ];

  final random = Random();
  final message = motivationalMessages[random.nextInt(motivationalMessages.length)];

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text("Expense Added!"),
        backgroundColor: Colors.white,
        content: Column(
          mainAxisSize: MainAxisSize.min, // Adjust to content size
          children: [
            //const Text("Your expense has been successfully added."),
            const SizedBox(height: 16),
            Text(
              message,
              style: const TextStyle(fontStyle: FontStyle.italic),
              textAlign: TextAlign.center,
            ),
          ],
        ),
        actions: <Widget>[
          TextButton(
            child: const Text("OK",style: TextStyle(color: Colors.green),),
            style: ButtonStyle(alignment: Alignment.center),
            onPressed: () {
              Navigator.push(context,MaterialPageRoute(builder: (context) => MainScreen()));
            },
          ),
        ],
      );
    },
  );
}

