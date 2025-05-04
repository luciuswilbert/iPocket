// lib/pages/home/reduce_page.dart

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ReducePage extends StatefulWidget {
  const ReducePage({Key? key}) : super(key: key);
  @override
  State<ReducePage> createState() => _ReducePageState();
}

class _ReducePageState extends State<ReducePage> {
  bool _loading = true;
  List<String> _tips = [];
  double _estimatedSavings = 0.0;
  double _salary = 1.0;

  @override
  void initState() {
    super.initState();
    _loadReduceData();
  }

  Future<void> _loadReduceData() async {
    final user = FirebaseAuth.instance.currentUser!;
    final now = DateTime.now();
    final startOfMonth = DateTime(now.year, now.month, 1);

    // Fetch transactions
    final txSnap = await FirebaseFirestore.instance
        .collection('users')
        .doc(user.email)
        .collection('transactions')
        .where('dateTime', isGreaterThanOrEqualTo: startOfMonth)
        .get();

    // Aggregate spend by category
    final totals = <String, double>{};
    for (var doc in txSnap.docs) {
      final data = doc.data();
      final amt = (data['amount'] as num).toDouble();
      final cat = data['category'] as String;
      totals[cat] = (totals[cat] ?? 0) + amt;
    }

    // Fetch salary
    final prof = await FirebaseFirestore.instance
        .collection('users')
        .doc(user.email)
        .get();
    final salary = (prof.data()?['monthlyIncome'] as num?)?.toDouble() ?? 0.0;

    // Estimate savings via AI
    final tipPrompt = StringBuffer()
      ..writeln("Generate a short money-saving tips article.")
      ..writeln("Monthly income: RM${salary.toStringAsFixed(0)}")
      ..writeln("Spending this month:")
      ..writeAll(totals.entries.map(
          (e) => "- ${e.key}: RM${e.value.toStringAsFixed(2)}\n"))
      ..writeln()
      ..writeln("Structure:")
      ..writeln("Introduction (1–2 sentences).")
      ..writeln("Then 3 sections for the top 3 spend categories (Bold this text), each with:")
      ..writeln("  Section heading = category name")
      ..writeln("  Why it helps: a brief sentence")
      ..writeln("  How to do it: 3 bullet points (1–2 sentences each).")
      ..writeln()
      ..writeln("Use plain text only, no markdown or asterisks.");

    final apiKey = dotenv.env['GEMINI_API_KEY']!;
    List<String> tips;
    double estimatedSavings = 0.0;

    try {
      final model = GenerativeModel(model: 'gemini-1.5-flash', apiKey: apiKey);
      final resp = await model.generateContent([
        Content.text(tipPrompt.toString()),
      ]);
      final text = resp.text!.trim();
      tips = text
          .split(RegExp(r'\n[-•]\s*'))
          .map((s) => s.trim())
          .where((s) => s.isNotEmpty)
          .toList();

      // Now ask AI to estimate savings:
      final savePrompt = StringBuffer()
        ..writeln("My monthly income is RM${salary.toStringAsFixed(0)}.")
        ..writeln("My spending by category:")
        ..writeAll(totals.entries.map(
            (e) => "- ${e.key}: RM${e.value.toStringAsFixed(2)}\n"))
        ..writeln()
        ..writeln("Here are the tips you provided:")
        ..writeAll(tips.map((t) => "- $t\n"))
        ..writeln()
        ..writeln("Estimate how much I could save in RM per month by following these tips. Return only a number.");
      final resp2 = await model.generateContent([
        Content.text(savePrompt.toString()),
      ]);
      final match = resp2.text != null
          ? RegExp(r'\d+(\.\d+)?').firstMatch(resp2.text!)
          : null;
      if (match != null) estimatedSavings = double.parse(match.group(0)!);
    } catch (_) {
      tips = ['Unable to fetch tips right now.'];
    }

    setState(() {
      _salary = salary > 0 ? salary : 1.0;
      _estimatedSavings = estimatedSavings;
      _tips = tips;
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(title: const Text('Reduce Spending')),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    final ratio = (_estimatedSavings / _salary).clamp(0.0, 1.0);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Reduce Spending'),
        backgroundColor: const Color(0xffDAA520),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.only(bottom: 24),
        children: [
          // Aesthetic Projected Savings Card
          Card(
            color: Colors.white,
            margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            elevation: 8,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
              side: const BorderSide(color: Color(0xffDAA520), width: 1.5),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  Text(
                    'Projected Monthly Savings',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey[800],
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'RM${_estimatedSavings.toStringAsFixed(0)}',
                    style: const TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Colors.green,
                    ),
                  ),
                  const SizedBox(height: 12),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: LinearProgressIndicator(
                      value: ratio,
                      minHeight: 8,
                      backgroundColor: Colors.grey.shade200,
                      color: Colors.green,
                    ),
                  ),
                  const SizedBox(height: 16),
                  // ElevatedButton(
                  //   onPressed: () {
                  //     // TODO: schedule reminders
                  //   },
                  //   style: ElevatedButton.styleFrom(
                  //     backgroundColor: const Color(0xffDAA520),
                  //     padding: const EdgeInsets.symmetric(
                  //         horizontal: 24, vertical: 12),
                  //     shape: RoundedRectangleBorder(
                  //       borderRadius: BorderRadius.circular(12),
                  //     ),
                  //     elevation: 4,
                  //   ),
                  //   child: const Text(
                  //     'Set Reminders',
                  //     style: TextStyle(fontSize: 16, color: Colors.white),
                  //   ),
                  // ),
                ],
              ),
            ),
          ),

          // AI-generated Tips
          if (_tips.isNotEmpty) ...[
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                'Smart Tips',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 12),
            ..._tips.map((tip) => _buildBulletPoint(tip)).toList(),
          ] else
            const Center(child: Text('No tips available.')),
        ],
      ),
    );
  }

  Widget _buildBulletPoint(String text) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.check_circle, size: 20, color: Color(0xffDAA520)),
          const SizedBox(width: 8),
          Expanded(
            child: Text(text,
                style: const TextStyle(
                    fontSize: 14, color: Colors.black87, height: 1.5)),
          ),
        ],
      ),
    );
  }
}
