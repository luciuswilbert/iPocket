import 'package:flutter/material.dart';

class CustomBottomNavigationBar extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onItemTapped;

  const CustomBottomNavigationBar({
    Key? key,
    required this.selectedIndex,
    required this.onItemTapped,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
       decoration: BoxDecoration(
         boxShadow: <BoxShadow>[
           BoxShadow(
             color: const Color.fromARGB(64, 0, 0, 0),
             blurRadius: 15,
           ),
         ],
       ),
       child: BottomAppBar(
        shape: const CircularNotchedRectangle(),
        notchMargin: 8.0,
        color: Colors.white,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildNavItem(0, Icons.home, "Home"),
            _buildNavItem(1, Icons.receipt, "Transaction"),
            const SizedBox(width: 48), // Space for FAB
            _buildNavItem(2, Icons.pie_chart, "Summary"),
            _buildNavItem(3, Icons.person, "Profile"),
          ],
        ),
      ),
    );
  }

  Widget _buildNavItem(int index, IconData icon, String label) {
    bool isSelected = selectedIndex == index;
    return GestureDetector(
      onTap: () => onItemTapped(index),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: isSelected ? const Color(0xffDAA520) : Colors.grey),
          Text(
            label,
            style: TextStyle(
              color: isSelected ? const Color(0xffDAA520) : Colors.grey,
            ),
          ),
        ],
      ),
    );
  }
}
