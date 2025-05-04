import 'package:flutter/material.dart';
import 'package:pie_chart/pie_chart.dart';
 
 
 
 // Pie Chart Widget
 class PieChartWidget extends StatelessWidget {
   final Map<String, double> data;
   final Map<String, Color> colors;
 
   const PieChartWidget({super.key, required this.data, required this.colors});
 
   @override
   Widget build(BuildContext context) {
     return PieChart(
       dataMap: data,
       colorList: data.keys.map((key) => colors[key]!).toList(),
       chartType: ChartType.ring,
       ringStrokeWidth: 32,
       centerText: 'RM${data.values.fold(0.0, (sum, item) => sum + item).toStringAsFixed(0)}',
       chartRadius: MediaQuery.of(context).size.width / 2,
       legendOptions: const LegendOptions(showLegends: false),
       chartValuesOptions: const ChartValuesOptions(showChartValues: false),
     );
   }
 }
 
 // Category List Widget
  class CategoryListWidget extends StatelessWidget {
    final Map<String, double> categories;
    final Map<String, Color> colors;
    final bool showPercentages;
  
    const CategoryListWidget({
      super.key,
      required this.categories,
      required this.colors,
      required this.showPercentages,
    });
 
   @override
   Widget build(BuildContext context) {
     final double total = categories.values.fold(0, (sum, item) => sum + item);
     return ListView.builder(
       shrinkWrap: true,
       physics: const NeverScrollableScrollPhysics(),
       itemCount: categories.length,
       itemBuilder: (context, index) {
         final String category = categories.keys.elementAt(index);
         final double amount = categories[category]!;
         final double percentage = (amount / total) * 100;
         final String displayText = showPercentages
             ? '${percentage.toStringAsFixed(1)}%'
             : '-RM${amount.toStringAsFixed(0)}';
         return Padding(
           padding: const EdgeInsets.symmetric(vertical: 4.0),
           child: Row(
             children: [
               // Colored dot
               Container(
                 width: 10,
                 height: 10,
                 margin: const EdgeInsets.only(right: 8.0),
                 decoration: BoxDecoration(
                   shape: BoxShape.circle,
                   color: colors[category],
                 ),
               ),
               // Category name and percentage bar
               Expanded(
                 child: Column(
                   crossAxisAlignment: CrossAxisAlignment.start,
                   children: [
                     Row(
                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
                       children: [
                         Text(category),
                         Text(
                           displayText,
                           style: TextStyle(
                             color: showPercentages ? Colors.black : Colors.red,
                           ),
                         ),
                       ],
                     ),
                     const SizedBox(height: 4.0),
                     // Horizontal percentage bar
                     LinearProgressIndicator(
                       value: percentage / 100, // Convert percentage to 0-1 range
                       backgroundColor: Colors.grey[300],
                       color: colors[category],
                       minHeight: 8.0,
                       borderRadius: BorderRadius.all(Radius.circular(50)),
                     ),
                   ],
                 ),
               ),
             ],
           ),
         );
       },
     );
   }
 }