import 'package:flutter/material.dart';

/// A reusable widget for the logout confirmation bottom sheet.
class LogoutDialog extends StatelessWidget {
  final VoidCallback onConfirm; // Callback when user confirms logout

  const LogoutDialog({super.key, required this.onConfirm});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        color: Colors.white,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            "Logout?",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            "Are you sure you want to logout?",
            style: TextStyle(fontSize: 14, color: Colors.grey),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              /// ❌ "No" Button (Cancel)
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  side: const BorderSide(color: Color(0xFFDAA520)),
                ),
                onPressed: () => Navigator.pop(context),
                child: const Text(
                  "No",
                  style: TextStyle(color: Color(0xFFDAA520)),
                ),
              ),

              /// ✅ "Yes" Button (Confirm Logout)
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFDAA520),
                ),
                onPressed: () {
                  Navigator.pop(context); // Close the dialog
                  onConfirm(); // Call the confirm callback
                },
                child: const Text(
                  "Yes",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
