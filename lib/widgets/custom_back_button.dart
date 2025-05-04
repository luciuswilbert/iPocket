import 'package:flutter/material.dart';

class CustomBackButton extends StatelessWidget {
  final Color color; // Allows customizing the icon color
  final double top;  // Allows adjusting position if needed

  const CustomBackButton({
    Key? key,
    this.color = Colors.black, // Default color
    this.top = 50.0, // Default position
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: top,
      left: 16,
      child: IconButton(
        icon: Icon(Icons.arrow_back, color: color),
        onPressed: () {
          Navigator.pop(context);
        },
      ),
    );
  }
}
