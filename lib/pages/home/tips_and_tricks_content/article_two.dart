import 'package:flutter/material.dart';

class ArticleTwo extends StatelessWidget {
  const ArticleTwo({Key? key}) : super(key: key);

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
                  '10 Practical Ways to Budget Effectively and Save Money',
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
              'Creating a budget is one of the most effective ways to take control of your finances and save money. Whether you\'re looking to pay off debt, save for a big purchase, or simply manage your spending, a well-structured budget can help you track your expenses and prioritize your financial goals. Here are 10 practical ways to create and stick to a budget that will help you save more money each month.',
              style: TextStyle(fontSize: 14, color: Colors.black87, height: 1.5),
            ),
            const SizedBox(height: 16),

            // Tips Section
            _buildTipSectionWithBullets(
              '1. Set Clear Financial Goals',
              [
                'Before you start budgeting, it\'s essential to know what you are budgeting for. Set clear, measurable goals that will motivate you. This could be anything from saving for a vacation, building an emergency fund, or paying off a loan. Having clear goals will give you something to work towards and make it easier to stay disciplined with your budget.',
              ],
              context,
            ),
            _buildTipSectionWithBullets(
              '2. Track Your Income and Expenses',
              [
                'To build an accurate budget, you need to know exactly how much money is coming in and going out each month. Start by tracking all sources of income, such as your salary, freelance work, or side gigs. Then, track your expenses, including fixed costs like rent or utilities, as well as variable expenses like groceries, entertainment, and transportation.',
              ],
              context,
            ),
            _buildTipSectionWithBullets(
              '3. Categorize Your Spending',
              [
                'Once you have an overview of your income and expenses, it\'s helpful to categorize them. Common categories include:',
                'Fixed Expenses: Rent/mortgage, utilities, insurance premiums.',
                'Variable Expenses: Groceries, entertainment, dining out.',
                'Savings & Investments: Emergency fund, retirement, education savings.',
                'Debt Repayment: Credit card payments, loans, student loans.',
                'By breaking your spending into categories, you\'ll be able to see where you\'re spending the most and where you might be able to cut back.',
              ],
              context,
            ),
            _buildTipSectionWithBullets(
              '4. Prioritize Essential Expenses',
              [
                'When working with a budget, it\'s crucial to prioritize your essential expenses. These are non-negotiable costs like rent or mortgage, utilities, and food. Ensure that your budget covers these expenses first before allocating money to non-essential purchases like entertainment or luxury items.',
              ],
              context,
            ),
            _buildTipSectionWithBullets(
              '5. Use the 50/30/20 Rule',
              [
                'The 50/30/20 rule is a simple budgeting framework that can help you manage your finances effectively:',
                '50% of your income should go towards needs (housing, utilities, transportation, etc.).',
                '30% should go towards wants (entertainment, dining out, travel, etc.).',
                '20% should go towards savings and debt repayment.',
                'This rule can help you balance your spending and ensure you\'re saving enough for future goals while still enjoying life in the present.',
              ],
              context,
            ),
            _buildTipSectionWithBullets(
              '6. Cut Unnecessary Expenses',
              [
                'One of the best ways to save money is to cut out unnecessary expenses. Review your spending and identify areas where you can reduce costs. This could include canceling unused subscriptions, cutting back on eating out, or finding cheaper alternatives for certain services. Even small changes can add up over time.',
              ],
              context,
            ),
            _buildTipSectionWithBullets(
              '7. Automate Your Savings',
              [
                'One of the most effective ways to ensure you stick to your savings goals is by automating the process. Set up automatic transfers to a savings account each month so that you don’t have to think about it. This could be a percentage of your income or a fixed amount. Automating your savings ensures that you\'re consistently putting money aside for your goals, even if you\'re tempted to spend.',
              ],
              context,
            ),
            _buildTipSectionWithBullets(
              '8. Use Your App for Tracking',
              [
                'If you’re struggling to stay on top of your budget, consider using an app like iPocket, your personal finance assistant. With iPocket, you can easily track your spending, set budgets for different categories, and get insights into where your money is going. You can also set savings goals, keep an eye on your progress, and get reminders to stay on track with your financial plans.',
                'iPocket’s user-friendly interface makes it easy to stick to your budget and track your progress toward your financial goals, all in one place.',
              ],
              context,
            ),
            _buildTipSectionWithBullets(
              '9. Review Your Budget Regularly',
              [
                'Creating a budget is not a one-time task—it’s something that needs to be reviewed and updated regularly. Make it a habit to review your budget at least once a month. Look at your expenses, see if you are sticking to your goals, and make adjustments as needed. If you’ve received a raise or if you’ve cut back on certain expenses, update your budget to reflect these changes.',
              ],
              context,
            ),
            _buildTipSectionWithBullets(
              '10. Stay Flexible',
              [
                'Life is unpredictable, and sometimes unexpected expenses come up. While it’s important to stick to your budget, it’s also essential to be flexible. If something comes up, like a car repair or medical expense, make adjustments to your budget. This could mean reducing your spending in other categories temporarily or dipping into your emergency fund. Flexibility will help you stay on track even when life throws a curveball.',
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
              'Budgeting doesn’t have to be complicated or restrictive. By setting clear goals, tracking your income and expenses, and being proactive about saving, you can create a budget that works for you. Apps like iPocket can also simplify the process, providing tools and insights to help you stay on top of your finances. Remember to review your budget regularly, stay flexible, and always be mindful of your long-term financial goals. By following these steps, you’ll be on your way to saving more and spending less.',
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