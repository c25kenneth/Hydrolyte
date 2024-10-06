import 'package:firebase_auth/firebase_auth.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:hydrolyte/components/PieWaterChart.dart';
import 'package:hydrolyte/components/WaterIntakeTrendLineChart.dart';
import 'package:hydrolyte/components/WaterLossTrendChart.dart';
import 'package:intl/intl.dart';

class TrendScreen extends StatefulWidget {
  final List<dynamic> allDrinks;
  final List<dynamic> allPredictions; 
  const TrendScreen({super.key, required this.allDrinks, required this.allPredictions});

  @override
  State<TrendScreen> createState() => _TrendScreenState();
}

class _TrendScreenState extends State<TrendScreen> {

  List<dynamic> allDrinks = []; 

  // What percent is water vs other drink
  Map<String, double> calculateWaterNonWaterPercentage(
      List<dynamic> allDrinks) {
    int totalDrinks = allDrinks.length;
    int waterDrinks = 0;
    int nonWaterDrinks = 0;

    for (var drink in allDrinks) {
      if (drink['isWater'] == true) {
        waterDrinks++;
      } else {
        nonWaterDrinks++;
      }
    }

    if (totalDrinks == 0) {
      return {'waterPercentage': 0, 'nonWaterPercentage': 0};
    }

    double waterPercentage = (waterDrinks / totalDrinks) * 100;
    double nonWaterPercentage = (nonWaterDrinks / totalDrinks) * 100;

    return {
      'waterPercentage': double.parse(waterPercentage.toStringAsFixed(2)),
      'nonWaterPercentage': double.parse(nonWaterPercentage.toStringAsFixed(2)),
    };
  }

  // Points on graph
  List<FlSpot> getPredictionSpots(List<dynamic> predictions) {
    List<MapEntry<DateTime, FlSpot>> spotsWithTimestamps = [];

    for (var prediction in predictions) {
      DateTime predictionTimestamp = DateFormat("yyyy-MM-ddTHH:mm:ss").parse(prediction['timestamp']);
      double waterLossAmount = double.tryParse(prediction['prediction_result'].toString()) ?? 0;

      double hour = predictionTimestamp.hour + (predictionTimestamp.minute / 60);

      spotsWithTimestamps.add(MapEntry(predictionTimestamp, FlSpot(hour, waterLossAmount)));
    }

    spotsWithTimestamps.sort((a, b) => a.key.compareTo(b.key));

    return spotsWithTimestamps.map((entry) => entry.value).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        child: Column(
          children: [
            Align(
                alignment: Alignment.topLeft,
                child: Container(
                    margin: const EdgeInsets.all(20),
                    child: const Text(
                      "Your Beverages",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
                    ))),
            Container(
              height: 200,
              child: PieWaterChart(
                nonWaterDrinks: calculateWaterNonWaterPercentage(widget.allDrinks)["nonWaterPercentage"] ?? 0.0,
                waterDrinks: calculateWaterNonWaterPercentage(widget.allDrinks)["waterPercentage"] ?? 0.0,
              ),
            ),
            const SizedBox(height: 20),

            Align(
                alignment: Alignment.topLeft,
                child: Container(
                    margin: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                    child: const Text(
                      "Your Water Intake",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
                    ))),
            Container(
              height: 200,
              child: WaterIntakeTrendLineChart(drinks: widget.allDrinks,),
            ),
            const SizedBox(height: 20),
            Align(
                alignment: Alignment.topLeft,
                child: Container(
                    margin: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                    child: const Text(
                      "Your Water Loss",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
                    ))),
            Container(
              height: 200,
              child: WaterLossTrendChart(uid: FirebaseAuth.instance.currentUser!.uid, allPredictions: widget.allPredictions)
            ),
          ],
        ),
      ),
    );
  }
}
