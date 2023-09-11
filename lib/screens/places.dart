// import 'package:dial/providers/user_places.dart';
// import 'package:dial/screens/add_place.dart';
// import 'package:dial/widgets/places_list.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
//
// import '../ReusableCode.dart';
//
// //TODO Display the place chosen and click ad to open the add widget
//
// class PlacesScreen extends ConsumerWidget {
//   const PlacesScreen({Key? key}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     final userPlaces = ref.watch(userPlacesProvider);
//
//     return Scaffold(
//       appBar: AppBar(
//         elevation: 0,
//         backgroundColor: Colors.transparent,
//         // automaticallyImplyLeading: false,
//         // leading: IconButton(
//         //   icon: Icon(
//         //     Icons.cancel,
//         //     color: Colors.transparent,
//         //     size: 30,
//         //   ),
//         //   onPressed: () {
//         //     Navigator.of(context).push(MaterialPageRoute(
//         //       builder: (context) => const AddLocation(),
//         //     ));
//         //   },
//         // ),
//         actions: [
//           IconButton(
//             icon: Icon(
//               Icons.add,
//               color: Theme.of(context).primaryColorLight,
//               size: 30,
//             ),
//             onPressed: () {
//               Navigator.of(context).push(MaterialPageRoute(
//                 builder: (context) => const AddLocation(),
//               ));
//             },
//           ),
//         ],
//
//         title: Text(
//           "Places",
//           style: textStyleText.copyWith(
//               color: Theme.of(context).primaryColorLight, fontSize: 16),
//         ),
//       ),
//       extendBodyBehindAppBar: true,
//       extendBody: true,
//       backgroundColor: const Color(0xFF072456),
//       body: Container(
//         height: MediaQuery.of(context).size.height,
//         width: MediaQuery.of(context).size.width,
//         margin: const EdgeInsets.only(top: 0.0),
//         decoration: const BoxDecoration(
//           gradient: LinearGradient(
//               colors: [Color(0xFF072456), Color(0xff000000)],
//               begin: Alignment.topCenter,
//               end: Alignment.bottomCenter),
//         ),
//         child: PlacesList(
//           places: userPlaces,
//         ),
//       ),
//     );
//   }
// }
