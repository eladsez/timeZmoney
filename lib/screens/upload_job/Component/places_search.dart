import 'package:flutter/material.dart';
import 'package:flutter_google_places_hoc081098/flutter_google_places_hoc081098.dart';
import 'package:google_api_headers/google_api_headers.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:time_z_money/utils/constants.dart';

import 'inputfiled.dart';

class SearchPlace extends StatefulWidget {

  TextEditingController districtController;
  TextEditingController geoPointController;

  SearchPlace({Key? key, required this.districtController, required this.geoPointController}) : super(key: key);

  @override
  State<SearchPlace> createState() => _SearchPlaceState();
}

class _SearchPlaceState extends State<SearchPlace> {
  String location = "Search Location";

  @override
  Widget build(BuildContext context) {
    return InkWell(
        onTap: () async {
          var place = await PlacesAutocomplete.show(
              context: context,
              apiKey: kGoogleApiKey,
              mode: Mode.overlay,
              types: [],
              strictbounds: false,
              components: [Component(Component.country, 'il')],
              //google_map_webservice package
              onError: (err) {
                print(err);
              });

          if (place != null) {
            setState(() {
              location = place.description.toString();
            });

            //form google_maps_webservice package
            final plist = GoogleMapsPlaces(
              apiKey: kGoogleApiKey,
              apiHeaders: await const GoogleApiHeaders().getHeaders(),
              //from google_api_headers package
            );
            String placeId = place.placeId ?? "0";
            final detail = await plist.getDetailsByPlaceId(placeId);
            final geometry = detail.result.geometry!;
            final lat = geometry.location.lat;
            final lang = geometry.location.lng;
            widget.districtController.text = location;
            widget.geoPointController.text = "$lat,$lang";
          }
        },
        child: InputField(
          hint: location,
          title: "Location",
          fieldController: widget.districtController,
          child: const Icon(
            Icons.search,
            size: 32,
            color: Colors.grey,
          ),
        ));
  }
}
