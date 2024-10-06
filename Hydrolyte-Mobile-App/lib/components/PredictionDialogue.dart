import 'package:flutter/material.dart';

class PredictionDialogue extends StatelessWidget {
  final String predictedWaterLoss; 
  const PredictionDialogue({Key? key, required this.predictedWaterLoss}) : super(key: key);
  final primaryColor = Colors.lightBlueAccent;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Container(
        width: MediaQuery.of(context).size.width / 1.5,
        height: MediaQuery.of(context).size.height / 5,
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(15.0),
            boxShadow: [
              BoxShadow(
                  offset: const Offset(12, 26),
                  blurRadius: 50,
                  spreadRadius: 0,
                  color: Colors.grey.withOpacity(.1)),
            ]),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(
              backgroundColor: primaryColor,
              radius: 25,
              child: const Icon(Icons.water_drop_outlined, color: Colors.white,),
            ),
            const SizedBox(
              height: 15,
            ),
            const Text("Your Predicted Water Loss",
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 18,
                    fontWeight: FontWeight.bold)),
            const SizedBox(
              height: 3.5,
            ),
            Text(predictedWaterLoss,
                style: const TextStyle(
                    color: Colors.grey,
                    fontSize: 18,
                    fontWeight: FontWeight.w600)),
            const SizedBox(
              height: 15,
            ),
            
          ],
        ),
      ),
    );
  }
}