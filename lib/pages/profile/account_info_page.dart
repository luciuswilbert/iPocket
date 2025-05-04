import 'package:flutter/material.dart';
import 'account_info_edit_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


class AccountInfoPage extends StatefulWidget {
  const AccountInfoPage({Key? key}) : super(key: key);

  @override
  _AccountInfoPageState createState() => _AccountInfoPageState();
}

class _AccountInfoPageState extends State<AccountInfoPage> {

  Map<String, dynamic>? userProfile;
  bool isGoogle = false;
  bool isLoading = true;

  String userName = "Lucius Wilbert Tjoa";
  String userEmail = "luciuswilbert@gmail.com";
  String userPhone = "+60 1112706927";
  String userDOB = "28/05/2025";
  String userPassword = "mySecret123"; // Default password (will be hidden)
  String userCountry = "Malaysia";

  bool _isPasswordVisible = false; // Toggle password visibility

  @override
  void initState() {
    super.initState();
    final user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      isGoogle = user.providerData.first.providerId == "google.com";

      FirebaseFirestore.instance
          .collection('users')
          .doc(user.email)
          .get()
          .then((doc) {
            if (doc.exists) {
              setState(() {
                userProfile = doc.data();
                isLoading = false;
              });
            }
          });
    }
  }


  @override
  Widget build(BuildContext context) {
    if (isLoading || userProfile == null) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xffDAA520), // Goldenrod color
        automaticallyImplyLeading: false,
        title: Stack(
          alignment: Alignment.center,
          children: [
            const Center(
              child: Text(
                "Account Info",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.black),
                onPressed: () => Navigator.pop(context),
              ),
            ),
          ],
        ),
      ),

      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 50,
              backgroundColor: const Color(0xffDAA520),
              backgroundImage: (userProfile?['profileImageUrl'] != null && userProfile!['profileImageUrl'].isNotEmpty)
                  ? NetworkImage(userProfile!['profileImageUrl'])
                  : null,
              child: (userProfile?['profileImageUrl'] == null || userProfile!['profileImageUrl'].isEmpty)
                  ? const Icon(Icons.person, size: 40, color: Colors.white)
                  : null,
            ),
            const SizedBox(height: 16),
            _buildInfoRow("Full Name", userProfile!['fullName'] ?? ''),
            _buildInfoRow("Email", userProfile!['email']),
            _buildInfoRow("Phone Number", userProfile!['phone']),
            _buildInfoRow("Date of Birth", userProfile!['dob']),
            isGoogle
              ? _buildInfoRow("Password", "Signed in with Google")
              : _buildPasswordRow("Password", userProfile!['password'] ?? ""),
            _buildInfoRow("Country", userProfile!['country']),

            const SizedBox(height: 24),
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xffDAA520), // Goldenrod color
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 12,
                ),
              ),
              icon: const Icon(Icons.edit, color: Colors.white),
              label: const Text(
                "Edit Info",
                style: TextStyle(color: Colors.white),
              ),
              onPressed: () async {
                final user = FirebaseAuth.instance.currentUser;
                if (user == null) return;

                try {
                  final doc = await FirebaseFirestore.instance
                      .collection("users")
                      .doc(user.email)
                      .get();

                  final userData = doc.data();

                  if (userData != null) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => AccountInfoEditPage(
                          initialData: userData,
                        ),
                      ),
                    ).then((_) {
                      // ✅ Re-fetch data after returning from edit page
                      setState(() {
                        isLoading = true;
                      });
                      FirebaseFirestore.instance
                          .collection('users')
                          .doc(user.email)
                          .get()
                          .then((doc) {
                            if (doc.exists) {
                              setState(() {
                                userProfile = doc.data();
                                isLoading = false;
                              });
                            }
                          });
                    });
                  } else {
                    print("❌ No user data found");
                  }
                } catch (e) {
                  print("❌ Error fetching user data: $e");
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
          Text(value, style: const TextStyle(color: Colors.grey)),
        ],
      ),
    );
  }

  Widget _buildPasswordRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 0.1),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
          Row(
            children: [
              Text(
                _isPasswordVisible ? value : "••••••••", // Hide/show password
                style: const TextStyle(color: Colors.grey),
              ),
              const SizedBox(width: 6),
              IconButton(
                icon: Icon(
                  _isPasswordVisible ? Icons.visibility : Icons.visibility_off,
                  color: Colors.black54,
                ),
                onPressed: () {
                  setState(() {
                    _isPasswordVisible = !_isPasswordVisible;
                  });
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
