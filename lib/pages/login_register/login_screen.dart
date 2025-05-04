import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:iPocket/pages/login_register/auth_theme.dart';
import 'package:iPocket/pages/login_register/profile_setup_page.dart';
import 'package:iPocket/pages/login_register/reset_password_screen.dart';
import 'package:iPocket/pages/login_register/responsive_scroll.dart';
import 'package:iPocket/providers/auth.dart';
import 'package:iPocket/providers/google.dart';
import 'package:iPocket/widgets/custom_password_field.dart';
import 'package:iPocket/widgets/custom_text_field.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool isChecked = false;
  String? message = ""; // Updated variable name
  bool isLoading = false;

  Future<void> loginWithEmailAndPassword() async {
    setState(() {
      isLoading = true;
      message = ""; // Clear previous messages
    });

    try {
      await Auth().loginWithEmailAndPassword(
        email: _emailController.text,
        password: _passwordController.text,
      );

      setState(() {
        message = "✅ Login successful! Redirecting...";
      });

      // ✅ Navigate to Dashboard after successful login
      Future.delayed(const Duration(seconds: 1), () {
        Navigator.pushReplacementNamed(context, "/homepage");
      });
    } on FirebaseAuthException {
      setState(() => message = "⚠️ Failed to login");
    } finally {
      setState(() => isLoading = false);
    }
  }

  Future<void> signInWithGoogle() async {
    try {
      final provider = Provider.of<GoogleSignInProvider>(
        context,
        listen: false,
      );

      final UserCredential? userCredential = await provider.googleLogin();

      // ✅ Ensure sign-in was successful
      if (userCredential != null && userCredential.user != null) {
        userCredential.user!;
        final user = userCredential.user;

        // ✅ Check if the user is signing in for the first time
        if (user != null) {
          final doc =
              await FirebaseFirestore.instance
                  .collection('users')
                  .doc(user.email)
                  .get();

          final setupComplete =
              doc.exists && doc.data()?['setupComplete'] == true;

          if (setupComplete) {
            // ✅ Profile is already completed
            Navigator.pushReplacementNamed(context, "/homepage");
          } else {
            // ❗ Profile not yet set up
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => const ProfileSetupPage()),
            );
          }
        }
      } else {
        setState(() {
          message = "Google Sign-In failed. Please try again.";
        });
      }
    } catch (e) {
      setState(() {
        message = "Google Sign-In failed. Please try again.";
      });
    }
  }

  Widget _message() {
    return Text(
      message!.isEmpty ? '' : message!,
      style: TextStyle(
        color: message!.contains("✅") ? Colors.green : Colors.red,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  @override
  void dispose() {
    // Dispose controllers to avoid memory leaks
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ResponsiveScroll(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text("Login", style: titleStyle),
              const SizedBox(height: 25),

              // Text Fields
              CustomTextField(label: "Email", controller: _emailController),
              CustomPasswordField(
                label: 'Password',
                controller: _passwordController,
              ),

              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const ResetPasswordScreen()),
                    );
                  },
                  child: const Text(
                    "Forgot Password?",
                    style: TextStyle(color: Colors.blue),
                  ),
                ),
              ),

              _message(),

              // Sign Up Button
              ElevatedButton(
                onPressed: isLoading ? null : loginWithEmailAndPassword,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0XFFDAA520),
                  minimumSize: const Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
                child:
                    isLoading
                        ? const CircularProgressIndicator(
                          color: Color.fromARGB(255, 228, 219, 130),
                        )
                        : const Text("Login", style: buttonTextStyle),
              ),
              const SizedBox(height: 10),
              // Sign up Navigation
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Create a new account? "),
                  GestureDetector(
                    onTap: () {
                      Navigator.pushReplacementNamed(context, "/sign-up");
                    },
                    child: const Text(
                      "Sign up",
                      style: TextStyle(color: Colors.amber),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 30),
              const Text("Or with"),
              const SizedBox(height: 10),

              // Google Login Button
              ElevatedButton.icon(
                onPressed: signInWithGoogle,
                style: ElevatedButton.styleFrom(
                  backgroundColor: googleBtnColor,
                  minimumSize: const Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                    side: const BorderSide(color: Colors.grey),
                  ),
                ),
                icon: Image.asset("assets/images/google-icon.png", height: 24),
                label: const Text(
                  "Sign in with Google",
                  style: TextStyle(color: Colors.black),
                ),
              ),

              const SizedBox(height: 15),
            ],
          ),
        ),
      ),
    );
  }
}
