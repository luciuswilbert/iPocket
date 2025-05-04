import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:iPocket/widgets/custom_date_picker.dart';
import 'package:iPocket/widgets/custom_password_field.dart';
import 'package:iPocket/widgets/custom_text_field.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class AccountInfoEditPage extends StatefulWidget {
  final Map<String, dynamic> initialData;

  const AccountInfoEditPage({Key? key, required this.initialData}) : super(key: key);

  @override
  _AccountInfoEditPageState createState() => _AccountInfoEditPageState();
}

class _AccountInfoEditPageState extends State<AccountInfoEditPage> {
  bool isGoogleSignIn = false;


  @override
  void initState() {
    super.initState();

    final user = FirebaseAuth.instance.currentUser;
    isGoogleSignIn = user?.providerData.first.providerId == "google.com";

    _fullNameController.text = widget.initialData["fullName"] ?? "";
    _emailController.text = widget.initialData["email"] ?? "";
    _phoneController.text = widget.initialData["phone"] ?? "";
    _dobController.text = widget.initialData["dob"] ?? "";
    _passwordController.text = isGoogleSignIn
        ? "Sign in with Google"
        : widget.initialData["password"] ?? "";
    _selectedCountry = widget.initialData["country"] ?? "Malaysia";
  }




  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _dobController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();


  final List<String> _countries = [
    "Afghanistan",
    "Albania",
    "Algeria",
    "Andorra",
    "Angola",
    "Argentina",
    "Armenia",
    "Australia",
    "Austria",
    "Azerbaijan",
    "Bahamas",
    "Bahrain",
    "Bangladesh",
    "Belarus",
    "Belgium",
    "Belize",
    "Benin",
    "Bhutan",
    "Bolivia",
    "Botswana",
    "Brazil",
    "Brunei",
    "Bulgaria",
    "Burkina Faso",
    "Burundi",
    "Cambodia",
    "Cameroon",
    "Canada",
    "Chad",
    "Chile",
    "China",
    "Colombia",
    "Comoros",
    "Costa Rica",
    "Croatia",
    "Cuba",
    "Cyprus",
    "Czech Republic",
    "Denmark",
    "Djibouti",
    "Dominican Republic",
    "Ecuador",
    "Egypt",
    "El Salvador",
    "Estonia",
    "Ethiopia",
    "Fiji",
    "Finland",
    "France",
    "Gabon",
    "Gambia",
    "Georgia",
    "Germany",
    "Ghana",
    "Greece",
    "Guatemala",
    "Honduras",
    "Hungary",
    "Iceland",
    "India",
    "Indonesia",
    "Iran",
    "Iraq",
    "Ireland",
    "Israel",
    "Italy",
    "Jamaica",
    "Japan",
    "Jordan",
    "Kazakhstan",
    "Kenya",
    "Kuwait",
    "Laos",
    "Latvia",
    "Lebanon",
    "Libya",
    "Lithuania",
    "Luxembourg",
    "Madagascar",
    "Malaysia",
    "Maldives",
    "Mali",
    "Malta",
    "Mexico",
    "Moldova",
    "Monaco",
    "Mongolia",
    "Montenegro",
    "Morocco",
    "Mozambique",
    "Myanmar",
    "Namibia",
    "Nepal",
    "Netherlands",
    "New Zealand",
    "Nicaragua",
    "Niger",
    "Nigeria",
    "North Korea",
    "Norway",
    "Oman",
    "Pakistan",
    "Palestine",
    "Panama",
    "Papua New Guinea",
    "Paraguay",
    "Peru",
    "Philippines",
    "Poland",
    "Portugal",
    "Qatar",
    "Romania",
    "Russia",
    "Rwanda",
    "Saudi Arabia",
    "Senegal",
    "Serbia",
    "Singapore",
    "Slovakia",
    "Slovenia",
    "Somalia",
    "South Africa",
    "South Korea",
    "Spain",
    "Sri Lanka",
    "Sudan",
    "Sweden",
    "Switzerland",
    "Syria",
    "Taiwan",
    "Tajikistan",
    "Tanzania",
    "Thailand",
    "Togo",
    "Tunisia",
    "Turkey",
    "Turkmenistan",
    "Uganda",
    "Ukraine",
    "United Arab Emirates",
    "United Kingdom",
    "United States",
    "Uruguay",
    "Uzbekistan",
    "Vatican City",
    "Venezuela",
    "Vietnam",
    "Yemen",
    "Zambia",
    "Zimbabwe",
  ];

  String _selectedCountry = "Malaysia";

  File? _selectedImage; // Holds selected image file

  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      setState(() {
        _selectedImage = File(image.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xffDAA520), // Goldenrod color
        automaticallyImplyLeading: false,
        title: Stack(
          alignment: Alignment.center,
          children: [
            /// Centered Title
            const Center(
              child: Text(
                "Edit Account Info",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ),

            /// Left-Aligned Back Button
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
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Stack(
              children: [
                CircleAvatar(
                  radius: 50,
                  backgroundColor: Colors.white,
                  child: CircleAvatar(
                    radius: 48,
                    backgroundImage:
                        _selectedImage != null
                            ? FileImage(_selectedImage!) as ImageProvider
                            : const AssetImage(
                              'assets/profile_placeholder.png',
                            ),
                  ),
                ),
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: GestureDetector(
                    onTap: _pickImage,
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.edit,
                        color: Colors.black,
                        size: 18,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            CustomTextField(label: "Full Name", controller: _fullNameController),
            // CustomTextField(label: "Email", controller: _emailController),
            CustomTextField(
              label: "Phone Number",
              controller: _phoneController,
            ),
            Theme(
              data: Theme.of(context).copyWith(
                dialogBackgroundColor:
                    Colors.white, // ✅ White background for the calendar dialog
                colorScheme: ColorScheme.light(
                  primary: Color(
                    0xFFDAA520,
                  ), // ✅ Gold for the selected date highlight
                  onPrimary: Colors.white, // ✅ White text on selected date
                  onSurface: Colors.black, // ✅ Black text for normal dates
                ),
              ),
              child: CustomDatePicker(
                label: "Date of Birth",
                controller: _dobController,
              ),
            ),
            const SizedBox(height: 12),
            if (isGoogleSignIn)
              TextField(
                readOnly: true,
                enabled: false,
                controller: TextEditingController(text: 'Sign in with Google'),
                decoration: InputDecoration(
                  labelText: 'Password',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                style: const TextStyle(color: Colors.grey),
              )
            else
              CustomPasswordField(
                label: "Password",
                controller: _passwordController,
              ),
            
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              value: _selectedCountry, // Keeps the selected value
              decoration: InputDecoration(
                labelText: "Country",
                filled: true,
                fillColor: Colors.white, // Background color for dropdown
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(color: Colors.black54),
                ),
              ),
              icon: const Icon(
                Icons.arrow_drop_down,
                color: Color(0xFFDAA520),
              ), // Gold dropdown icon
              dropdownColor: Colors.white, // White dropdown background
              style: const TextStyle(color: Colors.black), // Text color
              menuMaxHeight:
                  300, // ✅ Limits the dropdown height so it doesn't take full screen
              items:
                  _countries.map<DropdownMenuItem<String>>((String country) {
                    return DropdownMenuItem<String>(
                      value: country,
                      child: Row(
                        children: [
                          Icon(
                            Icons.flag,
                            color: Color(0xFFDAA520),
                          ), // Gold location icon
                          const SizedBox(width: 10),
                          Text(
                            country,
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
              onChanged: (String? newValue) {
                setState(() {
                  _selectedCountry = newValue!;
                });
              },
            ),

            const SizedBox(height: 24),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xffDAA520),
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 12,
                ),
              ),
              onPressed: () async {
                final user = FirebaseAuth.instance.currentUser;
                if (user == null) {
                  print("❌ No user logged in");
                  return;
                }

                final Map<String, dynamic> updatedData = {
                  "fullName": _fullNameController.text.trim(),
                  "email": _emailController.text.trim(),
                  "phone": _phoneController.text.trim(),
                  "dob": _dobController.text.trim(),
                  "password": _passwordController.text.trim(),
                  "country": _selectedCountry,
                  "profileImage": _selectedImage != null ? _selectedImage!.path : null, // Can be updated to Firebase Storage
                };

                try {
                  await FirebaseFirestore.instance
                      .collection("users")
                      .doc(user.email) // or user.uid
                      .set(updatedData);

                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("✅ Account info updated successfully!"),
                      backgroundColor: Colors.green,
                      behavior: SnackBarBehavior.floating,
                      duration: Duration(seconds: 2),
                    ),
                  );
                  Navigator.pop(context); // Go back after saving
                } catch (e) {
                  print("❌ Failed to update account info: $e");
                }
              },
              child: const Text(
                "Save Changes",
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
