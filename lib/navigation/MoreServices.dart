import 'package:flutter/material.dart';

import '../ReusableCode.dart';

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
                  alignment: Alignment.bottomCenter,
                  children: [
                    // SizedBox(
                    //   width: MediaQuery.of(context).size.width,
                    //   height: MediaQuery.of(context).size.height / 3.8,
                    //   child: Image.asset(
                    //     'images/la.png',
                    //     width: 390,
                    //     height: 218,
                    //     fit: BoxFit.cover,
                    //   ),
                    // ),
                    Container(
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height / 3.9,
                      padding: const EdgeInsets.all(10),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        border: Border.all(
                          width: 1,
                          color: Theme.of(context).primaryColor.withOpacity(.2),
                        ),
                      ),
                      child: Image.asset(
                        'images/la.png',
                        fit: BoxFit.cover,
                        width: double.infinity,
                        height: double.infinity,
                      ),
                    ),
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: Center(
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(10.0),
                          child: Container(
                            color: const Color(0x0f09091b).withOpacity(.6),
                            height: 55,
                            width: 331,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                // Reuse.navigatorButton(
                                //   Icon(
                                //     Icons.location_on,
                                //     size: 25.0,
                                //     color: Colors.green,
                                //   ),
                                //   () => Navigator.of(context)
                                //       .pushNamedAndRemoveUntil(
                                //           "/addLocat
                                //           ion", (route) => false),
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
                            Colors.pinkAccent,
                            Icons.girl_outlined,
                            () => Reuse.callGenderBasedViolence(),
                            context,
                          ),
                          //fighter button
                          Reuse.buttonType(
                            "SA Emergency",
                            Colors.green,
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
                            Colors.red,
                            Icons.sick,
                            () => Reuse.callNationalInstitutionOfDiseases(),
                            context,
                          ),
                          //fighter button
                          Reuse.buttonType(
                            "DOHA\nHome Affairs",
                            Colors.yellow,
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
                            Colors.purple,
                            Icons.crisis_alert,
                            () => Reuse.callNationalCrisisLine(),
                            context,
                          ),
                          //fighter button
                          Reuse.buttonType(
                            "Department of water affairs",
                            Colors.blueAccent,
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
