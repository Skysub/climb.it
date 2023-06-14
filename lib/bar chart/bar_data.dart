import 'package:climb_it/bar%20chart/individual_bar.dart';

class BarData {
  final double v0Amount;
  final double v1Amount;
  final double v2Amount;
  final double v3Amount;
  final double v4Amount;
  final double v5Amount;
  final double v6Amount;
  final double v7Amount;

  BarData({
    required this.v0Amount,
    required this.v1Amount,
    required this.v2Amount,
    required this.v3Amount,
    required this.v4Amount,
    required this.v5Amount,
    required this.v6Amount,
    required this.v7Amount,

  });

  List<IndividualBar> barData = [];

  void initializeBarData() {
    barData = [
      IndividualBar(x: 0, y: v0Amount),
      IndividualBar(x: 1, y: v1Amount),
      IndividualBar(x: 2, y: v2Amount),
      IndividualBar(x: 3, y: v3Amount),
      IndividualBar(x: 4, y: v4Amount),
      IndividualBar(x: 5, y: v5Amount),
      IndividualBar(x: 6, y: v6Amount),
      IndividualBar(x: 7, y: v7Amount),
    ];
  }

}