import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:iPocket/pages/login_register/auth_theme.dart';
import 'package:iPocket/pages/login_register/profile_setup_page.dart';
import 'package:iPocket/pages/login_register/responsive_scroll.dart';
import 'package:iPocket/providers/auth.dart';
import 'package:iPocket/widgets/custom_password_field.dart';
import 'package:iPocket/widgets/custom_text_field.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  bool isChecked = false; // Add this inside your StatefulWidget class
  String? message = "";
  bool isLogin = true;
  bool isLoading = false; // Track loading state

  Future<void> createInWithEmailAndPassword() async {
    if (_validateInputs()) {
      setState(() {
        isLoading = true;
        message = ""; // Clear previous messages
      });

      try {
        await Auth().createWithEmailAndPassword(
          email: _emailController.text,
          password: _passwordController.text,
        );
        setState(() {
          message = "✅ Account Created! Redirecting...";
        });

        Future.delayed(const Duration(seconds: 1), () {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const ProfileSetupPage()),
          );
        });
      } on FirebaseAuthException catch (e) {
        setState(() => message = e.message);
      } finally {
        setState(() => isLoading = false);
      }
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

  bool _validateInputs() {
    if (_nameController.text.isEmpty ||
        _emailController.text.isEmpty ||
        _passwordController.text.isEmpty ||
        _confirmPasswordController.text.isEmpty) {
      setState(() {
        message = "All fields must be filled";
      });
      return false;
    }

    if (_passwordController.text != _confirmPasswordController.text) {
      setState(() {
        message = "Password do not match.";
      });
      return false;
    }

    if (!isChecked) {
      setState(() {
        message = "You must agree to the terms!";
      });
      return false;
    }

    return true;
  }

  @override
  void dispose() {
    // Dispose controllers to avoid memory leaks
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
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
              const Text("Sign Up", style: titleStyle),
              const SizedBox(height: 25),

              // Text Fields
              CustomTextField(label: "Name", controller: _nameController),
              CustomTextField(label: "Email", controller: _emailController),
              CustomPasswordField(
                label: 'Password',
                controller: _passwordController,
              ),
              CustomPasswordField(
                label: 'Confirm Password',
                controller: _confirmPasswordController,
              ),

              const SizedBox(height: 10),

              // Terms & Conditions
              Row(
                children: [
                  Checkbox(
                    activeColor: themeColor,
                    value: isChecked,
                    onChanged: (value) {
                      setState(() {
                        isChecked = value ?? false;
                      });
                    },
                  ),
                  Expanded(
                    child: RichText(
                      text: TextSpan(
                        style: labelStyle, // Apply default style
                        children: [
                          const TextSpan(
                            text: "By signing up, you agree to the ",
                          ),
                          TextSpan(
                            text: "Terms of Service and Privacy Policy",
                            style: const TextStyle(
                              color: Color(0XFFDAA520),
                              fontSize: 13,
                            ),
                            recognizer:
                                TapGestureRecognizer()
                                  ..onTap = () {
                                    showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return AlertDialog(
                                          title: const Text("Terms & Privacy"),
                                          content: const Text(
                                            "This is a popup alert message.",
                                          ),
                                          actions: [
                                            TextButton(
                                              onPressed: () {
                                                Navigator.of(
                                                  context,
                                                ).pop(); // Close the dialog
                                              },
                                              child: const Text("OK"),
                                            ),
                                          ],
                                        );
                                      },
                                    );
                                  },
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),

              _message(),

              const SizedBox(height: 30),

              // Sign Up Button
              ElevatedButton(
                onPressed: isLoading ? null : createInWithEmailAndPassword,
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
                        : const Text("Sign Up", style: buttonTextStyle),
              ),

              const SizedBox(height: 15),

              // Login Navigation
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Already have an account? "),
                  GestureDetector(
                    onTap: () {
                      Navigator.pushReplacementNamed(context, "/login");
                    },
                    child: const Text(
                      "Login",
                      style: TextStyle(color: Colors.amber),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
