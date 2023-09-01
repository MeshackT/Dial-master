import 'package:dial/HistoryHome.dart';
import 'package:dial/MoreServices.dart';
import 'package:dial/ReusableCode.dart';
import 'package:dial/Settings.dart';
import 'package:dial/addFriends.dart';
import 'package:dial/feedback%20class/EmailTemplate.dart';
import 'package:flutter/material.dart';

import 'DialPadKeys.dart';
import 'Navigation.dart';
import 'landingScreen.dart';
import 'location/add_place.dart';

Reuse objReuse = Reuse();

void main() => runApp(const MyApp());

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Dial',
      theme: ThemeData(
        primarySwatch: Colors.indigo,
        primaryColorDark: Colors.deepPurple,
        primaryColorLight: Colors.white,
        fontFamily: 'Poppins',
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      debugShowCheckedModeBanner: false,
      // home: Navigation(),
      initialRoute: '/',
      routes: {
        // When navigating to the "/" route, build the FirstScreen(Home) widget.
        '/': (context) => const Navigation(),
        '/landingScreen': (context) => const MyHomePage(),
        '/addFriends': (context) => const AddFriends(),
        '/settings': (context) => const Settings(),
        '/emailTemplate': (context) => const EmailTemplate(),
        '/moreServices': (context) => const MoreServices(),
        '/contactForm': (context) => const ContactForm(),
        '/historyHome': (context) => const HistoryHome(),
        // '/createAContactButton': (context) => const CreateAContactButton(),
        '/dialPadKeys': (context) => const DialPadKeys(),
        '/addLocation': (context) => const AddLocation(),
      },
    );
  }
}
//   void showPermissionDialog() {
//     showCupertinoDialog(
//       context: context,
//       builder: (BuildContext context) {
//         final alertBox = Navigator.of(context);
//
//         return AlertDialog(
//           title: Text(
//             "Permission Required",
//             style: TextStyle(
//               fontSize: 14,
//               fontWeight: FontWeight.w800,
//               color: Theme.of(context).primaryColor,
//             ),
//           ),
//           content: Text(
//             "This app requires contacts and phone permissions to function.",
//             style: TextStyle(
//               color: Theme.of(context).primaryColor,
//               fontWeight: FontWeight.normal,
//               fontSize: 12,
//             ),
//           ),
//           actions: [
//             ClipRRect(
//               borderRadius:
//                   BorderRadius.circular(150), // Adjust the radius as needed
//               child: Container(
//                 color: Theme.of(context).primaryColor,
//                 child: TextButton(
//                   onPressed: () async {
//                     await getPermission();
//                     alertBox.pop();
//                   },
//                   child: Text(
//                     "Get Permission",
//                     style: TextStyle(
//                         fontSize: 14,
//                         color: Theme.of(context).primaryColorLight),
//                   ),
//                 ),
//               ),
//             ),
//           ],
//         );
//       },
//     );
//   }
// }
