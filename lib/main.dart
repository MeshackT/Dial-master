import 'package:dial/HistoryHome.dart';
import 'package:dial/ReusableCode.dart';
import 'package:dial/Settings.dart';
import 'package:dial/feedback%20class/EmailTemplate.dart';
import 'package:dial/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'DialPadKeys.dart';
import 'Notifications/local_notifications.dart';
import 'navigation/MoreServices.dart';
import 'navigation/Navigation.dart';
import 'navigation/addFriends.dart';
import 'navigation/landingScreen.dart';

Reuse objReuse = Reuse();
@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
}

final navigatorKey = GlobalKey<NavigatorState>();

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // LocalNotificationService localNotificationService =
  // LocalNotificationService();

  @override
  void initState() {
    super.initState();
    LocalNotificationService.initialize();
    LocalNotificationService.subscribeToTopicDevice("allToReceive");
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      key: navigatorKey,
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
        // '/addLocation': (context) => const AddLocation(),
      },
    );
  }
}
