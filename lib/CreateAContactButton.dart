import 'package:contacts_service/contacts_service.dart';
import 'package:dial/DBModel/DatabaseHelper.dart';
import 'package:dial/ReusableCode.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:logger/logger.dart';
import 'package:uuid/uuid.dart';

Logger logger = Logger(printer: PrettyPrinter(colors: true));

class CreateAContactButton extends StatefulWidget {
  const CreateAContactButton({Key? key}) : super(key: key);
  static const routeName = '/createAContactButton';

  @override
  State<CreateAContactButton> createState() => _CreateAContactButtonState();
}

class _CreateAContactButtonState extends State<CreateAContactButton> {
  final bool hideButton = false;
  final DatabaseHelperTwo _databaseHelperTwo = DatabaseHelperTwo.instance;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: _databaseHelperTwo.getContactList(),
        builder: (context, AsyncSnapshot snapshot) {
          if (!snapshot.hasData) {
            return Scaffold(
              extendBodyBehindAppBar: true,
              extendBody: true,
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
                      Reuse.headerText(context, "My list", "Created list"),
                      Reuse.spaceBetween(),
                      Text(
                        "No list created yet",
                        style: textStyleText.copyWith(
                            color: Theme.of(context).primaryColorLight),
                      ),
                      Reuse.spaceBetween(),
                      // const CircularProgressIndicator(),
                    ],
                  ),
                ),
              ),
              floatingActionButtonLocation:
                  FloatingActionButtonLocation.centerFloat,
              persistentFooterAlignment: AlignmentDirectional.bottomEnd,
              floatingActionButton: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(
                        width: 8,
                      ),
                      SizedBox(
                        child: FloatingActionButton(
                          backgroundColor: Theme.of(context).primaryColor,
                          heroTag: "button_1",
                          shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.horizontal(
                              left: Radius.circular(30),
                              right: Radius.circular(30),
                            ),
                          ),
                          onPressed: () async {
                            createMyContact(context);
                            // store the data to the database
                            // await DatabaseHelper.instance.insertMyContactData(contactData);
                            // _addItem([]);
                            //get the contacts again
                            setState(() {
                              //clear the textBox
                              // search.clear();
                            });
                            //call the list
                            await ContactsService.getContacts();
                            Fluttertoast.showToast(
                                gravity: ToastGravity.TOP,
                                backgroundColor: Colors.indigo,
                                msg: "Reloaded");
                          },
                          tooltip: 'Create a list',
                          child: Icon(Icons.create,
                              color: Theme.of(context).primaryColorLight),
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      const SizedBox(
                        width: 8,
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 60,
                  ),
                ],
              ),
            );
          } else if (snapshot.data.length <= 0) {
            return Scaffold(
              // extendBodyBehindAppBar: true,
              // extendBody: true,
              body: Container(
                padding: const EdgeInsets.only(top: 20),
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
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Reuse.headerText(
                          context, "My List", "My Create contact list"),
                      Reuse.spaceBetween(),
                      Reuse.spaceBetween(),
                      Reuse.spaceBetween(),
                      Text(
                        "No list created yet",
                        style: textStyleText.copyWith(
                          color: Theme.of(context).primaryColorLight,
                        ),
                      ),
                      SizedBox(
                        child: Center(
                          child: Image.asset(
                            "images/ic_launcher.png",
                            height: 200,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              floatingActionButtonLocation:
                  FloatingActionButtonLocation.centerFloat,
              persistentFooterAlignment: AlignmentDirectional.bottomEnd,
              floatingActionButton: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(
                        width: 8,
                      ),
                      SizedBox(
                        child: FloatingActionButton(
                          backgroundColor: Theme.of(context).primaryColor,
                          heroTag: "button_1",
                          shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.horizontal(
                              left: Radius.circular(30),
                              right: Radius.circular(30),
                            ),
                          ),
                          onPressed: () async {
                            //get the contacts again
                            createMyContact(context);
                            setState(() {});
                            //call the list
                            // await ContactsService.getContacts();
                          },
                          tooltip: 'Create a list',
                          child: Icon(Icons.create,
                              color: Theme.of(context).primaryColorLight),
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      const SizedBox(
                        width: 8,
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 60,
                  ),
                ],
              ),
            );
          }
          bool shouldHideButton = snapshot.data.length == 6;

          return Scaffold(
            // appBar: AppBar(
            //   elevation: 0,
            //   automaticallyImplyLeading: false,
            //   actions: [
            //     IconButton(
            //       onPressed: () {
            //         Navigator.of(context).pushNamedAndRemoveUntil(
            //             '/historyHome', (route) => false);
            //       },
            //       icon: Icon(
            //         Icons.history,
            //         color: Theme.of(context).primaryColorLight,
            //       ),
            //     ),
            //   ],
            // ),
            extendBodyBehindAppBar: true,
            extendBody: true,
            backgroundColor: const Color(0xFF072456),
            body: SafeArea(
              child: SingleChildScrollView(
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
                    padding:
                        const EdgeInsets.only(left: 20, right: 20, top: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Reuse.headerText(
                            context, "Contacts", "My personal List"),
                        SizedBox(
                          height: 5,
                        ),
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
                            Reuse.navigatorButton(
                              Icon(
                                Icons.history,
                                color: Theme.of(context).primaryColorLight,
                              ),
                              () => Navigator.of(context)
                                  .pushNamedAndRemoveUntil(
                                      '/historyHome', (route) => false),
                            ),
                            ClipRRect(
                              borderRadius: BorderRadius.circular(200.0),
                              child: Container(
                                width: MediaQuery.of(context).size.width / 4,
                                height: MediaQuery.of(context).size.height / 18,
                                color: Theme.of(context).primaryColor,
                                child: TextButton.icon(
                                  onPressed: () async {
                                    // showThis();
                                    showDialog(
                                        context: context,
                                        builder: (context) {
                                          return AlertDialog(
                                            backgroundColor: Theme.of(context)
                                                .primaryColorLight
                                                .withOpacity(.9),
                                            title: const Text(
                                              textAlign: TextAlign.center,
                                              'Confirm',
                                              style: TextStyle(
                                                  color: Colors.red,
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.w700),
                                            ),
                                            content: Text(
                                              "Remove all the contacts from the list?",
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                  color: Theme.of(context)
                                                      .primaryColor),
                                            ),
                                            actions: <Widget>[
                                              Center(
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    ClipRRect(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10.0),
                                                      child: TextButton(
                                                        onPressed: () {
                                                          Navigator.of(context)
                                                              .pop();
                                                        },
                                                        child: Text(
                                                          'No',
                                                          style: TextStyle(
                                                            color: Theme.of(
                                                                    context)
                                                                .primaryColor,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                    TextButton(
                                                      onPressed: () async {
                                                        //Delete the record
                                                        try {
                                                          // Call the delete function here
                                                          setState(() {
                                                            _databaseHelperTwo
                                                                .deletingAllContactData();
                                                          });
                                                          Navigator.of(context)
                                                              .pop();
                                                        } catch (e) {
                                                          logger.e(
                                                              "Can't delete");
                                                        }
                                                      },
                                                      child: Text(
                                                        'Yes',
                                                        style: TextStyle(
                                                          color:
                                                              Theme.of(context)
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
                                  icon: Icon(
                                    Icons.delete,
                                    size: 18,
                                    color: Theme.of(context).primaryColorLight,
                                  ),
                                  label: Text(
                                    'All',
                                    style: textStyleText.copyWith(
                                        fontSize: 14,
                                        color: Theme.of(context)
                                            .primaryColorLight),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        Expanded(
                          flex: 1,
                          child: Align(
                            alignment: Alignment.topCenter,
                            child: GridView.builder(
                              // physics: ScrollPhysics,
                              physics:
                                  const BouncingScrollPhysics(), // Add the physics you want
                              scrollDirection: Axis.vertical,
                              padding: const EdgeInsets.only(bottom: 130.0),
                              itemCount: snapshot.data.length,
                              itemBuilder: (context, index) {
                                final scannedData = snapshot.data![index];

                                return GestureDetector(
                                  onLongPress: () {
                                    showDialog(
                                        context: context,
                                        builder: (context) {
                                          return AlertDialog(
                                            backgroundColor: Theme.of(context)
                                                .primaryColorLight
                                                .withOpacity(.9),
                                            title: const Text(
                                              textAlign: TextAlign.center,
                                              'Confirm',
                                              style: TextStyle(
                                                  color: Colors.red,
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.w700),
                                            ),
                                            content: Text(
                                              "Remove the contact from the list?",
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                  color: Theme.of(context)
                                                      .primaryColor),
                                            ),
                                            actions: <Widget>[
                                              Center(
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    ClipRRect(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10.0),
                                                      child: TextButton(
                                                        onPressed: () {
                                                          Navigator.of(context)
                                                              .pop();
                                                        },
                                                        child: Text(
                                                          'No',
                                                          style: TextStyle(
                                                            color: Theme.of(
                                                                    context)
                                                                .primaryColor,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                    TextButton(
                                                      onPressed: () async {
                                                        //Delete the record
                                                        try {
                                                          // Call the delete function here
                                                          await _databaseHelperTwo
                                                              .deletingContactData(
                                                                  scannedData
                                                                      .id);
                                                          setState(() {});
                                                          Navigator.of(context)
                                                              .pop();
                                                        } catch (e) {
                                                          logger.e(
                                                              "Can't delete");
                                                        }
                                                      },
                                                      child: Text(
                                                        'Yes',
                                                        style: TextStyle(
                                                          color:
                                                              Theme.of(context)
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
                                  onTap: () async {
                                    try {
                                      final DateTime timeStamp = DateTime.now();

                                      String phoneNumber = scannedData.contact;

                                      //call the number
                                      await (FlutterPhoneDirectCaller
                                          .callNumber(
                                        phoneNumber.replaceAllMapped(
                                            RegExp(r'^(\+)/|D'), (Match m) {
                                          return m[0] == "+" ? "+" : "";
                                        }),
                                      ));
                                      //Add this data to the constructor
                                      ContactData contactData = ContactData(
                                        id: int.tryParse(const Uuid().v1()),
                                        name: scannedData.name,
                                        contact: scannedData.contact,
                                        date: timeStamp,
                                      );

                                      // store the data to the database
                                      await DatabaseHelper.instance
                                          .insertContactData(contactData);
                                    } on Exception catch (e) {
                                      // Anything else that is an exception
                                      if (kDebugMode) {
                                        print('Unknown exception: $e');
                                      }
                                    }
                                  },
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(15.0),
                                    child: Container(
                                      margin: const EdgeInsets.symmetric(
                                          vertical: 15, horizontal: 15),
                                      color: Theme.of(context)
                                          .primaryColor
                                          .withOpacity(.6),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Icon(
                                            Icons.person,
                                            color: Theme.of(context)
                                                .primaryColorLight,
                                            size: 40,
                                          ),
                                          SelectableText(
                                            scannedData.name!,
                                            style: TextStyle(
                                                fontWeight: FontWeight.w400,
                                                color: Theme.of(context)
                                                    .primaryColorLight,
                                                fontSize: 10),
                                          ),
                                          SelectableText(
                                            scannedData.contact!,
                                            style: TextStyle(
                                                fontWeight: FontWeight.w400,
                                                color: Theme.of(context)
                                                    .primaryColorLight,
                                                fontSize: 10),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              },
                              gridDelegate:
                                  SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerFloat,
            persistentFooterAlignment: AlignmentDirectional.bottomEnd,
            floatingActionButton: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Visibility(
                  visible: shouldHideButton ? hideButton : !hideButton,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(
                        width: 8,
                      ),
                      SizedBox(
                        child: FloatingActionButton(
                          backgroundColor: Theme.of(context).primaryColor,
                          heroTag: "button_1",
                          shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.horizontal(
                              left: Radius.circular(30),
                              right: Radius.circular(30),
                            ),
                          ),
                          onPressed: () async {
                            //get the contacts again

                            createMyContact(context);
                          },
                          tooltip: 'Create a list',
                          child: Icon(Icons.create,
                              color: Theme.of(context).primaryColorLight),
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      const SizedBox(
                        width: 8,
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 60,
                ),
              ],
            ), // This trai
          );
        });
  }
}

Future<dynamic> createMyContact(BuildContext context) {
  TextEditingController nameOfContact = TextEditingController();
  TextEditingController contactNumber = TextEditingController();

  return showDialog(
    useSafeArea: false,
    context: context,
    builder: (context) => Scaffold(
      appBar: AppBar(
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.cancel,
            color: Theme.of(context).primaryColor,
            size: 30,
          ),
          onPressed: () {
            Navigator.of(context)
                .pushNamedAndRemoveUntil('/', (route) => false);
          },
        ),
        backgroundColor: Theme.of(context).primaryColorLight,
        title: Text(
          "",
          style: textStyleText.copyWith(
              color: Theme.of(context).primaryColorLight, fontSize: 16),
        ),
      ),
      backgroundColor: Theme.of(context).primaryColorLight,
      body: SafeArea(
        child: SingleChildScrollView(
          child: SizedBox(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Reuse.spaceBetween(),
                  Reuse.spaceBetween(),
                  Reuse.headerText(
                      context, "Create", "Add the contact details"),
                  Reuse.spaceBetween(),
                  Reuse.spaceBetween(),
                  SizedBox(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 25.0, vertical: 3),
                          child: Column(children: [
                            TextFormField(
                              controller: nameOfContact,
                              maxLines: 1,
                              keyboardType: TextInputType.text,
                              decoration: textInputDecoration.copyWith(
                                  border: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Theme.of(context).primaryColor,
                                        width: 2),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Theme.of(context).primaryColor,
                                        width: 2),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Theme.of(context).primaryColor,
                                        width: 2),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  hintText: "Your name here",
                                  hintStyle: textStyleText.copyWith(
                                      fontWeight: FontWeight.w800,
                                      color: Theme.of(context)
                                          .primaryColor
                                          .withOpacity(.5)),
                                  fillColor:
                                      Theme.of(context).primaryColorLight),
                              style: textStyleText.copyWith(
                                color: Theme.of(context).primaryColor,
                              ),
                              textAlign: TextAlign.center,
                              autocorrect: true,
                              textAlignVertical: TextAlignVertical.center,
                              onSaved: (value) {
                                //Do something with the user input.
                                nameOfContact.text = value!;
                              },
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            TextFormField(
                              controller: contactNumber,
                              maxLines: 1,
                              keyboardType: TextInputType.number,
                              decoration: textInputDecoration.copyWith(
                                  hintText: "Your contact here",
                                  hintStyle: textStyleText.copyWith(
                                    fontWeight: FontWeight.w800,
                                    color: Theme.of(context)
                                        .primaryColor
                                        .withOpacity(.5),
                                  ),
                                  border: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Theme.of(context).primaryColor,
                                        width: 2),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Theme.of(context).primaryColor,
                                        width: 2),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Theme.of(context).primaryColor,
                                        width: 2),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  fillColor:
                                      Theme.of(context).primaryColorLight),
                              style: textStyleText.copyWith(
                                color: Theme.of(context).primaryColor,
                              ),
                              textAlign: TextAlign.center,
                              autocorrect: true,
                              textAlignVertical: TextAlignVertical.center,
                              onSaved: (value) {
                                //Do something with the user input.
                                contactNumber.text = value!;
                              },
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 10),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  OutlinedButton(
                                    onPressed: () async {
                                      if (nameOfContact.text.isEmpty ||
                                          contactNumber.text.isEmpty) {
                                        Reuse.callSnack(
                                            context, "Insert contact details");
                                      } else {
                                        final DateTime timeStamp =
                                            DateTime.now();

                                        //add the data to the table
                                        ContactData contactData = ContactData(
                                          id: int.tryParse(const Uuid().v1()),
                                          name: nameOfContact.text
                                              .trim()
                                              .toString(),
                                          contact: contactNumber.text
                                              .trim()
                                              .toString(),
                                          date: timeStamp,
                                        );

                                        DatabaseHelperTwo.instance
                                            .insertContactData(contactData);
                                        DatabaseHelperTwo.instance
                                            .getContactList();

                                        Fluttertoast.showToast(
                                            backgroundColor:
                                                Theme.of(context).primaryColor,
                                            msg: "Contact added to your list");
                                      }
                                      contactNumber.clear();
                                      nameOfContact.clear();
                                    },
                                    style: buttonRound.copyWith(
                                        backgroundColor:
                                            MaterialStateProperty.all<Color>(
                                                Theme.of(context)
                                                    .primaryColorLight)),
                                    child: Text(
                                      "Save",
                                      style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold,
                                        color: Theme.of(context).primaryColor,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Reuse.spaceBetween(),
                          ]),
                        ),
                      ],
                    ),
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
