import 'package:flutter/material.dart';
import 'package:iPocket/pages/Notification/notification_page.dart';

class NotificationButton extends StatelessWidget {
  const NotificationButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 50, 
      right: 16,
      child: GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const NotificationPage()),
          );
        },
        child: Container(
          padding: const EdgeInsets.all(10), // Adjust padding for better size
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.5), // ✅ Slightly transparent white
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1), // Soft shadow
                blurRadius: 1,
                spreadRadius: 1,
              ),
            ],
          ),
          child: const Icon(
            Icons.notifications,
            color: Colors.black,
          ),
        ),
      ),
    );
  }
}
