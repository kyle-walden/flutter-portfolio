import 'package:flutter/material.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';

class FullMap extends StatefulWidget {
  const FullMap();

  @override
  State createState() => FullMapState();
}

class FullMapState extends State<FullMap> {
  MapboxMap? mapboxMap;

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        body: MapWidget(
      key: ValueKey("mapWidget"),
      onMapCreated: _onMapCreated,
      cameraOptions: CameraOptions(
        // CameraOptions.center expects a Point instance.
        center: Point(coordinates: Position(-80.1263, 25.7845)),
        zoom: 12.0,
      ),
    ));
  }

  void _onMapCreated(MapboxMap createdMapboxMap) {
    setState(() {
      mapboxMap = createdMapboxMap;
    });
  }
}
