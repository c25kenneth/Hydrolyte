import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class WaterLossTrendChart extends StatefulWidget {
  final List<dynamic> allPredictions;
  final String uid;

  WaterLossTrendChart({super.key, required this.uid, required this.allPredictions});

  @override
  _WaterLossTrendChartState createState() => _WaterLossTrendChartState();
}

class _WaterLossTrendChartState extends State<WaterLossTrendChart> {

  // function to convert predictions to FlSpot objects for graph
  List<FlSpot> getPredictionSpots(List<dynamic> predictions) {
    List<MapEntry<DateTime, FlSpot>> spotsWithTimestamps = [];

    DateTime today = DateTime.now();
    DateTime todayStart = DateTime(today.year, today.month, today.day);
    DateTime todayEnd = DateTime(today.year, today.month, today.day, 23, 59, 59);

    for (var prediction in predictions) {
      DateTime predictionTimestamp = DateFormat("yyyy-MM-ddTHH:mm:ss").parse(prediction['timestamp']);

      if (predictionTimestamp.isAfter(todayStart) && predictionTimestamp.isBefore(todayEnd)) {
        double waterLossAmount = double.tryParse(prediction['prediction_result'].toString()) ?? 0;

        double hour = predictionTimestamp.hour + (predictionTimestamp.minute / 60);

        spotsWithTimestamps.add(MapEntry(predictionTimestamp, FlSpot(hour, waterLossAmount)));
      }
    }

    // Sort the spots based on time. 
    spotsWithTimestamps.sort((a, b) => a.key.compareTo(b.key));

    return spotsWithTimestamps.map((entry) => entry.value).toList();
  }

  @override
  Widget build(BuildContext context) {
    List<FlSpot> predictionSpots = getPredictionSpots(widget.allPredictions);
    if (predictionSpots.isEmpty) {
      return const Center(child: Text('No water loss data available'));
    }

    // Scale graph's axis
    double minX = predictionSpots.map((spot) => spot.x).reduce((a, b) => a < b ? a : b);
    double maxX = 24; 
    double maxWaterLoss = predictionSpots.map((spot) => spot.y).reduce((a, b) => a > b ? a : b);
    double verticalInterval = maxWaterLoss > 0 ? maxWaterLoss / 6 : 1; 

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: LineChart(
        LineChartData(
          gridData: FlGridData(
            show: true,
            drawVerticalLine: true,
            horizontalInterval: verticalInterval,
            verticalInterval: verticalInterval,
            getDrawingHorizontalLine: (value) {
              return FlLine(
                color: Colors.grey.withOpacity(0.5),
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
            show: true, 
            topTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 48, 
                getTitlesWidget: (value, meta) {
                  if (value.toInt() % 4 == 0) {
                    int hour = value.toInt();
                    String formattedTime = DateFormat.jm().format(DateTime(0, 1, 1, hour)); // Format to AM/PM
                    return Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Text(
                        formattedTime,
                        style: TextStyle(
                          color: Colors.black.withOpacity(0.7),
                          fontWeight: FontWeight.bold,
                          fontSize: 11, 
                        ),
                      ),
                    );
                  } else {
                    return const SizedBox.shrink();
                  }
                },
                interval: 4, 
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
                      value.toStringAsFixed(1),
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
              spots: predictionSpots,
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
          maxY: maxWaterLoss > 0 ? maxWaterLoss * 1.2 : 1,
        ),
      ),
    );
  }
}
