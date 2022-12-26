import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:time_z_money/screens/Loading_Screens/loading_screen.dart';
import '../../utils/constants.dart';

class MapDirection extends StatefulWidget {
  late final LatLng destination;

  MapDirection({required GeoPoint dest, Key? key}) : super(key: key) {
    destination = LatLng(dest.latitude, dest.longitude);
  }

  @override
  State<MapDirection> createState() => MapDirectionState();
}

class MapDirectionState extends State<MapDirection> {
  final Completer<GoogleMapController> _controller = Completer();

  Location location = Location();
  List<LatLng> polylineCoordinates = [];
  LocationData? currentLocation;

  updateCurrLocation() async {
    GoogleMapController googleMapController = await _controller.future;
    location.onLocationChanged.listen(
      (newLoc) {
        setState(() {
          currentLocation = newLoc;
          googleMapController.animateCamera(
            CameraUpdate.newCameraPosition(
              CameraPosition(
                zoom: 18,
                target: LatLng(
                  newLoc.latitude!,
                  newLoc.longitude!,
                ),
              ),
            ),
          );
        });
      },
    );
  }

  Future<void> setCurrentLocation() async {
    currentLocation = await location.getLocation();
    setState((){});
    getPolyPoints();
  }

  Future<void> getPolyPoints() async {
    PolylinePoints polylinePoints = PolylinePoints();
    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
      kGoogleApiKey,
      PointLatLng(currentLocation!.latitude!, currentLocation!.longitude!),
      PointLatLng(widget.destination.latitude, widget.destination.longitude),
    );
    if (result.points.isNotEmpty) {
      result.points.forEach(
        (PointLatLng point) => polylineCoordinates.add(
          LatLng(point.latitude, point.longitude),
        ),
      );
      setState(() {});
    }
  }

  @override
  void initState() {
    setCurrentLocation();
    updateCurrLocation();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: currentLocation == null
          ? const Loading()
          : GoogleMap(
              initialCameraPosition: CameraPosition(
                target: LatLng(
                    currentLocation!.latitude!, currentLocation!.longitude!),
                zoom: 5,
              ),
              polylines: {
                Polyline(
                  polylineId: const PolylineId("route"),
                  points: polylineCoordinates,
                  color: const Color(0xFF7B61FF),
                  width: 6,
                )
              },
              markers: {
                Marker(
                  markerId: const MarkerId("Your location"),
                  position: LatLng(
                      currentLocation!.latitude!, currentLocation!.longitude!),
                ),
                Marker(
                  markerId: const MarkerId("Job location"),
                  position: widget.destination,
                ),
              },
              onMapCreated: (mapController) {
                _controller.complete(mapController);
              },
            ),
    );
  }
}

// TODO: check if we need to add those function for permission

// void _getCurrentLocation() async {
//   Position position = await _determinePosition();
//   setState(() {
//     currentLocation = currentLocation;
//   });
// }
//
// Future<Position> _determinePosition() async {
//   LocationPermission permission;
//
//   permission = await Geolocator.checkPermission();
//
//   if(permission == LocationPermission.denied) {
//     permission = await Geolocator.requestPermission();
//     if(permission == LocationPermission.denied) {
//       return Future.error('Location Permissions are denied');
//     }
//   }
//
//   return await Geolocator.getCurrentPosition();
// }
