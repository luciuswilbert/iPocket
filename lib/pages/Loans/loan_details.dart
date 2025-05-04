import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

void showLoanDetailsDialog(
  BuildContext context, {
  required String loanName,
  required String loanType,
  required String lenderName,
  required double loanAmount,
  required double apr,
  required String aprType,
  required String? compoundInterest,
  required DateTime startDate,
  required int loanTermMonths,
  required double amountPaid,
  required VoidCallback onDeleteLoan,
}) {
  final double remainingBalance = loanAmount - amountPaid;
  final double percentagePaid = (amountPaid / loanAmount) * 100;
  final DateTime estimatedPayoffDate = startDate.add(Duration(days: loanTermMonths * 30));
  final double totalInterest = calculateTotalInterest(loanAmount, apr, loanTermMonths);
  final int remainingMonths = ((estimatedPayoffDate.year - DateTime.now().year) * 12 +
          estimatedPayoffDate.month - DateTime.now().month)
      .clamp(0, double.infinity)
      .toInt();
  final double monthlyPaymentNeeded = remainingMonths > 0 ? remainingBalance / remainingMonths : remainingBalance;

  String motivationalMessage;
  if (percentagePaid < 25) {
    motivationalMessage = "You're just getting started. Keep going!";
  } else if (percentagePaid < 50) {
    motivationalMessage = "Nice progress! You're on your way!";
  } else if (percentagePaid < 75) {
    motivationalMessage = "Halfway there. Amazing job!";
  } else {
    motivationalMessage = "Almost there. Finish strong!";
  }

  showDialog(
    context: context,
    builder: (context) {
      return Dialog(
        backgroundColor: const Color(0xffE8E8E8),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        child: Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.grey[300],
                    ),
                    child: const Icon(
                      Icons.account_balance,
                      size: 24,
                      color: Colors.grey,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Text(
                      loanName,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Text(
                'Loan Type: $loanType',
                style: const TextStyle(fontSize: 14, color: Colors.black54),
              ),
              Text(
                'Lender: $lenderName',
                style: const TextStyle(fontSize: 14, color: Colors.black54),
              ),
              Text(
                'APR: ${apr.toStringAsFixed(2)}% ($aprType)',
                style: const TextStyle(fontSize: 14, color: Colors.black54),
              ),
              if (compoundInterest != null)
                Text(
                  'Compound Interest: $compoundInterest',
                  style: const TextStyle(fontSize: 14, color: Colors.black54),
                ),
              Text(
                'Start Date: ${DateFormat('dd/MM/yyyy').format(startDate)}',
                style: const TextStyle(fontSize: 14, color: Colors.black54),
              ),
              Text(
                'Loan Term: $loanTermMonths months',
                style: const TextStyle(fontSize: 14, color: Colors.black54),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  const Text(
                    'Progress: ',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: Colors.black,
                    ),
                  ),
                  Text(
                    '${amountPaid.toStringAsFixed(2)} / ${loanAmount.toStringAsFixed(2)} RM',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: Colors.green,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              LinearProgressIndicator(
                value: amountPaid / loanAmount,
                backgroundColor: Colors.grey[300],
                valueColor: const AlwaysStoppedAnimation<Color>(Color(0xffdaa520)),
                minHeight: 8,
              ),
              const SizedBox(height: 8),
              Text(
                '${percentagePaid.toStringAsFixed(2)}% repaid',
                style: const TextStyle(fontSize: 14, color: Colors.black54),
              ),
              Text(
                'Remaining Balance: ${remainingBalance.toStringAsFixed(2)} RM',
                style: const TextStyle(fontSize: 14, color: Colors.black54),
              ),
              Text(
                'Total Interest: ${totalInterest.toStringAsFixed(2)} RM',
                style: const TextStyle(fontSize: 14, color: Colors.black54),
              ),
              Text(
                'Estimated Payoff Date: ${DateFormat('dd/MM/yyyy').format(estimatedPayoffDate)}',
                style: const TextStyle(fontSize: 14, color: Colors.black54),
              ),
              Text(
                'Pay ${monthlyPaymentNeeded.toStringAsFixed(2)} RM/month to stay on track',
                style: const TextStyle(fontSize: 14, color: Colors.black54),
              ),
              const SizedBox(height: 16),
              Text(
                motivationalMessage,
                style: const TextStyle(
                  fontSize: 16,
                  fontStyle: FontStyle.italic,
                  color: Color(0xffdaa520),
                ),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          backgroundColor: Colors.white,
                          title: const Text('Delete Loan'),
                          content: const Text('Are you sure you want to delete this loan?'),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(context),
                              child: const Text('Cancel', style: TextStyle(color: Colors.black)),
                            ),
                            TextButton(
                              onPressed: () {
                                onDeleteLoan();
                                Navigator.pop(context);
                                Navigator.pop(context);
                              },
                              child: const Text('Delete', style: TextStyle(color: Colors.red)),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    },
  );
}

double calculateTotalInterest(double loanAmount, double apr, int loanTermMonths) {
  // Simple interest calculation as a placeholder
  return loanAmount * (apr / 100) * (loanTermMonths / 12);
}