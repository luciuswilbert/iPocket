// lib/pages/home/invest_page.dart

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class InvestPage extends StatefulWidget {
  const InvestPage({Key? key}) : super(key: key);

  @override
  State<InvestPage> createState() => _InvestPageState();
}

class _InvestPageState extends State<InvestPage> {
  bool _loading = true;
  double _investableBalance = 0.0;
  int _selectedTier = -1; // 0=Low, 1=Medium, 2=High
  final List<String> _tiers = ['Low Risk', 'Medium Risk', 'High Risk'];
  final Map<String, List<Map<String, String>>> _suggestions = {
    'Low Risk': [
      {
        'name': 'High-Yield Savings Account',
        'rationale': 'Interest ~2% APY',
        'desc': 'Online savings accounts that pay higher rates than traditional banks.',
      },
      {
        'name': '1-Year Fixed Deposit',
        'rationale': 'Interest ~3% p.a.',
        'desc': 'Lock up funds at a bank for one year at a guaranteed rate.',
      },
      {
        'name': 'Gold',
        'rationale': 'Up ~2% last quarter',
        'desc': 'Physical gold or a gold ETF as a hedge against inflation.',
      },
      {
        'name': 'Silver',
        'rationale': 'Up ~3% last quarter',
        'desc': 'Less expensive than gold, with both industrial and store-of-value demand.',
      },
      {
        'name': 'Corporate Bond Fund',
        'rationale': 'Yield ~3.2% p.a.',
        'desc': 'Pooled investment-grade corporate bonds for stable income.',
      },
    ],

    'Medium Risk': [
      {
        'name': 'Apple (AAPL)',
        'rationale': 'Up ~10% last quarter',
        'desc': 'World’s largest tech company with steady earnings and dividends.',
      },
      {
        'name': 'Microsoft (MSFT)',
        'rationale': 'Up ~8% last quarter',
        'desc': 'Leader in cloud, software, and gaming with low single-stock risk.',
      },
      {
        'name': 'Johnson & Johnson (JNJ)',
        'rationale': 'Dividend ~2.8%',
        'desc': 'Household health & consumer products giant with decades of payouts.',
      },
      {
        'name': 'Coca-Cola (KO)',
        'rationale': 'Dividend ~3%',
        'desc': 'Global beverage powerhouse with recession-resilient cash flows.',
      },
      {
        'name': 'Procter & Gamble (PG)',
        'rationale': 'Dividend ~2.5%',
        'desc': 'Top consumer-goods maker selling everyday essentials worldwide.',
      },
    ],

    'High Risk': [
      {
        'name': 'Bitcoin (BTC)',
        'rationale': 'Volatile ±15%',
        'desc': 'Largest cryptocurrency—high reward, high price swings.',
      },
      {
        'name': 'Ethereum (ETH)',
        'rationale': 'Volatile ±20%',
        'desc': 'Smart-contract blockchain powering DeFi and NFTs.',
      },
      {
        'name': 'Solana (SOL)',
        'rationale': 'Volatile ±25%',
        'desc': 'High-speed blockchain platform with rapid growth and risk.',
      },
      {
        'name': 'Tesla (TSLA)',
        'rationale': 'Up ~20% last quarter',
        'desc': 'EV innovator—major upside potential and high valuation swings.',
      },
      {
        'name': 'NVIDIA (NVDA)',
        'rationale': 'Up ~25% last quarter',
        'desc': 'Leader in GPUs and AI hardware—big growth with volatility.',
      },
    ],
  };


  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() => _loading = true);

    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final doc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.email)
          .get();
      final rawBudget = doc.data()?['budget'];
      final budget = rawBudget is num
          ? rawBudget.toDouble()
          : double.tryParse(rawBudget.toString()) ?? 0.0;
      setState(() {
        _investableBalance = budget;
      });
    }

    setState(() => _loading = false);
  }

  IconData _iconFor(String name) {
    switch (name) {
      case 'High-Yield Savings Account':
        return Icons.savings;
      case '1-Year Fixed Deposit':
        return Icons.lock;
      case 'Gold':
        return Icons.emoji_events;
      case 'Silver':
        return Icons.emoji_events;
      case 'Corporate Bond Fund':
        return Icons.account_balance;
      case 'Apple (AAPL)':
        return Icons.phone_iphone;
      case 'Microsoft (MSFT)':
        return Icons.desktop_windows;
      case 'Johnson & Johnson (JNJ)':
        return Icons.health_and_safety;
      case 'Coca-Cola (KO)':
        return Icons.local_drink;
      case 'Procter & Gamble (PG)':
        return Icons.shopping_bag;
      case 'Bitcoin (BTC)':
        return Icons.currency_bitcoin;
      case 'Ethereum (ETH)':
        return Icons.flash_on;
      case 'Solana (SOL)':
        return Icons.sync_alt;
      case 'Tesla (TSLA)':
        return Icons.electric_car;
      case 'NVIDIA (NVDA)':
        return Icons.memory;
      default:
        return Icons.show_chart;
    }
  }

  Color _iconColorFor(String name) {
    switch (name) {
      case 'High-Yield Savings Account':
        return Colors.green;
      case '1-Year Fixed Deposit':
        return Colors.blue;
      case 'Gold':
        return Colors.amber;
      case 'Silver':
        return Colors.grey;
      case 'Corporate Bond Fund':
        return Colors.teal;
      case 'Apple (AAPL)':
        return Colors.black;
      case 'Microsoft (MSFT)':
        return Colors.blue;
      case 'Johnson & Johnson (JNJ)':
        return Colors.redAccent;
      case 'Coca-Cola (KO)':
        return Colors.red;
      case 'Procter & Gamble (PG)':
        return Colors.indigo;
      case 'Bitcoin (BTC)':
        return Colors.orange;
      case 'Ethereum (ETH)':
        return Colors.deepPurple;
      case 'Solana (SOL)':
        return Colors.tealAccent;
      case 'Tesla (TSLA)':
        return Colors.red;
      case 'NVIDIA (NVDA)':
        return Colors.greenAccent;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: const Text('Invest Suggestions'),
          backgroundColor: const Color(0xffDAA520),
          centerTitle: true,
        ),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Invest Suggestions'),
        backgroundColor: const Color(0xffDAA520),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(vertical: 24),
        children: [
          // Investable Balance Card
          Card(
            color: Colors.white,
            margin: const EdgeInsets.symmetric(horizontal: 20),
            elevation: 8,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
              side: const BorderSide(color: Color(0xffDAA520), width: 1.5),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  const Icon(Icons.account_balance_wallet,
                      color: Color(0xffDAA520), size: 32),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Investable Balance',
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold)),
                        const SizedBox(height: 4),
                        Text(
                          'RM${_investableBalance.toStringAsFixed(2)}',
                          style: const TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                              color: Colors.green),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.refresh, color: Color(0xffDAA520)),
                    onPressed: _loadData,
                  )
                ],
              ),
            ),
          ),

          const SizedBox(height: 24),

          // Smart Pick banner
          Card(
            color: Colors.green.shade50,
            margin: const EdgeInsets.symmetric(horizontal: 20),
            elevation: 4,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16)),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text('Smart Pick:',
                      style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Colors.green)),
                  SizedBox(height: 8),
                  Text(
                    '• Lower-risk options (bonds, gold) offer steadier but smaller returns.',
                    style: TextStyle(fontSize: 14, color: Colors.green),
                  ),
                  Text(
                    '• Medium-risk assets (broad market ETFs) balance growth and volatility.',
                    style: TextStyle(fontSize: 14, color: Colors.green),
                  ),
                  Text(
                    '• High-risk investments can yield the biggest gains at the cost of greater price swings.',
                    style: TextStyle(fontSize: 14, color: Colors.green),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 24),

          // Tier Selector
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Center(
              child: ToggleButtons(
                isSelected:
                    List.generate(_tiers.length, (i) => i == _selectedTier),
                onPressed: (idx) => setState(() => _selectedTier = idx),
                borderRadius: BorderRadius.circular(12),
                selectedColor: Colors.white,
                fillColor: const Color(0xffDAA520),
                color: Colors.black87,
                constraints: const BoxConstraints(minWidth: 0, minHeight: 40),
                children: _tiers.map((t) {
                  return Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                    child: Text(t, textAlign: TextAlign.center),
                  );
                }).toList(),
              ),
            ),
          ),

          const SizedBox(height: 12),

          // Suggestion cards
          // …after your ToggleButtons and SizedBox(height: 12),
if (_selectedTier < 0) ...[
  Padding(
    padding: const EdgeInsets.symmetric(horizontal: 20),
    child: Text(
      'Select a risk tier above to view suggestions.',
      style: TextStyle(fontSize: 14, color: Colors.grey[600]),
    ),
  ),
] else ...[
  for (var asset in _suggestions[_tiers[_selectedTier]]!) 
    ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              _iconColorFor(asset['name']!).withOpacity(0.1),
              Colors.white
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: _iconColorFor(asset['name']!).withOpacity(0.25),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Colored header with icon & title
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: _iconColorFor(asset['name']!),
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(16),
                  topRight: Radius.circular(16),
                ),
              ),
              child: Row(
                children: [
                  Icon(_iconFor(asset['name']!), color: Colors.white),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      asset['name']!,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // Body
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    asset['rationale']!,
                    style: const TextStyle(fontSize: 14, color: Colors.black87),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    asset['desc']!,
                    style: const TextStyle(
                      fontSize: 13,
                      color: Colors.black54,
                      height: 1.4,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Align(
                    alignment: Alignment.centerRight,
                    child: ElevatedButton(
                      onPressed: () {
                        // TODO: link out
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xffDAA520),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 8),
                      ),
                        child: const Text('Learn More', style: TextStyle(color: Colors.white)),
                      
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    ),
]

        ],
      ),
    );
  }
}
