import 'package:flutter/material.dart';

/// A reusable curved bottom container widget.
class CurvedBottomContainer extends StatelessWidget {
  final double height;
  final Widget? child;
  final Gradient? gradient;
  final Color? color;

  const CurvedBottomContainer({
    super.key,
    this.height = 260, // Default height
    this.child,
    this.gradient,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: double.infinity,
      padding: const EdgeInsets.only(top: 40, bottom: 20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.vertical(
          top: Radius.zero,
          bottom: Radius.elliptical(MediaQuery.sizeOf(context).width / 2, 25.5),
        ),
        gradient: gradient ??
            const LinearGradient(
              colors: [Color(0xFFF0E68C), Color(0xFFDAA520)],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
        color: color, // If a solid color is provided, use it instead
      ),
      child: child,
    );
  }
}
