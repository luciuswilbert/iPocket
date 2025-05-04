import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:iPocket/widgets/custom_dropdown.dart';
import 'package:iPocket/widgets/custom_text_field.dart';
import 'package:iPocket/widgets/custom_toggle.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({Key? key}) : super(key: key);
  
  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  Map<String, dynamic>? userProfile;
  bool isLoading = true;

  String _selectedCurrency = "USD";
  String _selectedLanguage = "English";
  bool _isDarkMode = false;
  bool _notificationsEnabled = true;
  bool _securityEnabled = false;
  final TextEditingController _expenseBudgetController = TextEditingController(
    text: "1000",
  );
  final TextEditingController _incomeController = TextEditingController(
    text: "2000",
  );
  

  final List<String> _currencies = [
    "AED",
    "AFN",
    "ALL",
    "AMD",
    "ANG",
    "AOA",
    "ARS",
    "AUD",
    "AWG",
    "AZN",
    "BAM",
    "BBD",
    "BDT",
    "BGN",
    "BHD",
    "BIF",
    "BMD",
    "BND",
    "BOB",
    "BRL",
    "BSD",
    "BTN",
    "BWP",
    "BYN",
    "BZD",
    "CAD",
    "CDF",
    "CHF",
    "CLP",
    "CNY",
    "COP",
    "CRC",
    "CUC",
    "CUP",
    "CVE",
    "CZK",
    "DJF",
    "DKK",
    "DOP",
    "DZD",
    "EGP",
    "ERN",
    "ETB",
    "EUR",
    "FJD",
    "FKP",
    "FOK",
    "GBP",
    "GEL",
    "GGP",
    "GHS",
    "GIP",
    "GMD",
    "GNF",
    "GTQ",
    "GYD",
    "HKD",
    "HNL",
    "HRK",
    "HTG",
    "HUF",
    "IDR",
    "ILS",
    "IMP",
    "INR",
    "IQD",
    "IRR",
    "ISK",
    "JEP",
    "JMD",
    "JOD",
    "JPY",
    "KES",
    "KGS",
    "KHR",
    "KID",
    "KMF",
    "KRW",
    "KWD",
    "KYD",
    "KZT",
    "LAK",
    "LBP",
    "LKR",
    "LRD",
    "LSL",
    "LYD",
    "MAD",
    "MDL",
    "MGA",
    "MKD",
    "MMK",
    "MNT",
    "MOP",
    "MRU",
    "MUR",
    "MVR",
    "MWK",
    "MXN",
    "MYR",
    "MZN",
    "NAD",
    "NGN",
    "NIO",
    "NOK",
    "NPR",
    "NZD",
    "OMR",
    "PAB",
    "PEN",
    "PGK",
    "PHP",
    "PKR",
    "PLN",
    "PYG",
    "QAR",
    "RON",
    "RSD",
    "RUB",
    "RWF",
    "SAR",
    "SBD",
    "SCR",
    "SDG",
    "SEK",
    "SGD",
    "SHP",
    "SLE",
    "SLL",
    "SOS",
    "SRD",
    "SSP",
    "STN",
    "SYP",
    "SZL",
    "THB",
    "TJS",
    "TMT",
    "TND",
    "TOP",
    "TRY",
    "TTD",
    "TVD",
    "TWD",
    "TZS",
    "UAH",
    "UGX",
    "USD",
    "UYU",
    "UZS",
    "VES",
    "VND",
    "VUV",
    "WST",
    "XAF",
    "XCD",
    "XOF",
    "XPF",
    "YER",
    "ZAR",
    "ZMW",
    "ZWL",
  ];
  final List<String> _languages = [
    "Afrikaans",
    "Albanian",
    "Amharic",
    "Arabic",
    "Armenian",
    "Azerbaijani",
    "Basque",
    "Belarusian",
    "Bengali",
    "Bosnian",
    "Bulgarian",
    "Burmese",
    "Catalan",
    "Cebuano",
    "Chinese (Simplified)",
    "Chinese (Traditional)",
    "Corsican",
    "Croatian",
    "Czech",
    "Danish",
    "Dutch",
    "English",
    "Esperanto",
    "Estonian",
    "Filipino",
    "Finnish",
    "French",
    "Galician",
    "Georgian",
    "German",
    "Greek",
    "Gujarati",
    "Haitian Creole",
    "Hausa",
    "Hawaiian",
    "Hebrew",
    "Hindi",
    "Hmong",
    "Hungarian",
    "Icelandic",
    "Igbo",
    "Indonesian",
    "Irish",
    "Italian",
    "Japanese",
    "Javanese",
    "Kannada",
    "Kazakh",
    "Khmer",
    "Korean",
    "Kurdish",
    "Kyrgyz",
    "Lao",
    "Latin",
    "Latvian",
    "Lithuanian",
    "Luxembourgish",
    "Macedonian",
    "Malagasy",
    "Malay",
    "Malayalam",
    "Maltese",
    "Maori",
    "Marathi",
    "Mongolian",
    "Nepali",
    "Norwegian",
    "Pashto",
    "Persian",
    "Polish",
    "Portuguese",
    "Punjabi",
    "Romanian",
    "Russian",
    "Samoan",
    "Scottish Gaelic",
    "Serbian",
    "Shona",
    "Sindhi",
    "Sinhala",
    "Slovak",
    "Slovenian",
    "Somali",
    "Spanish",
    "Sundanese",
    "Swahili",
    "Swedish",
    "Tajik",
    "Tamil",
    "Telugu",
    "Thai",
    "Turkish",
    "Ukrainian",
    "Urdu",
    "Uzbek",
    "Vietnamese",
    "Welsh",
    "Xhosa",
    "Yiddish",
    "Yoruba",
    "Zulu",
  ];

  @override
  void initState() {
    super.initState();
    final user = FirebaseAuth.instance.currentUser;
    _loadUserSettings(); // fetch Firestore data

    if (user != null) {
      FirebaseFirestore.instance.collection('users').doc(user.email).get().then(
        (doc) {
          if (doc.exists) {
            setState(() {
              userProfile = doc.data();
              _selectedCurrency = userProfile!['currency'];
              _selectedLanguage = userProfile!['language'];
              
              // Handle the budget: Convert it to a string if it's a number
              var budget = userProfile!['budget'];
              _expenseBudgetController.text = (budget != null) ? budget.toString() : '';
              var income = userProfile!['monthlyIncome'];
              _incomeController.text = (income != null) ? income.toString() : '';

              
              isLoading = false;
            });
          }
        },
      );
    }
  }

  void _loadUserSettings() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final doc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.email)
          .get();
      if (doc.exists) {
        final data = doc.data();
        setState(() {
          _selectedCurrency = data?['currency'] ?? _selectedCurrency;
          _selectedLanguage = data?['language'] ?? _selectedLanguage;
          
          // Convert the budget (if it's a number) to string before setting it
          var budget = data?['budget'];
          _expenseBudgetController.text = (budget != null) ? budget.toString() : _expenseBudgetController.text;
          
          _isDarkMode = data?['darkMode'] ?? false;
          _notificationsEnabled = data?['notifications'] ?? true;
          _securityEnabled = data?['security'] ?? false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading || userProfile == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xffDAA520), // Goldenrod color
        automaticallyImplyLeading: false, // Prevents default back button
        title: Stack(
          alignment: Alignment.center,
          children: [
            /// 🔙 Manual Back Button (Left-Aligned)
            Positioned(
              left: 0,
              child: IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.black),
                onPressed: () {
                  Navigator.pop(context); // Go back
                },
              ),
            ),

            /// 📝 Centered Title
            const Align(
              alignment: Alignment.center,
              child: Text(
                "Settings",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ),
          ],
        ),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            /// Currency Dropdown
            CustomDropdown(
              label: "Currency",
              items: _currencies,
              selectedItem: _selectedCurrency,
              onChanged: (value) => setState(() => _selectedCurrency = value!),
            ),

            /// Expense Budget (Using CustomTextField)
            CustomTextField(
              label: "Expense Budget",
              controller: _expenseBudgetController,
              keyboardType: TextInputType.number,
            ),

            CustomTextField(
              label: "Monthly Income",
              controller: _incomeController,
              keyboardType: TextInputType.number,
            ),

            /// Theme Toggle (Using CustomToggle)
            CustomToggle(
              title: "Dark Mode",
              value: _isDarkMode,
              onChanged: (value) => setState(() => _isDarkMode = value),
            ),

            /// Language Dropdown
            CustomDropdown(
              label: "Language",
              items: _languages,
              selectedItem: _selectedLanguage,
              onChanged: (value) => setState(() => _selectedLanguage = value!),
            ),

            /// Notifications Toggle
            CustomToggle(
              title: "Notifications",
              value: _notificationsEnabled,
              onChanged:
                  (value) => setState(() => _notificationsEnabled = value),
            ),

            /// Security Toggle (PIN/Face ID)
            CustomToggle(
              title: "Security (PIN/Face ID)",
              value: _securityEnabled,
              onChanged: (value) => setState(() => _securityEnabled = value),
            ),
            ElevatedButton(
              onPressed: () async {
                final user = FirebaseAuth.instance.currentUser;
                if (user != null) {
                  await FirebaseFirestore.instance
                      .collection('users')
                      .doc(user.email)
                      .update({
                        'currency': _selectedCurrency,
                        'language': _selectedLanguage,
                        'budget': _expenseBudgetController.text,
                        'monthlyIncome': double.parse(_incomeController.text),
                        'darkMode': _isDarkMode,
                        'notifications': _notificationsEnabled,
                        'security': _securityEnabled,
                      });
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Row(
                        children: const [
                          Icon(Icons.check_circle, color: Colors.green),
                          SizedBox(width: 8),
                          Text(
                            'Settings updated successfully!',
                            style: TextStyle(color: Colors.white),
                          ),
                        ],
                      ),
                      backgroundColor: Colors.black87,
                      behavior: SnackBarBehavior.floating,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  );
                  Navigator.pop(context);
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xffDAA520),
                minimumSize: const Size(double.infinity, 50),
              ),
              child: const Text(
                'Save Settings',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
