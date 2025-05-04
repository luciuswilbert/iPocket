import 'package:flutter/material.dart';

class ArticleFour extends StatelessWidget {
  const ArticleFour({Key? key}) : super(key: key);

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
                  'Frugal Living: Proven Strategies to Spend Less and Save More',
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
              'Adopting a frugal lifestyle doesn’t mean you have to compromise on quality of life. It’s about making smarter, more mindful choices that allow you to keep more money in your pocket while still enjoying the things you love. Here are proven strategies that will help you spend less and save more.',
              style: TextStyle(fontSize: 14, color: Colors.black87, height: 1.5),
            ),
            const SizedBox(height: 16),

            // Tips Section
            _buildTipSectionWithBullets(
              '1. Track Your Spending',
              [
                'Why it helps: You can\'t cut costs if you don\'t know where your money is going. Tracking your spending helps you identify unnecessary expenses.',
                'How to do it: Use a simple app like iPocket to track daily expenses, or keep a journal where you record everything you spend. Look for patterns and areas where you can reduce spending.',
              ],
              context,
            ),
            _buildTipSectionWithBullets(
              '2. Shop with a List',
              [
                'Why it helps: Impulse buys can add up quickly. Shopping with a list prevents you from picking up unplanned items.',
                'How to do it: Before heading out to the store, make a list of exactly what you need, and stick to it. This strategy works best when combined with planning meals ahead of time.',
              ],
              context,
            ),
            _buildTipSectionWithBullets(
              '3. Cut Out Unnecessary Subscriptions',
              [
                'Why it helps: Monthly subscriptions for services you rarely use can silently drain your account. Canceling those subscriptions can provide instant savings.',
                'How to do it: Review all your subscriptions (streaming services, gym memberships, magazine subscriptions, etc.) and eliminate any you don’t need or use regularly.',
              ],
              context,
            ),
            _buildTipSectionWithBullets(
              '4. Buy Second-Hand',
              [
                'Why it helps: Second-hand items can be just as good as new ones, and they often come at a fraction of the price. This applies to everything from furniture to clothing.',
                'How to do it: Shop at thrift stores, garage sales, or online marketplaces for high-quality, gently used items. You\'ll be surprised at the bargains you can find.',
              ],
              context,
            ),
            _buildTipSectionWithBullets(
              '5. Use Coupons and Discounts',
              [
                'Why it helps: Coupons, promotional codes, and sales events allow you to buy the same products for less. Over time, this can lead to significant savings.',
                'How to do it: Before making any purchase, search for discounts or coupons. Many stores offer digital coupons through their websites or apps, or you can use sites like RetailMeNot for promo codes.',
              ],
              context,
            ),
            _buildTipSectionWithBullets(
              '6. Switch to Generic Brands',
              [
                'Why it helps: Generic products often offer the same quality as brand-name items but at a significantly lower cost.',
                'How to do it: Try switching to store brands for grocery items, household products, and even over-the-counter medications. You’ll often find the same ingredients or materials at a much lower price.',
              ],
              context,
            ),
            _buildTipSectionWithBullets(
              '7. Limit Eating Out',
              [
                'Why it helps: Restaurants and takeout can eat up a large portion of your budget. Eating out less often frees up money for savings.',
                'How to do it: Plan meals at home and try cooking in batches to save both time and money. If you do eat out, look for deals or discount days, and consider sharing meals to cut costs.',
              ],
              context,
            ),
            _buildTipSectionWithBullets(
              '8. Negotiate Bills',
              [
                'Why it helps: Many service providers (like internet, cable, and insurance companies) are willing to offer lower rates to retain customers. Negotiating your bills can reduce monthly expenses.',
                'How to do it: Call your providers and ask for discounts or to match lower rates offered by competitors. You’d be surprised at how many companies will lower your bill to keep your business.',
              ],
              context,
            ),
            _buildTipSectionWithBullets(
              '9. Practice Minimalism',
              [
                'Why it helps: Living with less allows you to focus on what truly matters, reducing unnecessary spending. It’s about quality, not quantity.',
                'How to do it: Evaluate your belongings and eliminate items that no longer serve a purpose. Instead of constantly buying new things, invest in high-quality, durable items that will last longer.',
              ],
              context,
            ),
            _buildTipSectionWithBullets(
              '10. Automate Savings',
              [
                'Why it helps: One of the easiest ways to save is to automate the process. By setting up automatic transfers to your savings account, you’ll save without even thinking about it.',
                'How to do it: Set up an automatic transfer from your checking account to your savings account every payday. Even a small amount adds up over time and can help you build an emergency fund.',
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
              'Frugal living is all about making conscious choices that allow you to live well without overspending. By implementing these strategies, you can significantly cut your expenses and start saving more each month. The key is consistency—small changes add up over time, leading to big savings.',
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