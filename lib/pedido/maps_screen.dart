import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import '../pages/home_page.dart';

class MapsScreen extends StatefulWidget {
  final String partyNumber;
  final String userId;

  const MapsScreen({Key key, this.userId, this.partyNumber}) : super(key: key);

  @override
  _MapsScreenState createState() => _MapsScreenState();
}

class _MapsScreenState extends State<MapsScreen> {
  GoogleMapController _mapController;
  Location _location = Location();

  @override
  Void initState() {
    super.initState();

    _inititLocation();
  }

  _inititLocation() async {
    var _serviceEnabled = await _location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await _location.requestService();
      if (!_serviceEnabled) {
        return;
      }
    }

    var _permissionGranted = await _location.hasPermission();
    if (_permissionGranted == PermissionStatus.DENIED) {
      _permissionGranted = await _location.requestPermission();
      if (_permissionGranted != PermissionStatus.GRANTED) {
        print("NO PERMISSION");
        return;
      }
    }
    _location.onLocationChanged().listen((LocationData event) {
      if (_mapController != null) {
        _mapController.animateCamera(
          CameraUpdate.newLatLng(
            LatLng(event.latitude, event.longitude),
          ),
        );
      }
      print("$event.latitude}, $event.longitude} ");
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("See you Here"),
      ),
      body: GoogleMap(
        initialCameraPosition: CameraPosition(
          target: LatLng(-34.5811182, -58.4375054),
          zoom: 16,
        ),
        zoomControlsEnabled: true,
        myLocationEnabled: true,
        myLocationButtonEnabled: true,
        onMapCreated: (controller) => _mapController = controller,
      ),
    );
  }
}
