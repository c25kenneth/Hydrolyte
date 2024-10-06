import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:hydrolyte/components/Indicator.dart';

class PieWaterChart extends StatefulWidget {
  final double waterDrinks; 
  final double nonWaterDrinks; 
  const PieWaterChart({super.key, required this.waterDrinks, required this.nonWaterDrinks});

  @override
  State<StatefulWidget> createState() => PieWaterChartState();
}

class PieWaterChartState extends State<PieWaterChart> {
  int touchedIndex = -1;

  @override
  Widget build(BuildContext context) {
    if ((widget.waterDrinks > 0 && widget.nonWaterDrinks > 0)) {
      return AspectRatio(
        aspectRatio: 1.9,
        child: Row(
          children: <Widget>[
            const SizedBox(
              height: 18,
            ),
            Expanded(
              child: AspectRatio(
                aspectRatio: 1,
                child: PieChart(
                  PieChartData(
                    pieTouchData: PieTouchData(
                      touchCallback: (FlTouchEvent event, pieTouchResponse) {
                        setState(() {
                          if (!event.isInterestedForInteractions ||
                              pieTouchResponse == null ||
                              pieTouchResponse.touchedSection == null) {
                            touchedIndex = -1;
                            return;
                          }
                          touchedIndex = pieTouchResponse
                              .touchedSection!.touchedSectionIndex;
                        });
                      },
                    ),
                    borderData: FlBorderData(
                      show: false,
                    ),
                    sectionsSpace: 0,
                    centerSpaceRadius: 40,
                    sections: showingSections(widget.nonWaterDrinks, widget.waterDrinks,),
                  ),
                ),
              ),
            ),
            const Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Indicator(
                  color: Colors.lightBlueAccent,
                  text: 'Water',
                  isSquare: true,
                ),
                SizedBox(
                  height: 4,
                ),
                Indicator(
                  color: Colors.grey, 
                  text: 'Non-Water',
                  isSquare: true,
                ),
                SizedBox(
                  height: 18,
                ),
              ],
            ),
            const SizedBox(
              width: 28,
            ),
          ],
        ),
      );
    } else {
      return Container(
        child: Text("No water intake today!"),
      );
    }
  }

  List<PieChartSectionData> showingSections(double nonwater, double water) {
    return List.generate(2, (i) {
      final isTouched = i == touchedIndex;
      final fontSize = isTouched ? 25.0 : 16.0;
      final radius = isTouched ? 60.0 : 50.0;
      const shadows = [Shadow(color: Colors.black, blurRadius: 2)];

      switch (i) {
        case 0:
          return PieChartSectionData(
            color: Colors.lightBlueAccent, 
            value: water, 
            title: water.toString() + '%',
            radius: radius,
            titleStyle: TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.bold,
              shadows: shadows,
            ),
          );
        case 1:
          return PieChartSectionData(
            color: Colors.grey, 
            value: nonwater, 
            title: nonwater.toString() + "%",
            radius: radius,
            titleStyle: TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.bold,
              shadows: shadows,
            ),
          );
        default:
          throw Error();
      }
    });
  }
}
