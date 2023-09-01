import 'package:contacts_service/contacts_service.dart';
import 'package:dial/DBModel/DatabaseHelper.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:logger/logger.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:uuid/uuid.dart';

import 'ReusableCode.dart';

Logger logger = Logger(printer: PrettyPrinter(colors: true));

class AddFriends extends StatefulWidget {
  const AddFriends({Key? key}) : super(key: key);
  static const routeName = '/addFriends';

  @override
  State<AddFriends> createState() => _AddFriendsState();
}

class _AddFriendsState extends State<AddFriends> {
  final DateTime timeStamp = DateTime.now();

  //store contacts
  List<Contact> contacts = [];
  List<Contact> contactFiltered = [];
  //input field
  final TextEditingController search = TextEditingController();
  Logger log = Logger(printer: PrettyPrinter(colors: true));
  //initially we don't know which platform is used
  String platformVersion = 'Unknown';

  // in order to change the search while typing, we need to bind the controller to listener
  @override
  void initState() {
    super.initState();
    getAllContacts();
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
        String contactName = contact.displayName!.toLowerCase();
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

  //get the contacts from the phone
  Future<void> getAllContacts() async {
    //create a temporary list storing the contacts
    List<Contact> temporaryContacts =
        (await ContactsService.getContacts()).toList();

    setState(() {
      contacts = temporaryContacts;
    });
  }

  //add
  Future<void> _addContact(String name, String phoneNumber) async {
    if (await Permission.contacts.request().isGranted) {
      // Create a new contact object
      final newContact = Contact(
        givenName: name,
        phones: [Item(label: 'mobile', value: phoneNumber)],
      );

      // Add the contact using ContactsService
      await ContactsService.addContact(newContact);

      // Update the UI by adding the new contact to your contacts list
      setState(() {
        contacts.add(newContact);
      });
    } else {
      // Handle the case when permission is not granted
    }
  }

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
  void _updateContact(int index, String newName, String newPhoneNumber) async {
    if (await Permission.contacts.request().isGranted) {
      Contact updatedContact = contacts[index];
      updatedContact.displayName = newName;

      // Update the phone number. You might need to handle the case where the contact has multiple phone numbers.
      if (updatedContact.phones!.isNotEmpty) {
        updatedContact.phones![0].value = newPhoneNumber;
      }

      // Update the contact using ContactsService.updateContact
      await ContactsService.updateContact(updatedContact);

      setState(() {
        contacts[index] = updatedContact;
      });
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
    return Scaffold(
      // backgroundColor: Theme.of(context).primaryColorLight,
      extendBodyBehindAppBar: true,
      extendBody: true,
      backgroundColor: const Color(0xFF072456),
      body: SafeArea(
        child: SingleChildScrollView(
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
                Stack(
                  children: [
                    SizedBox(
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height / 3.8,
                      child: Image.asset(
                        'images/tap.png',
                        width: 390,
                        height: 218,
                        fit: BoxFit.cover,
                      ),
                    ),
                    //Reuse.speedDialHeader("Speed dial", context),
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
                            fillColor:
                                Theme.of(context).primaryColor.withOpacity(.50),
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
                    Center(
                      child: Padding(
                        padding: const EdgeInsets.only(top: 183),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(15.0),
                          child: Container(
                            color: const Color(0x0f09091b).withOpacity(.6),
                            height: 68,
                            width: 331,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                // Reuse.navigatorButton(
                                //   Icon(
                                //     Icons.location_on,
                                //     size: 25.0,
                                //     color: Theme.of(context).primaryColorLight,
                                //   ),
                                //   () => null,
                                // ),
                                Reuse.navigatorButton(
                                  Icon(
                                    Icons.history,
                                    size: 25.0,
                                    color: Theme.of(context).primaryColorLight,
                                  ),
                                  () => Navigator.pushNamedAndRemoveUntil(
                                      context,
                                      '/historyHome',
                                      (route) => false),
                                ),
                                // IconButton(
                                //   onPressed: () {
                                //     Navigator.pushNamedAndRemoveUntil(
                                //         context, '', (route) => false);
                                //   },
                                //   icon: Icon(
                                //     Icons.create,
                                //     size: 25.0,
                                //     color: Theme.of(context).primaryColorLight,
                                //   ),
                                // ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                Reuse.title("Contacts: ${contacts.length}", context),

                const SizedBox(
                  height: 10,
                ),
                //title ends//
                (contacts.isEmpty)
                    ? Center(
                        child: CircularProgressIndicator(
                          color: Theme.of(context).primaryColor,
                        ),
                      )
                    : Expanded(
                        flex: 1,
                        child: ListView.builder(
                          padding: const EdgeInsets.only(bottom: 130.0),
                          itemCount: (isSearching == true)
                              ? contactFiltered.length
                              : contacts.length,
                          itemBuilder: (context, index) {
                            //get the current contact index
                            Contact contact = (isSearching == true)
                                ? contactFiltered[index]
                                : contacts[index];
                            //get a particular phone
                            Uint8List? image = contact.avatar;

                            return GestureDetector(
                              onDoubleTap: () async {
                                final navContext = Navigator.of(context);
                                try {
                                  // variables
                                  String phoneNumber = contact.phones!
                                      .elementAt(0)
                                      .value
                                      .toString();
                                  String contactName = contact.displayName!;

                                  //call the number
                                  await (FlutterPhoneDirectCaller.callNumber(
                                    phoneNumber.replaceAllMapped(
                                        RegExp(r'^(\+)/|D'), (Match m) {
                                      return m[0] == "+" ? "+" : "";
                                    }),
                                  ));
                                  navContext.pop();

                                  //Add this data to the constructor
                                  ContactData contactData = ContactData(
                                    id: int.tryParse(const Uuid().v1()),
                                    name: contactName,
                                    contact: phoneNumber,
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
                              child: ListTile(
                                leading: (image != null && image.isNotEmpty)
                                    ? CircleAvatar(
                                        backgroundImage: MemoryImage(image),
                                      )
                                    : SizedBox(
                                        height: 50,
                                        width: 50,
                                        child: CircleAvatar(
                                          backgroundColor: Theme.of(context)
                                              .primaryColor
                                              .withOpacity(.49),
                                          child: Text(
                                            contact.displayName![0].trim(),
                                          ),
                                        ),
                                      ),
                                title: (contact.displayName == null &&
                                        contact.displayName!.isEmpty)
                                    ? Text(
                                        "No Name",
                                        style: TextStyle(
                                            color: Theme.of(context)
                                                .primaryColorLight),
                                      )
                                    : Text(
                                        contact.displayName.toString().trim(),
                                        style: TextStyle(
                                            color: Theme.of(context)
                                                .primaryColorLight),
                                      ),
                                subtitle: Text(
                                  contact.phones!.isEmpty
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

                                                //call the number
                                                await (FlutterPhoneDirectCaller
                                                    .callNumber(
                                                  phoneNumber.replaceAllMapped(
                                                      RegExp(r'^(\+)/|D'),
                                                      (Match m) {
                                                    return m[0] == "+"
                                                        ? "+"
                                                        : "";
                                                  }),
                                                ));
                                                navContext.pop();

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
                                              } on Exception catch (e) {
                                                // Anything else that is an exception
                                                if (kDebugMode) {
                                                  print(
                                                      'Unknown exception: $e');
                                                }
                                              }
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
                                              String nameTemporary = contact
                                                  .displayName
                                                  .toString()
                                                  .trim();
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
                                                                    logger.e(
                                                                        "Can't delete");
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
                                              _deleteContact(index);
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
                //title//
              ],
            ),
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
                backgroundColor: Theme.of(context).primaryColor,
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

                    //create a temporary list storing the contacts
                    List<Contact> temporaryContacts =
                        (await ContactsService.getContacts()).toList();
                    setState(() {
                      //populate the list and update the UI
                      // contacts = temporaryContacts;
                    });
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
          SizedBox(
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
      backgroundColor: Theme.of(context).primaryColor,
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
              getAllContacts();

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
              Text("Share contacts"),
            ],
          ),
        ),
      ),
    ],
  );
}
