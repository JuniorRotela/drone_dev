import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:google_maps/main.dart';
import 'package:google_maps/widgets/icon_container.dart';
import 'package:google_maps/widgets/reset_button.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:google_maps/widgets/bottom_view.dart';
import 'package:google_maps/widgets/centered_marker.dart';
import 'package:google_maps/widgets/custom_app_bar.dart';
import 'package:google_maps/widgets/my_location_button.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../blocs/pages/home/bloc.dart';
import '../pedido/join_screen.dart';
import 'package:location/location.dart';
export 'home_page.dart';
import '../widgets/realtime.dart';

class HomePage extends StatefulWidget {
  final String partyNumber;
  final String userId;

  const HomePage({Key key, this.userId, this.partyNumber}) : super(key: key);
  static const routeName = 'home-page';
  @override
  _HomePageState createState() => _HomePageState();
}

class Person {
  final String id;
  final LatLng position;
  Person(this.id, this.position);
}

class _HomePageState extends State<HomePage> {
  final HomeBloc _bloc = HomeBloc();
  // -0.1081339,-78.4699519,18z

  BitmapDescriptor pinLocationIcon; // -borrar prueba
  var start_currentPostion; // -borrar prueba
  var end_currentPostion; // -borrar prueba

  GoogleMapController _mapController;
  Location _location = Location();
  StreamSubscription<LocationData> subscription; // -borrar estados de entradas
  StreamSubscription<QuerySnapshot>
      documentSubscription; // -escuchar personas o estados
  List<Person> pleople = List();
  LatLng _at;
  @override
  void initState() {
    super.initState();

    _inititLocation(); // -borrar

    print("HOOOOOOOLA 😸");
  }

  _inititLocation() async {
    var _serviceEnabled = await _location.serviceEnabled(); // -borrar
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
    Firestore.instance
        .collection('parties')
        .document(widget.partyNumber)
        .collection('pleople')
        .snapshots()
        .listen((event) {
      pleople = event.documents
          .map(
            (e) => Person(
              e.documentID,
              LatLng(e['lat'], e['lng']),
            ),
          )
          .toList();
      setState(() {});
    });

    subscription = _location.onLocationChanged().listen((LocationData event) {
      if (_mapController != null) {
        _mapController.animateCamera(
          CameraUpdate.newLatLng(
            LatLng(event.latitude, event.longitude),
          ),
        );
      }
      //intancia para agregar valores a la base de datos//
      Firestore.instance
          .collection('parties')
          .document(widget.partyNumber)
          .collection('pleople')
          .document(widget.userId)
          .setData({
        'lat': event.latitude,
        'lng': event.longitude,
      });
      print("su latitud pana $event.latitude}, frezco $event.longitude} ");
    });
  } // -borrar

  @override
  void dispose() {
    // cancelar subscripcion a firebase//
    if (subscription != null) {
      subscription.cancel();
    }
    if (documentSubscription = null) {
      documentSubscription.cancel();
    }
    Firestore.instance
        .collection('parties')
        .document(widget.partyNumber)
        .collection('pleople')
        .document(widget.userId)
        .delete();

    _bloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bottomHeight = MediaQuery.of(context).padding.bottom;
    return BlocProvider.value(
      value: this._bloc,
      child: Scaffold(
        body: SlidingUpPanel(
          panel: BottomView(),
          minHeight: 100 + bottomHeight,
          body: SafeArea(
            bottom: false,
            child: BlocBuilder<HomeBloc, HomeState>(
              builder: (_, state) {
                if (!state.gpsEnabled) {
                  return Center(
                    child: Text(
                      "Para utilizar la app active el GPS",
                      textAlign: TextAlign.center,
                    ),
                  );
                }
                // IconContainer();
                if (state.loading) {
                  return Center(
                    child: CircularProgressIndicator(
                      backgroundColor: Colors.red,
                    ),
                  );
                }

                final CameraPosition initialPosition = CameraPosition(
                  target: state.myLocation,
                  zoom: 15,
                );

                return Column(
                  children: <Widget>[
                    Expanded(
                      child: Stack(
                        alignment: Alignment.center,
                        children: <Widget>[
                          GoogleMap(
                            initialCameraPosition: initialPosition,
                            zoomControlsEnabled: false,
                            compassEnabled: false,
                            myLocationEnabled: true,

                            markers: state.markers.values.toSet(),
                            //people
                            //.map(
                            // (e) => Marker(
                            // markerId: MarkerId(e.id),
                            //  position: e.position,
                            // ),
                            // )
                            // .toSet(),

                            onCameraMoveStarted: () {
                              print("onCameraMoveStarted");
                              if (state.mapPick != MapPick.none) {
                                this._bloc.onCameraMoveStarted();
                              }
                            },
                            onCameraMove: (cameraPosition) {
                              this._at = cameraPosition.target;
                            },
                            onCameraIdle: () {
                              if (state.mapPick != MapPick.none) {
                                this._bloc.reverseGeocode(this._at);
                              }
                            },
                            //  markers: state.markers.values
                            //  .toSet(), // descomentar para el marcador
                            polylines: state.polylines.values.toSet(),
                            polygons: state.polygons.values.toSet(),
                            myLocationButtonEnabled: false,
                            onMapCreated: (GoogleMapController controller) {
                              this._bloc.setMapController(controller);
                            },
                          ),
                          MyLocationButton(),
                          CenteredMarked(),
                          ResetButton()
                        ],
                      ),
                    ),
                    SizedBox(height: 100 + bottomHeight),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
