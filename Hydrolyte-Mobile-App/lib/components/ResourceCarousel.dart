import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class ResourceCarousel extends StatefulWidget {
  final Completer<GoogleMapController> controller; 
  final List<dynamic> locations; 
  const ResourceCarousel({Key? key, required this.locations, required this.controller}) : super(key: key);

  @override
  _ResourceCarouselState createState() => _ResourceCarouselState();
}

class _ResourceCarouselState extends State<ResourceCarousel> {

  final double carouselItemMargin = 16;

  late PageController _pageController;
  int _position = 0;
  Future<void> _findLocation(LatLng coordinate) async {
    final GoogleMapController controller = await widget.controller.future;
    await controller.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(target: coordinate, zoom: 15)));
  }
  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: 0, viewportFraction: .7);
  }

  @override
  Widget build(BuildContext context) {
    return PageView.builder(
        controller: _pageController,
        itemCount: widget.locations.length,
        onPageChanged: (int position) {
          setState(() {
            _position = position;
          });
        },
        itemBuilder: (BuildContext context, int position) {
          return imageSlider(position);
        });
  }

  Widget imageSlider(int position) {
    return AnimatedBuilder(
      animation: _pageController,
      builder: (BuildContext context, widget) {
        return Container(
          margin: EdgeInsets.all(carouselItemMargin),
          child: Center(child: widget),
        );
      },
      child: Container(
        child: CardFb1(name: widget.locations[position]['name'], address: widget.locations[position]['address'], type: widget.locations[position]['type'], location: LatLng(double.parse(widget.locations[position]['latitude']), double.parse(widget.locations[position]['longitude'])), onPressed: (){
          _findLocation(LatLng(double.parse(widget.locations[position]['latitude']), double.parse(widget.locations[position]['longitude'])));
        }),
      ),
    );
  }
}

class CardFb1 extends StatelessWidget {
  final String name;
  final String address; 
  final String type; 
  final LatLng location; 
  final Function() onPressed;

  const CardFb1(
      {required this.name,
      required this.address, 
      required this.type,
      required this.location,
      required this.onPressed,
      Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        width: 250,
        height: 130,  
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12.5),
          boxShadow: [
            BoxShadow(
                offset: const Offset(10, 20),
                blurRadius: 10,
                spreadRadius: 0,
                color: Colors.grey.withOpacity(.05)),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center, 
          children: [
            (type == "Park") ? Icon(Icons.park_outlined, size: 45, color: Colors.green,) : (type == "Gym") ? Icon(Icons.fitness_center_outlined, size: 45, color: Colors.blueGrey) : Icon(Icons.pool_outlined, size: 45, color: Colors.lightBlueAccent,),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,  
                mainAxisAlignment: MainAxisAlignment.center, 
                children: [
                  Text(name,
                      style: const TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                        overflow: TextOverflow.ellipsis,
                      )),
                  const SizedBox(height: 5),
                  Text(
                    address,
                    style: const TextStyle(
                      color: Colors.grey,
                      fontWeight: FontWeight.normal,
                      overflow: TextOverflow.ellipsis,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
