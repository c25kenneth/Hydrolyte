import 'package:firebase_auth/firebase_auth.dart';
import 'package:fl_location/fl_location.dart';
import 'package:flutter/material.dart';
import 'package:hydrolyte/components/BottomNavBar.dart';
import 'package:hydrolyte/BackendOperations.dart';
import 'package:hydrolyte/components/TextInputField.dart';
import 'package:hydrolyte/screens/AddDrink.dart';
import 'package:hydrolyte/screens/HomeScreen.dart';
import 'package:hydrolyte/screens/Map.dart';
import 'package:hydrolyte/screens/PredictHydration.dart';
import 'package:hydrolyte/screens/TrendScreen.dart';
import 'package:hydrolyte/screens/Welcome.dart';

class Home extends StatefulWidget {
  final Map<String, dynamic> userObj;
  const Home({super.key, required this.userObj});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  Map<String, dynamic> currUserObj = {};

  // Get permission to access phone's geolocation data
  _checkAndRequestPermission({bool? background}) async {
    if (!await FlLocation.isLocationServicesEnabled) {
      return false;
    }

    LocationPermission permission = await FlLocation.checkLocationPermission();
    if (permission == LocationPermission.deniedForever) {
      return false;
    } else if (permission == LocationPermission.denied) {
      permission = await FlLocation.requestLocationPermission();
      if (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever) {
        return false;
      }
    }

    if (background == true && permission == LocationPermission.whileInUse) {
      return false;
    }

    return true;
  }

  int _selectedIndex = 0;
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  List<dynamic> drinks = [];
  List<dynamic> allPredictions = [];
  List<dynamic> locations = [];

  String currentTemperature = "";
  String relativeHumidity = "";
  String weatherCondition = '';

  double latitude = 0.0;
  double longitude = 0.0;

  final TextEditingController _ageController = TextEditingController();
  final TextEditingController _weightController = TextEditingController();
  final TextEditingController _heightController = TextEditingController();
  
  // Call APIs and set initial values
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {
        currUserObj = widget.userObj;
      });
      _getLocation().then((locationMap) => {
            getWeather(locationMap["latitude"], locationMap["longitude"])
                .then((weatherData) {
              if (weatherData != null) {
                setState(() {
                  currentTemperature = '${weatherData['temperature']}°C';
                  relativeHumidity = '${weatherData['humidity']}%';
                  weatherCondition = weatherData['condition'];
                  latitude = locationMap["latitude"];
                  longitude = locationMap["longitude"];
                });
              }
            })
          });
      fetchLocations().then((fetchedLocations) {
        setState(() {
          locations = fetchedLocations;
        });
      });
      callWaterIntake();
      callPrediction();
      _ageController.text = widget.userObj["age"];
      _weightController.text = widget.userObj["weight"];
      _heightController.text = widget.userObj["height"];
    });
  }

  callPrediction() {
    getPrediction(FirebaseAuth.instance.currentUser!.uid).then((predictions) {
      setState(() {
        allPredictions = predictions;
      });
    });
  }

  callWaterIntake() {
    getWaterIntake(FirebaseAuth.instance.currentUser!.uid).then((allDrinks) {
      setState(() {
        drinks = allDrinks;
      });
    });
  }

  Future<Map> _getLocation() async {
    if (await _checkAndRequestPermission()) {
      final Location location = await FlLocation.getLocation();
      return location.toJson();
    } else {
      return {};
    }
  }

  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _titleController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: (_selectedIndex == 0 ||
              _selectedIndex == 3 ||
              _selectedIndex == 1)
          ? AppBar(
              flexibleSpace: Container(
                decoration: const BoxDecoration(
                    gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [Colors.cyan, Colors.cyanAccent])),
              ),
              title: Text(
                (_selectedIndex == 0)
                    ? "Welcome"
                    : (_selectedIndex == 3)
                        ? "Predict Water Loss 🥵"
                        : "Statistics",
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    letterSpacing: 2,
                    fontSize: (_selectedIndex == 0) ? 30 : 25),
              ),
              centerTitle: false,
              actions: [
                IconButton(
                    padding: const EdgeInsets.all(15),
                    tooltip: "Settings",
                    onPressed: () async {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return StatefulBuilder(
                            builder:
                                (BuildContext context, StateSetter setState) {
                              return AlertDialog(
                                backgroundColor: Colors.white,
                                title: const Text('Update Biometric Data'),
                                content: SingleChildScrollView(
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      TextInputFb1(
                                        inputController: _ageController,
                                        inputType: TextInputType.text,
                                        hintText: "Enter Age (years)",
                                        prefixIcon: Icons.numbers_outlined,
                                      ),
                                      const SizedBox(height: 5),
                                      TextInputFb1(
                                        inputController: _heightController,
                                        inputType: TextInputType.text,
                                        hintText: "Enter Height (cm)",
                                        prefixIcon: Icons.height_outlined,
                                      ),
                                      const SizedBox(height: 5),
                                      TextInputFb1(
                                        inputController: _weightController,
                                        inputType: TextInputType.text,
                                        hintText: "Enter Weight (kg)",
                                        prefixIcon: Icons.scale_outlined,
                                      ),
                                    ],
                                  ),
                                ),
                                actions: [
                                  TextButton(
                                    child: const Text(
                                      'Cancel',
                                      style: TextStyle(color: Colors.cyan),
                                    ),
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                  ),
                                  TextButton(
                                    child: const Text(
                                      'Update',
                                      style: TextStyle(color: Colors.cyan),
                                    ),
                                    onPressed: () async {
                                      // Update the user in the backend first
                                      await updateUser(
                                        widget.userObj["uid"],
                                        age: int.parse(_ageController.text),
                                        weight: double.parse(
                                            _weightController.text),
                                        height: double.parse(
                                            _heightController.text),
                                      );
                                      setState(() {
                                        currUserObj = {
                                          'uid': widget.userObj["uid"],
                                          'age': _ageController.text,
                                          'weight': _weightController.text,
                                          'height': _heightController.text,
                                        };

                                      });
                                      if (mounted) {
                                        Navigator.of(context).pop();
                                      }
                                    },
                                  ),
                                ],
                              );
                            },
                          );
                        },
                      );
                    },
                    icon: const Icon(
                      Icons.settings_outlined,
                      color: Colors.white,
                      size: 30,
                    )),
                IconButton(
                    padding: const EdgeInsets.all(15),
                    tooltip: "Log out",
                    onPressed: () async {
                      await FirebaseAuth.instance.signOut();
                      Navigator.of(context).pushReplacement(
                          MaterialPageRoute(builder: (context) => Welcome()));
                    },
                    icon: const Icon(
                      Icons.logout_outlined,
                      color: Colors.white,
                      size: 30,
                    ))
              ],
            )
          : null,
      floatingActionButton: _selectedIndex == 2
          ? FloatingActionButton(
              onPressed: () {
                String _selectedDrinkType = 'Water';

                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return StatefulBuilder(
                      builder: (BuildContext context, StateSetter setState) {
                        return AlertDialog(
                          backgroundColor: Colors.white,
                          title: const Text('Log Water Intake'),
                          content: SingleChildScrollView(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                TextInputFb1(
                                  inputController: _titleController,
                                  inputType: TextInputType.text,
                                  hintText: "Enter Drink Name",
                                  prefixIcon: Icons.local_drink_outlined,
                                ),
                                const SizedBox(height: 10),
                                TextInputFb1(
                                  inputController: _amountController,
                                  inputType: TextInputType.number,
                                  hintText: "Enter amount (mL)",
                                  prefixIcon: Icons.water_drop_outlined,
                                ),
                                const SizedBox(height: 10),
                                DropdownButton<String>(
                                  dropdownColor: Colors.white,
                                  value: _selectedDrinkType,
                                  isExpanded: true,
                                  items: <String>['Water', 'Other']
                                      .map<DropdownMenuItem<String>>(
                                          (String value) {
                                    return DropdownMenuItem<String>(
                                      value: value,
                                      child: Text(value),
                                    );
                                  }).toList(),
                                  onChanged: (String? newValue) {
                                    setState(() {
                                      _selectedDrinkType = newValue!;
                                    });
                                  },
                                ),
                              ],
                            ),
                          ),
                          actions: [
                            TextButton(
                              child: const Text(
                                'Cancel',
                                style: TextStyle(color: Colors.cyan),
                              ),
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                            ),
                            TextButton(
                              child: const Text(
                                'Log',
                                style: TextStyle(color: Colors.cyan),
                              ),
                              onPressed: () async {
                                await addWaterIntake(
                                    widget.userObj["uid"],
                                    _titleController.text,
                                    double.parse(_amountController.text),
                                    (_selectedDrinkType == "Water")
                                        ? true
                                        : false);
                                callWaterIntake();
                                setState(() {
                                  _selectedDrinkType = "Water";
                                });
                                _titleController.clear();
                                _amountController.clear();

                                Navigator.of(context).pop();
                              },
                            ),
                          ],
                        );
                      },
                    );
                  },
                );
              },
              backgroundColor: Colors.lightBlueAccent,
              child: const Icon(
                Icons.add_outlined,
                color: Colors.white,
              ),
            )
          : null,
      body: currUserObj.isNotEmpty
          ? IndexedStack(
              index: _selectedIndex,
              children: <Widget>[
                HomeScreen(
                  currentWeather: weatherCondition,
                  relativeHumidity: relativeHumidity,
                  currentTemperature: currentTemperature,
                  userObj: currUserObj,
                  allDrinks: drinks,
                ),
                TrendScreen(
                  allDrinks: drinks,
                  allPredictions: allPredictions,
                ),
                AddDrink(
                  allDrinks: drinks,
                ),
                PredictHydration(
                  userObj: currUserObj,
                  updateHydration: callPrediction,
                ),
                latitude != 0.0 && longitude != 0.0 
                    ? WaterMap(
                        latitude: latitude,
                        longitude: longitude,
                        locations: locations,
                      )
                    : const Center(
                        child:
                            CircularProgressIndicator()),
              ],
            )
          : const Center(child: CircularProgressIndicator()),
      bottomNavigationBar: BottomNavBarMallika1(
        onItemTapped: _onItemTapped,
        selectedIndex: _selectedIndex,
      ),
    );
  }
}
