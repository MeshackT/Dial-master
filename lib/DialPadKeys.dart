import 'package:flutter/material.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:uuid/uuid.dart';

import 'DBModel/DatabaseHelper.dart';

class DialPadKeys extends StatefulWidget {
  const DialPadKeys({Key? key}) : super(key: key);
  static const routeName = '/dialPadKeys';

  @override
  State<DialPadKeys> createState() => _DialPadKeysState();
}

class _DialPadKeysState extends State<DialPadKeys> {
  TextEditingController numbers = TextEditingController();
  String phonNumbers = "";
  FocusNode focusNode = FocusNode();
  String value = 'delete';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColorLight,
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
      ),
      extendBodyBehindAppBar: true,
      extendBody: true,
      backgroundColor: const Color(0xffffffff),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            // decoration: const BoxDecoration(
            //   gradient: LinearGradient(
            //       colors: [Color(0xFF072456), Color(0xff000000)],
            //       begin: Alignment.topCenter,
            //       end: Alignment.bottomCenter),
            // ),
            color: Theme.of(context).primaryColorLight,
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            child: SingleChildScrollView(
              child: Container(
                color: Theme.of(context).primaryColorLight,
                width: MediaQuery.of(context).size.width,
                margin: const EdgeInsets.all(20),
                padding: const EdgeInsets.all(10),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(
                      height: 40,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          margin: const EdgeInsets.only(bottom: 20),
                          padding: const EdgeInsets.only(left: 30),
                          width: MediaQuery.of(context).size.width / 1.5,
                          child: TextField(
                            style: TextStyle(
                                color: Theme.of(context).primaryColor,
                                fontWeight: FontWeight.w600),
                            decoration: InputDecoration(
                              fillColor: Theme.of(context).primaryColorLight,
                              filled: true,
                              hintText: ' ',
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
                            onChanged: (val) {
                              setState(() {
                                numbers.text = val;
                              });
                            },
                          ),
                        ),
                        buttonNumberCancel(
                            const Icon(
                              Icons.cancel,
                              color: Colors.red,
                            ),
                            () => _handleButtonPressDelete(numbers.text)),
                      ],
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            buttonNumber("1", () => _handleButtonPress("1")),
                            buttonNumber("2", () => _handleButtonPress("2")),
                            buttonNumber("3", () => _handleButtonPress("3")),
                          ],
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            buttonNumber("4", () => _handleButtonPress("4")),
                            buttonNumber("5", () => _handleButtonPress("5")),
                            buttonNumber("6", () => _handleButtonPress("6")),
                          ],
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            buttonNumber("7", () => _handleButtonPress("7")),
                            buttonNumber("8", () => _handleButtonPress("8")),
                            buttonNumber("9", () => _handleButtonPress("9")),
                          ],
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            buttonNumber("*", () => _handleButtonPress("*")),
                            buttonNumber("0", () => _handleButtonPress("0")),
                            buttonNumber("#", () => _handleButtonPress("#")),
                          ],
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                      ],
                    ),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(50.0),
                      child: Container(
                        width: 80,
                        height: 80,
                        color: Colors.green,
                        child: IconButton(
                          onPressed: () {
                            _handleButtonPressCall(numbers.text.trim());
                          },
                          icon: Icon(
                            Icons.call,
                            color: Theme.of(context).primaryColorLight,
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _handleButtonPress(String value) {
    setState(() {
      numbers.text += value;
    });
  }

  void _handleButtonPressDelete(String value) {
    setState(() {
      numbers.text = numbers.text.substring(0, numbers.text.length - 1);
    });
  }

  void _handleButtonPressCall(String value) async {
    final DateTime timeStamp = DateTime.now();

    try {
      await FlutterPhoneDirectCaller.callNumber(value).whenComplete(
        () => const DialPadKeys(),
      );
      //Add this data to the constructor
      ContactData contactData = ContactData(
        id: int.tryParse(const Uuid().v1()),
        name: "In App call",
        contact: value,
        date: timeStamp,
      );

      // store the data to the database
      await DatabaseHelper.instance.insertContactData(contactData);
    } catch (e) {
      Fluttertoast.showToast(msg: e.toString());
    }
  }

  ClipRRect buttonNumber(String number, Function() onPress) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(50.0),
      child: Container(
        width: 80,
        height: 80,
        color: Colors.grey.shade300,
        child: TextButton(
          onPressed: onPress,
          child: Text(
            number,
            style: TextStyle(fontWeight: FontWeight.w800, fontSize: 14),
          ),
        ),
      ),
    );
  }

  ClipRRect buttonNumberCancel(Icon icon, Function() onPress) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(50.0),
      child: TextButton(
        onPressed: onPress,
        child: icon,
      ),
    );
  }
}
