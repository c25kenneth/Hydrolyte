import 'package:flutter/material.dart';

class TopAppBarFb2 extends StatelessWidget {
  final String title;
  final String upperTitle;
  const TopAppBarFb2({required this.title, required this.upperTitle, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children:  [
          Text(title,
              style: const TextStyle(
                  color: Colors.grey,
                  fontSize: 14,
                  fontWeight: FontWeight.normal)),
          Text(upperTitle,
              style: const TextStyle(
                  color: Colors.black,
                  fontSize: 26,
                  fontWeight: FontWeight.bold))
        ],
    );
  }
}
