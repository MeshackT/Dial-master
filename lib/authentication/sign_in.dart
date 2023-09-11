import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../ReusableCode.dart';
import '../main.dart';

class SignIn extends StatefulWidget {
  final Function toggleView;

  const SignIn({Key? key, required this.toggleView}) : super(key: key);

  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  // AuthService authService = AuthService();
  final _formKey = GlobalKey<FormState>();
  String email = "";
  final formKey = GlobalKey<FormState>();

  //we access signing previlages using this class
  // final FirebaseAuth _auth = FirebaseAuth.instance;
  bool isLoading = false;
  bool passwordVisible = true;
  bool showButton = false;

  //textField state
  String password = '';
  String error = '';
  String codeUnit = '';
  bool loading = false;
  String role = "teacher";
  String code = '';
  String codePassword = "WMPSST";

  @override
  void initState() {
    super.initState();
    // ConnectionChecker.checkTimer();
  }

  @override
  void dispose() {
    super.dispose();
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
                      "Sign In",
                      textAlign: TextAlign.center,
                      style: textStyleText.copyWith(
                          color: Theme.of(context).primaryColorLight,
                          fontSize: 28,
                          fontWeight: FontWeight.w800),
                    ),
                  ),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height / 1.2,
                  width: MediaQuery.of(context).size.width / .9,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 30.0, vertical: 30),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        children: <Widget>[
                          SizedBox(
                              height: 30,
                              child: Text(
                                "Sign in to be able to share your location",
                                style: textStyleText.copyWith(
                                    color: Theme.of(context).primaryColorLight,
                                    fontWeight: FontWeight.w400),
                              )),
                          Reuse.spaceBetween(),
                          Reuse.spaceBetween(),
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
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              SizedBox(
                                height: 30,
                                child: Text(
                                  "Forgot password?",
                                  style: textStyleText.copyWith(
                                      color:
                                          Theme.of(context).primaryColorLight,
                                      fontWeight: FontWeight.normal),
                                ),
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              InkWell(
                                onTap: () {
                                  showSheetToReset(context);
                                },
                                child: SizedBox(
                                  height: 30,
                                  child: Text(
                                    "Reset",
                                    style: textStyleText.copyWith(
                                        color: Theme.of(context).primaryColor,
                                        fontWeight: FontWeight.normal),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          ClipRRect(
                            borderRadius: BorderRadius.circular(100),
                            child: SizedBox(
                              width: MediaQuery.of(context).size.width,
                              child: MaterialButton(
                                height: 60,
                                onPressed: () async {
                                  final navigatorContext =
                                      Navigator.of(context);

                                  //check if the form is validated
                                  if (_formKey.currentState!.validate()) {
                                    await signIn();
                                  }
                                  // else {
                                  //   Reuse.callSnack(
                                  //       context, "Failed to Sign In");
                                  // }
                                },
                                color: Theme.of(context)
                                    .primaryColor
                                    .withOpacity(.2),
                                child: loading
                                    ? CircularProgressIndicator(
                                        color:
                                            Theme.of(context).primaryColorLight,
                                      )
                                    : Text(
                                        "Sign In",
                                        style: textStyleText.copyWith(
                                            color: Theme.of(context)
                                                .primaryColorLight,
                                            fontWeight: FontWeight.normal),
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
                                  "Sign Up",
                                  style: textStyleText.copyWith(
                                      color:
                                          Theme.of(context).primaryColorLight,
                                      fontWeight: FontWeight.w700),
                                ),
                              ),
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

  //Works perfect
  Future<void> signIn() async {
    setState(() {
      loading = true;
    });

    final navContext = Navigator.of(context);
    try {
      // Check if user exists
      bool userExists = false;
      UserCredential userCredential =
          await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email.trim().toLowerCase(),
        password: password.trim(),
      );
      userExists = userCredential.user != null;

      // Navigate to the home screen if user exists
      if (userExists = userCredential.user != null) {
        return;
        // navContext.pushReplacement(
        //     MaterialPageRoute(builder: (context) => const Home()));
      } else if (!userExists) {
        Reuse.callSnack(context, "email doesn't exist");
      } else {
        Fluttertoast.showToast(msg: 'Email account not registered');
        Reuse.callSnack(context, "Email doesn't exist");
      }
    } on FirebaseAuthException catch (e) {
      if (e.code != 'user-not-found') {
        Reuse.callSnack(
          context,
          "Email not registered",
        );
        setState(() {
          loading = false;
        });
        return;
      } else if (e.code != 'wrong-password') {
        Reuse.callSnack(context, "Wrong password");
        setState(() {
          loading = false;
        });
      }
    } catch (error) {
      // Handle other types of errors
      switch (error) {
        case 'ERROR_INVALID_EMAIL':
        case 'ERROR_WRONG_PASSWORD':
        case 'ERROR_USER_DISABLED':
        case 'ERROR_TOO_MANY_REQUESTS':
        case 'ERROR_OPERATION_NOT_ALLOWED':
          Reuse.callSnack(context, error.toString());
          setState(() {
            loading = false;
          });
          break;
        default:
          Reuse.callSnack(context, 'An unknown error occurred');
          setState(() {
            loading = false;
          });
          break;
      }
    }

    setState(() {
      loading = false;
    });

    // Clear the login scren stack from the navigator
    navigatorKey.currentState!.popUntil((route) => route.isFirst);
  }

  showSheetToReset(BuildContext context) {
    showModalBottomSheet(
      barrierColor: Theme.of(context).primaryColor.withOpacity(.1),
      isScrollControlled: true,
      enableDrag: true,
      elevation: 1,
      clipBehavior: Clip.antiAlias,
      context: context,
      builder: (context) {
        return Wrap(
          alignment: WrapAlignment.center,
          children: [
            SingleChildScrollView(
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
                child: Column(
                  children: [
                    const SizedBox(
                      height: 20,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 50),
                      child: Center(
                        child: Text(
                          "Forgot Password",
                          textAlign: TextAlign.center,
                          style: textStyleText.copyWith(
                              color: Theme.of(context).primaryColorLight,
                              fontSize: 28,
                              fontWeight: FontWeight.w700),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    SizedBox(
                      child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 30.0, vertical: 30),
                          child: Form(
                            key: formKey,
                            child: Column(
                              children: <Widget>[
                                const SizedBox(
                                  height: 20,
                                ),
                                TextFormField(
                                  decoration: textInputDecoration1.copyWith(
                                    label: Text(
                                      'My email',
                                      style: textStyleText.copyWith(
                                          fontSize: 12,
                                          color: Theme.of(context)
                                              .primaryColorLight),
                                    ),
                                    hintText: "example@gmail.com",
                                    hintStyle: textStyleText.copyWith(
                                        color: Theme.of(context)
                                            .primaryColorLight),
                                  ),
                                  style: textStyleText.copyWith(
                                      fontSize: 12,
                                      color:
                                          Theme.of(context).primaryColorLight),
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
                                const SizedBox(
                                  height: 20,
                                ),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Text(
                                      "Forgot password?",
                                      style: textStyleText.copyWith(
                                          color: Theme.of(context)
                                              .primaryColorLight,
                                          fontWeight: FontWeight.normal),
                                    ),
                                    const SizedBox(
                                      width: 10,
                                    ),
                                    InkWell(
                                        onTap: () {
                                          Navigator.of(context).pop();
                                        },
                                        child: Text(
                                          "Login",
                                          style: TextStyle(
                                              fontWeight: FontWeight.normal,
                                              letterSpacing: 1,
                                              color: Theme.of(context)
                                                  .primaryColor),
                                        ))
                                  ],
                                ),
                                const SizedBox(
                                  height: 20,
                                ),
                                ClipRRect(
                                  borderRadius: const BorderRadius.only(
                                    bottomLeft: Radius.circular(70),
                                    bottomRight: Radius.circular(70),
                                    topRight: Radius.circular(70),
                                    topLeft: Radius.circular(70),
                                  ),
                                  child: SizedBox(
                                    width: MediaQuery.of(context).size.width,
                                    child: MaterialButton(
                                      height: 60,
                                      onPressed: () async {
                                        final navContext =
                                            Navigator.of(context);
                                        //check if the form is validated
                                        if (formKey.currentState!.validate()) {
                                          await forgotPassword();
                                          Navigator.of(context).pop();
                                        }
                                      },
                                      color: Theme.of(context)
                                          .primaryColor
                                          .withOpacity(.2),
                                      child: loading == true
                                          ? CircularProgressIndicator(
                                              color: Theme.of(context)
                                                  .primaryColorLight,
                                            )
                                          : Text(
                                              "Reset ",
                                              style: textStyleText.copyWith(
                                                  color: Theme.of(context)
                                                      .primaryColorLight),
                                            ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          )),
                    ),
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Future<void> forgotPassword() async {
    //set this state after I press the button
    setState(() {
      loading = true;
    });
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email.trim());
      Reuse.callSnack(
          context, "Please check you email to continue with the process");
    } on FirebaseAuthException catch (e) {
      Reuse.callSnack(context, "There is no user record or internet failure");
      Reuse.logger.i(e);
    }
    setState(() {
      loading = false;
    });

    //Navigator.current
    // navigatorKey.currentState!.popUntil((route) {
    //   return route.isFirst;
    // });
  }
}
