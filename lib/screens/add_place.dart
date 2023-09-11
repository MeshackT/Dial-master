// import 'package:dial/DBModel/Place.dart';
// import 'package:dial/ReusableCode.dart';
// import 'package:dial/location/location_input.dart';
// import 'package:dial/providers/user_places.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
//
// //TODO Add screen, add a place title asl known as addPLacesScreen
// class AddLocation extends ConsumerStatefulWidget {
//   const AddLocation({Key? key}) : super(key: key);
//   static const routeName = '/addLocation';
//
//   @override
//   ConsumerState<AddLocation> createState() => _AddLocationState();
// }
//
// class _AddLocationState extends ConsumerState<AddLocation> {
//   final _titleController = TextEditingController();
//   PlaceLocation? _selectedLocation;
//
//   //TODO Place title
//   void _savePlace() {
//     final enteredTitle = _titleController.text;
//
//     //basic validation
//     if (enteredTitle.isEmpty || _selectedLocation == null) {
//       return;
//     }
//     Reuse.logger.e(enteredTitle);
//
//     ref.read(userPlacesProvider.notifier).addPlace(
//           enteredTitle,
//           _selectedLocation!,
//         );
//     setState(() {
//       _titleController.text = "";
//     });
//     // Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context)=>const );
//   }
//
//   @override
//   void dispose() {
//     _titleController.dispose();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: Colors.transparent,
//         elevation: 0,
//         leading: IconButton(
//           icon: Icon(
//             Icons.cancel,
//             color: Theme.of(context).primaryColorLight,
//             size: 30,
//           ),
//           onPressed: () {
//             // Navigator.of(context).push(
//             //     MaterialPageRoute(builder: (context) => const PlacesScreen()));
//             Navigator.of(context)
//                 .pushNamedAndRemoveUntil('/', (route) => false);
//           },
//         ),
//       ),
//       extendBodyBehindAppBar: true,
//       extendBody: true,
//       backgroundColor: const Color(0xFF072456),
//       body: SafeArea(
//         child: SingleChildScrollView(
//           child: Container(
//             height: MediaQuery.of(context).size.height,
//             width: MediaQuery.of(context).size.width,
//             margin: const EdgeInsets.only(top: 0.0),
//             decoration: const BoxDecoration(
//               //screen background color
//               gradient: LinearGradient(
//                   colors: [Color(0xFF072456), Color(0xff000000)],
//                   begin: Alignment.topCenter,
//                   end: Alignment.bottomCenter),
//             ),
//             child: Column(
//               children: [
//                 LocationInput(
//                   onSelectLocation: (location) {
//                     _selectedLocation = location;
//                   },
//                 ),
//                 Reuse.spaceBetween(),
//                 Padding(
//                   padding: const EdgeInsets.symmetric(horizontal: 30.0),
//                   child: TextField(
//                     style:
//                         TextStyle(color: Theme.of(context).primaryColorLight),
//                     controller: _titleController,
//                     cursorColor: Theme.of(context).primaryColorLight,
//                     textAlign: TextAlign.center,
//                     decoration: InputDecoration(
//                       filled: true,
//                       fillColor:
//                           Theme.of(context).primaryColorLight.withOpacity(.5),
//                       hintText: "Add a place",
//                       hintStyle: textStyleText.copyWith(
//                           color: Theme.of(context).primaryColorLight),
//                     ),
//                   ),
//                 ),
//                 Reuse.spaceBetween(),
//                 TextButton(
//                   onPressed: _savePlace,
//                   child: const Text("Add Place"),
//                 ),
//                 Reuse.spaceBetween(),
//                 TextButton(
//                   onPressed: () {
//                     // Navigator.of(context).push(MaterialPageRoute(
//                     //     builder: (context) => GoogleMap(initialCameraPosition: CameraPosition(target: null))));
//                   },
//                   child: const Text("View Place"),
//                 ),
//                 // Reuse.spaceBetween(),
//                 // TextButton(
//                 //   onPressed: () {
//                 //     Navigator.of(context).push(MaterialPageRoute(
//                 //       builder: (context) => PlacesScreen(),
//                 //     ));
//                 //   },
//                 //   child: const Text("View Place"),
//                 // ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
