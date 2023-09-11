// import 'package:dial/ReusableCode.dart';
// import 'package:dial/screens/places_details.dart';
// import 'package:flutter/material.dart';
//
// import '../DBModel/Place.dart';
//
// // TODO Display this list after adding places by calling this screen from places.dart
//
// class PlacesList extends StatelessWidget {
//   final List<Place> places;
//   const PlacesList({Key? key, required this.places}) : super(key: key);
//   final apiKey = "AIzaSyBOx5ybi0WTutSJZr3LD9EyotpyoO5srgk";
//
//   //get location
//   String get locationImage {
//     return ''
//         'https://maps.googleapis.com/maps/api/staticmap?center=63.259591,-144.667969&zoom=6&size=600x400&markers=color:blue%7Clabel:S%7C62.107733,-145.541936&markers=size:tiny%7Ccolor:green%7CDelta+Junction,AK&markers=size:mid%7Ccolor:0xFFFF00%7Clabel:C%7CTok,AK"&key=$apiKey';
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     //check if places exist
//     if (places.isEmpty) {
//       return Center(
//         child: Text(
//           "No places added yet",
//           style: textStyleText.copyWith(
//               color: Theme.of(context).primaryColorLight),
//         ),
//       );
//     }
//
//     return ListView.builder(
//       itemCount: places.length,
//       itemBuilder: (context, index) => ListTile(
//         onTap: () {
//           Navigator.of(context).push(MaterialPageRoute(
//             builder: (context) => PlaceDetailsScreen(place: places[index]),
//           ));
//         },
//         leading: CircleAvatar(
//           child: Text(places[index].title[0]),
//         ),
//         title: Text(
//           places[index].title,
//           style: textStyleText.copyWith(
//               color: Theme.of(context).primaryColorLight,
//               fontWeight: FontWeight.w800),
//         ),
//         subtitle: Text(
//           places[index].location.address,
//           style: textStyleText.copyWith(
//             color: Theme.of(context).primaryColorLight.withOpacity(.69),
//             fontSize: 10,
//           ),
//         ),
//       ),
//     );
//   }
// }
