import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class WaterIntakeTrendLineChart extends StatelessWidget {
  final List<dynamic> drinks;

  WaterIntakeTrendLineChart({super.key, required this.drinks});

  @override
  Widget build(BuildContext context) {
    List<FlSpot> waterIntakeSpots = getWaterIntakeSpotsForToday();

    if (waterIntakeSpots.isEmpty) {
      return const Center(child: Text('No water intake data for today'));
    }

    double minX = waterIntakeSpots.map((spot) => spot.x).reduce((a, b) => a < b ? a : b);
    double maxX = waterIntakeSpots.map((spot) => spot.x).reduce((a, b) => a > b ? a : b);

    double maxWaterIntake = waterIntakeSpots.map((spot) => spot.y).reduce((a, b) => a > b ? a : b);

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: LineChart(
        LineChartData(
          gridData: FlGridData(
            show: true,
            drawVerticalLine: true,
            horizontalInterval: 1.5,
            verticalInterval: maxWaterIntake / 6,
            getDrawingHorizontalLine: (value) {
              return FlLine(
                color: Colors.grey.withOpacity(0.2),
                strokeWidth: 1,
              );
            },
            getDrawingVerticalLine: (value) {
              return FlLine(
                color: Colors.grey.withOpacity(0.5),
                strokeWidth: 1,
              );
            },
          ),
          titlesData: FlTitlesData(
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 40,
                getTitlesWidget: (value, meta) {
                  return Container(
                    margin: const EdgeInsets.all(3.0),
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Text(
                      getFormattedTime(value.toInt()),
                      style: TextStyle(
                        color: Colors.black.withOpacity(0.7),
                        fontWeight: FontWeight.bold,
                        fontSize: 7.5,
                      ),
                    ),
                  );
                },
                interval: 1, 
              ),
            ),
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 40,
                getTitlesWidget: (value, meta) {
                  return Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: Text(
                      value.toString(),
                      style: TextStyle(
                        color: Colors.black.withOpacity(0.7),
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
          lineBarsData: [
            LineChartBarData(
              isCurved: true,
              spots: waterIntakeSpots,
              isStrokeCapRound: true,
              barWidth: 5,
              color: Colors.blueAccent,
              dotData: const FlDotData(
                show: true,
              ),
              belowBarData: BarAreaData(
                show: true,
                gradient: LinearGradient(
                  colors: [
                    Colors.blueAccent.withOpacity(0.4),
                    Colors.blueAccent.withOpacity(0.1),
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
            ),
          ],
          borderData: FlBorderData(
            show: true,
            border: Border.all(
              color: Colors.blueAccent.withOpacity(0.6),
              width: 2,
            ),
          ),
          minX: minX,
          maxX: maxX,
          minY: 0,
          maxY: maxWaterIntake,
          backgroundColor: Colors.transparent,
        ),
      ),
    );
  }

  String getFormattedTime(int timeValue) {
    DateTime time = DateTime(0, 1, 1, timeValue * 4);
    return DateFormat.jm().format(time);
  }

  // Filter water intake list for intake TODAY
  List<FlSpot> getWaterIntakeSpotsForToday() {
    List<FlSpot> spots = [];
    Map<int, double> hourlyWaterIntake = {};

    DateTime now = DateTime.now();

    for (var drink in drinks) {
      DateTime drinkTimestamp = DateFormat("MMM d, yyyy h:mm a").parse(drink['timestamp'].replaceAll('\u202f', ' '));

      if (drinkTimestamp.year == now.year &&
          drinkTimestamp.month == now.month &&
          drinkTimestamp.day == now.day) {
        int hour = drinkTimestamp.hour ~/ 4;

        if (!hourlyWaterIntake.containsKey(hour)) {
          hourlyWaterIntake[hour] = 0;
        }

        double drinkAmount = double.tryParse(drink['drinkAmount']) ?? 0;
        hourlyWaterIntake[hour] = hourlyWaterIntake[hour]! + drinkAmount;
      }
    }

    hourlyWaterIntake.forEach((hour, amount) {
      if (amount > 0) {
        spots.add(FlSpot(hour.toDouble(), amount));
      }
    });

    spots.sort((a, b) => a.x.compareTo(b.x));

    return spots;
  }
}
