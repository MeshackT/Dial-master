// import 'package:dial/DBModel/Place.dart';
// import 'package:flutter/material.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
//
// class MapScreen extends StatefulWidget {
//   const MapScreen({Key? key, this.location}) : super(key: key);
//   final PlaceLocation? location;
//
//   @override
//   State<MapScreen> createState() => _MapScreenState();
// }
//
// class _MapScreenState extends State<MapScreen> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: GoogleMap(
//         mapType: MapType.hybrid,
//         initialCameraPosition: CameraPosition(
//             target:
//                 LatLng(widget.location!.latitude, widget.location!.longitude),
//             tilt: 59.440717697143555,
//             zoom: 19.151926040649414),
//         onMapCreated: (GoogleMapController controller) {
//           // _controller.complete(controller);
//         },
//       ),
//     );
//   }
// }
