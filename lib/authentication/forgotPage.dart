import 'package:flutter/material.dart';

import '../ReusableCode.dart';

class Forgot extends StatefulWidget {
  const Forgot({Key? key}) : super(key: key);

  @override
  State<Forgot> createState() => _ForgotState();
}

class _ForgotState extends State<Forgot> {
  String email = "";
  bool loading = false;
  final formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    // ConnectionChecker.checkTimer();
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
                                    color: Theme.of(context).primaryColorLight,
                                    fontWeight: FontWeight.normal),
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              InkWell(
                                  onTap: () {},
                                  child: Text(
                                    "Login",
                                    style: TextStyle(
                                        fontWeight: FontWeight.normal,
                                        letterSpacing: 1,
                                        color: Theme.of(context).primaryColor),
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
                                  //check if the form is validated
                                  if (formKey.currentState!.validate()) {
                                    // await forgotPassword()
                                    //     .then(
                                    //       (value) => Reuse.callSnack(context,
                                    //           "Link sent to your email",
                                    //           ),
                                    //     )
                                    //     .whenComplete(() => Navigator.of(
                                    //             context)
                                    //         .pushReplacement(MaterialPageRoute(
                                    //             builder: (context) =>
                                    //                 const Authenticate())));
                                  } else {
                                    Reuse.callSnack(
                                        context, "enter your email");
                                  }
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
    );
  }

  // Future<void> forgotPassword() async {
  //   //set this state after I press the button
  //   setState(() {
  //     loading = true;
  //   });
  //   try {
  //     await FirebaseAuth.instance.sendPasswordResetEmail(email: email.trim());
  //   } on FirebaseAuthException catch (e) {
  //     snack(e.toString(), context);
  //   }
  //
  //   //Navigator.current
  //   navigatorKey.currentState!.popUntil((route) {
  //     return route.isFirst;
  //   });
  //   //set this state after I press the button
  //   setState(() {
  //     loading = false;
  //   });
  // }
}
