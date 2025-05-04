import 'package:flutter/material.dart';

class ArticleThree extends StatelessWidget {
  const ArticleThree({Key? key}) : super(key: key);

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
                  'How to Slash Your Monthly Bills: 10 Simple Hacks to Save Big',
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
              'Monthly bills can quickly accumulate and take a large portion of your income. While some expenses, like rent or mortgage, are non-negotiable, there are plenty of other ways to cut back on everyday costs. With a few strategic moves, you can drastically reduce your monthly bills and free up more of your income for savings or other priorities. Here are 10 simple hacks to help you slash your monthly bills and start saving big.',
              style: TextStyle(fontSize: 14, color: Colors.black87, height: 1.5),
            ),
            const SizedBox(height: 16),

            // Tips Section
            _buildTipSectionWithBullets(
              '1. Negotiate Your Rent or Mortgage',
              [
                'Your housing payment is often your biggest monthly expense. If you’ve been a long-time renter, it’s worth negotiating your rent with your landlord. Many landlords are willing to lower rent for reliable tenants, especially if you’re willing to sign a longer lease. If you own a home, consider refinancing your mortgage for a lower interest rate or exploring other options that could reduce your monthly payment.',
              ],
              context,
            ),
            _buildTipSectionWithBullets(
              '2. Switch to Energy-Efficient Appliances',
              [
                'Energy bills can quickly add up, but there are simple ways to cut back on electricity costs. Start by switching to energy-efficient appliances, such as LED light bulbs, energy-efficient refrigerators, and washing machines. These appliances consume less power and lower your electricity bill over time. Additionally, consider using a smart thermostat to better control your heating and cooling costs.',
              ],
              context,
            ),
            _buildTipSectionWithBullets(
              '3. Cancel Unused Subscriptions',
              [
                'Subscriptions are sneaky expenses that often go unnoticed until they show up on your credit card statement. Review all your subscriptions—streaming services, gym memberships, and magazine subscriptions—and cancel any you don’t use regularly. Many people are paying for services they no longer need or barely use. Cutting out these unnecessary subscriptions can free up a significant amount of money each month.',
              ],
              context,
            ),
            _buildTipSectionWithBullets(
              '4. Downsize Your Cable or Phone Plan',
              [
                'Cable bills are notoriously expensive, but you don’t have to settle for pricey packages. Consider downgrading your cable package or switching to a cheaper streaming service. You can also cut the cord altogether and rely on streaming platforms for entertainment. Similarly, review your phone plan to ensure you’re not paying for more data or features than you need. Switching to a more basic plan can save you a substantial amount each month.',
              ],
              context,
            ),
            _buildTipSectionWithBullets(
              '5. Switch to Generic Brands',
              [
                'Whether it’s groceries, over-the-counter medications, or household supplies, switching to generic brands is a great way to save on everyday expenses. Generic brands are typically just as good as name-brand products but are often sold at a fraction of the price. Start substituting your favorite name-brand items with their generic counterparts, and you’ll start noticing big savings over time.',
              ],
              context,
            ),
            _buildTipSectionWithBullets(
              '6. Use Public Transportation or Carpool',
              [
                'Transportation is another area where you can save big. If possible, switch to public transportation instead of driving your car. Not only will you save on gas, but you\'ll also avoid car maintenance costs and parking fees. If public transportation isn’t an option, try carpooling with coworkers or friends. Sharing a ride can reduce your fuel costs and allow you to split expenses.',
              ],
              context,
            ),
            _buildTipSectionWithBullets(
              '7. Refinance Your Loans',
              [
                'If you have outstanding loans, such as student loans, personal loans, or credit card debt, consider refinancing them to lower your interest rates. Refinancing can help you reduce your monthly payments and save money in the long run. Check with your bank or other lenders to explore your options for consolidating or refinancing loans.',
              ],
              context,
            ),
            _buildTipSectionWithBullets(
              '8. Take Advantage of Free Activities',
              [
                'Entertainment costs can quickly add up if you’re always going out to movies, concerts, or restaurants. Instead, take advantage of free or low-cost activities in your community. Many local parks, museums, and libraries offer free events or admission days. You can also enjoy outdoor activities like hiking or biking, which are both free and great for your health.',
              ],
              context,
            ),
            _buildTipSectionWithBullets(
              '9. Cut Back on Dining Out',
              [
                'Dining out is a luxury that adds up quickly, especially if you eat out multiple times a week. To cut your food expenses, try cooking at home more often. Meal prepping and cooking in bulk can save both time and money. Not only will you save on restaurant bills, but you’ll also have more control over your meals, which can lead to healthier eating habits.',
              ],
              context,
            ),
            _buildTipSectionWithBullets(
              '10. Bundle Your Insurance Policies',
              [
                'Insurance premiums, whether for auto, home, or health, are another major monthly expense. Many insurers offer discounts when you bundle multiple policies together. For example, you might save money by combining your car and home insurance policies with the same provider. Shop around and compare rates to ensure you’re getting the best deal and consider bundling your policies for additional savings.',
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
              'Slashing your monthly bills doesn’t require radical changes to your lifestyle. By implementing these 10 simple hacks, you can significantly reduce your monthly expenses and free up more money for savings or other financial goals. Start with a few changes and gradually make more adjustments as you go. Small changes can add up to big savings over time, helping you keep more of your hard-earned money.',
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