import 'package:climb_it/bar%20chart/individual_bar.dart';

class BarData {
  final List<double> amounts;

  BarData({
    required this.amounts,
  });

  List<IndividualBar> barData = [];

  void initializeBarData() {
    barData = [
      for (int i = 0; i < amounts.length; i++)
        IndividualBar(x: i, y: amounts[i])
    ];
  }
}
