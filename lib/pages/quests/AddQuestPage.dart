import 'package:flutter/material.dart';
import 'package:iPocket/pages/quests/quest_card.dart';
import 'package:iPocket/pages/transaction/rounded_rect_clipper.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:convert';

import 'package:intl/intl.dart'; // For base64 encoding

class AddQuestPage extends StatefulWidget {
  @override
  _AddQuestPageState createState() => _AddQuestPageState();
}

class _AddQuestPageState extends State<AddQuestPage> {
  final _questNameController = TextEditingController();
  final _targetAmountController = TextEditingController();
  File? _imageFile;
  DateTime? _selectedEndDate;
  Color _selectedColor = Colors.blueGrey;
  final user = FirebaseAuth.instance.currentUser;

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
    }
  }

  Future<void> _pickEndDate(BuildContext context) async {
    final DateTime now = DateTime.now();
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate:now.add(Duration(days: 1)),
      firstDate: now.add(Duration(days: 1)),
      lastDate: DateTime(now.year + 5),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            scaffoldBackgroundColor: Colors.white,
            colorScheme: const ColorScheme.light(
              primary: Color(0xffDAA520),
              onPrimary: Colors.white,
              onSurface: Colors.black,
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: Colors.black,
              ),
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null && picked.isAfter(now)) {
      setState(() {
        _selectedEndDate = picked;
      });
    }
  }

  String _calculateDaysLeft() {
    if (_selectedEndDate == null) return '0 days left';
    final now = DateTime.now();
    final difference = _selectedEndDate!.difference(now).inDays;
    return difference > 0 ? '$difference days left' : '0 days left';
  }

  void _pickColor(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Pick a Background Color'),
          content: SingleChildScrollView(
            child: BlockPicker(
              pickerColor: _selectedColor,
              availableColors: [
                const Color(0xFFF0F0F0), // Light Warm Gray
                const Color(0xFFE8E8E8), // Lighter Warm Gray
                const Color(0xFFFAF9E6), // Cream/Off-White
                const Color(0xFFE0F2F7), // Light Teal/Mint
                const Color(0xFFE0EEE0), // Another Light Teal/Mint variation
                const Color(0xFFF5F5DC), // Light Sand/Beige
                const Color(0xFFF5F5E0), // Another Light Sand/Beige variation
                const Color(0xFFEEE8AA), // Light Muted Gold
              ],
              onColorChanged: (color) {
                setState(() {
                  _selectedColor = color;
                });
              },
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Done'),
            ),
          ],
        );
      },
    );
  }

  String _colorToHex(Color color) {
    return '#${color.value.toRadixString(16).padLeft(8, '0').substring(2)}';
  }

  Future<void> updateBudget(double txAmount) async {
    if (user == null) {
      print("Error: User is not logged in. Cannot update budget.");
      // Depending on your app flow, you might want to throw an error
      // or handle this differently (e.g., navigate to login).
      return;
    }else {
      final doc =
          await FirebaseFirestore.instance
              .collection('users')
              .doc(user!.email)
              .get();
      try {
        final data = doc.data();
        final double currentBudget = double.parse(data!['budget']);

        final double newBudget = currentBudget - txAmount; // Result will be double
        await FirebaseFirestore.instance
                        .collection('users')
                        .doc(user!.email)
                        .update({
                          'budget': newBudget.toString(),
                        });

        print("Budget successfully updated for ${user!.email} to $newBudget"); // Optional: Log success


      } catch (e) {
        // Handle any errors during the transaction (network, permissions, thrown exceptions)
        print("Failed to update budget for ${user!.email}: $e");
        // Depending on requirements, you might want to:
        // - Show an error message to the user
        // - Log the error to a monitoring service
        // - Rethrow the error if needed: throw e;
      }
    }
  }

  Future<void> _addQuest() async {
    String questName = _questNameController.text;
    double targetAmount = double.tryParse(_targetAmountController.text) ?? 0;

    // Validate inputs
    if (questName.isEmpty || targetAmount <= 0 || _selectedEndDate == null || user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please fill all fields correctly')),
      );
      return;
    }

    try {
      // Show loading indicator
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => Center(child: CircularProgressIndicator()),
      );

      // Convert image to base64 if selected
      String? imageBase64;
      if (_imageFile != null) {
        final bytes = await _imageFile!.readAsBytes();
        imageBase64 = base64Encode(bytes);
      }

      // Save to Firestore under users/{user.email}/quests
      await FirebaseFirestore.instance
          .collection('users')
          .doc(user!.email)
          .collection('quests')
          .add({
        'questName': questName,
        'targetAmount': targetAmount,
        'savedAmount': 0.0,
        'startDate': Timestamp.now(),
        'endDate': Timestamp.fromDate(_selectedEndDate!),
        'backgroundColor': _colorToHex(_selectedColor),
        'imageBase64': imageBase64, // Save base64 string (null if no image)
      });

      // Close the loading dialog and navigate back
      Navigator.pop(context); // Close loading dialog
      Navigator.pop(context); // Go back to the previous screen
    } catch (e) {
      // Handle errors
      Navigator.pop(context); // Close loading dialog
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to add quest: $e')),
      );
      print('Error adding quest: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    String timeLeft = _calculateDaysLeft();
    double targetAmount = double.tryParse(_targetAmountController.text) ?? 0;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'Add New Quest',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color(0xffF6E392),
                Color(0xffdaa520),
              ],
              begin: Alignment.topRight,
              end: Alignment.bottomLeft,
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipPath(
              clipper: RoundedRectClipper(radius: 24.0),
              child: QuestCard(
                imageFile: _imageFile,
                imageBase64: null, // Not used in preview
                questName: _questNameController.text,
                savedAmount: 0.0,
                targetAmount: targetAmount,
                timeLeft: timeLeft,
                backgroundColor: _selectedColor,
                onTap: () {},
              ),
            ),
            SizedBox(height: 30),
            TextField(
              controller: _questNameController,
              decoration: InputDecoration(labelText: 'Quest Name'),
              onChanged: (value) => setState(() {}),
            ),
            TextField(
              controller: _targetAmountController,
              decoration: InputDecoration(labelText: 'Target Amount (RM)'),
              keyboardType: TextInputType.number,
              onChanged: (value) => setState(() {}),
            ),
            SizedBox(height: 16),
            GestureDetector(
              onTap:() => _pickEndDate(context),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12), // Rounded corners
                  border: Border.all(color: Colors.grey),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      _selectedEndDate == null
                          ? 'Select a date'
                          : DateFormat('dd/MM/yyyy').format(_selectedEndDate!),
                      style: const TextStyle(color: Colors.black87),
                    ),
                    const Icon(Icons.calendar_today, color: Colors.black54),
                  ],
                ),
              ),
            ),
              
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: _pickImage,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xffDAA520),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: SizedBox( 
                width: double.infinity, 
                child: Center( 
                  child: Text(
                    'Pick Image',
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                ),
              ),
            ),
            SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Background Color:',
                  style: TextStyle(fontSize: 16),
                ),
                GestureDetector(
                  onTap: () => _pickColor(context),
                  child: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: _selectedColor,
                      border: Border.all(color: Colors.black54),
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: _addQuest,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xffDAA520),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: SizedBox( 
                width: double.infinity, 
                child: Center( 
                  child: Text(
                    'Add Quest',
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}