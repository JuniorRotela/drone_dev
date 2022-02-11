import 'package:equatable/equatable.dart';
import 'package:google_maps/models/place.dart';
import 'package:google_maps/models/reverse_geocode_task.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'dart:io' show Platform;

import '../../../models/place.dart';

enum MapPick { none, origin, destination }
enum MapPicko { none, origin, destination }

class HomeState extends Equatable {
  final LatLng myLocation;
  final bool loading, gpsEnabled;
  final Map<MarkerId, Marker> markers;
  final Map<PolylineId, Polyline> polylines;
  final Map<PolygonId, Polygon> polygons;
  final Map<String, Place> history;
  final Place origin, destination;
  final MapPick mapPick;
  final MapPicko mapPicko;
  final ReverseGeocodeTask reverseGeocodeTask;

  HomeState({
    this.myLocation,
    this.loading,
    this.markers,
    this.gpsEnabled,
    this.polylines,
    this.polygons,
    this.history,
    this.destination,
    this.origin,
    this.mapPick,
    this.mapPicko,
    this.reverseGeocodeTask,
  });

  static HomeState get initialState => new HomeState(
        myLocation: null,
        loading: true,
        markers: Map(),
        polylines: Map(),
        polygons: Map(),
        history: Map(),
        gpsEnabled: Platform.isIOS,
        mapPick: MapPick.none,
        mapPicko: MapPicko.none,
      );

  HomeState copyWith({
    LatLng myLocation,
    bool loading,
    bool gpsEnabled,
    Map<MarkerId, Marker> markers,
    Map<PolylineId, Polyline> polylines,
    Map<PolygonId, Polygon> polygons,
    Map<String, Place> history,
    Place origin,
    Place destination,
    MapPick mapPick,
    MapPicko mapPicko,
    ReverseGeocodeTask reverseGeocodeTask,
  }) {
    return HomeState(
      myLocation: myLocation ?? this.myLocation,
      loading: loading ?? this.loading,
      markers: markers ?? this.markers,
      gpsEnabled: gpsEnabled ?? this.gpsEnabled,
      polylines: polylines ?? this.polylines,
      polygons: polygons ?? this.polygons,
      history: history ?? this.history,
      origin: origin ?? this.origin,
      destination: destination ?? this.destination,
      mapPick: mapPick ?? this.mapPick,
      mapPicko: mapPicko ?? this.mapPicko,
      reverseGeocodeTask: reverseGeocodeTask ?? this.reverseGeocodeTask,
    );
  }

  HomeState reset() {
    Place origin = Place(
      id: 'origin',
      title: "Tienda.",
      position: LatLng(-25.5074407, -54.6150159),
    );

    return HomeState(
      origin: origin,
      myLocation: LatLng(-25.5074407, -54.6150159),
      loading: false,
      markers: Map(),
      polylines: Map(),
      polygons: Map(),
      history: this.history,
      gpsEnabled: this.gpsEnabled,
      mapPick: MapPick.none,
    );
  }

  @override
  List<Object> get props => [
        myLocation,
        loading,
        markers,
        gpsEnabled,
        polylines,
        history,
        origin,
        destination,
        mapPick,
        mapPicko,
        polygons,
        reverseGeocodeTask,
      ];
}