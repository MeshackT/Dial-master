import 'package:dial/ReusableCode.dart';
import 'package:flutter/material.dart';

//call buttons

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);
  static const routeName = '/landingScreen';

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
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
                      padding: const EdgeInsets.all(10),
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height / 3.9,
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
                Reuse.title("Emergency", context),
                //title ends//
                Padding(
                  padding: const EdgeInsets.only(top: 15),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Reuse.buttonType(
                            "Ambulance",
                            Colors.green,
                            Icons.car_repair,
                            () => Reuse.callAmbulance(),
                            context,
                          ),
                          //fighter button
                          Reuse.buttonType(
                            "Child Line",
                            Colors.orange,
                            Icons.child_care,
                            () => Reuse.callChildLine(),
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
                            "Police",
                            Colors.blue,
                            Icons.star,
                            () => Reuse.callPolice(),
                            context,
                          ),
                          //fighter button
                          Reuse.buttonType(
                            "Fire Fighter",
                            Colors.red,
                            Icons.fire_truck_sharp,
                            () => Reuse.callFireFighter(),
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
                            "Private Ambulance",
                            Colors.lightGreen,
                            Icons.car_rental_sharp,
                            () => Reuse.callPrivateEmergency(),
                            context,
                          ),
                          //fighter button
                          Reuse.buttonType(
                            "Net Care",
                            Colors.orange,
                            Icons.child_care,
                            () => Reuse.callNetcare(),
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
