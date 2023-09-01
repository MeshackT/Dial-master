import 'package:dial/CreateAContactButton.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:uuid/uuid.dart';

import 'MoreServices.dart';
import 'ReusableCode.dart';
import 'Settings.dart';
import 'addFriends.dart';
import 'landingScreen.dart';

class Navigation extends StatefulWidget {
  // final bool darkModeEnabled;
  // final Function(bool) toggleDarkMode;
  const Navigation({Key? key}) : super(key: key);
  static const routeName = '/';

  @override
  State<Navigation> createState() => _NavigationState();
}

class _NavigationState extends State<Navigation> {
  //current index of screen
  int selectedIndex = 0;

  PageController pageController = PageController(initialPage: 0);

  //change the index when selected
  changeTab(int index) {
    setState(() {
      selectedIndex = index;
      pageController.jumpToPage(index);
    });
  }

  String phoneNumber = '';
  FocusNode focusNode = FocusNode();
  String value = 'delete';

  void _handleButtonPress(String value) {
    setState(() {
      if (value == 'delete') {
        if (phoneNumber.isNotEmpty) {
          setState(() {
            phoneNumber = phoneNumber.substring(0, phoneNumber.length - 1);
          });
        }
      } else {
        phoneNumber += value;
      }
    });
  }

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
      Reuse.callToast("Permission Denied");
    } else if (statuses[Permission.phone]!.isDenied) {
      Reuse.callToast("Permission Denied");
    } else {
      return;
    }
  }

  @override
  void initState() {
    super.initState();
    getPermission();
    focusNode.requestFocus();
  }

  @override
  void dispose() {
    focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    //list of screens
    final screens = [
      const CreateAContactButton(),
      const MyHomePage(),
      const MoreServices(),
      const AddFriends(),
      const Settings(),
    ];

    return Scaffold(
      backgroundColor: Theme.of(context).primaryColorLight,
      extendBody: true,
      body: PageView(
        controller: pageController,
        children: screens,
        onPageChanged: (index) {
          setState(() {
            selectedIndex = index;
          });
        },
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).primaryColor,
          boxShadow: [
            BoxShadow(
              blurRadius: 20,
              color: Colors.black.withOpacity(.2),
            )
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 8),
          child: GNav(
            tabBorderRadius: 100,
            tabActiveBorder: Border.all(
              color: Theme.of(context).primaryColorLight,
              width: 1.0,
              style: BorderStyle.solid,
              strokeAlign: BorderSide.strokeAlignInside,
            ),
            rippleColor: Colors.transparent,
            hoverColor: Theme.of(context).primaryColor.withOpacity(.8),
            gap: 0,
            activeColor: Theme.of(context).primaryColorLight,
            iconSize: 20,
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            duration: const Duration(milliseconds: 400),
            // tabBackgroundColor:
            //     Theme.of(context).primaryColorLight.withOpacity(.8),
            color: Theme.of(context).primaryColorLight,
            tabs: const [
              GButton(
                icon: Icons.radio_button_checked,
                textSize: 8,
              ),
              GButton(
                icon: Icons.home,
                textSize: 8,
              ),
              GButton(
                icon: Icons.assistant,
                textSize: 8,
              ),
              GButton(
                icon: Icons.contacts,
                textSize: 8,
              ),
              GButton(
                icon: Icons.settings,
                textSize: 8,
              ),
            ],
            selectedIndex: selectedIndex,
            onTabChange: changeTab,
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Visibility(
              visible: selectedIndex != 4,
              child: FloatingActionButton(
                backgroundColor: Theme.of(context).primaryColor,
                heroTag: "button_2",
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.horizontal(
                    left: Radius.circular(30),
                    right: Radius.circular(30),
                  ),
                ),
                onPressed: () async {
                  // searchData(context);
                  Navigator.of(context).pushNamedAndRemoveUntil(
                      '/dialPadKeys', (route) => false);
                },
                child: Icon(
                  Icons.call,
                  color: Theme.of(context).primaryColorLight,
                ),
              ),
            ),
            const SizedBox(
              width: 8,
            ),
          ]),
    );
  }

  Widget _buildNumberButton(String value) {
    return Padding(
      padding: const EdgeInsets.only(top: 10, bottom: 10),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(50.0),
        child: SizedBox(
          height: 60,
          width: 60,
          child: ElevatedButton(
            onPressed: () {
              _handleButtonPress(value);
            },
            child: Text(value),
          ),
        ),
      ),
    );
  }

  Widget _buildActionButton1(String value) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(100.0),
      child: Container(
        height: 60,
        width: 60,
        color: Theme.of(context).primaryColor,
        child: IconButton(
          icon: Icon(
            Icons.backspace,
            color: Theme.of(context).primaryColorLight,
          ),
          onPressed: () {
            if (value == 'Call') {
              _handleButtonPress('Call');
            } else if (value == 'delete') {
              _handleButtonPress('delete');
            }
          },
        ),
      ),
    );
  }

  Widget _buildActionButton2(String value) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(100.0),
      child: Container(
        height: 60,
        width: 60,
        color: Colors.green,
        child: IconButton(
          icon: Icon(
            Icons.call,
            color: Colors.white,
          ),
          onPressed: () {
            if (value == 'Call') {
              _handleButtonPress('Call');
            } else if (value == 'delete') {
              _handleButtonPress('delete');
            }
          },
        ),
      ),
    );
  }

  Future<dynamic> searchData(BuildContext context) {
    return showDialog(
      useSafeArea: false,
      context: context,
      builder: (context) => Scaffold(
        backgroundColor: Theme.of(context).primaryColorLight,
        body: SizedBox(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(
                  height: 50,
                ),
                ClipRRect(
                  borderRadius: BorderRadius.circular(50.0),
                  child: Container(
                    width: 50,
                    height: 50,
                    color: Theme.of(context).primaryColor,
                    child: IconButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      icon: Icon(
                        Icons.close,
                        size: 25,
                        color: Theme.of(context).primaryColorLight,
                      ),
                    ),
                  ),
                ),
                // Reuse.buttonType("", Theme.of(context).primaryColor, Icons.close,
                //     () => Navigator.of(context).pop(), context),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(50.0),
                      child: SizedBox(
                        width: 100,
                        child: Divider(
                          height: 2,
                          thickness: 8,
                          color: Theme.of(context).primaryColor,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                          top: 10.0, bottom: 0, left: 30, right: 30),
                      child: TextField(
                        decoration: InputDecoration(
                          hintText: 'Phone Number',
                          hintStyle: TextStyle(
                            color: Theme.of(context).primaryColor,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        focusNode: FocusNode(canRequestFocus: true),
                        // Remove focus
                        readOnly: true,
                        textAlign: TextAlign.center,
                        cursorWidth: 1,
                        cursorColor: Theme.of(context).primaryColor,
                        controller: TextEditingController(text: phoneNumber),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _buildNumberButton('1'),
                        _buildNumberButton('2'),
                        _buildNumberButton('3'),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _buildNumberButton('4'),
                        _buildNumberButton('5'),
                        _buildNumberButton('6'),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _buildNumberButton('7'),
                        _buildNumberButton('8'),
                        _buildNumberButton('9'),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _buildNumberButton('*'),
                        _buildNumberButton('0'),
                        _buildNumberButton('+'),
                      ],
                    ),
                    SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _buildActionButton2('Call'),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class ContactForm extends StatefulWidget {
  const ContactForm({Key? key}) : super(key: key);
  static const routeName = '/contactForm';

  @override
  State<ContactForm> createState() => _ContactFormState();
}

class _ContactFormState extends State<ContactForm> {
  String phoneNumber = '';
  FocusNode focusNode = FocusNode();
  String value = 'delete';

  Future<void> _handleButtonPress(String value) async {
    if (value == 'delete') {
      if (phoneNumber.isNotEmpty) {
        setState(() {
          phoneNumber = phoneNumber.substring(0, phoneNumber.length - 1);
        });
      }
    } else {
      setState(() {
        phoneNumber += value;
      });
      await FlutterPhoneDirectCaller.callNumber(phoneNumber).whenComplete(
        () => const ContactForm(),
      );
    }
    focusNode.requestFocus();
  }

  @override
  void initState() {
    super.initState();
    focusNode.requestFocus();
  }

  @override
  void dispose() {
    focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    TextEditingController numbers = TextEditingController();
    String phonNumbers = "";

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.cancel),
          onPressed: () {
            Navigator.of(context)
                .pushNamedAndRemoveUntil('/', (route) => false);
          },
        ),
      ),
      body: Container(
        color: Theme.of(context).primaryColorLight,
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              TextField(
                key: Key(const Uuid().v1()),
                decoration: InputDecoration(
                  hintText: 'Phone Number',
                  hintStyle: TextStyle(
                    color: Theme.of(context).primaryColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                focusNode: FocusNode(canRequestFocus: true),
                // Remove focus
                readOnly: true,
                textAlign: TextAlign.center,
                cursorWidth: 1,
                cursorColor: Theme.of(context).primaryColor,
                controller: numbers,
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNumberButton(String value) {
    return Padding(
      padding: const EdgeInsets.only(top: 10, bottom: 10),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(50.0),
        child: SizedBox(
          height: 60,
          width: 60,
          child: ElevatedButton(
            onPressed: () {
              _handleButtonPress(value);
            },
            child: Text(value),
          ),
        ),
      ),
    );
  }

  Widget _buildActionButton1(String value) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(100.0),
      child: Container(
        height: 60,
        width: 60,
        color: Theme.of(context).primaryColor,
        child: IconButton(
          icon: Icon(
            Icons.backspace,
            color: Theme.of(context).primaryColorLight,
          ),
          onPressed: () {
            if (value == 'Call') {
              _handleButtonPress('Call');
            } else if (value == 'delete') {
              _handleButtonPress('delete');
            }
          },
        ),
      ),
    );
  }

  Widget _buildActionButton2(String value) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(100.0),
      child: Container(
        height: 60,
        width: 60,
        color: Colors.green,
        child: IconButton(
          icon: Icon(
            Icons.call,
            color: Colors.white,
          ),
          onPressed: () {},
        ),
      ),
    );
  }
}
