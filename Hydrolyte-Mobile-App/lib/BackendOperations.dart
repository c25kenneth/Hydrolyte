import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

// Base endpoint (hid full location for Github)
String baseURL = 'http://XXX.XXX.XX.XX:00000/';

// Add predicted water loss to database. 
Future addPrediction(String uid, int age, double weight, double height, double hand_temp, double arm_temp) async {
  String url = '${baseURL}put_prediction';

  Map<String, dynamic> data = {
    "uid": uid, 
    "age_years": age, 
    "weight_kg": weight, 
    "height_cm": height,
    "hand_temperature_average": hand_temp, 
    "arm_temperature_average": arm_temp,
  };

  try {
    final response = await http.post(
      Uri.parse(url),
      headers: {
        "Content-Type": "application/json",
      },
      body: jsonEncode(data),
    );

    if (response.statusCode == 200) {
      print('Prediction result: ${response.body}');
      return response.body;

    } else {
      print('Error: ${response.statusCode}');
    }
  } catch (e) {
    print('Error: $e');
  }
}

// Firebase Auth Sign in w/ Google Function 
dynamic signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

      final GoogleSignInAuthentication? googleAuth =
          await googleUser?.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );
      
      UserCredential cred = await FirebaseAuth.instance.signInWithCredential(credential);
      
      return cred;
    } catch (e) {
      print(e.toString());
      return "Error signing in with Google. Please try again.";
    }
  }

// Update user biometric data information
Future<void> updateUser(String uid, {int? age, double? weight, double? height}) async {
  final String apiUrl = '${baseURL}update_user'; 

  Map<String, dynamic> body = {
    'uid': uid,
    'age': age,
    'weight': weight,
    'height': height,
  };

  // Make sure there are no null values
  body.removeWhere((key, value) => value == null);

  try {
    final response = await http.put(
      Uri.parse(apiUrl),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode(body),
    );

    if (response.statusCode == 200) {
      print('User updated successfully: ${response.body}');
    } else {
      print('Failed to update user: ${response.statusCode} - ${response.body}');
    }
  } catch (e) {
    print('Error updating user: $e');
  }
}

// Call weather API based on device's geolocation data.
getWeather(double latitude, double longitude) async {
  String url = 'https://api.open-meteo.com/v1/forecast?latitude=$latitude&longitude=$longitude&current_weather=true&hourly=temperature_2m,relative_humidity_2m';

  var response = await http.get(Uri.parse(url));

  if (response.statusCode == 200) {
    var data = jsonDecode(response.body);

    var currentWeather = data['current_weather'];
    var temperature = currentWeather['temperature'];
    var hourlyHumidity = data['hourly']['relative_humidity_2m'];
    var weatherCode = currentWeather['weathercode'];
    String condition = getWeatherConditionFromCode(weatherCode);
    
    print('Current temperature: ${temperature.toStringAsFixed(2)}°C');

    // Make sure we get a value for the humidity 
    if (hourlyHumidity != null && hourlyHumidity.isNotEmpty) {
      var currentHumidity = hourlyHumidity[0];
      print('Current relative humidity: $currentHumidity%');
      return {
        'temperature': temperature,
        'humidity': currentHumidity,
        'condition': condition
      };
    } else {
      print('Humidity data not available.');

      return "Error fetching data"; 
    }

  } else {
    return "Error fetching data"; 
  }
}

// Convert weather code to actual weather 
String getWeatherConditionFromCode(int weatherCode) {
  if (weatherCode == 0) return 'Sunny';
  if (weatherCode == 1 || weatherCode == 2) return 'Partly Cloudy';
  if (weatherCode == 3) return 'Cloudy';
  if (weatherCode >= 45 && weatherCode <= 48) return 'Foggy';
  if (weatherCode >= 51 && weatherCode <= 57) return 'Drizzle';
  if (weatherCode >= 61 && weatherCode <= 67) return 'Rain';
  if (weatherCode >= 71 && weatherCode <= 77) return 'Snow';
  if (weatherCode >= 80 && weatherCode <= 82) return 'Showers';
  if (weatherCode >= 95) return 'Thunderstorm';
  return 'Unknown';
}

// Get user JSON via document
Future<dynamic> getUser(String uid) async {
  final String apiUrl = '${baseURL}get_user?uid=$uid';

  final response = await http.get(
    Uri.parse(apiUrl),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
  );

  if (response.statusCode == 200) {
    var userData = jsonDecode(response.body);
    print(userData);
    return userData;  
  } else if (response.statusCode == 404) {
    print("No user found");
    return null;  
  } else {
    print("Failed to load user data: ${response.statusCode}");
    return "Failed to load user data";  
  }
}

// Create user if they don't exist. 
Future<dynamic> addUser(String uid, int age, double weight, double height) async {
  final String apiUrl = '${baseURL}add_user';

  final response = await http.post(
    Uri.parse(apiUrl),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(<String, dynamic>{
      'uid': uid,
      'age': age,
      'weight': weight,  
      'height': height, 
    }),
  );

  if (response.statusCode == 200) {
    print("User added successfully: ${response.body}");
    return {
      'uid': uid,
      'age': age,
      'weight': weight,
      'height': height
    };
  } else {
    print("Failed to add user: ${response.statusCode} - ${response.body}");
    return "Failed to add user"; 
  }
}

// Log water intake 
addWaterIntake(String uid, String drinkName, double drinkAmount, bool isWater) async {
  final String apiUrl = '${baseURL}add_water_intake';

  final Map<String, dynamic> waterIntakeData = {
    'uid': uid,
    'drinkName': drinkName,
    'drinkAmount': drinkAmount,
    'isWater': isWater,
  };

  final response = await http.post(
    Uri.parse(apiUrl),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(waterIntakeData),  
  );

  if (response.statusCode == 200) {
    print("Water intake added successfully: ${response.body}");
  } else {
    print("Failed to add water intake: ${response.statusCode} - ${response.body}");
  }
}

// Get list of all waters drank (filter drinks from today later)
Future<List<Map<String, dynamic>>> getWaterIntake(String uid) async {
  final String apiUrl = '${baseURL}get_water_intake?uid=$uid';

  try {
    final response = await http.get(
      Uri.parse(apiUrl),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );

    if (response.statusCode == 200) {
      var jsonResponse = jsonDecode(response.body);
      List<dynamic> drinks = jsonResponse['drinks'];

      List<Map<String, dynamic>> readableDrinks = drinks.map<Map<String, dynamic>>((drink) {
        String readableTimestamp = _convertTimestamp(drink['timestamp']);
        return {
          'drinkAmount': drink['drinkAmount'],
          'drinkName': drink['drinkName'],
          'isWater': drink['isWater'],
          'timestamp': readableTimestamp,
          'uid': drink['uid'],
        };
      }).toList();

      return readableDrinks;
    } else {
      print("Failed to fetch water intake: ${response.statusCode} - ${response.body}");
      return [];
    }
  } catch (e) {
    print("Error fetching water intake: $e");
    return [];
  }
}

// Add water loss prediction. Use uid 
Future<List<dynamic>> getPrediction(String uid) async {
  final String url = '${baseURL}get_prediction'; 
  final response = await http.get(
    Uri.parse('$url?uid=$uid'),
    headers: {
      'Content-Type': 'application/json',
    },
  );

  if (response.statusCode == 200) {
    final Map<String, dynamic> data = jsonDecode(response.body);
    return data['predictions'] ?? []; // Return the predictions list or an empty list
  } else {
    throw Exception('Failed to load predictions: ${response.statusCode}');
  }
}

// Get list of locations from Dynamo
Future<List<dynamic>> fetchLocations() async {
  final String apiUrl = '${baseURL}get_locations';

  try {
    final response = await http.get(Uri.parse(apiUrl));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      
      return data['locations'];
    } else {
      throw Exception('Failed to load locations');
    }
  } catch (error) {
    print('Error fetching locations: $error');
    return [];
  }
}

// Convert database timestamp to DateTime obj 
String _convertTimestamp(String timestamp) {
  DateTime dateTime = DateTime.parse(timestamp);
  return DateFormat('yMMMd').add_jm().format(dateTime); 
}
