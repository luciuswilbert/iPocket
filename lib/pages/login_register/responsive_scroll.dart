import 'package:flutter/material.dart';

class ResponsiveScroll extends StatelessWidget {
  final Widget child;

  const ResponsiveScroll({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        bool needsScroll =
            constraints.maxHeight < 500; // Adjust threshold based on UI

        return SingleChildScrollView(
          physics:
              needsScroll
                  ? AlwaysScrollableScrollPhysics()
                  : NeverScrollableScrollPhysics(),
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: constraints.maxHeight, // Prevent layout errors
            ),
            child: IntrinsicHeight(
              // Ensures child takes up available height
              child: child,
            ),
          ),
        );
      },
    );
  }
}
