import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/services.dart';
import 'package:iPocket/pages/Loans/loans_page.dart';
import 'package:iPocket/pages/Onboard/splash_screen.dart';
import 'package:iPocket/pages/add_expense/add_expense.dart';
import 'package:iPocket/pages/add_expense/ocr_add_expense.dart';
import 'package:iPocket/pages/add_expense/voice_assistant_add_expense.dart';
import 'package:iPocket/pages/home/chatbot_page.dart';
import 'package:iPocket/pages/home/home_page.dart';

import 'package:iPocket/pages/home/tips_and_tricks_page.dart';
import 'package:iPocket/pages/login_register/google_profile.dart';
import 'package:iPocket/pages/login_register/login_register_screen.dart';
import 'package:iPocket/pages/login_register/login_screen.dart';
import 'package:iPocket/pages/login_register/profile_success_screen.dart';
import 'package:iPocket/pages/login_register/saving_profile_screen.dart';
import 'package:iPocket/pages/login_register/sign_up_screen.dart';
import 'package:iPocket/pages/profile/profile_page.dart';
import 'package:iPocket/pages/quests/current_quests_page.dart';
import 'package:iPocket/pages/summary/summary.dart';
import 'package:iPocket/pages/transaction/transaction_page.dart';
import 'package:iPocket/providers/firebase_options.dart';
import 'package:iPocket/providers/google.dart';
import 'package:iPocket/widgets/bottom_nav_bar.dart';
import 'package:provider/provider.dart';
import 'package:rive/rive.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await RiveFile.initialize(); // ✅ Required before using RiveFile.import()
  // Loading environment variables from .env file

  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    print("🔥 Firebase initialized successfully!"); // Debug message
  } catch (e) {
    print("❌ Firebase initialization failed: $e");
  }
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp, // Restricts to portrait mode only
  ]).then((_) {
    runApp(const MyApp());
  });
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => GoogleSignInProvider()),
      ],

      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Expense App',
        theme: ThemeData(primarySwatch: Colors.orange),
        initialRoute: "/",
        routes: {
          "/saving-profile": (context) => const SavingProfileScreen(),
          "/profile-success": (context) => const ProfileSuccessScreen(),
          "/":
              (context) => SplashScreen(
                nextScreen: LoginRegisterScreen(),
              ), // Make sure this is correct
          "/homepage": (context) => const MainScreen(),
          "/login": (context) => LoginScreen(),
          "/sign-up": (context) => SignUpScreen(),
          "/profile": (context) => ProfileScreen(),
          "/ocr": (context) => OCRAddExpensePage(),
          "/chatbot": (context) => const ChatbotPage(),
          '/tips_and_tricks': (context) => const TipsAndTricksPage(),
          '/voice-assistant': (context) => const RecorderScreen(),
          '/quests': (context) => const QuestPage(),
          "/iLoan": (context) => ILoanPage(),

        },
      ),
    );
  }
}

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      body: _getSelectedPage(_selectedIndex),
      bottomNavigationBar: CustomBottomNavigationBar(
        selectedIndex: _selectedIndex,
        onItemTapped: _onItemTapped,
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xffDAA520), // Goldenrod
        shape: const CircleBorder(),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddExpensePage()),
          );
        },
        child: const Icon(Icons.add, color: Colors.white),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }

  Widget _getSelectedPage(int index) {
    switch (index) {
      case 0:
        return const Center(child: HomePage());
      case 1:
        return TransactionPage();
      case 2:
        return SummaryPage();
      case 3:
      default:
        return const ProfilePage();
    }
  }
}
