import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hydrolyte/components/ResourceCarousel.dart';

class WaterMap extends StatefulWidget {
  final List<dynamic> locations;
  final double latitude;
  final double longitude;

  const WaterMap(
      {super.key,
      required this.latitude,
      required this.longitude,
      required this.locations});

  @override
  State<WaterMap> createState() => _WaterMapState();
}

class _WaterMapState extends State<WaterMap> {

  // Controllable through resource carousel .
  final Completer<GoogleMapController> _controller =
      Completer<GoogleMapController>();
  Set<Marker> _markers = {};

  @override
  void initState() {
    super.initState();
    _setMarkers();
  }

  void _setMarkers() {
    Set<Marker> markers = {};

    for (var location in widget.locations) {
      markers.add(
        Marker(
          markerId: MarkerId(location['id']),
          position: LatLng(double.parse(location['latitude']),
              double.parse(location['longitude'])),
          infoWindow: InfoWindow(
            title: location['name'],
            snippet: location['address'],
          ),
        ),
      );
    }

    setState(() {
      _markers = markers;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          GoogleMap(
            markers: _markers,
            onMapCreated: (GoogleMapController controller) {
              _controller.complete(controller);
            },
            initialCameraPosition: CameraPosition(
              target: LatLng(widget.latitude, widget.longitude),
              zoom: 11.0,
            ),
          ),
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Container(
              height: 230,
              margin: const EdgeInsets.fromLTRB(0, 50, 0, 0),
              child: ResourceCarousel(
                controller: _controller,
                locations: widget.locations,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
