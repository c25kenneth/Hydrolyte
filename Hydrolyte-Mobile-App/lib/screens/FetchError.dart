import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class FetchError extends StatefulWidget {
  const FetchError({super.key});

  @override
  State<FetchError> createState() => _FetchErrorState();
}

class _FetchErrorState extends State<FetchError> {
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset(
              "assets/images/undraw_warning_re_eoyh.svg",
              width: width * 0.45,
              height: width * 0.45,
            ),
            SizedBox(height: 35),
            Text("Please check your network connectivity", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),textAlign: TextAlign.center,)
          ],
        ),
      ),
    );
  }
}
