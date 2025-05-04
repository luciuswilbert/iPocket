import 'package:flutter/material.dart';
import 'dart:io';
import 'dart:convert'; 

enum LoanType {
  personal,
  car,
  education,
  home,
  business,
  other,
}


Icon getLoanTypeIcon(LoanType loanType) {
  switch (loanType) {
    case LoanType.personal:
      return const Icon(Icons.person_4_rounded); // Or any other personal loan icon
    case LoanType.car:
      return const Icon(Icons.directions_car);
    case LoanType.education:
      return const Icon(Icons.school);
    case LoanType.home:
      return const Icon(Icons.home);
    case LoanType.business:
      return const Icon(Icons.business);
    case LoanType.other:
      return const Icon(Icons.more_horiz); // Or a generic icon
  }
}

class LoanCard extends StatelessWidget {
  final String LoanName;
  final LoanType loanType;
  final double paidAmount;
  final double targetAmount;
  final String timeLeft;
  final VoidCallback onTap;

  const LoanCard({
    super.key,
    required this.LoanName,
    required this.loanType,
    required this.paidAmount,
    required this.targetAmount,
    required this.timeLeft,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(24),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24), // Add border radius here too for the container
          border: Border.all(
            color: Color(0XFFDAA520), // Choose your border color
            width: 2.5, // Choose your border width
          ),
        ),
        child: Row(
          children: [
            getLoanTypeIcon(loanType),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        LoanName,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: Colors.black87,
                        ),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      ),
                      Text(
                        targetAmount.toString(),
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: Colors.black87,
                        ),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  LinearProgressIndicator(
                    borderRadius: BorderRadius.circular(100),
                    value: targetAmount==0? paidAmount : paidAmount / targetAmount,
                    backgroundColor: Colors.grey[300],
                    valueColor: const AlwaysStoppedAnimation<Color>(Color(0xffdaa520)),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    timeLeft,
                    style: const TextStyle(fontSize: 14, color: Color.fromARGB(255, 185, 185, 185)),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}