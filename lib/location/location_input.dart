// import 'dart:convert';
//
// import 'package:dial/DBModel/Place.dart';
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'package:location/location.dart';
//
// import '../ReusableCode.dart';
//
// class LocationInput extends StatefulWidget {
//   final void Function(PlaceLocation location) onSelectLocation;
//   const LocationInput({Key? key, required this.onSelectLocation})
//       : super(key: key);
//
//   @override
//   State<LocationInput> createState() => _LocationInputState();
// }
//
// class _LocationInputState extends State<LocationInput> {
//   PlaceLocation? _pickLocation;
//   bool _isGettingLocation = false;
//
//   final apiKey = "AIzaSyBOx5ybi0WTutSJZr3LD9EyotpyoO5srgk";
//
//   //get location
//   String get locationImage {
//     final lat = _pickLocation?.latitude;
//     final lng = _pickLocation?.longitude;
//
//     if (_pickLocation == null) {
//       return 'https://maps.googleapis.com/maps/api/staticmap?center=63.259591,-144.667969&zoom=6&size=600x400&markers=color:blue%7Clabel:S%7C62.107733,-145.541936&markers=size:tiny%7Ccolor:green%7CDelta+Junction,AK&markers=size:mid%7Ccolor:0xFFFF00%7Clabel:C%7CTok,AK"&key=$apiKey';
//     }
//     Reuse.logger.e("get latitude: ${_pickLocation!.latitude}");
//     Reuse.logger.e("get longitude: ${_pickLocation!.longitude}");
//
//     return 'https://maps.googleapis.com/maps/api/staticmap?center=$lat,$lng&zoom=16&size=600x300&maptype=roadmap&markers=color:red%7Clabel:A%7C$lat, $lng&key=$apiKey';
//     // 'https://maps.googleapis.com/maps/api/staticmap?center=$lat,$lng,SA&zoom=16&size=600x300&markers=color:red%7Clabel:A%7C$lat, $lng&key=$apiKey';
//   }
//
// //get current location
//   void _getCurrentLocation() async {
//     Location location = Location();
//
//     setState(() {
//       _isGettingLocation = true;
//     });
//     bool serviceEnabled;
//     PermissionStatus permissionGranted;
//     LocationData locationData;
//
//     serviceEnabled = await location.serviceEnabled();
//     if (!serviceEnabled) {
//       serviceEnabled = await location.requestService();
//       if (!serviceEnabled) {
//         return;
//       }
//     }
//
//     permissionGranted = await location.hasPermission();
//     if (permissionGranted == PermissionStatus.denied) {
//       permissionGranted = await location.requestPermission();
//       if (permissionGranted != PermissionStatus.granted) {
//         return;
//       }
//     }
//
//     locationData = await location.getLocation();
//
//     final lat = locationData.latitude;
//     final lng = locationData.longitude;
//     final url = Uri.parse(
//         'https://maps.googleapis.com/maps/api/geocode/json?latlng=$lat,$lng&key=$apiKey');
//
//     if (lat == null || lng == null) {
//       return;
//     }
//
//     //Extracting data from the object created
//     final response = await http.get(url);
//     final resData = jsonDecode(response.body);
//     final address = resData['results'][0]['formatted_address'];
//     Reuse.logger.e(locationData.latitude);
//     Reuse.logger.e(locationData.longitude);
//
//     setState(() {
//       _pickLocation =
//           PlaceLocation(latitude: lat, longitude: lng, address: address);
//       _isGettingLocation = false;
//     });
//     widget.onSelectLocation(_pickLocation!);
//
//     Reuse.logger.e(locationData.latitude);
//     Reuse.logger.e(locationData.longitude);
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     //No image yet
//     Widget previewContent = const Text(
//       "No location yet",
//       style: TextStyle(),
//     );
//
//     if (!_isGettingLocation) {
//       setState(() {
//         previewContent = const CircularProgressIndicator();
//       });
//     }
//     //get image
//     setState(() {
//       previewContent = Image.network(
//         locationImage,
//         fit: BoxFit.cover,
//         width: double.infinity,
//         height: double.infinity,
//         scale: 1,
//       );
//       _isGettingLocation = false;
//     });
//
//     return Column(
//       children: [
//         //show the map
//         Container(
//           height: 200,
//           padding: const EdgeInsets.all(10),
//           width: double.infinity,
//           alignment: Alignment.center,
//           decoration: BoxDecoration(
//             border: Border.all(
//               width: 1,
//               color: Theme.of(context).primaryColor.withOpacity(.2),
//             ),
//           ),
//           child: _isGettingLocation
//               ? const CircularProgressIndicator()
//               : previewContent,
//         ),
//         //  pick and get location
//         Row(
//           mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//           children: [
//             TextButton.icon(
//               // onPressed: () {},
//               onPressed: _getCurrentLocation,
//               icon: const Icon(Icons.location_on),
//               label: Text(
//                 "Get location",
//                 style: TextStyle(
//                   color: Theme.of(context).primaryColorLight,
//                 ),
//               ),
//             ),
//             TextButton.icon(
//               onPressed: () {},
//               icon: const Icon(Icons.map),
//               label: Text(
//                 "Select on map",
//                 style: TextStyle(
//                   color: Theme.of(context).primaryColorLight,
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ],
//     );
//   }
// }
