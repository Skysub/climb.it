import 'dart:math';

import 'package:climb_it/bar%20chart/bar_data.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class MyBarGraph extends StatelessWidget {
  final List<double> amounts;
  const MyBarGraph({
    super.key,
    required this.amounts,
  });

  @override
  Widget build(BuildContext context) {
    BarData myBarData = BarData(amounts: amounts);
    myBarData.initializeBarData();
    return BarChart(
      BarChartData(
        barTouchData: BarTouchData(enabled: false),
        maxY: (amounts.reduce(max) / 5).ceil() * 5,
        minY: 0,
        gridData: const FlGridData(show: false),
        borderData: FlBorderData(show: false),
        titlesData: FlTitlesData(
            show: true,
            topTitles:
                const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            rightTitles:
                const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            bottomTitles: const AxisTitles(
              sideTitles: SideTitles(
                reservedSize: 26,
                showTitles: true,
                getTitlesWidget: getBottomTitles,
              ),
            ),
            leftTitles: AxisTitles(
                sideTitles: SideTitles(
                    reservedSize: 40,
                    showTitles: true,
                    interval: max(
                        1,
                        (((amounts.reduce(max) / 5).ceil() * 5) ~/ 5)
                            .toDouble())))),
        barGroups: myBarData.barData
            .map(
              (data) => BarChartGroupData(
                x: data.x,
                barRods: [
                  BarChartRodData(
                    toY: data.y,
                    color: Colors.pink,
                    width: 15,
                    borderRadius: BorderRadius.circular(5),
                  ),
                ],
              ),
            )
            .toList(),
      ),
    );
  }
}

Widget getBottomTitles(double value, TitleMeta meta) {
  return SideTitleWidget(
      axisSide: meta.axisSide,
      child: Text('V${value.toStringAsFixed(0)}',
          style: const TextStyle(fontSize: 14)));
}
