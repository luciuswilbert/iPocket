import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:iPocket/pages/quests/quest_card.dart';
import 'package:iPocket/pages/transaction/rounded_rect_clipper.dart';

class OldQuestPage extends StatefulWidget {
  const OldQuestPage({Key? key}) : super(key: key);

  @override
  OldQuestPageState createState() => OldQuestPageState();
}

class OldQuestPageState extends State<OldQuestPage> {
  final user = FirebaseAuth.instance.currentUser;
  final now = DateTime.now();

  Color _hexToColor(String hex) {
    return Color(int.parse('0xff${hex.substring(1)}'));
  }

  String _calculateDaysLeft(DateTime endDate) {
    final difference = endDate.difference(now).inDays.abs() ;
    return '$difference days ago';
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
        centerTitle: true,
        title: const Text(
          'Previous Achievments',
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
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('users')
            .doc(user!.email)
            .collection('quests')
            .where('endDate', isLessThan: Timestamp.fromDate(now))
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
            return  {
              'id': doc.id,
              'questName': data['questName'],
              'targetAmount': (data['targetAmount'] as num).toDouble(),
              'savedAmount': (data['savedAmount'] as num).toDouble(),
              'timeLeft': _calculateDaysLeft(endDate),
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
                    onTap: () {},
                  ),
                )
              );
            },
          );
        },
      ),
    );
  }
}