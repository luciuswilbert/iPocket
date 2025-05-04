import 'package:flutter/material.dart';

class SavingProfileScreen extends StatelessWidget {
  const SavingProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Future.delayed(const Duration(seconds: 1), () {
      Navigator.pushReplacementNamed(context, "/profile-success");
    });

    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            CircularProgressIndicator(color: Color(0xffDAA520)),
            SizedBox(height: 20),
            Text(
              "Please hang on,\nwe are saving your profile...",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
            ),
          ],
        ),
      ),
    );
  }
}
