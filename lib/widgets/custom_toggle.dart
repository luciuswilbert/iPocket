import 'package:flutter/material.dart';

class CustomToggle extends StatelessWidget {
  final String title;
  final bool value;
  final ValueChanged<bool> onChanged;

  const CustomToggle({
    Key? key,
    required this.title,
    required this.value,
    required this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
      trailing: Switch(
        value: value,
        onChanged: onChanged,
        activeColor: const Color(0xffDAA520),
      ),
    );
  }
}
