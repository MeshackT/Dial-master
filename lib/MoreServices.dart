import 'package:flutter/material.dart';

import 'ReusableCode.dart';

class MoreServices extends StatelessWidget {
  const MoreServices({Key? key}) : super(key: key);
  static const routeName = '/moreServices';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      extendBody: true,
      backgroundColor: const Color(0xFF072456),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            height: MediaQuery.of(context).size.height,
            margin: const EdgeInsets.only(top: 0.0),
            decoration: const BoxDecoration(
              //screen background color
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
                        'images/la.png',
                        width: 390,
                        height: 218,
                        fit: BoxFit.cover,
                      ),
                    ),
                    // Reuse.speedDialHeader("Speed dial", context),
                    Center(
                      child: Padding(
                        padding: const EdgeInsets.only(top: 183),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(10.0),
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
                                //   () =>
                                //       Fluttertoast.showToast(msg: "Coming song"),
                                //       // Navigator.of(context)
                                //       // .pushNamedAndRemoveUntil(
                                //       //     "/addLocation", (route) => false),
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
                                // Reuse.navigatorButton(
                                //   Icon(
                                //     Icons.create,
                                //     size: 25.0,
                                //     color: Theme.of(context).primaryColorLight,
                                //   ),
                                //   () => Navigator.pushNamedAndRemoveUntil(
                                //       context, '/settings', (route) => false),
                                // ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                //title//
                Reuse.title("More Services", context),

                Padding(
                  padding: const EdgeInsets.only(top: 20),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Reuse.buttonType(
                            "Gender Based violence",
                            Theme.of(context).primaryColorDark.withOpacity(.49),
                            Icons.girl_outlined,
                            () => Reuse.callGenderBasedViolence(),
                            context,
                          ),
                          //fighter button
                          Reuse.buttonType(
                            "SA Emergency",
                            Theme.of(context).primaryColorDark.withOpacity(.49),
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
                            Theme.of(context).primaryColorDark.withOpacity(.49),
                            Icons.sick,
                            () => Reuse.callNationalInstitutionOfDiseases(),
                            context,
                          ),
                          //fighter button
                          Reuse.buttonType(
                            "DOHA\nHome Affairs",
                            Theme.of(context).primaryColorDark.withOpacity(.49),
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
                            Theme.of(context).primaryColorDark.withOpacity(.49),
                            Icons.crisis_alert,
                            () => Reuse.callNationalCrisisLine(),
                            context,
                          ),
                          //fighter button
                          Reuse.buttonType(
                            "Department of water affairs",
                            Theme.of(context).primaryColorDark.withOpacity(.49),
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
    );
  }
}
