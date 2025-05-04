import 'package:flutter/material.dart';
import 'dart:convert'; // For base64 decoding

void showDetailsDialog(
  BuildContext context, {
  required String? imageBase64,
  required String questName,
  required double savedAmount,
  required double targetAmount,
  required String timeLeft,
  required DateTime startDate,
  required Function(double) onAddToQuest,
  required VoidCallback onDeleteQuest,
}) {
  final double percentage = (savedAmount / targetAmount) * 100;
  final double remainingAmount = targetAmount - savedAmount;
  final int daysLeft = int.parse(timeLeft.split(' ')[0]);
  final double dailySavingsNeeded = daysLeft > 0 ? remainingAmount / daysLeft : remainingAmount;

  String motivationalMessage;
  if (percentage < 25) {
    motivationalMessage = "You’re just getting started. Keep going!";
  } else if (percentage < 50) {
    motivationalMessage = "Nice progress! You’re on your way!";
  } else if (percentage < 75) {
    motivationalMessage = "Halfway there. Amazing job!";
  } else {
    motivationalMessage = "Almost there. Finish strong!";
  }

  double amountToAdd = 0.0;

  showDialog(
    context: context,
    builder: (context) {
      return StatefulBuilder(
        builder: (context, setState) {
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
                        child: imageBase64 != null
                            ? ClipOval(
                                child: Image.memory(
                                  base64Decode(imageBase64),
                                  fit: BoxFit.cover,
                                  width: 40,
                                  height: 40,
                                  errorBuilder: (context, error, stackTrace) => const Icon(
                                    Icons.image,
                                    size: 24,
                                    color: Colors.grey,
                                  ),
                                ),
                              )
                            : const Icon(
                                Icons.image,
                                size: 24,
                                color: Colors.grey,
                              ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Text(
                          questName,
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
                        '${savedAmount.toStringAsFixed(2)} / ${targetAmount.toStringAsFixed(2)} RM',
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
                    value: savedAmount / targetAmount,
                    backgroundColor: Colors.grey[300],
                    valueColor: const AlwaysStoppedAnimation<Color>(Color(0xffdaa520)),
                    minHeight: 8,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '${percentage.toStringAsFixed(2)}% complete',
                    style: const TextStyle(fontSize: 14, color: Colors.black54),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Started: ${startDate.day}/${startDate.month}/${startDate.year}',
                    style: const TextStyle(fontSize: 14, color: Colors.black54),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Time Left: $timeLeft',
                    style: const TextStyle(fontSize: 14, color: Colors.black54),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Save ${dailySavingsNeeded.toStringAsFixed(2)} RM/day to stay on track',
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
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Amount to Add:',
                        style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        '${amountToAdd.toStringAsFixed(2)} RM',
                        style: const TextStyle(fontSize: 14, color: Colors.black87),
                      ),
                    ],
                  ),
                  Slider(
                    value: amountToAdd,
                    min: 0.0,
                    max: remainingAmount > 0 ? remainingAmount : 1.0,
                    divisions: 100,
                    label: amountToAdd.toStringAsFixed(2),
                    activeColor: Color(0xffdaa520),
                    inactiveColor: Colors.grey[300],
                    onChanged: (value) {
                      setState(() {
                        amountToAdd = value;
                      });
                    },
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Row(
                        children: [
                          IconButton(
                            icon: const Icon(Icons.delete, color: Colors.red),
                            onPressed: () {
                              showDialog(
                                context: context,
                                builder: (context) => AlertDialog(
                                  backgroundColor: Colors.white,
                                  title: const Text('Delete Quest'),
                                  content: const Text('Are you sure you want to delete this quest?'),
                                  actions: [
                                    TextButton(
                                      onPressed: () => Navigator.pop(context),
                                      child: const Text('Cancel',style: TextStyle(color: Colors.black)),
                                    ),
                                    TextButton(
                                      onPressed: () {
                                        onDeleteQuest();
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
                      ElevatedButton(
                        onPressed: () {
                          if (amountToAdd > 0) {
                            onAddToQuest(amountToAdd);
                            Navigator.of(context).pop();
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Please select an amount greater than 0.'),
                              ),
                            );
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          foregroundColor: Colors.white,
                          backgroundColor: const Color(0xffdaa520),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                        child: const Text('Add to quest'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      );
    },
  );
}