import 'package:flutter/material.dart';
import 'package:hydrolyte/components/PredictionForm.dart';

class PredictHydration extends StatefulWidget {
  final Map<String, dynamic> userObj; 
  final Function updateHydration; 
  const PredictHydration({super.key, required this.userObj, required this.updateHydration});

  @override
  State<PredictHydration> createState() => _PredictHydrationState();
}

class _PredictHydrationState extends State<PredictHydration> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(child: StepperWidget(userObj: widget.userObj, updatePredictions: widget.updateHydration,)),
        ],
      ),
    );
  }
}