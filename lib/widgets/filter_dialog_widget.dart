import 'package:flutter/material.dart';


class FilterDialog extends StatefulWidget {
  final String initialDuration;
  final String initialSort;
  final List<String> initialSelectedCategories;
  final Function(String, String, List<String>) onApply;

  const FilterDialog({
    super.key,
    required this.initialDuration,
    required this.initialSort,
    required this.initialSelectedCategories,
    required this.onApply,
  });

  @override
  _FilterDialogState createState() => _FilterDialogState();
}

class _FilterDialogState extends State<FilterDialog> {
  late String selectedDuration;
  late String selectedSort;
  late List<String> selectedCategories;

  @override
  void initState() {
    super.initState();
    selectedDuration = widget.initialDuration;
    selectedSort = widget.initialSort;
    selectedCategories = List.from(widget.initialSelectedCategories);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.white,
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text('Filter Transactions', style: TextStyle(fontSize: 20),),
          TextButton(
            style: ButtonStyle(overlayColor: WidgetStateProperty.all(const Color.fromARGB(40, 158, 158, 158))),
            onPressed: () {
              setState(() {
                selectedDuration = 'Month'; // or 'All Time' if you prefer that as the default
                selectedSort = 'Newest';
                selectedCategories.clear();
              });
            },
            child: const Text('Reset', style:TextStyle( color: Color(0xffDAA520))),
          ),
        ],
      ),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Duration Section
            const Text('Duration', style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              children: ['Day', 'Week', 'Month', 'Year', 'All Time'].map((duration) {
                return ChoiceChip(
                  label: Text(duration, style: TextStyle(fontWeight: FontWeight.w700, color: Colors.black)),
                  selected: selectedDuration == duration,
                  onSelected: (selected) {
                    if (selected){
                      setState(() {
                        selectedDuration = duration ;
                      });
                    }
                  },
                  selectedColor: Color(0xffDAA520),
                  backgroundColor: Colors.white,
                );
              }).toList(),
            ),
            const SizedBox(height: 16),

            // Sort By Section
            const Text('Sort By', style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              children: ['Highest', 'Lowest', 'Newest', 'Oldest'].map((sort) {
                return ChoiceChip(
                  label: Text(sort, style: TextStyle(fontWeight: FontWeight.w700,color: Colors.black)),
                  selected: selectedSort == sort,
                  onSelected: (selected) {
                    if (selected){
                      setState(() {
                        selectedSort = sort ;
                      });
                    }
                  },
                  selectedColor: Color(0xffdaa520),
                  backgroundColor: Colors.white,
                );
              }).toList(),
            ),
            const SizedBox(height: 16),

            // Category Section
            const Text('Category', style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            TextButton(
              style: ButtonStyle(overlayColor: WidgetStateProperty.all(const Color.fromARGB(40, 158, 158, 158))),
              onPressed: () async {
                final result = await showDialog<List<String>>(
                  context: context,
                  builder: (context) => CategorySelectionDialog(
                    initialSelected: selectedCategories,
                  ),
                );
                if (result != null) {
                  setState(() {
                    selectedCategories = result;
                  });
                }
              },
              child: Text('Choose Category (${selectedCategories.length} selected)', style: TextStyle(fontWeight: FontWeight.w700, color: Color(0xffDAA520))),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          style: ButtonStyle(overlayColor: WidgetStateProperty.all(const Color.fromARGB(40, 158, 158, 158))),
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel', style:TextStyle( color: Color(0xffDAA520))),
        ),
        TextButton(
          style: ButtonStyle(overlayColor: WidgetStateProperty.all(const Color.fromARGB(40, 158, 158, 158))),
          onPressed: () {
            widget.onApply(selectedDuration, selectedSort, selectedCategories);
            Navigator.of(context).pop();
          },
          child: const Text('Apply', style:TextStyle( color: Color(0xffDAA520))),
        ),
      ],
    );
  }
}

class CategorySelectionDialog extends StatefulWidget {
  final List<String> initialSelected;

  const CategorySelectionDialog({super.key, required this.initialSelected});

  @override
  _CategorySelectionDialogState createState() => _CategorySelectionDialogState();
}

class _CategorySelectionDialogState extends State<CategorySelectionDialog> {
  late List<String> selected;

  @override
  void initState() {
    super.initState();
    selected = List.from(widget.initialSelected);
  }

  @override
  Widget build(BuildContext context) {
    final categories = ['Groceries', 'Subscription', 'Food', 'Shopping', 'Healthcare', 'Transportation', 'Utilities', 'Housing', 'Miscellaneous'];

    return AlertDialog(
      backgroundColor: Colors.white,
      title: const Text('Select Categories'),
      content: SingleChildScrollView(
        child: Column(
          children: categories.map((category) {
            return CheckboxListTile(
              title: Text(category),
              value: selected.contains(category),
              onChanged: (bool? value) {
                setState(() {
                  if (value == true) {
                    selected.add(category);
                  } else {
                    selected.remove(category);
                  }
                });
              },
            );
          }).toList(),
        ),
      ),
      actions: [
        TextButton(
          style: ButtonStyle(overlayColor: WidgetStateProperty.all(const Color.fromARGB(40, 158, 158, 158))),
          onPressed: () => Navigator.of(context).pop(selected),
          child: const Text('Apply', style:TextStyle( color: Color(0xffDAA520))),
        ),
      ],
    );
  }
}