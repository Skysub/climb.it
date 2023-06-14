import 'package:climb_it/bar%20chart/bar_data.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class MyBarGraph extends StatelessWidget {
  final List vAmmount;
  const MyBarGraph({
    super.key,
    required this.vAmmount,
  });

  @override
  Widget build(BuildContext context) {
    BarData myBarData = BarData(
      v0Amount: vAmmount[0],
      v1Amount: vAmmount[1],
      v2Amount: vAmmount[2],
      v3Amount: vAmmount[3],
      v4Amount: vAmmount[4],
      v5Amount: vAmmount[5],
      v6Amount: vAmmount[6],
      v7Amount: vAmmount[7],
    );
    myBarData.initializeBarData();

    return BarChart(
      BarChartData(
        maxY: 20,
        minY: 0,
        gridData: const FlGridData(show: false),
        borderData: FlBorderData(show: false),
        titlesData: const FlTitlesData(
          show: true,
          topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true, 
              getTitlesWidget: getBottomTitles,
            ),
          ),
        ),
        barGroups: myBarData.barData
            .map(
              (data) => BarChartGroupData(
                x: data.x,
                barRods: [
                  BarChartRodData(
                    toY: data.y,
                    color: Colors.lightGreen,
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

Widget getBottomTitles (double value, TitleMeta meta){
  const style = TextStyle(
    color: Colors.pink,
    fontWeight: FontWeight.bold,
    fontSize: 14,
  );

  Widget text;
  switch (value.toInt()) {
    case 0:
      text = const Text('V0', style: style);
      break;
    case 1:
      text = const Text('V1', style: style);
      break;
    case 2:
      text = const Text('V2', style: style);
      break;
    case 3:
      text = const Text('V3', style: style);
      break;
    case 4:
      text = const Text('V4', style: style);
      break;
    case 5:
      text = const Text('V5', style: style);
      break;
    case 6:
      text = const Text('V6', style: style);
      break;
    case 7:
      text = const Text('V7', style: style);
      break;
    default:
      text = const Text('', style: style);
    }

    return SideTitleWidget(child: text, axisSide: meta.axisSide);
}