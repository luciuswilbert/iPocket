import 'package:flutter/material.dart';

class ArticleFive extends StatelessWidget {
  const ArticleFive({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'Money-Saving Tips',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        backgroundColor: const Color(0xffDAA520),
        elevation: 0,
        automaticallyImplyLeading: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Main Title
            const Center(
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 16.0),
                child: Text(
                  'Master Your Finances: 7 Essential Tips for Effective Expense Budgeting',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            // Introduction Section
            const Text(
              'Introduction',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Effective budgeting is crucial for managing your finances, cutting unnecessary expenses, and saving money for future goals. By following a clear budgeting strategy and making small, consistent changes, you can take control of your spending and work toward achieving your financial goals. Here are 7 essential tips to help you master your budgeting.',
              style: TextStyle(fontSize: 14, color: Colors.black87, height: 1.5),
            ),
            const SizedBox(height: 16),

            // Tips Section
            _buildTipSectionWithBullets(
              '1. Set Clear Financial Goals',
              [
                'Why it helps: Having specific financial goals helps you stay focused and motivated. Whether it’s saving for a vacation, a down payment on a home, or an emergency fund, clear goals guide your budgeting decisions.',
                'How to do it: Set short-term and long-term goals. For example, aim to save \$500 for a new gadget or \$3,000 for an emergency fund. Break these goals down into manageable steps that you can track over time.',
              ],
              context,
            ),
            _buildTipSectionWithBullets(
              '2. Track Every Expense',
              [
                'Why it helps: Knowing exactly where your money is going allows you to identify unnecessary spending. Tracking your expenses can reveal habits that need adjusting, such as overspending on dining out or subscriptions.',
                'How to do it: Record all of your expenses to better understand where you’re spending your money. You can use iPocket to track your expenses and categorize them to ensure you\'re staying within budget.',
              ],
              context,
            ),
            _buildTipSectionWithBullets(
              '3. Create a Realistic Budget',
              [
                'Why it helps: A budget is a plan for your money. It tells you exactly how much you should spend on necessities and how much you should save or invest.',
                'How to do it: Begin by listing your monthly income and essential expenses like rent, utilities, and loan payments. Then, set aside a portion of your income for savings and discretionary spending (entertainment, shopping, etc.). Be realistic about what you can afford to spend.',
              ],
              context,
            ),
            _buildTipSectionWithBullets(
              '4. Review Your Budget Regularly',
              [
                'Why it helps: Your financial situation may change over time, and your budget should reflect these changes. Regularly reviewing your budget ensures it stays relevant and helps you adjust if needed.',
                'How to do it: Set a reminder to review your budget monthly. Make adjustments as your income or expenses change. For example, if you get a raise or experience a large unexpected expense, tweak your budget accordingly.',
              ],
              context,
            ),
            _buildTipSectionWithBullets(
              '5. Cut Unnecessary Expenses',
              [
                'Why it helps: Reducing unnecessary expenses helps you free up more money to save or invest. Small changes can lead to big savings over time.',
                'How to do it: Analyze your spending and identify areas where you can cut back. For example, you can cancel subscriptions you don’t use, limit dining out, or shop for sales. Adjust your spending based on the categories where you\'re overspending.',
              ],
              context,
            ),
            _buildTipSectionWithBullets(
              '6. Automate Your Savings',
              [
                'Why it helps: Automating savings ensures you consistently set money aside for future needs without having to think about it. This is especially useful for building an emergency fund or saving for big goals.',
                'How to do it: Set up an automatic transfer to your savings account or investment account each payday. Consider using a feature in iPocket to set savings goals, so you’re automatically reminded to contribute a specific amount each month.',
              ],
              context,
            ),
            _buildTipSectionWithBullets(
              '7. Be Flexible and Patient',
              [
                'Why it helps: Budgets are not set in stone. Life can be unpredictable, and flexibility will help you stay on track even during financial setbacks. Patience is key to maintaining your budget in the long run.',
                'How to do it: Don’t get discouraged if you don’t meet your budget goals every month. Stay committed to your plan, and adjust it as needed to accommodate unforeseen events, like medical expenses or job changes.',
              ],
              context,
            ),

            // Conclusion Section
            const SizedBox(height: 16),
            const Text(
              'Conclusion',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Mastering your finances through effective budgeting is essential for saving money and achieving your financial goals. By setting clear goals, tracking expenses, cutting unnecessary spending, and automating savings, you can take control of your financial future. Stay consistent and make small adjustments along the way, and you\'ll be well on your way to financial success.',
              style: TextStyle(fontSize: 14, color: Colors.black87, height: 1.5),
            ),
          ],
        ),
      ),
    );
  }

  // Method to build each Tip Section with Bullet Points
  Widget _buildTipSectionWithBullets(String title, List<String> content, BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Color(0xffDAA520),
          ),
        ),
        const SizedBox(height: 8),
        ...content.map((text) => _buildBulletPoint(text)).toList(),
        const SizedBox(height: 16),
      ],
    );
  }

  Widget _buildBulletPoint(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.check_circle,
            size: 16,
            color: Color(0xffDAA520),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(
                fontSize: 14,
                color: Colors.black87,
                height: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }
}