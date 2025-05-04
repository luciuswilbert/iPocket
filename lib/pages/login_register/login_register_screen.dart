import 'package:carousel_slider/carousel_slider.dart';
import 'package:iPocket/pages/login_register/responsive_scroll.dart';
import 'package:iPocket/pages/login_register/sign_up_screen.dart';
import './login_screen.dart';
import 'package:flutter/material.dart';

const TextStyle titleStyle = TextStyle(
  fontSize: 32,
  fontWeight: FontWeight.bold,
);

const TextStyle descriptionStyle = TextStyle(
  fontSize: 16,
  color: Color(0xFF616161), // Equivalent to Colors.grey[700]
);

final List<Map<String, String>> _onboardingData = [
  {
    "image": "assets/images/money_hand.png",
    "title": "Gain total control of your money",
    "description": "Become your own money manager and make every cent count",
  },
  {
    "image": "assets/images/money_paper.png",
    "title": "Know where your money goes",
    "description":
        "Track your transaction easily, with categories and financial report",
  },
  {
    "image": "assets/images/checklist.png",
    "title": "Planning ahead",
    "description": "Setup your budget for each category so you are in control",
  },
];

class LoginRegisterScreen extends StatefulWidget {
  const LoginRegisterScreen({super.key});

  @override
  State<LoginRegisterScreen> createState() => _LoginRegisterScreenState();
}

class _LoginRegisterScreenState extends State<LoginRegisterScreen> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ResponsiveScroll(
        // ✅ Wrap with the reusable scroll widget
        child: Column(
          mainAxisSize: MainAxisSize.min, // Prevents overflow
          children: [
            Expanded(
              child: CarouselSlider(
                items:
                    _onboardingData.map((data) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 50),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset(data["image"]!, height: 250),
                            const SizedBox(height: 10),
                            Text(
                              data["title"]!,
                              style: titleStyle,
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 10),
                            Text(
                              data["description"]!,
                              style: descriptionStyle,
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                options: CarouselOptions(
                  height: MediaQuery.of(context).size.height * 0.75,
                  viewportFraction: 1.0,
                  enableInfiniteScroll: false,
                  autoPlay: false,
                  onPageChanged: (index, reason) {
                    setState(() {
                      _currentIndex = index;
                    });
                  },
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(_onboardingData.length, (index) {
                return Container(
                  margin: const EdgeInsets.symmetric(horizontal: 4.0),
                  width: _currentIndex == index ? 14.0 : 8.0,
                  height: _currentIndex == index ? 14.0 : 8.0,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color:
                        _currentIndex == index
                            ? Colors.amber
                            : Colors.grey[400],
                  ),
                );
              }),
            ),
            const SizedBox(height: 40),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40.0),
              child: Column(
                children: [
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => SignUpScreen()),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0XFFDAA520),
                      minimumSize: const Size(double.infinity, 50),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                    child: const Text(
                      "Sign Up",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  const SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => LoginScreen()),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.amber[100],
                      minimumSize: const Size(double.infinity, 50),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                    child: const Text(
                      "Login",
                      style: TextStyle(color: Color(0XFFDAA520)),
                    ),
                  ),
                  const SizedBox(height: 60),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
