import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hydrolyte/BackendOperations.dart';
import 'package:hydrolyte/components/TextInputField.dart';
import 'package:hydrolyte/screens/FetchError.dart';
import 'package:hydrolyte/screens/Home.dart';

class AddUserInfo extends StatefulWidget {
  final String uid; 
  const AddUserInfo({super.key, required this.uid});

  @override
  State<AddUserInfo> createState() => _AddUserInfoState();
}

class _AddUserInfoState extends State<AddUserInfo> {

  final TextEditingController _ageEditingController = TextEditingController();
  final TextEditingController _weightEditingController = TextEditingController();
  final TextEditingController _heightEditingController = TextEditingController();

  String errorText = ""; 
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(title: const Text("Tell us about yourself")),
      body: Center(
        child: Column(
          children: [
            const SizedBox(height: 30),
            SvgPicture.asset(
              "assets/images/undraw_energizer_re_vhjv.svg",
              width: width * 0.45,
              height: width * 0.45,
            ),
            const SizedBox(height: 45),
            Container(
                margin: const EdgeInsets.all(10),
                child: TextInputFb1(
                  inputController: _ageEditingController,
                  prefixIcon: Icons.numbers,
                  hintText: "Enter your age",
                  inputType: TextInputType.number,
                )),
            Container(
                margin: const EdgeInsets.all(10),
                child: TextInputFb1(
                  inputController: _weightEditingController,
                  prefixIcon: Icons.scale,
                  hintText: "Enter your weight in kg",
                  inputType: TextInputType.number,
                )),
            Container(
                margin: const EdgeInsets.all(10),
                child: TextInputFb1(
                  inputController: _heightEditingController,
                  prefixIcon: Icons.height,
                  hintText: "Enter your height in cm",
                  inputType: TextInputType.number,
                )),
            Container(
              width: width,
              margin: const EdgeInsets.all(16),
              child: SizedBox(
                height: 50, 
                child: MaterialButton(
                  color: Colors.cyan,
                  onPressed: () async {

                    if (_ageEditingController.text.isEmpty || _weightEditingController.text.isEmpty || _heightEditingController.text.isEmpty) {
                      setState(() {
                        errorText = "One or more fields are empty!";
                      });
                    } else {
                      dynamic res = await addUser(widget.uid, int.parse(_ageEditingController.text), double.parse(_weightEditingController.text), double.parse(_heightEditingController.text));

                      if (res.runtimeType==String) {
                        Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => FetchError()));
                      } else {
                        Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => Home(userObj: res,)));
                      }
                    }
                  },
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(
                        10),
                  ),
                  child: const Text(
                    "Finish",
                    style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 15),
            Text(errorText, style: TextStyle(color: Colors.red, fontSize: 20),)
          ],
        ),
      ),
    );
  }
}
