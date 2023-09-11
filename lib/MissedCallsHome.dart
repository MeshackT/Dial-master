import 'package:dial/DBModel/DatabaseHelper.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:flutter_share/flutter_share.dart';
import 'package:intl/intl.dart';
import 'package:logger/logger.dart';

import 'ReusableCode.dart';

Logger logger = Logger(printer: PrettyPrinter(colors: true));

class MissedCallsHome extends StatefulWidget {
  const MissedCallsHome({Key? key}) : super(key: key);
  static const routeName = '/missedcallsHome';

  @override
  State<MissedCallsHome> createState() => _MissedCallsHomeState();
}

class _MissedCallsHomeState extends State<MissedCallsHome> {
  ContactData contactData = ContactData();

  late Future<List<ContactData>> _contactData;
  final DateTime _dateFormater = DateTime.now();

  DatabaseHelper _databaseHelper = DatabaseHelper.instance;

  _updateContactList() {
    _contactData = DatabaseHelper.instance.getContactList();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _updateContactList();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: _databaseHelper.getContactList(),
        builder: (context, AsyncSnapshot snapshot) {
          if (!snapshot.hasData) {
            return Scaffold(
              appBar: AppBar(
                backgroundColor: Colors.transparent,
                elevation: 0,
                automaticallyImplyLeading: false,
              ),
              extendBodyBehindAppBar: true,
              extendBody: true,
              backgroundColor: const Color(0xFF072456),
              body: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                      colors: [Color(0xFF072456), Color(0xff000000)],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter),
                ),
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Reuse.headerText(
                          context, "Missed", "A list of my recent calls"),
                      Reuse.spaceBetween(),
                      Text(
                        "No Data yet...",
                        style: textStyleText.copyWith(
                            color: Theme.of(context).primaryColor),
                      ),
                      Reuse.spaceBetween(),
                      const CircularProgressIndicator(),
                    ],
                  ),
                ),
              ),
            );
          } else if (snapshot.data.length <= 0) {
            return Scaffold(
              appBar: AppBar(
                backgroundColor: Colors.transparent,
                automaticallyImplyLeading: false,
                elevation: 0,
                leading: IconButton(
                  icon: Icon(
                    Icons.cancel,
                    color: Theme.of(context).primaryColorLight,
                  ),
                  onPressed: () {
                    Navigator.of(context)
                        .pushNamedAndRemoveUntil('/', (route) => false);
                  },
                ),
              ),
              extendBodyBehindAppBar: true,
              extendBody: true,
              body: SingleChildScrollView(
                child: Container(
                  padding: const EdgeInsets.only(top: 50),
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                        colors: [Color(0xFF072456), Color(0xff000000)],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter),
                  ),
                  height: MediaQuery.of(context).size.height,
                  width: MediaQuery.of(context).size.width,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Reuse.headerText(context, "Missed",
                            "A list of my recent called contacts"),
                        Reuse.spaceBetween(),
                        Reuse.spaceBetween(),
                        Reuse.spaceBetween(),
                        Text(
                          "No Data yet...",
                          style: textStyleText.copyWith(
                            color: Theme.of(context).primaryColorLight,
                          ),
                        ),
                        SizedBox(
                          height: 150,
                          child: Center(
                            child: Image.asset(
                              "images/ic_launcher.png",
                              height: 150,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          }

          return Scaffold(
            appBar: AppBar(
              elevation: 0,
              backgroundColor: Colors.transparent,
              automaticallyImplyLeading: false,
              leading: IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () {
                  Navigator.of(context)
                      .pushNamedAndRemoveUntil('/', (route) => false);
                },
              ),
            ),
            extendBodyBehindAppBar: true,
            extendBody: true,
            backgroundColor: const Color(0xFF072456),
            body: SafeArea(
              child: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                      colors: [Color(0xFF072456), Color(0xff000000)],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter),
                ),
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                // color: Theme.of(context).primaryColorLight,
                child: Padding(
                  padding: const EdgeInsets.only(left: 20, right: 20, top: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Reuse.headerText(
                          context, "History", "A list of my recent scans"),
                      Reuse.spaceBetween(),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Contacts: ${snapshot.data!.length.toString()}",
                            textAlign: TextAlign.center,
                            style: textStyleText.copyWith(
                                fontWeight: FontWeight.w800,
                                color: Theme.of(context).primaryColorLight),
                          ),
                          ClipRRect(
                            borderRadius: BorderRadius.circular(200.0),
                            child: Container(
                              width: MediaQuery.of(context).size.width / 4,
                              height: MediaQuery.of(context).size.height / 18,
                              color: Theme.of(context).primaryColor,
                              child: TextButton.icon(
                                onPressed: () async {
                                  showThis();
                                },
                                icon: Icon(
                                  Icons.delete,
                                  size: 18,
                                  color: Theme.of(context)
                                      .primaryColorLight
                                      .withOpacity(.7),
                                ),
                                label: Text(
                                  'All',
                                  style: textStyleText.copyWith(
                                      fontSize: 14,
                                      color:
                                          Theme.of(context).primaryColorLight),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Expanded(
                        flex: 1,
                        child: Align(
                          alignment: Alignment.topCenter,
                          child: ListView.builder(
                            // reverse: true,
                            // padding: const EdgeInsets.only(bottom: 130.0),
                            physics: const AlwaysScrollableScrollPhysics(),
                            itemCount: snapshot.data.length,
                            itemBuilder: (context, index) {
                              // Use the actual data
                              final scannedData = snapshot.data![index];

                              String timeDate = DateFormat('MMM d, h:mm a')
                                  .format(scannedData.date!);
                              return GestureDetector(
                                onTap: () async {
                                  try {
                                    viewData(context, scannedData.name,
                                        scannedData.contact);
                                    logger.e(snapshot.data![index]);
                                  } on Exception catch (e) {
                                    // Anything else that is an exception
                                    logger.e(contactData);
                                    if (kDebugMode) {
                                      print('Unknown exception: $e');
                                    }
                                  }
                                },
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(10.0),
                                  child: Padding(
                                    padding:
                                        const EdgeInsets.symmetric(vertical: 4),
                                    child: Container(
                                      color: Colors.transparent,
                                      child: ListTile(
                                        leading: CircleAvatar(
                                          backgroundColor: Theme.of(context)
                                              .primaryColorLight,
                                          child: Icon(
                                            Icons.link,
                                            color:
                                                Theme.of(context).primaryColor,
                                          ),
                                        ),
                                        title: SelectableText(
                                          scannedData.name!,
                                          style: TextStyle(
                                              fontWeight: FontWeight.w400,
                                              color: Theme.of(context)
                                                  .primaryColorLight),
                                        ),
                                        subtitle: Text(
                                          "${scannedData.contact!}\n$timeDate",
                                          style: TextStyle(
                                              fontSize: 12,
                                              color: Theme.of(context)
                                                  .primaryColorLight
                                                  .withOpacity(.49)),
                                        ),
                                        trailing: IconButton(
                                          icon: Icon(
                                            Icons.delete,
                                            color: Theme.of(context)
                                                .primaryColorLight
                                                .withOpacity(.7),
                                          ),
                                          onPressed: () async {
                                            showDialog(
                                                context: context,
                                                builder: (context) {
                                                  return AlertDialog(
                                                    backgroundColor:
                                                        Theme.of(context)
                                                            .primaryColorLight
                                                            .withOpacity(.9),
                                                    title: const Text(
                                                      textAlign:
                                                          TextAlign.center,
                                                      'Confirm',
                                                      style: TextStyle(
                                                          color: Colors.red,
                                                          fontSize: 20,
                                                          fontWeight:
                                                              FontWeight.w700),
                                                    ),
                                                    content: Text(
                                                      "Permanently delete this previously called contacts?",
                                                      textAlign:
                                                          TextAlign.center,
                                                      style: TextStyle(
                                                          color: Theme.of(
                                                                  context)
                                                              .primaryColor),
                                                    ),
                                                    actions: <Widget>[
                                                      Center(
                                                        child: Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .center,
                                                          children: [
                                                            ClipRRect(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          10.0),
                                                              child: TextButton(
                                                                onPressed: () {
                                                                  Navigator.of(
                                                                          context)
                                                                      .pop();
                                                                },
                                                                child: Text(
                                                                  'No',
                                                                  style:
                                                                      TextStyle(
                                                                    color: Theme.of(
                                                                            context)
                                                                        .primaryColor,
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                            TextButton(
                                                              onPressed:
                                                                  () async {
                                                                //Delete the record
                                                                try {
                                                                  // Call the delete function here
                                                                  await _databaseHelper
                                                                      .deletingContactData(snapshot
                                                                          .data![
                                                                              index]
                                                                          .id)
                                                                      .then((value) =>
                                                                          _updateContactList())
                                                                      .whenComplete(
                                                                        () => setState(
                                                                            () {
                                                                          Navigator.of(context)
                                                                              .pop();
                                                                        }),
                                                                      );
                                                                  // Update the UI by reloading the data

                                                                  logger
                                                                      .e(index);
                                                                } catch (e) {}
                                                              },
                                                              child: Text(
                                                                'Yes',
                                                                style:
                                                                    TextStyle(
                                                                  color: Theme.of(
                                                                          context)
                                                                      .primaryColor,
                                                                ),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ],
                                                  );
                                                });
                                          },
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        });
  }

  Future showThis() {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          // );
          return AlertDialog(
            backgroundColor:
                Theme.of(context).primaryColorLight.withOpacity(.9),
            title: const Text(
              textAlign: TextAlign.center,
              'Confirm',
              style: TextStyle(
                  color: Colors.red, fontSize: 20, fontWeight: FontWeight.w700),
            ),
            content: Text(
              "Permanently delete all your previously contacts?",
              textAlign: TextAlign.center,
              style: TextStyle(color: Theme.of(context).primaryColor),
            ),
            actions: <Widget>[
              Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10.0),
                      child: TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: Text(
                          'No',
                          style: TextStyle(
                            color: Theme.of(context).primaryColor,
                          ),
                        ),
                      ),
                    ),
                    TextButton(
                      onPressed: () async {
                        //Delete the record
                        try {
                          DatabaseHelper.instance.deletingAllContactData();
                          await _databaseHelper
                              .deletingAllContactData()
                              .then((value) => _updateContactList())
                              .whenComplete(
                                () => setState(() {
                                  Navigator.of(context).pop();
                                }),
                              );
                        } catch (e) {}
                      },
                      child: Text(
                        'Yes',
                        style: TextStyle(
                          color: Theme.of(context).primaryColor,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        });
  }
}

Future<dynamic> viewData(
    BuildContext context, String name, String phoneNumber) {
  return showDialog(
    useSafeArea: false,
    context: context,
    builder: (context) => Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.cancel,
            color: Theme.of(context).primaryColorLight,
            size: 30,
          ),
          onPressed: () {
            Navigator.of(context)
                .pushNamedAndRemoveUntil('/historyHome', (route) => false);
          },
        ),
      ),
      extendBodyBehindAppBar: true,
      extendBody: true,
      backgroundColor: const Color(0xFF072456),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            decoration: const BoxDecoration(
              //screen background color
              gradient: LinearGradient(
                  colors: [Color(0xFF072456), Color(0xff000000)],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter),
            ),
            padding: const EdgeInsets.only(top: 50),
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Reuse.spaceBetween(),
                  Reuse.headerText(
                      context, "Overview ", "See your previous call details"),
                  Reuse.spaceBetween(),
                  Reuse.spaceBetween(),
                  SizedBox(
                      width: MediaQuery.of(context).size.width / 2,
                      height: MediaQuery.of(context).size.height / 5,
                      child: Image.asset(
                        "images/ic_launcher.png",
                        height: 100,
                      )),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(20.0),
                    child: Card(
                      elevation: 1,
                      child: Container(
                          width: MediaQuery.of(context).size.width,
                          padding: const EdgeInsets.symmetric(
                              vertical: 20, horizontal: 20),
                          color: Theme.of(context).primaryColor,
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  SelectableText(
                                    'Name: $name ',
                                    style: textStyleText.copyWith(
                                        color: Theme.of(context)
                                            .primaryColorLight),
                                    textAlign: TextAlign.center,
                                  ),
                                ],
                              ),
                              Reuse.spaceBetween(),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  SelectableText(
                                    'Contact: $phoneNumber',
                                    style: textStyleText.copyWith(
                                        color: Theme.of(context)
                                            .primaryColorLight),
                                    textAlign: TextAlign.center,
                                  ),
                                ],
                              ),
                              Reuse.spaceBetween(),
                            ],
                          )),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(100.0),
                        child: Container(
                          width: 40,
                          height: 40,
                          color: Theme.of(context).primaryColor,
                          child: IconButton(
                              onPressed: () async {
                                try {
                                  if (name.isNotEmpty ||
                                      name.isNotEmpty ||
                                      phoneNumber.isNotEmpty) {
                                    await FlutterShare.share(
                                      title: 'Share contact details',
                                      text:
                                          '${name.toString()}\n${phoneNumber.toString()}',
                                    );
                                  } else {
                                    Reuse.callSnack(
                                      context,
                                      "There's no name",
                                    );
                                  }
                                } on Exception catch (e) {
                                  Reuse.callSnack(
                                    context,
                                    e.toString(),
                                  );
                                }
                              },
                              icon: Icon(
                                Icons.share,
                                color: Theme.of(context).primaryColorLight,
                              )),
                        ),
                      ),
                      const SizedBox(
                        width: 20,
                      ),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(100.0),
                        child: Container(
                          width: 40,
                          height: 40,
                          color: Colors.green,
                          child: IconButton(
                              onPressed: () async {
                                try {
                                  if (phoneNumber.length < 0 ||
                                      phoneNumber.isNotEmpty) {
                                    await FlutterPhoneDirectCaller.callNumber(
                                        phoneNumber);
                                  } else {
                                    Reuse.callSnack(
                                      context,
                                      "Can't make a call",
                                    );
                                  }
                                } on Exception catch (e) {
                                  Reuse.callSnack(
                                    context,
                                    e.toString(),
                                  );
                                }
                              },
                              icon: Icon(
                                Icons.call,
                                color: Theme.of(context).primaryColorLight,
                              )),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    ),
  );
}
