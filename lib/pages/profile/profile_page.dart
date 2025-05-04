import 'package:flutter/material.dart';
import 'package:iPocket/pages/Onboard/onboard.dart';
import 'package:iPocket/pages/profile/settings_page.dart';
import 'package:iPocket/widgets/curved_bottom_container.dart';
import 'package:iPocket/widgets/custom_notification.dart';
import 'package:iPocket/widgets/logout_dialog.dart';
import 'account_info_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  Map<String, dynamic>? userProfile;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchUserData(); // Initial fetch
  }

  // ✅ Reusable method to fetch user data
  void _fetchUserData() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final doc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.email)
          .get();

      if (doc.exists) {
        setState(() {
          userProfile = doc.data();
          isLoading = false;
        });
      }
    }
  }

  void _showLogoutDialog() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return LogoutDialog(
          onConfirm: () async {
            // ✅ Sign out from Firebase
            await FirebaseAuth.instance.signOut();

            // ✅ Remove all previous routes and go to Onboarding
            Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(builder: (context) => const OnboardingScreen()),
              (Route<dynamic> route) => false,
            );
          },
        );
      },
    );
  }


  @override
  Widget build(BuildContext context) {
    if (isLoading || userProfile == null) {
      return const Scaffold(
        backgroundColor: Colors.white,
        body: Center(child: CircularProgressIndicator(
          color: Color(0xffdaa520),)),
      );
    }

    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          _buildHeader(),
          const SizedBox(height: 120),
          _buildProfileOptions(),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    final String userName = userProfile!['fullName'] ?? '';
    final String userEmail = userProfile!['email'];
    final String? imageUrl = userProfile?['profileImageUrl'];

    return Stack(
      clipBehavior: Clip.none,
      alignment: Alignment.center,
      children: [
        CurvedBottomContainer(height: 200, child: const SizedBox()),

        Positioned(
          top: 60,
          child: const Text(
            "Profile",
            style: TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
        ),

        Positioned(
          top: 140,
          child: Column(
            children: [
              CircleAvatar(
                radius: 50,
                backgroundColor: const Color(0xffDAA520),
                backgroundImage: (imageUrl != null && imageUrl.isNotEmpty)
                    ? NetworkImage(imageUrl)
                    : null,
                child: (imageUrl == null || imageUrl.isEmpty)
                    ? const Icon(Icons.person, size: 40, color: Colors.white)
                    : null,
              ),
              const SizedBox(height: 12),
              Text(
                userName,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                userEmail,
                style: const TextStyle(fontSize: 14, color: Colors.grey),
              ),
            ],
          ),
        ),
        const NotificationButton(),
      ],
    );
  }

  Widget _buildProfileOptions() {
    return Column(
      children: [
        _buildOption(Icons.person, "Account Info"),
        _buildOption(Icons.settings, "Settings"),
        _buildOption(Icons.delete, "Clear Cache"),
        _buildOption(Icons.logout, "Log Out"),
      ],
    );
  }

  Widget _buildOption(IconData icon, String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 3),
      child: Card(
        elevation: 1.5,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        color: const Color(0xFFFAF3E0),
        child: ListTile(
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 20, vertical: 2),
          leading: Icon(icon, color: const Color(0xFFB8860B)),
          title: Text(
            title,
            style: const TextStyle(
              fontSize: 14,
              color: Colors.black,
              fontWeight: FontWeight.bold,
            ),
          ),
          trailing: const Icon(
            Icons.arrow_forward_ios,
            size: 16,
            color: Color(0xFFB8860B),
          ),
          onTap: () async {
            if (title == "Account Info") {
              await Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const AccountInfoPage()),
              );
              _fetchUserData(); // 🔁 Re-fetch on return
            } else if (title == "Settings") {
              await Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const SettingsPage()),
              );
              _fetchUserData(); // 🔁 Optional
            } else if (title == "Log Out") {
              _showLogoutDialog();
            }
          },
        ),
      ),
    );
  }
}
