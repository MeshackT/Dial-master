import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:contacts_service/contacts_service.dart';
import 'package:dial/Notifications/local_notifications.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:location/location.dart';
import 'package:logger/logger.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:uuid/uuid.dart';

import '/ReusableCode.dart';
import '../DBModel/DatabaseHelper.dart';

Logger logger = Logger(printer: PrettyPrinter(colors: true));

class AddFriends extends StatefulWidget {
  const AddFriends({Key? key}) : super(key: key);
  static const routeName = '/addFriends';

  @override
  State<AddFriends> createState() => _AddFriendsState();
}

class _AddFriendsState extends State<AddFriends> {
  final DateTime timeStamp = DateTime.now();
  bool setOn = true;
  // LocalNotificationService localNotificationService =
  //     LocalNotificationService();
  //store contacts
  List<Contact> contacts = [];
  List<Contact> contactFiltered = [];
  //input field
  final TextEditingController search = TextEditingController();
  Logger log = Logger(printer: PrettyPrinter(colors: true));
  //initially we don't know which platform is used
  String platformVersion = 'Unknown';

  List<Color> itemColors = [];

  Random random = Random();

  Color generateRandomColor() {
    return Color.fromARGB(
      255,
      random.nextInt(256),
      random.nextInt(256),
      random.nextInt(256),
    );
  }
  //
  // Future<void> _loadListState() async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   setState(() {
  //     setOn = prefs.getBool('my_List') ?? false;
  //   });
  // }
  //
  // Future<void> _saveListState(bool value) async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   await prefs.setBool('my_List', value);
  // }

  // in order to change the search while typing, we need to bind the controller to listener
  @override
  void initState() {
    super.initState();
    // _loadListState();
    _fetchContacts();
    generateRandomColor();
    // getAllContacts();
    search.addListener(() {
      filterContext();
    });
  }

  filterContext() async {
    // A list to store contacts
    List<Contact> contact = [];
    //adding contacts from phone and add them to new list
    contact.addAll(contacts);

    //check the search text if it is empty or not
    if (search.text.isNotEmpty) {
      //this removes all that is not in the search
      contact.retainWhere((contact) {
        //store the searched item in a variable called searchItem
        String searchedItem = search.text.toLowerCase().trim();

        String searchTermFlattened = flattenedPhoneNumber(searchedItem);

        //create a variable to compare the searched Item to
        String contactName = contact.displayName!.toLowerCase() ?? "";
        //searchBy contact
        bool nameMatches = contactName.contains(searchedItem);
        if (nameMatches == true) {
          return true;
        }
        if (searchTermFlattened.isNotEmpty) {
          return false;
        }

        var phone = contact.phones!.firstWhere((phn) {
          String phnFlattened = flattenedPhoneNumber(phn.value.toString());
          return phnFlattened.contains(searchTermFlattened);
        }, orElse: null);
        return phone != null;
      });
      setState(() {
        //update the UI
        contactFiltered = contact;
      });
    }
  }

  //removes the signs in a number
  String flattenedPhoneNumber(String phoneStr) {
    return phoneStr.replaceAllMapped(RegExp(r'^(\+)/|D'), (Match m) {
      return m[0] == "+" ? "+" : "";
    });
  }

  // List<Contact>? temporaryContacts = [];
  // //get the contacts from the phone
  // Future<void> getAllContacts() async {
  //   //create a temporary list storing the contacts
  //   temporaryContacts = (await ContactsService.getContacts()).toList();
  //   if (temporaryContacts != null) {
  //     contacts = temporaryContacts!;
  //   }
  //   setState(() {});
  // }

  //add
  // Future<void> _addContact(String name, String phoneNumber) async {
  //   if (await Permission.contacts.request().isGranted) {
  //     // Create a new contact object
  //     final newContact = Contact(
  //       givenName: name,
  //       phones: [Item(label: 'mobile', value: phoneNumber)],
  //     );
  //
  //     // Add the contact using ContactsService
  //     await ContactsService.addContact(newContact);
  //
  //     // Update the UI by adding the new contact to your contacts list
  //     setState(() {
  //       contacts.add(newContact);
  //     });
  //   } else {
  //     // Handle the case when permission is not granted
  //   }
  // }

  //delete
  Future<void> _deleteContact(int index) async {
    if (await Permission.contacts.request().isGranted) {
      await ContactsService.deleteContact(contacts[index]);
      setState(() {
        contacts.removeAt(index);
      });
    }
  }

  // _update
  // void _updateContact(int index, String newName, String newPhoneNumber) async {
  //   if (await Permission.contacts.request().isGranted) {
  //     Contact updatedContact = contacts[index];
  //     updatedContact.displayName = newName;
  //
  //     // Update the phone number. You might need to handle the case where the contact has multiple phone numbers.
  //     if (updatedContact.phones!.isNotEmpty) {
  //       updatedContact.phones![0].value = newPhoneNumber;
  //     }
  //
  //     // Update the contact using ContactsService.updateContact
  //     await ContactsService.updateContact(updatedContact);
  //
  //     setState(() {
  //       contacts[index] = updatedContact;
  //     });
  //   }
  // }

  // List<Contact> _contacts = [];

  Future<void> _fetchContacts() async {
    try {
      final Iterable<Contact> cont = await ContactsService.getContacts();
      setState(() {
        contacts = cont.toList();
      });
    } catch (e) {
      // Handle any errors that occur during contact fetching
      print('Error fetching contacts: $e');
    }
  }

  @override
  void dispose() {
    search.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    bool isSearching = search.text.isNotEmpty;
    // setState(() {
    //   contacts;
    // });
    // Reuse.logger.i(contacts.first);
    return Scaffold(
      // backgroundColor: Theme.of(context).primaryColorLight,
      extendBodyBehindAppBar: true,
      extendBody: true,
      backgroundColor: const Color(0xFF072456),
      body: SafeArea(
        child: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          margin: const EdgeInsets.only(top: 0.0),
          decoration: const BoxDecoration(
            gradient: LinearGradient(
                colors: [Color(0xFF072456), Color(0xff000000)],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Column(
                children: [
                  Stack(
                    alignment: Alignment.topCenter,
                    children: [
                      Stack(
                        alignment: Alignment.bottomCenter,
                        children: [
                          Container(
                            width: MediaQuery.of(context).size.width,
                            height: MediaQuery.of(context).size.height / 3.9,
                            padding: const EdgeInsets.all(10),
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              border: Border.all(
                                width: 1,
                                color: Theme.of(context)
                                    .primaryColor
                                    .withOpacity(.2),
                              ),
                            ),
                            child: Image.asset(
                              'images/tap.png',
                              fit: BoxFit.cover,
                              width: double.infinity,
                              height: double.infinity,
                            ),
                          ),
                          ClipRRect(
                            borderRadius: BorderRadius.circular(15.0),
                            child: Container(
                              color: const Color(0x0f09091b).withOpacity(.6),
                              height: 55,
                              width: 331,
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  Reuse.navigatorButton(
                                    Icon(
                                      Icons.history,
                                      size: 25.0,
                                      color:
                                          Theme.of(context).primaryColorLight,
                                    ),
                                    () => Navigator.pushNamedAndRemoveUntil(
                                        context,
                                        '/historyHome',
                                        (route) => false),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                            bottom: 0.0, left: 80, right: 80, top: 30),
                        child: Container(
                          height: 50,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(40),
                          ),
                          child: TextFormField(
                            textAlign: TextAlign.center,
                            cursorWidth: 1,
                            autofocus: false,
                            autocorrect: true,
                            showCursor: true,
                            controller: search,
                            cursorColor: Theme.of(context).primaryColorLight,
                            style: TextStyle(
                                color: Theme.of(context).primaryColorLight,
                                fontWeight: FontWeight.w500,
                                fontSize: 14),
                            decoration: InputDecoration(
                              hintText: "Enter your search",
                              hintStyle: TextStyle(
                                  color: Theme.of(context).primaryColorLight),
                              fillColor: Theme.of(context)
                                  .primaryColor
                                  .withOpacity(.50),
                              filled: true,
                              label: Text(
                                "Search ",
                                style: TextStyle(
                                    color: Theme.of(context).primaryColorLight),
                              ),
                              border: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: Theme.of(context).primaryColorDark),
                                borderRadius: BorderRadius.circular(50),
                              ),
                              prefixIcon: Icon(
                                Icons.search,
                                color: Theme.of(context).primaryColorLight,
                                size: 30,
                              ),
                            ),
                            validator: (val) {
                              if (search.text.isNotEmpty) {
                                val = search.text;
                              }
                              return null;
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                  Reuse.title("Contacts: ${contacts.length}", context),
                ],
              ),
              //title ends//
              (contacts.isEmpty)
                  ? Center(
                      child: CircularProgressIndicator(
                        color: Theme.of(context).primaryColor,
                      ),
                    )
                  : Expanded(
                      child: Container(
                        margin: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 1),
                        decoration: BoxDecoration(
                          border: Border.all(
                            width: .5,
                            color: Theme.of(context)
                                .primaryColorLight
                                .withOpacity(.2),
                          ),
                        ),
                        height: MediaQuery.of(context).size.height,
                        width: MediaQuery.of(context).size.width,
                        child: ListView.builder(
                          padding: const EdgeInsets.only(bottom: 100),
                          physics: const AlwaysScrollableScrollPhysics(),
                          itemCount: (isSearching == true)
                              ? contactFiltered.length
                              : contacts.length,
                          itemBuilder: (context, index) {
                            // Get the current contact
                            Contact contact = (isSearching == true)
                                ? contactFiltered[index]
                                : contacts[index];
                            // Get the contact's image
                            Uint8List? image = contact.avatar;
                            // Initialize itemColors list
                            if (itemColors.length <= index) {
                              itemColors.add(generateRandomColor());
                            }

                            return GestureDetector(
                              onDoubleTap: () async {
                                try {
                                  // variables
                                  String phoneNumber = contact.phones!
                                      .elementAt(0)
                                      .value
                                      .toString();
                                  String contactName =
                                      contact.displayName ?? "No Name";

                                  // Call the number
                                  await (FlutterPhoneDirectCaller.callNumber(
                                    phoneNumber.replaceAllMapped(
                                        RegExp(r'^(\+)/|D'), (Match m) {
                                      return m[0] == "+" ? "+" : "";
                                    }),
                                  ));

                                  // Add this data to the constructor
                                  ContactData contactData = ContactData(
                                    id: int.tryParse(const Uuid().v1()) ?? 0,
                                    name: contactName,
                                    contact: phoneNumber,
                                    date: timeStamp,
                                  );

                                  // Store the data to the database
                                  await DatabaseHelper.instance
                                      .insertContactData(contactData);
                                } on Exception catch (e) {
                                  // Handle exceptions
                                  if (kDebugMode) {
                                    print('Unknown exception: $e');
                                  }
                                }
                              },
                              child: ListTile(
                                leading: (image != null && image.isNotEmpty)
                                    ? CircleAvatar(
                                        backgroundImage: MemoryImage(image),
                                      )
                                    : CircleAvatar(
                                        backgroundColor:
                                            Colors.indigo.withOpacity(.2),
                                        child: Icon(
                                          Icons.person,
                                          color: Theme.of(context)
                                              .primaryColorLight,
                                        ),
                                      ),
                                title: Text(
                                  contact.displayName?.trim() ?? "No Name",
                                  style: TextStyle(
                                      color:
                                          Theme.of(context).primaryColorLight),
                                ),
                                subtitle: Text(
                                  contact.phones?.isEmpty == true
                                      ? 'No Phone number'
                                      : contact.phones!
                                          .elementAt(0)
                                          .value
                                          .toString(),
                                  style: TextStyle(
                                      color: Theme.of(context)
                                          .primaryColorLight
                                          .withOpacity(.49)),
                                ),
                                trailing: Container(
                                  width: 30,
                                  color: Colors.transparent,
                                  child: SizedBox(
                                    width: 30,
                                    child: PopupMenuButton(
                                      color:
                                          Theme.of(context).primaryColorLight,
                                      itemBuilder: (BuildContext context) =>
                                          <PopupMenuEntry>[
                                        // Popup menu items

                                        PopupMenuItem(
                                          value: 0,
                                          child: TextButton(
                                            onPressed: () async {
                                              final navContext =
                                                  Navigator.of(context);
                                              try {
                                                // variables
                                                String phoneNumber = contact
                                                    .phones!
                                                    .elementAt(0)
                                                    .value
                                                    .toString();
                                                String contactName =
                                                    contact.displayName!;

                                                if (phoneNumber.isNotEmpty) {
                                                  //call the number
                                                  await (FlutterPhoneDirectCaller
                                                      .callNumber(
                                                    phoneNumber
                                                        .replaceAllMapped(
                                                            RegExp(r'^(\+)/|D'),
                                                            (Match m) {
                                                      return m[0] == "+"
                                                          ? "+"
                                                          : "";
                                                    }),
                                                  ));
                                                  // findUserByContactNumber(contactName, "", "");

                                                  //Add this data to the constructor
                                                  ContactData contactData =
                                                      ContactData(
                                                    id: int.tryParse(
                                                        const Uuid().v1()),
                                                    name: contactName,
                                                    contact: phoneNumber,
                                                    date: timeStamp,
                                                  );

                                                  // store the data to the database
                                                  await DatabaseHelper.instance
                                                      .insertContactData(
                                                          contactData);
                                                } else {
                                                  Fluttertoast.showToast(
                                                    backgroundColor:
                                                        Theme.of(context)
                                                            .primaryColor
                                                            .withOpacity(.8),
                                                    msg:
                                                        "Invalid contact number",
                                                  );
                                                }
                                              } on Exception catch (e) {
                                                // Anything else that is an exception
                                                throw 'Unknown exception: $e';
                                              }
                                              navContext.pop();
                                            },
                                            child: Row(
                                              children: [
                                                ClipRRect(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          150), // Adjust the radius as needed

                                                  child: SizedBox(
                                                    height: 30,
                                                    width: 30,
                                                    child: SizedBox(
                                                        width: MediaQuery.of(
                                                                context)
                                                            .size
                                                            .width,
                                                        height: MediaQuery.of(
                                                                    context)
                                                                .size
                                                                .height /
                                                            3.8,
                                                        child: const Icon(
                                                          Icons.call,
                                                          color: Colors.green,
                                                        )),
                                                  ),
                                                ),
                                                const SizedBox(
                                                  width: 10,
                                                ),
                                                const Text("Make a call"),
                                              ],
                                            ),
                                          ),
                                        ),
                                        PopupMenuItem(
                                          value: 1,
                                          child: TextButton(
                                            onPressed: () {
                                              String nameTemporary = contact
                                                  .displayName
                                                  .toString()
                                                  .trim();
                                              String phoneTemporary = contact
                                                  .phones!
                                                  .elementAt(0)
                                                  .value
                                                  .toString();

                                              Reuse.display(
                                                  context,
                                                  nameTemporary,
                                                  phoneTemporary,
                                                  "Share");
                                              Navigator.of(context).pop();
                                            },
                                            child: Row(
                                              children: [
                                                ClipRRect(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          150), // Adjust the radius as needed

                                                  child: SizedBox(
                                                    height: 30,
                                                    width: 30,
                                                    child: SizedBox(
                                                      width:
                                                          MediaQuery.of(context)
                                                              .size
                                                              .width,
                                                      height:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .height /
                                                              3.8,
                                                      child: Image.asset(
                                                        'images/share.png',
                                                        fit: BoxFit.cover,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                const SizedBox(
                                                  width: 10,
                                                ),
                                                const Text("Share contacts")
                                              ],
                                            ),
                                          ),
                                        ),
                                        PopupMenuItem(
                                          value: 2,
                                          child: TextButton(
                                            onPressed: () {
                                              String phoneTemporary = contact
                                                  .phones!
                                                  .elementAt(0)
                                                  .value
                                                  .toString();

                                              Reuse.openWhatsApp(context,
                                                  phoneNumber: phoneTemporary,
                                                  message: "Hello");
                                              Navigator.of(context).pop();
                                            },
                                            child: Row(
                                              children: [
                                                ClipRRect(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          150), // Adjust the radius as needed

                                                  child: SizedBox(
                                                    height: 30,
                                                    width: 30,
                                                    child: SizedBox(
                                                      width:
                                                          MediaQuery.of(context)
                                                              .size
                                                              .width,
                                                      height:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .height /
                                                              3.8,
                                                      child: Image.asset(
                                                        'images/whatsapp.png',
                                                        fit: BoxFit.cover,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                const SizedBox(
                                                  width: 10,
                                                ),
                                                const Text("Open WhatsApp"),
                                              ],
                                            ),
                                          ),
                                        ),
                                        PopupMenuItem(
                                          value: 3,
                                          child: TextButton(
                                            onPressed: () {
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
                                                                FontWeight
                                                                    .w700),
                                                      ),
                                                      content: Text(
                                                        "Delete the contact from the list?",
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
                                                                child:
                                                                    TextButton(
                                                                  onPressed:
                                                                      () {
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
                                                                  final navContext =
                                                                      Navigator.of(
                                                                          context);
                                                                  //Delete the record
                                                                  try {
                                                                    await _deleteContact(
                                                                        index);
                                                                    navContext
                                                                        .pop();
                                                                  } catch (e) {
                                                                    Reuse.logger
                                                                        .e("Can't delete");
                                                                  }
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
                                              // _deleteContact(index);
                                              Navigator.of(context).pop();
                                            },
                                            child: Row(
                                              children: [
                                                ClipRRect(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          150), // Adjust the radius as needed

                                                  child: SizedBox(
                                                    height: 30,
                                                    width: 30,
                                                    child: SizedBox(
                                                      width:
                                                          MediaQuery.of(context)
                                                              .size
                                                              .width,
                                                      height:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .height /
                                                              3.8,
                                                      child: const Icon(
                                                        Icons.delete,
                                                        color: Colors.red,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                const SizedBox(
                                                  width: 10,
                                                ),
                                                const Text("Delete contact"),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
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
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      persistentFooterAlignment: AlignmentDirectional.bottomEnd,
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              FloatingActionButton(
                backgroundColor: Theme.of(context).primaryColor.withOpacity(.2),
                heroTag: "button_9",
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.horizontal(
                    left: Radius.circular(30),
                    right: Radius.circular(30),
                  ),
                ),
                onPressed: () async {
                  try {
                    //open contact form to save contacts
                    await ContactsService.openContactForm();
                  } on FormOperationException catch (e) {
                    switch (e.errorCode) {
                      case FormOperationErrorCode.FORM_COULD_NOT_BE_OPEN:
                        break;
                      case FormOperationErrorCode.FORM_OPERATION_CANCELED:
                        if (kDebugMode) {
                          print(e.toString());
                        }
                        break;
                      case FormOperationErrorCode.FORM_OPERATION_UNKNOWN_ERROR:
                        if (kDebugMode) {
                          print(e.toString());
                        }
                        break;
                      default:
                    }
                  }
                },
                child: Icon(
                  Icons.add,
                  color: Theme.of(context).primaryColorLight,
                ),
              ),
              const SizedBox(
                width: 15,
              ),
              SizedBox(
                child: FloatingActionButton(
                  backgroundColor:
                      Theme.of(context).primaryColor.withOpacity(.2),
                  heroTag: "button_1",
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.horizontal(
                      left: Radius.circular(30),
                      right: Radius.circular(30),
                    ),
                  ),
                  onPressed: () async {
                    //get the contacts again
                    setState(() {
                      //clear the textBox
                      search.clear();
                    });
                    //call the list
                    await ContactsService.getContacts();
                    Fluttertoast.showToast(
                        gravity: ToastGravity.TOP,
                        backgroundColor: Colors.indigo,
                        msg: "Reloaded");
                  },
                  tooltip: 'Refresh contact',
                  child: Icon(Icons.refresh,
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
          const SizedBox(
            height: 60,
          ),
        ],
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  //call scaffold
  Future<ScaffoldFeatureController<SnackBar, SnackBarClosedReason>> callSnack(
      Contact contact, int index) async {
    return ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      backgroundColor: Theme.of(context).primaryColor.withOpacity(.2),
      duration: const Duration(seconds: 0),
      content: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text(
            " Do you want to delete? ",
            style: TextStyle(color: Theme.of(context).primaryColorLight),
          ),
          TextButton(
            onPressed: () async {
              ContactsService newDel =
                  await ContactsService.deleteContact(contacts[index]);
              _fetchContacts();
              List<Contact> temporaryContacts =
                  (await ContactsService.getContacts()).toList();

              contacts.remove(newDel);
              setState(() {
                contacts = temporaryContacts;
              });
            },
            child: Text(
              "Yes",
              style: TextStyle(color: Theme.of(context).primaryColorLight),
            ),
          ),
        ],
      ),
    ));
    //__________________//
  }
}

popButtons(String nameTemporary, phoneTemporary) {
  return PopupMenuButton(
    itemBuilder: (BuildContext context) => <PopupMenuEntry>[
      PopupMenuItem(
        value: 0,
        child: TextButton(
          onPressed: () {},
          child: Row(
            children: [
              ClipRRect(
                borderRadius:
                    BorderRadius.circular(150), // Adjust the radius as needed

                child: SizedBox(
                  height: 30,
                  width: 30,
                  child: GestureDetector(
                    onTap: () {
                      Reuse.display(
                          context, nameTemporary, phoneTemporary, "Share");
                    },
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height / 3.8,
                      child: Image.asset(
                        'images/share.png',
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(
                width: 10,
              ),
              const Text("Share contacts")
            ],
          ),
        ),
      ),
      PopupMenuItem(
        value: 1,
        child: TextButton(
          onPressed: () {
            Reuse.openWhatsApp(context,
                phoneNumber: phoneTemporary, message: "Hello");
          },
          child: Row(
            children: [
              const Text("Open whatsApp"),
              ClipRRect(
                borderRadius:
                    BorderRadius.circular(150), // Adjust the radius as needed

                child: SizedBox(
                  height: 30,
                  width: 30,
                  child: GestureDetector(
                    onTap: () {
                      Reuse.display(context, nameTemporary, phoneTemporary, '');
                    },
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height / 3.8,
                      child: Image.asset(
                        'images/whatsapp.png',
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(
                width: 10,
              ),
              const Text("Share contacts"),
            ],
          ),
        ),
      ),
    ],
  );
}

//Get current Location
//get current location
void _getCurrentLocation(String userInputNumber) async {
  Location location = Location();

  bool serviceEnabled;
  // PermissionStatus permissionGranted;
  LocationData locationData;

  serviceEnabled = await location.serviceEnabled();
  if (!serviceEnabled) {
    serviceEnabled = await location.requestService();
    if (!serviceEnabled) {
      return;
    }
  }

  locationData = await location.getLocation();

  final lat = locationData.latitude;
  final lng = locationData.longitude;

  if (lat == null || lng == null) {
    return;
  }

  Future.delayed(
      const Duration(
        seconds: 2,
      ), () {
    findUserByContactNumber(userInputNumber, "", "");
  });
}

Future<Map<String, dynamic>?> findUserByContactNumber(
    String userInputNumber, String longitude, String latitude) async {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  try {
    // Check if the phone number starts with "+27" and format it accordingly
    if (userInputNumber.startsWith("+27")) {
      userInputNumber = "0${userInputNumber.substring(3).replaceAll(" ", "")}";
    } else if (userInputNumber.contains(" ")) {
      userInputNumber = userInputNumber.replaceAll(" ", "");
    }
    var querySnapshot1 = await firestore
        .collection('userData')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get();
    var documentSnapshot1 = querySnapshot1.get('name');

    // Query the database to find documents with matching contactNumber
    var querySnapshot = await firestore
        .collection('userData')
        .where('contactNumber', isEqualTo: userInputNumber)
        .get();

    if (querySnapshot.size > 0) {
      Reuse.logger.i("Data Found ${querySnapshot.size}");

      // Get the first document with matching contactNumber
      var documentSnapshot = querySnapshot.docs[0];

      // Retrieve user information
      String docId = documentSnapshot.id;
      String email = documentSnapshot['email'];
      String name = documentSnapshot['name'];
      String secondName = documentSnapshot['secondName'];
      String contactNumber = documentSnapshot['contactNumber'];
      String deviceToken = documentSnapshot['deviceToken'];

      // Create a map to store user information and return it
      Map<String, dynamic> userInfo = {
        'docId': docId,
        'email': email,
        'name': name,
        'secondName': secondName,
        'contactNumber': contactNumber,
        'deviceToken': deviceToken,
      };
      Reuse.logger.i(userInfo.toString());
      Reuse.logger.e("my name is $documentSnapshot1");

      LocalNotificationService.sendNotificationToCurrentPhone(
          deviceToken, latitude, longitude, documentSnapshot1);

      return userInfo;
    } else {
      Reuse.logger.i('No documents found with the specified contactNumber');
      return null; // Return null if no matching user is found
    }
  } on Exception catch (e) {
    // Handle exceptions
    Reuse.logger.e('Error: $e');
    return null; // Return null in case of an exception
  }
}
