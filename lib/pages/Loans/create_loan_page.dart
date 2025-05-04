import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:iPocket/pages/Loans/loan_card.dart';
import 'package:intl/intl.dart';


class AddLoanPage extends StatefulWidget {
  @override
  _AddLoanPageState createState() => _AddLoanPageState();
}

class _AddLoanPageState extends State<AddLoanPage> {
  final _loanNameController = TextEditingController();
  final _targetAmountController = TextEditingController();
  final _lenderNameController = TextEditingController();
  final _loanTermController = TextEditingController();
  final _APRController = TextEditingController();
  final _compoundInterestController = TextEditingController();
  final _startDateController = TextEditingController();
  DateTime? _selectedStartDate;
  String? _selectedAPRType = 'Fixed';
  LoanType? _selectedLoanType = LoanType.personal;
  final _formKey = GlobalKey<FormState>();
  final user = FirebaseAuth.instance.currentUser;

  Future<void> _pickStartDate(BuildContext context) async {
    final DateTime now = DateTime.now();
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: now,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            scaffoldBackgroundColor: Colors.white,
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

    if (picked != null) {
      setState(() {
        _selectedStartDate = picked;
        _startDateController.text = DateFormat('dd/MM/yyyy').format(picked);
      });
    }
  }

  Future<void> _addLoan() async {
    if (_formKey.currentState!.validate()) {
      try {
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) => Center(child: CircularProgressIndicator()),
        );

        Map<String, dynamic> data = {
          'loanName': _loanNameController.text,
          'loanAmount': double.parse(_targetAmountController.text),
          'lenderName': _lenderNameController.text,
          'loanTerm': int.parse(_loanTermController.text),
          'APR': double.parse(_APRController.text),
          'APRType': _selectedAPRType!,
          'loanType': _selectedLoanType!.toString().split('.').last,
          'startDate': Timestamp.fromDate(_selectedStartDate!),
          'paidAmount': 0.0,
          'lastDeductionDate': Timestamp.fromDate(_selectedStartDate!), // Initialize with start date
        };

        if (_selectedAPRType == 'Variable') {
          data['compoundInterest'] = _compoundInterestController.text;
        }

        await FirebaseFirestore.instance
            .collection('users')
            .doc(user!.email)
            .collection('loans')
            .add(data);

        Navigator.pop(context); // Close loading dialog
        Navigator.pop(context); // Go back
      } catch (e) {
        Navigator.pop(context); // Close loading dialog
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to add loan: $e')),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please fill all fields correctly')),
      );
    }
  }

  @override
  void dispose() {
    _loanNameController.dispose();
    _targetAmountController.dispose();
    _lenderNameController.dispose();
    _loanTermController.dispose();
    _APRController.dispose();
    _compoundInterestController.dispose();
    _startDateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'Add Loan',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color(0xffF6E392),
                Color(0xffdaa520),
              ],
              begin: Alignment.topRight,
              end: Alignment.bottomLeft,
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                controller: _loanNameController,
                decoration: InputDecoration(
                  labelText: 'Loan Name',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a loan name';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              DropdownButtonFormField<LoanType>(
                decoration: InputDecoration(
                  labelText: 'Loan Type',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                value: _selectedLoanType,
                items: LoanType.values.map((LoanType type) {
                  return DropdownMenuItem<LoanType>(
                    value: type,
                    child: Text(type.toString().split('.').last),
                  );
                }).toList(),
                onChanged: (LoanType? newValue) {
                  setState(() {
                    _selectedLoanType = newValue;
                  });
                },
                validator: (value) {
                  if (value == null) {
                    return 'Please select a loan type';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: _targetAmountController,
                decoration: InputDecoration(
                  labelText: 'Loan Amount (RM)',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the loan amount';
                  }
                  if (double.tryParse(value) == null || double.parse(value) <= 0) {
                    return 'Please enter a valid positive number';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: _lenderNameController,
                decoration: InputDecoration(
                  labelText: 'Lender Name',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the lender name';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: _loanTermController,
                decoration: InputDecoration(
                  labelText: 'Loan Term (months)',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the loan term';
                  }
                  if (int.tryParse(value) == null || int.parse(value) <= 0) {
                    return 'Please enter a valid positive integer';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: _APRController,
                decoration: InputDecoration(
                  labelText: 'APR (%)',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the APR';
                  }
                  if (double.tryParse(value) == null) {
                    return 'Please enter a valid number';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              DropdownButtonFormField<String>(
                decoration: InputDecoration(
                  labelText: 'APR Type',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                value: _selectedAPRType,
                items: ['Fixed', 'Variable'].map((String type) {
                  return DropdownMenuItem<String>(
                    value: type,
                    child: Text(type),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    _selectedAPRType = newValue;
                  });
                },
                validator: (value) {
                  if (value == null) {
                    return 'Please select an APR type';
                  }
                  return null;
                },
              ),
              if (_selectedAPRType == 'Variable') ...[
                SizedBox(height: 16),
                TextFormField(
                  controller: _compoundInterestController,
                  decoration: InputDecoration(
                    labelText: 'Compound Interest',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  validator: (value) {
                    if (_selectedAPRType == 'Variable' && (value == null || value.isEmpty)) {
                      return 'Please enter the compound interest';
                    }
                    return null;
                  },
                ),
              ],
              SizedBox(height: 16),
              TextFormField(
                controller: _startDateController,
                readOnly: true,
                decoration: InputDecoration(
                  labelText: 'Start Date',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  suffixIcon: Icon(Icons.calendar_today),
                ),
                onTap: () => _pickStartDate(context),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please select a start date';
                  }
                  return null;
                },
              ),
              SizedBox(height: 30),
              ElevatedButton(
                onPressed: _addLoan,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xffDAA520),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: SizedBox(
                  width: double.infinity,
                  child: Center(
                    child: Text(
                      'Save Loan',
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}