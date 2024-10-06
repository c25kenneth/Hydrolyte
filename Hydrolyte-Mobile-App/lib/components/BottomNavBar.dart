import 'package:flutter/material.dart';
class BottomNavBarMallika1 extends StatelessWidget {
  const BottomNavBarMallika1({
    Key? key,
    required this.onItemTapped,
    required this.selectedIndex,
  }) : super(key: key);

  final Function(int) onItemTapped;
  final int selectedIndex;

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      color: Colors.white,
      child: SizedBox(
        height: 56,
        width: MediaQuery.of(context).size.width,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconBottomBar(
                text: "Home",
                icon: Icons.home_outlined,
                selected: selectedIndex == 0,
                onPressed: () => onItemTapped(0),
              ),
              IconBottomBar(
                text: "Track",
                icon: Icons.trending_up_outlined,
                selected: selectedIndex == 1,
                onPressed: () => onItemTapped(1),
              ),
              IconBottomBar2(
                text: "Add",
                icon: Icons.water_drop_outlined,
                selected: selectedIndex == 2,
                onPressed: () => onItemTapped(2),
              ),
              IconBottomBar(
                text: "Water Loss",
                icon: Icons.psychology,
                selected: selectedIndex == 3,
                onPressed: () => onItemTapped(3),
              ),
              IconBottomBar(
                text: "Resources",
                icon: Icons.map_outlined,
                selected: selectedIndex == 4,
                onPressed: () => onItemTapped(4),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class IconBottomBar extends StatelessWidget {
  const IconBottomBar({
    Key? key,
    required this.text,
    required this.icon,
    required this.selected,
    required this.onPressed,
  }) : super(key: key);

  final String text;
  final IconData icon;
  final bool selected;
  final VoidCallback onPressed;

  final blueColor = Colors.lightBlueAccent;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        IconButton(
          onPressed: onPressed,
          icon: Icon(
            icon,
            size: 25,
            color: selected ? blueColor : Colors.black54,
          ),
        ),
      ],
    );
  }
}

class IconBottomBar2 extends StatelessWidget {
  const IconBottomBar2({
    Key? key,
    required this.text,
    required this.icon,
    required this.selected,
    required this.onPressed,
  }) : super(key: key);

  final String text;
  final IconData icon;
  final bool selected;
  final VoidCallback onPressed;

  final blueColor = Colors.lightBlueAccent;

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      backgroundColor: blueColor,
      child: IconButton(
        onPressed: onPressed,
        icon: Icon(
          icon,
          size: 25,
          color: Colors.white,
        ),
      ),
    );
  }
}