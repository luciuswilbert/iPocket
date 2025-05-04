import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CustomDatePicker extends StatefulWidget {
  final String label;
  final TextEditingController controller;

  const CustomDatePicker({
    Key? key,
    required this.label,
    required this.controller,
  }) : super(key: key);

  @override
  _CustomDatePickerState createState() => _CustomDatePickerState();
}

class _CustomDatePickerState extends State<CustomDatePicker> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: TextField(
        controller: widget.controller,
        readOnly: true,
        decoration: InputDecoration(
          filled: true,
          fillColor: Color(0xFFF8F0F8), // Match your form background color
          labelText: widget.label,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
          suffixIcon: IconButton(
            icon: const Icon(Icons.calendar_today, color: Colors.black54),
            onPressed: () async {
              DateTime? pickedDate = await showDatePicker(
                context: context,
                initialDate: DateTime.now(),
                firstDate: DateTime(1900),
                lastDate: DateTime(2100),
                builder: (context, child) {
                  return Theme(
                    data: Theme.of(context).copyWith(
                      dialogBackgroundColor: Colors.white, // ← White calendar background
                      colorScheme: ColorScheme.light(
                        primary: Color(0xffDAA520), // Golden selection color
                        onPrimary: Colors.white, // Text color on selected day
                        onSurface: Colors.black, // Text color for normal days
                      ),
                    ),
                    child: child!,
                  );
                },
              );
              if (pickedDate != null) {
                setState(() {
                  widget.controller.text = DateFormat(
                    "dd/MM/yyyy",
                  ).format(pickedDate);
                });
              }
            },
          ),
        ),
      ),
    );
  }
}
