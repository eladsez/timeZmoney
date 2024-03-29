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
    location.onLocationChanged.listen(
      (newLoc) {
        currentLocation = newLoc;
      },
    );
  }

  Future<void> setCurrentLocation() async {
    currentLocation = await location.getLocation();
    setState(() {});
    getPolyPoints();
  }

  goToCurrLocation() async{
    GoogleMapController googleMapController = await _controller.future;
    googleMapController.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(
          zoom: 18,
          target: LatLng(
            currentLocation!.latitude!,
            currentLocation!.longitude!,
          ),
        ),
      ),
    );
    setState(() {
    });

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
                zoom: 15,
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
      floatingActionButtonLocation: FloatingActionButtonLocation.startTop,
      floatingActionButton: GestureDetector(
        onTap: () => Navigator.of(context).pop(),
        child: Container(
            padding: const EdgeInsets.all(2),
            margin: const EdgeInsets.all(10),
            decoration: const BoxDecoration(
                shape: BoxShape.circle, color: Colors.white),
            child: const Icon(
              Icons.arrow_back,
              color: Color(0xff01b2b8),
            )),
      ),
    );
  }
}
