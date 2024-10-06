import 'package:flutter/material.dart';
import 'package:hydrolyte/components/WaterIntakeChart.dart';
import 'package:intl/intl.dart';

class HomeScreen extends StatefulWidget {
  final List allDrinks;
  final String currentWeather;
  final String currentTemperature;
  final String relativeHumidity;
  final Map<String, dynamic> userObj;
  HomeScreen(
      {required this.currentWeather,
      required this.currentTemperature,
      required this.relativeHumidity,
      required this.userObj,
      required this.allDrinks});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  double totalAmount = 0;
  double goal = 0;

  // Claculate total drinks for today
  double sumDrinkAmountsForToday(List<dynamic> allDrinks) {
    double total = 0;
    DateTime now = DateTime.now();
    DateFormat dateFormat = DateFormat("MMM d, yyyy h:mm a");

    for (var drink in allDrinks) {
      print("Drink timestamp: ${drink['timestamp']}");

      try {
        String normalizedTimestamp =
            drink['timestamp'].replaceAll('\u202F', ' ');
        DateTime drinkTimestamp = dateFormat.parse(normalizedTimestamp);
        print("Parsed timestamp: $drinkTimestamp");

        if (drinkTimestamp.year == now.year &&
            drinkTimestamp.month == now.month &&
            drinkTimestamp.day == now.day) {
          double? drinkAmount =
              double.tryParse(drink['drinkAmount'].toString());
          if (drinkAmount != null) {
            total += drinkAmount;
          } else {
            print("Invalid drink amount: ${drink['drinkAmount']}");
          }
        }
      } catch (e) {
        print("Error parsing date: $e");
      }
    }

    return total;
  }

  void _setGoal() {
    setState(() {
      goal = double.tryParse(widget.userObj['weight'].toString()) != null
          ? double.parse(widget.userObj['weight'].toString()) * 35
          : 0;
    });
  }

  // Set default goal value.
  @override
  void initState() {
    super.initState();
    _setGoal();
  }

  @override
  void didUpdateWidget(HomeScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.userObj != widget.userObj) {
      _setGoal();
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Row(
          children: [
            Card(
              margin: const EdgeInsets.all(15),
              elevation: 2.0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.0),
              ),
              color: Colors.white,
              child: SizedBox(
                width: screenWidth * 0.40,
                height: screenWidth * 0.40,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Text(
                      "Temperature",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 10),
                    Icon(
                      _getWeatherIcon(widget.currentWeather),
                      size: screenWidth * 0.15,
                      color: _getWeatherColor(widget.currentWeather),
                    ),
                    const SizedBox(height: 15),
                    Text(
                      widget.currentTemperature,
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 22),
                    ),
                  ],
                ),
              ),
            ),
            Card(
              margin: const EdgeInsets.all(15),
              elevation: 2.0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.0),
              ),
              color: Colors.white,
              child: SizedBox(
                width: screenWidth * 0.40,
                height: screenWidth * 0.40,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Text(
                      "Humidity",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 10),
                    Icon(
                      Icons.water_drop,
                      size: screenWidth * 0.15,
                      color: Colors.lightBlue,
                    ),
                    const SizedBox(height: 15),
                    Text(
                      "${widget.relativeHumidity} (2m)",
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 19),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
        WaterIntakeChart(
          goal: double.parse(widget.userObj['weight']) * 35,
          currentDrink: sumDrinkAmountsForToday(widget.allDrinks),
        ),
      ],
    );
  }
}

// Convert weather to Icon
IconData _getWeatherIcon(String condition) {
  switch (condition) {
    case 'Sunny':
      return Icons.wb_sunny;
    case 'Partly Cloudy':
      return Icons.cloud;
    case 'Cloudy':
      return Icons.cloud;
    case 'Foggy':
      return Icons.foggy;
    case 'Drizzle':
      return Icons.umbrella;
    case 'Rain':
      return Icons.umbrella;
    case 'Snow':
      return Icons.ac_unit;
    case 'Showers':
      return Icons.umbrella;
    case 'Thunderstorm':
      return Icons.thunderstorm;
    default:
      return Icons.help;
  }
}

// Convert weather string to color
Color _getWeatherColor(String condition) {
  switch (condition) {
    case 'Sunny':
      return Colors.orange;
    case 'Partly Cloudy':
      return Colors.grey;
    case 'Cloudy':
      return Colors.blueGrey;
    case 'Foggy':
      return Colors.grey[600]!;
    case 'Drizzle':
    case 'Rain':
      return Colors.blue;
    case 'Snow':
      return Colors.lightBlue;
    case 'Showers':
      return Colors.blueAccent;
    case 'Thunderstorm':
      return Colors.yellow;
    default:
      return Colors.black;
  }
}
