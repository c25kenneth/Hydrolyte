import 'package:flutter/material.dart';

class DrinkCard extends StatelessWidget {
  final String text;
  final String imageUrl;
  final String subtitle;
  final String time; 
  final bool isWater; 
  final Function() onPressed;

  const DrinkCard(
      {required this.text,
      required this.imageUrl,
      required this.subtitle,
      required this.time, 
      required this.isWater, 
      required this.onPressed,
      Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onLongPress: () {
        print("Held");
      },
      onTap: onPressed,
      child: Material(
        elevation: 2.0,
        borderRadius: BorderRadius.circular(24), 
        child: Container(
          width: MediaQuery.of(context).size.width * 0.9,
          padding: const EdgeInsets.all(15.0),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24), 
          ),
          child: Row(
            children: [
              (isWater) ? const Icon(Icons.local_drink_outlined, size: 32, color: Colors.lightBlueAccent,) : const Icon(Icons.coffee_outlined, color: Colors.black54,),
              const SizedBox(width: 15),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center, 
                  children: [
                    Row(
                      children: [
                        Text(
                          text,
                          textAlign: TextAlign.left,
                          style: const TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                        const Spacer(), 
                        Text(
                      time,
                      textAlign: TextAlign.left,
                      style: const TextStyle(
                        color: Colors.grey,
                        overflow: TextOverflow.ellipsis,
                        fontWeight: FontWeight.normal,
                        fontSize: 14,
                      ),
                    ),
                      ],
                    ),
                    const SizedBox(height: 2), 
                    Text(
                      subtitle,
                      textAlign: TextAlign.left,
                      style: TextStyle(
                        color: Colors.grey[700],
                        fontWeight: FontWeight.normal,
                        fontSize: 15,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
