import 'package:flutter/material.dart';

class RoundedRectClipper extends CustomClipper<Path> {
  final double radius;

  RoundedRectClipper({this.radius = 24.0});

  @override
  Path getClip(Size size) {
    final path = Path();
    final rect = RRect.fromRectAndRadius(
      Rect.fromLTWH(0, 0, size.width, size.height),
      Radius.circular(radius),
    );
    path.addRRect(rect);
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
