import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:iPocket/main.dart';
import 'package:iPocket/pages/home/home_page.dart';
import 'package:iPocket/pages/quests/AddQuestPage.dart';
import 'package:iPocket/pages/quests/Oldquests.dart';
import 'package:iPocket/pages/quests/details_dialog.dart';
import 'package:iPocket/pages/quests/quest_card.dart';
import 'package:iPocket/pages/transaction/rounded_rect_clipper.dart';

class QuestPage extends StatefulWidget {
  const QuestPage({Key? key}) : super(key: key);

  @override
  QuestPageState createState() => QuestPageState();
}

class QuestPageState extends State<QuestPage> {
  final user = FirebaseAuth.instance.currentUser;
  final now = DateTime.now();

  Color _hexToColor(String hex) {
    return Color(int.parse('0xff${hex.substring(1)}'));
  }

  String _calculateDaysLeft(DateTime endDate, DateTime startDate) {
    final difference = endDate.difference(startDate).inDays;
    return difference >= 0 ? '$difference days left' : 'Expired';
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

  @override
  Widget build(BuildContext context) {
    if (user == null) {
      return Scaffold(
        body: Center(child: Text('Please log in to view quests.')),
      );
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black), // Standard back arrow icon
          onPressed: () {
            // Instead of Navigator.pop(context), navigate explicitly
            // Option 1: Push and remove history (often best for this scenario)
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => MainScreen()), // Replace with YOUR target page
              (Route<dynamic> route) => false, // This predicate removes all previous routes
            );
          },
        ),
        centerTitle: true,
        title: const Text(
          'Current Quests',
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
        actions: [
          IconButton(
            icon: const Icon(Icons.history, color: Colors.black),
            onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => OldQuestPage()),
          );
        },
          ),
        ],
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('users')
            .doc(user!.email)
            .collection('quests')
            .where('endDate', isGreaterThanOrEqualTo: Timestamp.fromDate(now))
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text('No Quests found.'));
          }

          final quests = snapshot.data!.docs.map((doc) {
            var data = doc.data() as Map<String, dynamic>;
            DateTime endDate = (data['endDate'] as Timestamp).toDate();
            DateTime startDate = (data['startDate'] as Timestamp).toDate();
            return {
              'id': doc.id,
              'questName': data['questName'],
              'targetAmount': (data['targetAmount'] as num).toDouble(),
              'savedAmount': (data['savedAmount'] as num).toDouble(),
              'timeLeft': _calculateDaysLeft(endDate, startDate),
              'endDate': endDate,
              'startDate': startDate,
              'imageBase64': data['imageBase64'],
              'backgroundColor': data['backgroundColor'],
            };
          }).toList();

          return ListView.builder(
            padding: const EdgeInsets.only(
              top: 8.0,
              bottom: 8.0,
              left: 8.0,
              right: 8.0,
            ),
            itemCount: quests.length,
            itemBuilder: (context, index) {
              final quest = quests[index];
              return Container(
                margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                child: ClipPath(
                  clipper: RoundedRectClipper(radius: 24.0),
                  child: QuestCard(
                    imageFile: null,
                    imageBase64: quest['imageBase64'],
                    questName: quest['questName'],
                    savedAmount: quest['savedAmount'],
                    targetAmount: quest['targetAmount'],
                    timeLeft: quest['timeLeft'],
                    backgroundColor: _hexToColor(quest['backgroundColor']),
                    onTap: () {
                      showDetailsDialog(
                        context,
                        imageBase64: quest['imageBase64'],
                        questName: quest['questName'],
                        savedAmount: quest['savedAmount'],
                        targetAmount: quest['targetAmount'],
                        timeLeft: quest['timeLeft'],
                        startDate: quest['startDate'],
                        onAddToQuest: (amount) async {
                          await FirebaseFirestore.instance
                              .collection('users')
                              .doc(user!.email)
                              .collection('quests')
                              .doc(quest['id'])
                              .update({
                            'savedAmount': quest['savedAmount'] + amount,
                          });
                          updateBudget(amount);
                          print('Added $amount to quest');
                        },
                        onDeleteQuest: () async {
                          await FirebaseFirestore.instance
                              .collection('users')
                              .doc(user!.email)
                              .collection('quests')
                              .doc(quest['id'])
                              .delete();
                          print('Deleted quest');
                        },
                      );
                    },
                  ),
                )
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xffDAA520), // Goldenrod
        shape: const CircleBorder(),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddQuestPage()),
          );
        },
        child: Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}