// import 'package:flutter/material.dart';
//
// import '../DBModel/Place.dart';
// import '../ReusableCode.dart';
//
// class PlaceDetailsScreen extends StatelessWidget {
//   final Place place;
//   const PlaceDetailsScreen({Key? key, required this.place}) : super(key: key);
//   final apiKey = "AIzaSyBOx5ybi0WTutSJZr3LD9EyotpyoO5srgk";
//
//   String get locationImage {
//     final lat = place.location.latitude;
//     final lng = place.location.longitude;
//
//     return 'https://maps.googleapis.com/maps/api/staticmap?center=$lat,$lng&zoom=16&size=600x300&maptype=roadmap&markers=color:red%7Clabel:A%7C$lat, $lng&key=$apiKey';
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         elevation: 0,
//         backgroundColor: Theme.of(context).primaryColor,
//         title: Text(
//           place.title,
//           style: textStyleText.copyWith(
//               color: Theme.of(context).primaryColorLight, fontSize: 16),
//         ),
//       ),
//       backgroundColor: Theme.of(context).primaryColorLight,
//       body: Center(
//         child: Stack(
//           children: [
//             ClipRRect(
//                 borderRadius: BorderRadius.circular(100.0),
//                 child: Image.network(locationImage)),
//             Positioned(
//               child: Text(
//                 place.location.address,
//                 style: textStyleText.copyWith(),
//               ),
//             )
//           ],
//         ),
//       ),
//     );
//   }
// }
