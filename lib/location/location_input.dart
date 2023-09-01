import 'package:flutter/material.dart';

class LocationInput extends StatefulWidget {
  const LocationInput({Key? key}) : super(key: key);

  @override
  State<LocationInput> createState() => _LocationInputState();
}

class _LocationInputState extends State<LocationInput> {
  // Location? _pickLocation;
  // bool _isGettingLocation = false;
  //
  // //get current location
  // void _getCurrentLocation() async {
  //   Location location = Location();
  //
  //   bool serviceEnabled;
  //   PermissionStatus permissionGranted;
  //   LocationData locationData;
  //
  //   serviceEnabled = await location.serviceEnabled();
  //   if (!serviceEnabled) {
  //     serviceEnabled = await location.requestService();
  //     if (!serviceEnabled) {
  //       return;
  //     }
  //   }
  //
  //   permissionGranted = await location.hasPermission();
  //   if (permissionGranted == PermissionStatus.denied) {
  //     permissionGranted = await location.requestPermission();
  //     if (permissionGranted != PermissionStatus.granted) {
  //       return;
  //     }
  //   }
  //   setState(() {
  //     _isGettingLocation = true;
  //   });
  //
  //   locationData = await location.getLocation();
  //   setState(() {
  //     _isGettingLocation = false;
  //   });
  //
  //   Reuse.logger.e(locationData.latitude);
  //   Reuse.logger.e(locationData.longitude);
  // }

  @override
  Widget build(BuildContext context) {
    Widget previewContent = Text(
      "No location yet",
      style: TextStyle(),
    );

    // if (_isGettingLocation) {
    //   previewContent = const CircularProgressIndicator();
    // }

    return Column(
      children: [
        //show the map
        Container(
          height: 170,
          width: double.infinity,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            border: Border.all(
              width: 1,
              color: Theme.of(context).primaryColor.withOpacity(.2),
            ),
          ),
          child: previewContent,
        ),
        //  pick and get location
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            TextButton.icon(
              onPressed: () {},
              // onPressed: _getCurrentLocation,
              icon: const Icon(Icons.location_on),
              label: Text(
                "Get location",
                style: TextStyle(
                  color: Theme.of(context).primaryColorLight,
                ),
              ),
            ),
            TextButton.icon(
              onPressed: () {},
              icon: Icon(Icons.map),
              label: Text(
                "Select on map",
                style: TextStyle(
                  color: Theme.of(context).primaryColorLight,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
