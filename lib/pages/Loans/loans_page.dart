import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:iPocket/main.dart';
import 'package:iPocket/pages/Loans/create_loan_page.dart';
import 'package:iPocket/pages/Loans/loan_card.dart';
import 'package:iPocket/pages/Loans/loan_details.dart';
import 'package:iPocket/pages/transaction/rounded_rect_clipper.dart';

class ILoanPage extends StatefulWidget {
  const ILoanPage({Key? key}) : super(key: key);

  @override
  ILoanPageState createState() => ILoanPageState();
}



class ILoanPageState extends State<ILoanPage> {
  final user = FirebaseAuth.instance.currentUser;


  String _calculateTimeLeft(DateTime startDate, int loanTermMonths) {

    final DateTime estimatedPayoffDate = startDate.add(Duration(days: loanTermMonths * 30));
    final int remainingMonths = ((estimatedPayoffDate.year - DateTime.now().year) * 12 +
          estimatedPayoffDate.month - DateTime.now().month)
      .clamp(0, double.infinity)
      .toInt();
    return remainingMonths > 0 ? '$remainingMonths months left' : 'Expired';
  }

  Future<void> updateBudget(double txAmount) async {
    if (user == null) {
      print("Error: User is not logged in. Cannot update budget.");
      return;
    }
    final doc = await FirebaseFirestore.instance
        .collection('users')
        .doc(user!.email)
        .get();
    try {
      final data = doc.data();
      final double currentBudget = double.parse(data!['budget']);
      final double newBudget = currentBudget - txAmount;
      await FirebaseFirestore.instance
          .collection('users')
          .doc(user!.email)
          .update({'budget': newBudget.toString()});
      print("Budget successfully updated for ${user!.email} to $newBudget");
    } catch (e) {
      print("Failed to update budget for ${user!.email}: $e");
    }
  }

  Future<void> _processAutomaticDeduction(Map<String, dynamic> loan) async {
    final now = DateTime.now();
    final DateTime lastDeductionDate = (loan['lastDeductionDate'] as Timestamp).toDate();
    final int monthsSinceLastDeduction =
        (now.year - lastDeductionDate.year) * 12 + now.month - lastDeductionDate.month;

    if (monthsSinceLastDeduction >= 1) {
      final double remainingBalance = loan['targetAmount'] - loan['paidAmount'];
      final DateTime estimatedPayoffDate = loan['startDate'].add(Duration(days: loan['loanTermMonths'] * 30));
      final int remainingMonths = ((estimatedPayoffDate.year - now.year) * 12 +
              estimatedPayoffDate.month - now.month)
          .clamp(0, double.infinity)
          .toInt();
      final double monthlyPayment = remainingMonths > 0 ? remainingBalance / remainingMonths : remainingBalance;

      if (remainingBalance > 0 && monthlyPayment > 0) {
        double paymentAmount = monthlyPayment.clamp(0, remainingBalance);
        await FirebaseFirestore.instance
            .collection('users')
            .doc(user!.email)
            .collection('loans')
            .doc(loan['id'])
            .update({
          'paidAmount': loan['paidAmount'] + paymentAmount,
          'lastDeductionDate': Timestamp.fromDate(now),
        });
        await updateBudget(paymentAmount);
        print('Deducted $paymentAmount for loan ${loan['loanName']}');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (user == null) {
      return Scaffold(
        body: Center(child: Text('Please log in to view loans.')),
      );
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => MainScreen()),
              (Route<dynamic> route) => false,
            );
          },
        ),
        centerTitle: true,
        title: const Text(
          'Current Loans',
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
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('users')
            .doc(user!.email)
            .collection('loans')
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text('No Loans found.'));
          }

          final loans = snapshot.data!.docs.map((doc) {
            var data = doc.data() as Map<String, dynamic>;
            DateTime startDate = (data['startDate'] as Timestamp).toDate();
            int loanTermMonths = data['loanTerm'];
            double paidAmount = (data['paidAmount'] ?? 0.0).toDouble();
            DateTime lastDeductionDate = (data['lastDeductionDate'] as Timestamp?)?.toDate() ?? startDate;
            return {
              'id': doc.id,
              'loanName': data['loanName'],
              'loanType': LoanType.values.firstWhere(
                (e) => e.toString().split('.').last == data['loanType'],
                orElse: () => LoanType.other,
              ),
              'paidAmount': paidAmount,
              'targetAmount': (data['loanAmount'] as num).toDouble(),
              'timeLeft': _calculateTimeLeft(startDate, loanTermMonths),
              'lenderName': data['lenderName'],
              'apr': data['APR'],
              'aprType': data['APRType'],
              'compoundInterest': data['compoundInterest'],
              'startDate': startDate,
              'loanTermMonths': loanTermMonths,
              'lastDeductionDate': lastDeductionDate,
            };
          }).toList();

          // Process automatic deductions for each loan
          for (var loan in loans) {
            _processAutomaticDeduction(loan);
          }

          return ListView.builder(
            padding: const EdgeInsets.all(8.0),
            itemCount: loans.length,
            itemBuilder: (context, index) {
              final loan = loans[index];
              return Container(
                margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                child: ClipPath(
                  clipper: RoundedRectClipper(radius: 24.0),
                  child: LoanCard(
                    LoanName: loan['loanName'],
                    loanType: loan['loanType'],
                    paidAmount: loan['paidAmount'],
                    targetAmount: loan['targetAmount'],
                    timeLeft: loan['timeLeft'],
                    onTap: () {
                      showLoanDetailsDialog(
                        context,
                        loanName: loan['loanName'],
                        loanType: loan['loanType'].toString().split('.').last,
                        lenderName: loan['lenderName'],
                        loanAmount: loan['targetAmount'],
                        apr: loan['apr'],
                        aprType: loan['aprType'],
                        compoundInterest: loan['compoundInterest'],
                        startDate: loan['startDate'],
                        loanTermMonths: loan['loanTermMonths'],
                        amountPaid: loan['paidAmount'],
                        onDeleteLoan: () async {
                          await FirebaseFirestore.instance
                              .collection('users')
                              .doc(user!.email)
                              .collection('loans')
                              .doc(loan['id'])
                              .delete();
                          print('Deleted loan');
                        },
                      );
                    },
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xffDAA520),
        shape: const CircleBorder(),
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) => AddLoanPage()));
        },
        child: Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}