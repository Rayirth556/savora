import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class SpendingPieChart extends StatelessWidget {
  final Map<String, double> data;

  const SpendingPieChart({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    final colors = [
      Colors.blue,
      Colors.green,
      Colors.orange,
      Colors.red,
      Colors.purple,
    ];
    int i = 0;

    return PieChart(
      PieChartData(
        sections: data.entries.map((entry) {
          final color = colors[i++ % colors.length];
          return PieChartSectionData(
            color: color,
            value: entry.value,
            title: entry.key,
            radius: 50,
            titleStyle: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          );
        }).toList(),
        sectionsSpace: 2,
        centerSpaceRadius: 40,
      ),
    );
  }
}

class SpendingBarChart extends StatelessWidget {
  final Map<String, double> data;

  const SpendingBarChart({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    final barData = data.entries.toList();

    return BarChart(
      BarChartData(
        alignment: BarChartAlignment.spaceAround,
        maxY: (data.values.reduce((a, b) => a > b ? a : b)) + 10,
        barGroups: List.generate(barData.length, (index) {
          return BarChartGroupData(
            x: index,
            barRods: [
              BarChartRodData(
                toY: barData[index].value,
                color: Colors.teal,
                width: 20,
              ),
            ],
          );
        }),
        titlesData: FlTitlesData(
          leftTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: true),
          ),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (double value, _) {
                final idx = value.toInt();
                if (idx >= 0 && idx < barData.length) {
                  return Text(
                    barData[idx].key,
                    style: const TextStyle(fontSize: 10),
                  );
                }
                return const SizedBox.shrink();
              },
            ),
          ),
        ),
      ),
    );
  }
}
