import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

import '../ReusableCode.dart';

//A Model to grab and store data
class User {
  final String email;
  final String name;
  final String secondName;
  final String phoneNumber;
  final String docId;
  final String deviceToken;

  User(
    this.email,
    this.name,
    this.secondName,
    this.phoneNumber,
    this.docId,
    this.deviceToken,
  );

  // final userData = FirebaseFirestore.instance.collection('userData').doc();
  Future<void> addUser() {
    //get document ID
    final user = FirebaseAuth.instance.currentUser!.uid;
    final userData =
        FirebaseFirestore.instance.collection('userData').doc(user);

    // Call the user's CollectionReference to add a new user
    return userData
        .set({
          'contactNumber': phoneNumber,
          'name': name,
          'secondName': secondName,
          'email': email, // John Doe
          'docId': user, // John Doe
          'deviceToken': deviceToken,
        })
        .then((value) => Reuse.logger.i("User added"))
        .catchError((error) => Reuse.logger.i("Failed to add user: $error"));
  }
}
//=====================================================================

class Register extends StatefulWidget {
  final Function toggleView;
  const Register({Key? key, required this.toggleView}) : super(key: key);

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  //AuthService authService = AuthService();
  final _formKey = GlobalKey<FormState>();

  //we access signing privileges using this class
  //final FirebaseAuth _auth = FirebaseAuth.instance;

  //textField state
  String email = '';
  String password = '';
  String confirmPassword = '';
  String userUid = '';
  String name = '';
  String secondName = '';
  String documentID = '';
  String contactNumber = '';
  String? token = '';

  String error = '';
  bool loading = false;
  bool passwordVisible = true;

  Future<void> getTokenData() async {
    //Todo get token first
    final FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;
    token = await firebaseMessaging.getToken();

    print("token $token");
    // Future.delayed(Duration(seconds: 2), () => );
  }

  @override
  void initState() {
    super.initState();
    getTokenData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF072456),
      body: SafeArea(
        child: Container(
          height: MediaQuery.of(context).size.height,
          margin: const EdgeInsets.only(top: 0.0),
          decoration: const BoxDecoration(
            //screen background color
            gradient: LinearGradient(
                colors: [Color(0xFF072456), Color(0xff000000)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight),
          ),
          child: SingleChildScrollView(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 50),
                  child: Center(
                    child: Text(
                      "Sign up",
                      textAlign: TextAlign.center,
                      style: textStyleText.copyWith(
                          color: Theme.of(context).primaryColorLight,
                          fontSize: 28,
                          fontWeight: FontWeight.w700),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                    top: 8,
                  ),
                  child: Center(
                    child: Text(
                      "Ensure that your account is real",
                      textAlign: TextAlign.center,
                      style: textStyleText.copyWith(
                          color: Theme.of(context).primaryColorLight,
                          fontSize: 14,
                          fontWeight: FontWeight.w400),
                    ),
                  ),
                ),
                Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 30.0, vertical: 5),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Reuse.spaceBetween(),
                          Reuse.spaceBetween(),
                          TextFormField(
                            cursorColor: Theme.of(context).primaryColorLight,
                            decoration: textInputDecoration1.copyWith(
                              label: Text(
                                'My contact number',
                                style: textStyleText.copyWith(
                                    fontSize: 12,
                                    color: Theme.of(context).primaryColorLight),
                              ),
                              hintText: "Enter your contact number",
                              hintStyle: textStyleText1.copyWith(
                                  fontSize: 12,
                                  color: Theme.of(context).primaryColorLight),
                            ),
                            style: textStyleText.copyWith(
                                fontSize: 12,
                                color: Theme.of(context).primaryColorLight),
                            onChanged: (val) {
                              setState(() {
                                contactNumber = val;
                              });
                            },
                          ),

                          Reuse.spaceBetween(),
                          Reuse.spaceBetween(),

                          TextFormField(
                            cursorColor: Theme.of(context).primaryColorLight,
                            decoration: textInputDecoration1.copyWith(
                              label: Text(
                                'My first name',
                                style: textStyleText.copyWith(
                                    fontSize: 12,
                                    color: Theme.of(context).primaryColorLight),
                              ),
                              hintText: "Enter your first name",
                              hintStyle: textStyleText1.copyWith(
                                  fontSize: 12,
                                  color: Theme.of(context).primaryColorLight),
                            ),
                            style: textStyleText.copyWith(
                                fontSize: 12,
                                color: Theme.of(context).primaryColorLight),
                            onChanged: (val) {
                              setState(() {
                                name = val;
                              });
                            },
                          ),
                          //Name

                          Reuse.spaceBetween(),
                          Reuse.spaceBetween(),

                          TextFormField(
                            cursorColor: Theme.of(context).primaryColorLight,
                            decoration: textInputDecoration1.copyWith(
                              label: Text(
                                'My second name',
                                style: textStyleText.copyWith(
                                    fontSize: 12,
                                    color: Theme.of(context).primaryColorLight),
                              ),
                              hintText: "Enter your second name",
                              hintStyle: textStyleText1.copyWith(
                                  fontSize: 12,
                                  color: Theme.of(context).primaryColorLight),
                            ),
                            style: textStyleText.copyWith(
                                fontSize: 12,
                                color: Theme.of(context).primaryColorLight),
                            onChanged: (val) {
                              setState(() {
                                secondName = val;
                              });
                            },
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          TextFormField(
                            decoration: textInputDecoration1.copyWith(
                              label: Text(
                                'My email',
                                style: textStyleText.copyWith(
                                    fontSize: 12,
                                    color: Theme.of(context).primaryColorLight),
                              ),
                              hintText: "example@gmail.com",
                              hintStyle: textStyleText.copyWith(
                                  color: Theme.of(context).primaryColorLight),
                            ),
                            style: textStyleText.copyWith(
                                fontSize: 12,
                                color: Theme.of(context).primaryColorLight),
                            validator: (val) {
                              if (val!.isEmpty) {
                                return "Enter an email address";
                              } else if (!val.contains("@")) {
                                return "Enter a correct email address";
                              }
                              return null;
                            },
                            onChanged: (val) {
                              setState(() {
                                email = val;
                              });
                            },
                          ),

                          Reuse.spaceBetween(),
                          Reuse.spaceBetween(),

                          TextFormField(
                            decoration: textInputDecoration1.copyWith(
                              suffixIcon: IconButton(
                                onPressed: () {
                                  setState(() {
                                    passwordVisible = !passwordVisible;
                                  });
                                },
                                icon: passwordVisible
                                    ? Icon(
                                        Icons.visibility,
                                        color: IconTheme.of(context).color,
                                      )
                                    : Icon(
                                        Icons.lock,
                                        color: IconTheme.of(context).color,
                                      ),
                              ),
                              label: Text(
                                'My password',
                                style: textStyleText.copyWith(
                                    fontSize: 12,
                                    color: Theme.of(context).primaryColorLight),
                              ),
                              hintText: "Enter your password",
                              hintStyle: textStyleText.copyWith(
                                  fontSize: 12,
                                  color: Theme.of(context).primaryColorLight),
                            ),
                            style: textStyleText.copyWith(
                                fontSize: 12,
                                color: Theme.of(context).primaryColorLight),
                            obscureText: passwordVisible,
                            validator: (val) {
                              if (val!.length < 6) {
                                return "Enter a password greater than 5";
                              }
                              return null;
                            },
                            onChanged: (val) {
                              setState(() {
                                password = val;
                              });
                            },
                          ),
                          Reuse.spaceBetween(),
                          Reuse.spaceBetween(),
                          TextFormField(
                            decoration: textInputDecoration1.copyWith(
                              suffixIcon: IconButton(
                                onPressed: () {
                                  setState(() {
                                    passwordVisible = !passwordVisible;
                                  });
                                },
                                icon: passwordVisible
                                    ? Icon(
                                        Icons.visibility,
                                        color: IconTheme.of(context).color,
                                      )
                                    : Icon(
                                        Icons.lock,
                                        color: IconTheme.of(context).color,
                                      ),
                              ),
                              label: Text(
                                'Confirm my password',
                                style: textStyleText.copyWith(
                                    fontSize: 12,
                                    color: Theme.of(context).primaryColorLight),
                              ),
                              hintText: "Enter your password again",
                              hintStyle: textStyleText.copyWith(
                                  fontSize: 12,
                                  color: Theme.of(context).primaryColorLight),
                            ),
                            style: textStyleText.copyWith(
                                fontSize: 12,
                                color: Theme.of(context).primaryColorLight),
                            obscureText: passwordVisible,
                            validator: (val) {
                              if (!confirmPassword
                                  .trim()
                                  .contains(password.trim())) {
                                return "Passwords don't match";
                              }
                              return null;
                            },
                            onChanged: (val) {
                              setState(() {
                                confirmPassword = val;
                              });
                            },
                          ),
                          const SizedBox(
                            height: 30,
                          ),
                          Center(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(100),
                                  child: SizedBox(
                                    width: MediaQuery.of(context).size.width,
                                    child: MaterialButton(
                                      height: 60,
                                      onPressed: () async {
                                        //check if the form is validated
                                        if (_formKey.currentState!.validate()) {
                                          //set this state when I press the button
                                          await signUp();
                                        }
                                      },
                                      color: Theme.of(context)
                                          .primaryColor
                                          .withOpacity(.2),
                                      child: loading
                                          ? CircularProgressIndicator(
                                              color: Theme.of(context)
                                                  .primaryColorLight,
                                            )
                                          : Text(
                                              "Sign Up",
                                              style: textStyleText.copyWith(
                                                  color: Theme.of(context)
                                                      .primaryColorLight,
                                                  fontWeight: FontWeight.w700),
                                            ),
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  height: 6,
                                ),
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(100),
                                  child: SizedBox(
                                    width: MediaQuery.of(context).size.width,
                                    child: MaterialButton(
                                      height: 60,
                                      onPressed: () {
                                        widget.toggleView();
                                      },
                                      color: Theme.of(context)
                                          .primaryColor
                                          .withOpacity(0),
                                      child: Text(
                                        "Sign In",
                                        style: textStyleText.copyWith(
                                            color: Theme.of(context)
                                                .primaryColorLight,
                                            fontWeight: FontWeight.w700),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),

                          Text(
                            error,
                            style: const TextStyle(
                              color: Colors.red,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    )),
              ],
            ),
          ),
        ),
      ),
    );
  }
  //
  // Future signUp() async {
  //   setState(() {
  //     loading = true;
  //   });
  //   final navContext = Navigator.of(context);
  //   try {
  //     // Check if email already exists
  //     final signInMethods = await FirebaseAuth.instance
  //         .fetchSignInMethodsForEmail(email.toLowerCase().trim());
  //     if (signInMethods.isNotEmpty) {
  //       Reuse.callSnack(context, "Email already exists");
  //       setState(() {
  //         loading = false;
  //       });
  //       return;
  //     }
  //
  //     // Create new user account
  //     await FirebaseAuth.instance.createUserWithEmailAndPassword(
  //         email: email.toLowerCase().trim(), password: password.trim());
  //
  //     final FirebaseAuth auth = FirebaseAuth.instance;
  //     //get Current User
  //     final userCurrent = auth.currentUser!.uid;
  //     //store user in a string/
  //     uid = userCurrent.toString();
  //
  //     //insert data using a class
  //     User userData = User(
  //       contactNumber.toString(),
  //       name.trim(),
  //       secondName.trim(),
  //       email.trim().toLowerCase(),
  //       password.trim(),
  //       documentID,
  //       uid,
  //     );
  //     //this should add the registered user to the userData collection with UID
  //     await userData.addUser();
  //     // navContext.pushReplacement(
  //     //     MaterialPageRoute(builder: (context) => const VerifyEmailPage()));
  //     //logger.i(_user.addUser());
  //   } on FirebaseAuthException catch (e) {
  //     Reuse.callSnack(context, e.toString());
  //   } catch (e) {
  //     Reuse.callSnack(context, e.toString());
  //   }
  //   //Navigator.current
  //   // var navigatorKey;
  //   navigatorKey.currentState!.popUntil((route) {
  //     return route.isFirst;
  //   });
  //   setState(() {
  //     loading = false;
  //   });
  // }

  Future signUp() async {
    setState(() {
      loading = true;
    });
    final navContext = Navigator.of(context);

    try {
      // Check if email already exists
      final signInMethods = await FirebaseAuth.instance
          .fetchSignInMethodsForEmail(email.toLowerCase().trim());
      if (signInMethods.isNotEmpty) {
        Reuse.callSnack(context, "Email already exists");
        setState(() {
          loading = false;
        });
        return;
      }

      // Create new user account
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email.toLowerCase().trim(),
        password: password.trim(),
      );
      setState(() {
        loading = false;
      });
      User userData = User(
          email, name, secondName, contactNumber, documentID, token.toString());
      // Add the registered user to the userData collection with UID
      await userData.addUser();
    } on FirebaseAuthException catch (e) {
      Reuse.callSnack(
          context, e.message ?? "An error occurred during registration");
      setState(() {
        loading = false;
      });
    } catch (e) {
      Reuse.callSnack(context, "An unexpected error occurred: $e");
      setState(() {
        loading = false;
      });
    }

    // navigatorKey.currentState!.popUntil((route) {
    //   return route.isFirst;
    // });
  }
}
