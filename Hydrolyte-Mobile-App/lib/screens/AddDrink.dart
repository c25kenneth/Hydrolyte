import 'package:flutter/material.dart';
import 'package:hydrolyte/components/DrinkCard.dart';
import 'package:hydrolyte/components/TopAppBar.dart';

class AddDrink extends StatefulWidget {
  final List<dynamic> allDrinks; 
  const AddDrink({super.key, required this.allDrinks});

  @override
  State<AddDrink> createState() => _AddDrinkState();
}

class _AddDrinkState extends State<AddDrink> {
    
  @override
  Widget build(BuildContext context) {
    return Center(
      child: SafeArea(
        child: Column(
          children: [
            Container(margin: const EdgeInsets.all(20), child: const Align(alignment: Alignment.centerLeft, child: TopAppBarFb2(title: "", upperTitle: "Your Water Intake 💧"))),
            
            Expanded(
              child: ListView.builder(itemCount: widget.allDrinks.length, itemBuilder: (context, index) {
                return Container(margin: const EdgeInsets.all(12), child: DrinkCard(text: widget.allDrinks[index]["drinkName"], imageUrl: "", subtitle: widget.allDrinks[index]["drinkAmount"], time: widget.allDrinks[index]["timestamp"], isWater: widget.allDrinks[index]["isWater"], onPressed: () {}));
              }),
            ),
          ],
        ),
      ),
    );
  }
}