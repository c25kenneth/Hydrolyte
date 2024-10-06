import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hydrolyte/BackendOperations.dart';
import 'package:hydrolyte/components/GoogleButton.dart';
import 'package:hydrolyte/screens/AddUserInfo.dart';
import 'package:hydrolyte/screens/FetchError.dart';
import 'package:hydrolyte/screens/Home.dart';
import 'package:wave/config.dart';
import 'package:wave/wave.dart';

class Welcome extends StatefulWidget {
  const Welcome({super.key});

  @override
  State<Welcome> createState() => _WelcomeState();
}

class _WelcomeState extends State<Welcome> {
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Stack(
        children: [
          WaveWidget(
            config: CustomConfig(
              gradients: [
                [Colors.blue, Colors.lightBlueAccent],
                [Colors.cyan, Colors.tealAccent],
                [Colors.teal, Colors.greenAccent],
                [Colors.lightBlue, Colors.cyanAccent]
              ],
              gradientBegin: Alignment.centerLeft,
              gradientEnd: Alignment.centerRight,
              durations: [3500, 19440, 10800, 6000],
              heightPercentages: [0.38, 0.41, 0.43, 0.48],
              blur: const MaskFilter.blur(BlurStyle.solid, 3),
            ),
            size: const Size(double.infinity, double.infinity),
          ),
          SafeArea(
            child: Center(
              child: Column(
                children: [
                  SizedBox(height: height * 0.05),
                  Text(
                    "Hyrdolyte",
                    style: TextStyle(
                        color: Colors.lightBlueAccent,
                        fontSize: width * 0.14,
                        fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: height * 0.02),
                  Image.asset(
                    "assets/images/Designer.png",
                    width: width * 0.60,
                    height: width * 0.60,
                  ),
                  const SizedBox(height: 45),
                  Container(
                    margin: EdgeInsets.symmetric(vertical: height * 0.03),
                    padding: EdgeInsets.symmetric(horizontal: width * 0.05),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Stay Hydrated, \nStay Healthy',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: width * 0.07,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  SizedBox(height: 5),
                  GoogleBtn1(
                    onPressed: () async {
                      dynamic res = await signInWithGoogle();
                      if (res.runtimeType == UserCredential) {
                        var user = await getUser(res.user!.uid);
                        if (user != null) {
                          Navigator.of(context).pushReplacement(
                            MaterialPageRoute(
                                builder: (context) => Home(userObj: user)),
                          );
                        } else if (user.runtimeType == String) {
                          Navigator.of(context).pushReplacement(
                            MaterialPageRoute(
                                builder: (context) => FetchError()),
                          );
                        } else {
                          Navigator.of(context).pushReplacement(
                            MaterialPageRoute(
                                builder: (context) =>
                                    AddUserInfo(uid: res.user!.uid)),
                          );
                        }
                      }
                    },
                  ),
                  SizedBox(height: height * 0.10)
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
