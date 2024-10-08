import 'package:flutter/material.dart';

class TextInputFb1 extends StatelessWidget {
  final TextEditingController inputController;
  final TextInputType inputType; 
  final IconData? prefixIcon; 
  final String hintText; 
  const TextInputFb1({Key? key,required this.inputController, required this.inputType, required this.hintText, this.prefixIcon}) : super(key: key);
  

  @override
  Widget build(BuildContext context) {
    const primaryColor = Colors.cyan;
    const secondaryColor = Colors.cyan;
    const accentColor = Color(0xffffffff);
    const errorColor = Color(0xffEF4444);
   
    return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(
            height: 8,
          ),
          Container(
            height: 50,
            decoration: BoxDecoration(boxShadow: [
              BoxShadow(
                  offset: const Offset(12, 26),
                  blurRadius: 50,
                  spreadRadius: 0,
                  color: Colors.grey.withOpacity(.1)),
            ]),
            child: TextField(  
              controller: inputController,
              onChanged: (value) {
                //Do something wi
              },
              keyboardType: inputType,
              style: const TextStyle(fontSize: 14, color: Colors.black),
              decoration: InputDecoration(
                prefixIcon: Icon(prefixIcon, color: Colors.cyan,),
                filled: true,
                fillColor: accentColor,
                hintText: hintText,
                hintStyle: TextStyle(color: Colors.grey.withOpacity(.75)),
                contentPadding:
                    const EdgeInsets.symmetric(vertical: 0.0, horizontal: 20.0),
                border: const OutlineInputBorder(
                  borderSide: BorderSide(color: primaryColor, width: 1.0),
                  borderRadius: BorderRadius.all(Radius.circular(10.0)),
                ),
                focusedBorder: const OutlineInputBorder(
                  borderSide: BorderSide(color: secondaryColor, width: 1.0),
                  borderRadius: BorderRadius.all(Radius.circular(10.0)),
                ),
               errorBorder:const OutlineInputBorder(
                  borderSide: BorderSide(color: errorColor, width: 1.0),
                  borderRadius: BorderRadius.all(Radius.circular(10.0)),
                ) ,
                enabledBorder: const OutlineInputBorder(
                  borderSide: BorderSide(color: primaryColor, width: 1.0),
                  borderRadius: BorderRadius.all(Radius.circular(10.0)),
                ),
              ),
            ),
          ),
        ],
    );
  }
}