import 'package:double_back_to_close_app/double_back_to_close_app.dart';
import 'package:flutter/material.dart';

import 'ReusableCode.dart';

class MoreServices extends StatelessWidget {
  const MoreServices({Key? key}) : super(key: key);
  static const routeName = '/moreServices';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: DoubleBackToCloseApp(
        snackBar: SnackBar(
          backgroundColor: Theme.of(context).primaryColor.withOpacity(1),
          content: Text(
            'Tap back again to leave the application',
            style: TextStyle(color: Theme.of(context).primaryColorLight),
            textAlign: TextAlign.center,
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            child: Container(
              height: MediaQuery.of(context).size.height,
              margin: const EdgeInsets.only(top: 0.0),
              decoration: const BoxDecoration(
                //screen background color
                gradient: LinearGradient(
                    colors: [Color(0xff3D3C77), Color(0xff000000)],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Stack(
                    children: [
                      Image.asset(
                        'images/la.png',
                        width: 390,
                        height: 218,
                        fit: BoxFit.cover,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 10, left: 10),
                        child: ElevatedButton.icon(
                          style: OutlinedButton.styleFrom(
                              backgroundColor: Theme.of(context).primaryColor,
                              shape: const RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(20))),
                              foregroundColor:
                                  Theme.of(context).primaryColorDark),
                          icon: Icon(
                            Icons.arrow_back_ios,
                            size: 15,
                            color: Theme.of(context).primaryColorLight,
                          ),
                          onPressed: () {
                            Navigator.pushNamedAndRemoveUntil(
                                context, "/", (route) => false);
                          },
                          label: Text(
                            "Back",
                            style: TextStyle(
                              color: Theme.of(context).primaryColorLight,
                            ),
                            selectionColor: Theme.of(context).primaryColorLight,
                          ),
                        ),
                      ),
                      Center(
                        child: Padding(
                          padding: const EdgeInsets.only(top: 183),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(10.0),
                            child: Container(
                              color: const Color(0x0f09091b).withOpacity(.6),
                              height: 68,
                              width: 331,
                              child: Center(
                                child: Text(
                                  "More Services",
                                  style: TextStyle(
                                      color:
                                          Theme.of(context).primaryColorLight,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      letterSpacing: 1),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  //title//
                  // Reuse.title(" your fingertips", context),
                  //title ends//
                  const SizedBox(
                    height: 20,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 20),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Reuse.buttonType(
                              "Gender Based violence",
                              Theme.of(context)
                                  .primaryColorDark
                                  .withOpacity(.49),
                              Icons.girl_outlined,
                              () => Reuse.callGenderBasedViolence(),
                              context,
                            ),
                            //fighter button
                            Reuse.buttonType(
                              "SA Emergency",
                              Theme.of(context)
                                  .primaryColorDark
                                  .withOpacity(.49),
                              Icons.flag,
                              () => Reuse.callSAEmergency(),
                              context,
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 20.0,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Reuse.buttonType(
                              "NIC diseases",
                              Theme.of(context)
                                  .primaryColorDark
                                  .withOpacity(.49),
                              Icons.sick,
                              () => Reuse.callNationalInstitutionOfDiseases(),
                              context,
                            ),
                            //fighter button
                            Reuse.buttonType(
                              "DOHA\nHome Affairs",
                              Theme.of(context)
                                  .primaryColorDark
                                  .withOpacity(.49),
                              Icons.maps_home_work_outlined,
                              () => Reuse.callDepartmentOfHomeAffairs(),
                              context,
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 20.0,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Reuse.buttonType(
                              "National Crisis Line",
                              Theme.of(context)
                                  .primaryColorDark
                                  .withOpacity(.49),
                              Icons.crisis_alert,
                              () => Reuse.callNationalCrisisLine(),
                              context,
                            ),
                            //fighter button
                            Reuse.buttonType(
                              "Department of water affairs",
                              Theme.of(context)
                                  .primaryColorDark
                                  .withOpacity(.49),
                              Icons.water,
                              () => Reuse.callDepartmentOfWater(),
                              context,
                            ),
                          ],
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
    );
  }
}
