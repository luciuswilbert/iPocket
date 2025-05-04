import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Get the current logged-in user
    final User? user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      appBar: AppBar(title: const Text("Profile")),
      body: Center(
        child: user == null
            ? const Text("No user logged in")
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Display user profile picture
                  CircleAvatar(
                    radius: 50,
                    backgroundImage: user.photoURL != null
                        ? NetworkImage(user.photoURL!)
                        : const AssetImage("assets/images/default_avatar.png") as ImageProvider,
                  ),
                  const SizedBox(height: 10),

                  // Display user name
                  Text(
                    user.displayName ?? "No Name",
                    style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  
                  // Display user email
                  Text(
                    user.email ?? "No Email",
                    style: const TextStyle(fontSize: 16, color: Colors.grey),
                  ),

                  const SizedBox(height: 20),

                  // Logout Button
                  ElevatedButton(
                    onPressed: () async {
                      // await FirebaseAuth.instance.signOut();
                      // Navigator.pushReplacementNamed(context, "/login");
                      
                    },
                    child: const Text("Logout"),
                  ),
                ],
              ),
      ),
    );
  }
}
