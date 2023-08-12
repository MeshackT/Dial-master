import 'package:dial/MoreServices.dart';
import 'package:dial/ReusableCode.dart';
import 'package:dial/Settings.dart';
import 'package:dial/addFriends.dart';
import 'package:dial/feedback%20class/EmailTemplate.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

import 'landingScreen.dart';

Reuse objReuse = Reuse();

void main() => runApp(const MyApp());

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  /*get permission*/
  Future<void> getPermission() async {
    await Permission.phone.request();
    await Permission.photos.request();
    await Permission.contacts.request();

    // You can request multiple permissions at once.
    Map<Permission, PermissionStatus> statuses = await [
      Permission.contacts,
      Permission.photos,
      Permission.phone,

      //add more permission to request here.
    ].request();

    if (statuses[Permission.contacts]!.isDenied) {
      //check each permission status after.
      //showToast("Permission Denied");
      Reuse.callToast("Permission Denied");
    } else if (statuses[Permission.photos]!.isDenied) {
      //check each permission status after.
      //showToast("Permission Denied");
      //Reuse.callToast("Permission Denied");
    } else if (statuses[Permission.phone]!.isDenied) {
      //check each permission status after.
      //showToast("Permission Denied");
      Reuse.callToast("Permission Denied");
    } else {
      //showToast("Permission Granted");
      Reuse.callToast("Permission Granted");
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Speed Dial',
      theme: ThemeData(
        primarySwatch: Colors.indigo,
        primaryColorDark: Colors.deepPurple,
        primaryColorLight: Colors.white,
        fontFamily: 'Poppins',
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes: {
        // When navigating to the "/" route, build the FirstScreen(Home) widget.
        '/': (context) => const MyHomePage(),
        '/addFriends': (context) => const AddFriends(),
        '/settings': (context) => const Settings(),
        '/emailTemplate': (context) => const EmailTemplate(),
        '/moreServices': (context) => const MoreServices(),
      },
    );
  }

  @override
  void initState() {
    getPermission();
    super.initState();
  }
}
