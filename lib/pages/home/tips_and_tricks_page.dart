import 'package:flutter/material.dart';
import 'package:iPocket/pages/home/tips_and_tricks_content/article_five.dart';
import 'package:iPocket/pages/home/tips_and_tricks_content/article_four.dart' show ArticleFour;
import 'package:iPocket/pages/home/tips_and_tricks_content/article_one.dart';
import 'package:iPocket/pages/home/tips_and_tricks_content/article_three.dart';
import 'package:iPocket/pages/home/tips_and_tricks_content/article_two.dart';

class TipsAndTricksPage extends StatelessWidget {
  const TipsAndTricksPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'Tips & Tricks',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        backgroundColor: const Color(0xffDAA520),
        elevation: 0,
        automaticallyImplyLeading: false,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.black,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            const Text(
              'Money-Saving Tips',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 16),

            // Tip Card 1
            _buildTipCard(
              context,
              icon: Icons.account_balance_wallet,
              title: '50 Smart Ways to Cut Expenses and Save More Money Every Month',
              readTime: '5 min read',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const ArticleOne(), // Updated class name
                  ),
                );
              },
            ),
            const SizedBox(height: 16),

            // Placeholder for Tip 2
            _buildTipCard(
              context,
              icon: Icons.account_balance,
              title: '10 Practical Ways to Budget Effectively and Save Money',
              readTime: '3 min read',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const ArticleTwo(), // Updated class name
                  ),
                );
              },
            ),
            const SizedBox(height: 16),

            // Placeholder for Tip 3
            _buildTipCard(
              context,
              icon: Icons.money_off,
              title: 'How to Slash Your Monthly Bills: 10 Simple Hacks to Save Big',
              readTime: '4 min read',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const ArticleThree(), // Assuming you have ArticleThree
                  ),
                );
              },
            ),
            const SizedBox(height: 16),

            // Placeholder for Tip 4
            _buildTipCard(
              context,
              icon: Icons.savings, // Changed icon to savings
              title: 'Frugal Living: Proven Strategies to Spend Less and Save More', // Updated title
              readTime: '5 min read', // Updated read time
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const ArticleFour(),
                  ),
                );
              },
            ),
            const SizedBox(height: 16),

            // Placeholder for Tip 5
            _buildTipCard(
              context,
              icon: Icons.trending_up, // Changed to a more relevant icon
              title: 'Master Your Finances: 7 Essential Tips for Effective Expense Budgeting',
              readTime: '4-5 min read',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const ArticleFive(),
                  ),
                );
              },
            ),
            const SizedBox(height: 16),

            // Placeholder for Tip 6
            _buildTipCard(
              context,
              icon: Icons.lightbulb_outline,
              title: 'Tip 6 (Coming Soon)',
              readTime: 'TBD',
              onTap: () {
                _showTipDetails(context, 'Tip 6', 'Content coming soon!');
              },
            ),
            const SizedBox(height: 16),

            // Placeholder for Tip 7
            _buildTipCard(
              context,
              icon: Icons.lightbulb_outline,
              title: 'Tip 7 (Coming Soon)',
              readTime: 'TBD',
              onTap: () {
                _showTipDetails(context, 'Tip 7', 'Content coming soon!');
              },
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  // Reusable Tip Card Widget
  Widget _buildTipCard(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String readTime,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: Colors.grey[100],
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              blurRadius: 4,
              offset: const Offset(2, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            // Icon
            Container(
              padding: const EdgeInsets.all(8.0),
              decoration: BoxDecoration(
                color: Colors.yellow[100],
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                icon,
                size: 30,
                color: Colors.yellow[800],
              ),
            ),
            const SizedBox(width: 16),

            // Title and Read Time
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    readTime,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Show Tip Details in a Dialog (for placeholders)
  void _showTipDetails(BuildContext context, String title, String content) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        content: Text(content),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }
}