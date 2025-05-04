import 'package:flutter/material.dart';

class ArticleOne extends StatelessWidget {
  const ArticleOne({Key? key}) : super(key: key);

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
            // Main Title
            const Center(
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 16.0),
                child: Text(
                  '50 Smart Ways to Cut Expenses and Save More Money Every Month',
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
              'In today\'s economy, saving money is more important than ever. Cutting expenses doesn’t mean sacrificing your lifestyle—it means making smarter financial choices. Here are 50 effective ways to reduce expenses while maintaining a comfortable lifestyle.',
              style: TextStyle(
                fontSize: 14,
                color: Colors.black87,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 16),

            // Housing & Utilities Section
            const Text(
              'Housing & Utilities',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Color(0xffDAA520),
              ),
            ),
            const SizedBox(height: 8),
            _buildBulletPoint('Downsize your home – If you’re living in a space that’s bigger than you need, moving to a smaller home can save on rent, mortgage, and utility costs.'),
            _buildBulletPoint('Negotiate your rent or mortgage – Landlords and banks may be willing to lower payments for long-term tenants or refinanced loans.'),
            _buildBulletPoint('Use energy-efficient appliances – ENERGY STAR-rated appliances consume less power, reducing your electricity bill.'),
            _buildBulletPoint('Unplug electronics when not in use – Phantom power from plugged-in devices can add up over time.'),
            _buildBulletPoint('Switch to LED bulbs – LED bulbs last longer and use far less electricity than traditional incandescent bulbs.'),
            const SizedBox(height: 16),

            // Food & Grocery Savings Section
            const Text(
              'Food & Grocery Savings',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Color(0xffDAA520),
              ),
            ),
            const SizedBox(height: 8),
            _buildBulletPoint('Plan your meals – A weekly meal plan prevents impulse food purchases and minimizes food waste.'),
            _buildBulletPoint('Use grocery store loyalty programs – Many stores offer discounts or cashback on purchases.'),
            _buildBulletPoint('Buy generic brands – Often, store-brand products are just as good as name brands at a lower cost.'),
            _buildBulletPoint('Avoid shopping when hungry – You’ll be less likely to make impulse purchases.'),
            _buildBulletPoint('Grow your own herbs and vegetables – Even a small garden can save money on produce.'),
            const SizedBox(height: 16),

            // Transportation Savings Section
            const Text(
              'Transportation Savings',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Color(0xffDAA520),
              ),
            ),
            const SizedBox(height: 8),
            _buildBulletPoint('Use public transportation – Monthly passes are cheaper than daily commutes by car.'),
            _buildBulletPoint('Carpool or rideshare – Sharing rides reduces fuel costs significantly.'),
            _buildBulletPoint('Maintain your vehicle – Regular maintenance helps prevent costly repairs.'),
            _buildBulletPoint('Use fuel price comparison apps – Find the cheapest gas stations near you.'),
            _buildBulletPoint('Consider biking or walking for short trips – It’s free and great for your health.'),
            const SizedBox(height: 16),

            // Entertainment & Subscriptions Section
            const Text(
              'Entertainment & Subscriptions',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Color(0xffDAA520),
              ),
            ),
            const SizedBox(height: 8),
            _buildBulletPoint('Cancel unused subscriptions – Audit streaming services, gym memberships, and magazine subscriptions.'),
            _buildBulletPoint('Utilize free entertainment – Libraries offer free books, movies, and events.'),
            _buildBulletPoint('Share streaming services – Many platforms allow family sharing.'),
            _buildBulletPoint('Find free community events – Local parks, museums, and town events often have free admission.'),
            _buildBulletPoint('DIY hobbies instead of costly activities – Painting, reading, and home workouts are great budget-friendly hobbies.'),
            const SizedBox(height: 16),

            // Shopping & Lifestyle Adjustments Section
            const Text(
              'Shopping & Lifestyle Adjustments',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Color(0xffDAA520),
              ),
            ),
            const SizedBox(height: 8),
            _buildBulletPoint('Buy second-hand – Thrift stores and online marketplaces have great deals.'),
            _buildBulletPoint('Use cashback apps – Apps like Rakuten and Honey offer rebates and discounts.'),
            _buildBulletPoint('Follow the 24-hour rule – Wait a day before making non-essential purchases.'),
            _buildBulletPoint('Try minimalism – Owning fewer things means spending less money.'),
            _buildBulletPoint('Repair instead of replace – Fix items before considering a new purchase.'),
            const SizedBox(height: 16),

            // Closing Note
            const Text(
              'The full list continues, but applying just a few of these tips can make a noticeable difference in your savings!',
              style: TextStyle(
                fontSize: 14,
                fontStyle: FontStyle.italic,
                color: Colors.black87,
              ),
            ),
          ],
        ),
      ),
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