import 'package:dial/landingScreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:logger/logger.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:uuid/uuid.dart';

import 'DBModel/DatabaseHelper.dart';
import 'MoreServices.dart';

class Reuse {
  static final DateTime _dateFormater = DateTime.now();
  static Logger logger = Logger(printer: PrettyPrinter(colors: true));

  //space
  static SizedBox spaceBetween() {
    return const SizedBox(
      height: 10,
    );
  }

  //header
  static ClipRRect headerText(context, title, subtitle) {
    final contextDataColor = Theme.of(context);

    return ClipRRect(
      borderRadius: BorderRadius.circular(10.0),
      child: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height / 8,
        color: Theme.of(context).primaryColor,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              title,
              textAlign: TextAlign.start,
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.w900,
                color: contextDataColor.primaryColorLight,
              ),
            ),
            Text(
              subtitle,
              textAlign: TextAlign.start,
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w400,
                color: contextDataColor.primaryColorLight,
              ),
            ),
          ],
        ),
      ),
    );
  }

  //button cards emergency
  static ClipRRect buttonType(String title, Color color, icon,
      Function() onPress, BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: Container(
        color: color,
        width: 100,
        height: 100,
        child: ElevatedButton(
          onPressed: onPress,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Text(
                title,
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: Theme.of(context).primaryColorLight, fontSize: 11),
              ),
              Icon(
                icon,
                size: 40,
                color: Theme.of(context).primaryColorLight,
              )
            ],
          ),
        ),
      ),
    );
  }

  //navigation header page name Speed dial
  static Center title(String header, BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.only(top: 20),
        child: Text(
          header,
          style: TextStyle(
            fontSize: 16,
            color: Theme.of(context).primaryColorLight,
          ),
        ),
      ),
    );
  }

  //speed dial Top header
  static Center speedDialHeader(String headerText, BuildContext context) {
    return Center(
      child: Text(
        headerText,
        style: TextStyle(
          color: Theme.of(context).primaryColorLight,
          fontWeight: FontWeight.w700,
          fontSize: 16,
          letterSpacing: 1,
        ),
      ),
    );
  }

  /*
  * Call functions for emergency purposes
  * navigation functions
  */
  static IconButton navigatorButton(Icon icon, Function() onPress) {
    return IconButton(
      onPressed: onPress,
      icon: icon,
    );
  }

  //call function for departments
  static Future<void> callAmbulance() async {
    // DateTime timeStamp =
    //     DateFormat('MMM d, h:mm a').format(_dateFormater) as DateTime;
    const String number = '10177';
    await FlutterPhoneDirectCaller.callNumber(number).whenComplete(
      () => const MyHomePage(),
    );
    //Add this data to the constructor
    ContactData contactData = ContactData(
      id: int.tryParse(const Uuid().v1()),
      name: "Ambulance",
      contact: number,
      date: _dateFormater,
    );

    // store the data to the database
    await DatabaseHelper.instance.insertContactData(contactData);
  }

  static Future<void> callPolice() async {
    const String number = '10111';
    await FlutterPhoneDirectCaller.callNumber(number).whenComplete(
      () => const MyHomePage(),
    );
    //Add this data to the constructor
    ContactData contactData = ContactData(
      id: int.tryParse(const Uuid().v1()),
      name: "Police",
      contact: number,
      date: _dateFormater,
    );

    // store the data to the database
    await DatabaseHelper.instance.insertContactData(contactData);
  }

  static Future<void> callChildLine() async {
    const String number = '116';
    await FlutterPhoneDirectCaller.callNumber(number).whenComplete(
      () => const MyHomePage(),
    );
    //Add this data to the constructor
    ContactData contactData = ContactData(
      id: int.tryParse(const Uuid().v1()),
      name: "Child-Line",
      contact: number,
      date: _dateFormater,
    );

    // store the data to the database
    await DatabaseHelper.instance.insertContactData(contactData);
  }

  static Future<void> callNetcare() async {
    const String number = '0829111';
    await FlutterPhoneDirectCaller.callNumber(number).whenComplete(
      () => const MyHomePage(),
    );
    //Add this data to the constructor
    ContactData contactData = ContactData(
      id: int.tryParse(const Uuid().v1()),
      name: "NetCare",
      contact: number,
      date: _dateFormater,
    );

    // store the data to the database
    await DatabaseHelper.instance.insertContactData(contactData);
  }

  static Future<void> callPrivateEmergency() async {
    const String number = '0873652087';
    await FlutterPhoneDirectCaller.callNumber(number).whenComplete(
      () => const MyHomePage(),
    );
    //Add this data to the constructor
    ContactData contactData = ContactData(
      id: int.tryParse(const Uuid().v1()),
      name: "Private Emergency",
      contact: number,
      date: _dateFormater,
    );

    // store the data to the database
    await DatabaseHelper.instance.insertContactData(contactData);
  }

  static Future<void> callFireFighter() async {
    const String number = '10177';
    await FlutterPhoneDirectCaller.callNumber(number).whenComplete(
      () => const MyHomePage(),
    );
    //Add this data to the constructor
    ContactData contactData = ContactData(
      id: int.tryParse(const Uuid().v1()),
      name: "Fire Fighter",
      contact: number,
      date: _dateFormater,
    );

    // store the data to the database
    await DatabaseHelper.instance.insertContactData(contactData);
  }

  // More settings
  static Future<void> callSAEmergency() async {
    const String number = '112';
    await FlutterPhoneDirectCaller.callNumber(number).whenComplete(
      () => const MoreServices(),
    );
    //Add this data to the constructor
    ContactData contactData = ContactData(
      id: int.tryParse(const Uuid().v1()),
      name: "SA Emergency",
      contact: number,
      date: _dateFormater,
    );

    // store the data to the database
    await DatabaseHelper.instance.insertContactData(contactData);
  }

  static Future<void> callDepartmentOfWater() async {
    const String number = '0800200200';
    await FlutterPhoneDirectCaller.callNumber(number).whenComplete(
      () => const MoreServices(),
    );
    //Add this data to the constructor
    ContactData contactData = ContactData(
      id: int.tryParse(const Uuid().v1()),
      name: "Department of water",
      contact: number,
      date: _dateFormater,
    );

    // store the data to the database
    await DatabaseHelper.instance.insertContactData(contactData);
  }

  static Future<void> callNationalCrisisLine() async {
    const String number = '0861322322';
    await FlutterPhoneDirectCaller.callNumber(number).whenComplete(
      () => const MoreServices(),
    );
    //Add this data to the constructor
    ContactData contactData = ContactData(
      id: int.tryParse(const Uuid().v1()),
      name: "National Crisis Line",
      contact: number,
      date: _dateFormater,
    );

    // store the data to the database
    await DatabaseHelper.instance.insertContactData(contactData);
  }

  static Future<void> callNationalInstitutionOfDiseases() async {
    const String number = '0800029999';
    await FlutterPhoneDirectCaller.callNumber(number).whenComplete(
      () => const MoreServices(),
    );
    //Add this data to the constructor
    ContactData contactData = ContactData(
      id: int.tryParse(const Uuid().v1()),
      name: "National Inst of Diseases",
      contact: number,
      date: _dateFormater,
    );

    // store the data to the database
    await DatabaseHelper.instance.insertContactData(contactData);
  }

  static Future<void> callDepartmentOfHomeAffairs() async {
    const String number = ' 0800601190';
    await FlutterPhoneDirectCaller.callNumber(number).whenComplete(
      () => const MoreServices(),
    );
    //Add this data to the constructor
    ContactData contactData = ContactData(
      id: int.tryParse(const Uuid().v1()),
      name: "Department of Home Affairs",
      contact: number,
      date: _dateFormater,
    );

    // store the data to the database
    await DatabaseHelper.instance.insertContactData(contactData);
  }

  static Future<void> callGenderBasedViolence() async {
    const String number = '0800428428';
    await FlutterPhoneDirectCaller.callNumber(number).whenComplete(
      () => const MoreServices(),
    );
    //Add this data to the constructor
    ContactData contactData = ContactData(
      id: int.tryParse(const Uuid().v1()),
      name: "GBV",
      contact: number,
      date: _dateFormater,
    );

    // store the data to the database
    await DatabaseHelper.instance.insertContactData(contactData);
  }

  //Share details
  static display(BuildContext context, String nameTemporary,
      String phoneTemporary, String message) async {
    return await Share.share('$nameTemporary\n$phoneTemporary').then(
      (value) => Fluttertoast.showToast(
        msg: "Sharing contacts",
        backgroundColor: Theme.of(context).primaryColor,
        textColor: Theme.of(context).primaryColorLight,
      ),
    );
  }

  static ScaffoldFeatureController<SnackBar, SnackBarClosedReason> callSnack(
      BuildContext context, String text) {
    return ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
          backgroundColor: Theme.of(context).primaryColor,
          content: Text(
            text,
            style: TextStyle(color: Theme.of(context).primaryColorLight),
          )),
    );
  }

  static callToast(String title) {
    return Fluttertoast.showToast(
      msg: title,
      textColor: Colors.white,
      backgroundColor: Colors.deepPurple,
      toastLength: Toast.LENGTH_SHORT,
    );
    //   ScaffoldMessenger.of(context).showSnackBar(
    //   SnackBar(
    //       backgroundColor: Theme.of(context).primaryColor,
    //       content: Text(
    //         "Number Copied",
    //         style: TextStyle(color: Theme.of(context).primaryColorLight),
    //       )),
    // );
  }

  //whatsapp call
  static Future<void> openWhatsApp(BuildContext context,
      {@required phoneNumber, @required message}) async {
    //var url = Uri.parse("whatsapp://send?phone=$phoneNumber&text=$message");

    var whatsAppURlAndroid =
        Uri.parse("whatsApp://send?phone=$phoneNumber}&text=$message");

    /*search for checking platforms later*/
    await canLaunchUrl(whatsAppURlAndroid)
        ? launchUrl(whatsAppURlAndroid)
        : ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              backgroundColor: Theme.of(context).primaryColorDark,
              content: Text(
                "Can't open whatsApp",
                style: TextStyle(color: Theme.of(context).primaryColorLight),
              ),
            ),
          );
  }

  static Padding links(BuildContext context, var url, String title) {
    return Padding(
      padding: const EdgeInsets.only(right: 10.0),
      child: SizedBox(
        width: 100,
        child: TextButton(
          onPressed: () async {
            if (await canLaunchUrl(url)) {
              await launchUrl(url);
            } else {
              Fluttertoast.showToast(msg: "Could not launch.");
            }
          },
          child: Text(
            title,
            textAlign: TextAlign.start,
            style: TextStyle(color: Theme.of(context).primaryColorLight),
          ),
        ),
      ),
    );
  }
}

TextStyle textStyleText = const TextStyle(
    fontWeight: FontWeight.normal, letterSpacing: 1, color: Colors.indigo);

InputDecoration textInputDecoration = const InputDecoration(
  fillColor: Colors.white,
  filled: true,
);
ButtonStyle buttonRound = OutlinedButton.styleFrom(
  elevation: 1,
  shape: const RoundedRectangleBorder(
    borderRadius: BorderRadius.all(
      Radius.circular(20),
    ),
  ),
);
