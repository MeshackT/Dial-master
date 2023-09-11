import 'package:dial/authentication/register.dart';
import 'package:flutter/material.dart';

import 'sign_in.dart';

class Authenticate extends StatefulWidget {
  const Authenticate({Key? key}) : super(key: key);

  @override
  State<Authenticate> createState() => _AuthenticateState();
}

class _AuthenticateState extends State<Authenticate> {
  bool showSignIn = true;
  bool showReset = true;

  void toggleView() {
    setState(() {
      showSignIn = !showSignIn;
    });
  }

  void toggleViewResetAndLogin() {
    setState(() {
      showReset = !showReset;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (showSignIn == true) {
      return SignIn(toggleView: toggleView);
    } else {
      return Register(toggleView: toggleView);
    }
  }
}
