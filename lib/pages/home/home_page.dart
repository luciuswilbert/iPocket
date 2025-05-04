import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:iPocket/pages/home/tips_and_tricks_page.dart';
import 'package:iPocket/widgets/curved_bottom_container.dart';
import 'package:iPocket/widgets/custom_notification.dart';
import 'package:iPocket/widgets/segmentation_card.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Map<String, dynamic>? userProfile;
  bool isLoading = true;
  String _selectedCurrency = "USD";

  final TextEditingController _expenseBudgetController = TextEditingController(
    text: "1000",
  );

  String _getGreeting() {
    final hour = DateTime.now().hour; // Get the current hour (0-23)
    if (hour < 10) {
      return 'Good Morning,';
    } else if (hour < 15) {
      return 'Good Afternoon,';
    } else if (hour < 19) {
      return 'Good Evening,';
    } else {
      return 'Good Night,';
    }
  }

  void _loadUserSettings() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final doc =
          await FirebaseFirestore.instance
              .collection('users')
              .doc(user.email)
              .get();
      if (doc.exists) {
        final data = doc.data();
        setState(() {
          _selectedCurrency = data!['currency'];

          // Convert the budget (if it's a number) to string before setting it
          var budget = data['budget'];
          _expenseBudgetController.text =
              (budget != null)
                  ? budget.toString()
                  : _expenseBudgetController.text;
        });
      }
    }
  }

  @override
  void initState() {
    super.initState();
    _fetchUserData(); // Initial fetch
    _loadUserSettings(); // Load user settings
  }

  // ✅ Reusable method to fetch user data
  void _fetchUserData() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final doc =
          await FirebaseFirestore.instance
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

  @override
  Widget build(BuildContext context) {
    final String greeting = _getGreeting();
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        // ✅ Ensures full page is scrollable
        child: Column(
          children: [
            Stack(
              children: [
                /// ✅ Yellow Curved Background
                const CurvedBottomContainer(height: 240),

                /// ✅ Notification Button
                const NotificationButton(),

                /// ✅ Greeting Text
                Positioned(
                  top: 50,
                  left: 16,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        greeting,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: Colors.black,
                        ),
                      ),

                      Text(
                        userProfile?['fullName'] ?? '',
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                ),

                /// ✅ Total Balance
                Positioned(
                  top: 140,
                  left: 0,
                  right: 0,
                  child: Column(
                    children: [
                      const Text(
                        'Total Balance',
                        style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        _selectedCurrency +
                            " " +
                            (userProfile?['budget']?.toString() ?? ''),
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20),

            const SegmentationCard(),

            const SizedBox(height: 20),
            Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(30, 0, 16, 5),
                child: Text(
                  "Features",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ),
            ),

            /// ✅ Feature Cards (OCR, Chatbot, etc.)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),

              child: Wrap(
                spacing: 16,
                runSpacing: 16,
                children: [
                  _buildFeatureCard(Icons.receipt_long, "iScan", () {
                    Navigator.pushNamed(context, '/ocr');
                  }),
                  _buildFeatureCard(Icons.chat, "iBot", () {
                    Navigator.pushNamed(context, '/chatbot');
                  }),
                  _buildFeatureCard(Icons.mic, "iSpeak", () {
                    Navigator.pushNamed(context, '/voice-assistant');
                  }),
                  _buildFeatureCard(Icons.summarize, "Tips & Tricks", () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const TipsAndTricksPage(),
                      ),
                    );
                  }),
                  _buildFeatureCard(Icons.star_border, "iQuests", () {
                    Navigator.pushNamed(context, '/quests');
                  }),
                  // _buildFeatureCard(Icons.home, "iHome", () {
                  //   Navigator.pushNamed(context, "/iHome");
                  // }),
                  _buildFeatureCard(Icons.monetization_on_sharp, "iLoan", () {
                    Navigator.pushNamed(context, '/iLoan');
                  }),
                  _buildFeatureCard(Icons.home, "iHome", () {
                    Navigator.pushNamed(context, '/iHome');
                  }),
                ],
              ),
            ),

            const SizedBox(height: 120), // Padding at bottom
          ],
        ),
      ),
    );
  }

  /// ✅ Reusable Feature Card
  Widget _buildFeatureCard(IconData icon, String label, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: MediaQuery.of(context).size.width * 0.4,
        height: 100,
        decoration: BoxDecoration(
          color: const Color(0xFFFAF3E0),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              blurRadius: 4,
              offset: const Offset(2, 2),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 30, color: const Color(0xffDAA520)),
            const SizedBox(height: 8),
            Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }
}
