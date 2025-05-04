import 'package:flutter/material.dart';
import 'dart:io';
import 'dart:convert'; 

class QuestCard extends StatelessWidget {
  final File? imageFile; // Local file for preview
  final String? imageBase64; // Base64 string from Firestore
  final String questName;
  final double savedAmount;
  final double targetAmount;
  final String timeLeft;
  final VoidCallback onTap;
  final Color backgroundColor;

  const QuestCard({
    super.key,
    this.imageFile,
    this.imageBase64,
    required this.questName,
    required this.savedAmount,
    required this.targetAmount,
    required this.timeLeft,
    required this.onTap,
    required this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(24),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(color: backgroundColor),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.grey[300],
              ),
              child: imageFile != null
                  ? ClipOval(
                      child: Image.file(
                        imageFile!,
                        fit: BoxFit.cover,
                        width: 40,
                        height: 40,
                      ),
                    )
                  : imageBase64 != null
                      ? ClipOval(
                          child: Image.memory(
                            base64Decode(imageBase64!),
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
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        questName,
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
                    value: targetAmount==0? savedAmount : savedAmount / targetAmount,
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