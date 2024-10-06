import 'package:flutter/material.dart';
import 'package:hydrolyte/BackendOperations.dart';
import 'package:hydrolyte/components/PredictionDialogue.dart';
import 'package:hydrolyte/components/TextInputField.dart';

class StepperWidget extends StatefulWidget {
  final Map<String, dynamic> userObj;
  final Function updatePredictions; 
  const StepperWidget({Key? key, required this.userObj, required this.updatePredictions}) : super(key: key);

  @override
  State<StepperWidget> createState() => _StepperWidgetState();
}

class _StepperWidgetState extends State<StepperWidget> {
  final TextEditingController _ageController = TextEditingController();
  final TextEditingController _heightController = TextEditingController();
  final TextEditingController _weightController = TextEditingController();
  final TextEditingController _handTempController = TextEditingController();
  final TextEditingController _armTempController = TextEditingController();

  int _currentStepper = 0;

  _stepTapped(int step) {
    setState(() => _currentStepper = step);
  }

  // Stepper logic
  _stepContinue() async {
    if (_currentStepper == 0) {
      if (_ageController.text.isNotEmpty &&
          _heightController.text.isNotEmpty &&
          _weightController.text.isNotEmpty) {
        setState(() => _currentStepper += 1);
      } else {
        print("Please fill out all demographics fields.");
      }
    } else if (_currentStepper == 1) {
      if (_handTempController.text.isNotEmpty &&
          _armTempController.text.isNotEmpty) {
        setState(() => _currentStepper += 1);
      } else {
        // Empty field
        print("Please fill out all temperature fields.");
      }
    } else if (_currentStepper == 2) {
      // Run this after all previous fields are filled
      dynamic res = await addPrediction(
          widget.userObj["uid"],
          int.parse(_ageController.text),
          double.parse(_weightController.text),
          double.parse(_heightController.text),
          double.parse(_handTempController.text),
          double.parse(_armTempController.text));
          setState(() {
            _currentStepper = 0; 
          });
          widget.updatePredictions(); 
      showDialog(
          context: context,
          builder: (context) => PredictionDialogue(
                predictedWaterLoss: res,
              ));
      _handTempController.clear();
      _armTempController.clear();
    }
  }

  _stepCancel() {
    _currentStepper > 0 ? setState(() => _currentStepper -= 1) : null;
  }

  final bool _isVerticalStepper = true;

  @override
  void initState() {
    super.initState();
    print(widget.userObj); 
    _updateControllers(widget.userObj); 
  }

  @override
  void didUpdateWidget(StepperWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.userObj != widget.userObj) {
      _updateControllers(widget.userObj); 
    }
  }

  // Set initial values for controllers (use inputted biometric data)
  void _updateControllers(Map<String, dynamic> userObj) {
    _ageController.text = userObj["age"].toString();
    _weightController.text = userObj["weight"].toString();
    _heightController.text = userObj["height"].toString();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;

    return SafeArea(
      child: Column(
        children: [
          Expanded(
            child: Stepper(
              type: _isVerticalStepper
                  ? StepperType.vertical
                  : StepperType.horizontal,
              physics: const ScrollPhysics(),
              currentStep: _currentStepper,
              onStepTapped: (step) => _stepTapped(step),
              onStepContinue: _stepContinue,
              onStepCancel: _stepCancel,
              steps: [
                Step(
                  title: const Text('Biometric Data'),
                  content: Column(
                    children: [
                      TextInputFb1(
                          inputController: _ageController,
                          inputType: TextInputType.number,
                          hintText: "Age",
                          prefixIcon: Icons.calendar_today),
                      TextInputFb1(
                          inputController: _heightController,
                          inputType: TextInputType.number,
                          hintText: "Height (cm)",
                          prefixIcon: Icons.height),
                      TextInputFb1(
                          inputController: _weightController,
                          inputType: TextInputType.number,
                          hintText: "Weight (kg)",
                          prefixIcon: Icons.monitor_weight),
                    ],
                  ),
                  isActive: _currentStepper >= 0,
                  state: _currentStepper >= 0
                      ? StepState.complete
                      : StepState.disabled,
                ),
                Step(
                  title: const Text('Temperature Measurements'),
                  content: Column(
                    children: [
                      TextFormField(
                        controller: _handTempController,
                        decoration:
                            const InputDecoration(labelText: 'Hand Temp (°C)'),
                      ),
                      TextFormField(
                        controller: _armTempController,
                        decoration:
                            const InputDecoration(labelText: 'Arm Temp (°C)'),
                      ),
                    ],
                  ),
                  isActive: _currentStepper >= 0,
                  state: _currentStepper >= 1
                      ? StepState.complete
                      : StepState.disabled,
                ),
                Step(
                  title: const Text('Predict'),
                  content: Column(
                    children: [
                      Row(
                        children: [
                          Image.asset(
                            "assets/images/Designer.png",
                            width: width * 0.20,
                            height: width * 0.20,
                          ),
                          const SizedBox(width: 15),
                          const Expanded(
                            child: Text(
                                "Our AI model will analyze the data you've input and predict your water loss!"),
                          ),
                        ],
                      ),
                    ],
                  ),
                  isActive: _currentStepper >= 0,
                  state: _currentStepper >= 2
                      ? StepState.complete
                      : StepState.disabled,
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
