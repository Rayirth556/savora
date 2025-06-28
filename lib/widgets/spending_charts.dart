import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../theme/savora_theme.dart';

class SpendingPieChart extends StatelessWidget {
  final Map<String, double> data;

  const SpendingPieChart({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    final colors = [
      SavoraColors.primary,
      SavoraColors.secondary,
      SavoraColors.accent,
      SavoraColors.success,
      SavoraColors.warning,
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
    final colors = [
      SavoraColors.primary,
      SavoraColors.secondary,
      SavoraColors.accent,
      SavoraColors.success,
      SavoraColors.warning,
    ];

    return BarChart(
      BarChartData(
        alignment: BarChartAlignment.spaceAround,
        maxY: data.values.isEmpty ? 100 : data.values.reduce((a, b) => a > b ? a : b) * 1.2,
        barTouchData: BarTouchData(enabled: false),
        titlesData: FlTitlesData(
          show: true,
          rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (value, meta) {
                if (value.toInt() >= 0 && value.toInt() < barData.length) {
                  return Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Text(
                      barData[value.toInt()].key,
                      style: context.savoraText.bodySmall,
                    ),
                  );
                }
                return const Text('');
              },
            ),
          ),
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 40,
              getTitlesWidget: (value, meta) {
                return Text(
                  '₹${value.toInt()}',
                  style: context.savoraText.bodySmall,
                );
              },
            ),
          ),
        ),
        borderData: FlBorderData(show: false),
        barGroups: barData.asMap().entries.map((entry) {
          final index = entry.key;
          final data = entry.value;
          return BarChartGroupData(
            x: index,
            barRods: [
              BarChartRodData(
                toY: data.value,
                color: colors[index % colors.length],
                width: 20,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(4),
                  topRight: Radius.circular(4),
                ),
              ),
            ],
          );
        }).toList(),
      ),
    );
  }
}
