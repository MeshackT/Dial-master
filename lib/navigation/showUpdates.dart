import 'dart:convert';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dial/ReusableCode.dart';
import 'package:dial/payments/paymentWidget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:location/location.dart';
import 'package:pay/pay.dart';
import 'package:url_launcher/url_launcher.dart';

import '../DBModel/Place.dart';
// import 'payment_configurations.dart' as payment_configurations;

class ShowUpdates extends StatefulWidget {
  const ShowUpdates({Key? key}) : super(key: key);
  static const routeName = '/showUpdates';

  @override
  State<ShowUpdates> createState() => _ShowUpdatesState();
}

class _ShowUpdatesState extends State<ShowUpdates> {
  final String apiKey = 'AIzaSyBOx5ybi0WTutSJZr3LD9EyotpyoO5srgk';
  final int radius = 80000;
  final String searchType = 'hospital';
  final String searchTypePolice = 'police';
  final String searchTypeSchool = 'school';
  final String searchTypeFire = 'fire_fighter';
  final String searchTypeHomeAffairs = 'HomeAffairs';
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  late final Future<PaymentConfiguration> _googlePayConfigFuture;

  //get data and store it in a list
  List<dynamic> hospitals = [];
  List<dynamic> policeStation = [];
  List<dynamic> fireStation = [];
  List<dynamic> homeAffairs = [];
  List<dynamic> schools = [];

  //TOdo show departments
  bool hospitalButton = false;
  bool policeButton = false;
  bool fireFighterButton = false;
  bool homeAffairsButton = false;

  //Todo show default data
  bool hospitalButtonD = false;
  bool policeButtonD = false;
  bool fireFighterButtonD = false;

  bool hospitalList = false;

  //Default buttons
  bool defaultButton = true;
  bool defaultButton1 = true;

  //Todo starts/////////////////////////////////////////////////////////
  PlaceLocation? _pickLocation;
  bool _isGettingLocation = false;

  //get location
  String get locationImage {
    final lat = _pickLocation?.latitude;
    final lng = _pickLocation?.longitude;

    if (_pickLocation == null) {
      setState(() {
        _isGettingLocation = true;
        CircularProgressIndicator(
          color: Theme.of(context).primaryColorLight,
        );
      });
      return 'https://maps.googleapis.com/maps/api/staticmap?center=63.259591,-144.667969&zoom=6&size=600x400&markers=color:blue%7Clabel:S%7C62.107733,-145.541936&markers=size:tiny%7Ccolor:green%7CDelta+Junction,AK&markers=size:mid%7Ccolor:0xFFFF00%7Clabel:C%7CTok,AK"&key=$apiKey';
    }
    // Reuse.logger.e("get latitude: ${_pickLocation!.latitude}");
    // Reuse.logger.e("get longitude: ${_pickLocation!.longitude}");
    setState(() {
      Reuse.logger.e("stored latitude: $lat}");
      Reuse.logger.e("stored longitude: $lng}");
      _isGettingLocation = false;
    });

    return 'https://maps.googleapis.com/maps/api/staticmap?center=$lat,$lng&zoom=16&size=600x300&maptype=roadmap&markers=color:red%7Clabel:A%7C$lat, $lng&key=$apiKey';
  }

//get current location
  void _getCurrentLocation() async {
    Location location = Location();

    setState(() {
      _isGettingLocation = true;
    });
    bool serviceEnabled;
    PermissionStatus permissionGranted;
    LocationData locationData;

    serviceEnabled = await location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await location.requestService();
      if (!serviceEnabled) {
        return;
      }
    }

    permissionGranted = await location.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await location.requestPermission();
      if (permissionGranted != PermissionStatus.granted) {
        return;
      }
    }

    locationData = await location.getLocation();

    final lat = locationData.latitude;
    final lng = locationData.longitude;
    final url = Uri.parse(
        'https://maps.googleapis.com/maps/api/geocode/json?latlng=$lat,$lng&key=$apiKey');

    if (lat == null || lng == null) {
      return;
    }

    //Extracting data from the object created
    final response = await http.get(url);
    final resData = jsonDecode(response.body);
    final address = resData['results'][0]['formatted_address'];
    // Reuse.logger.e(locationData.latitude);
    // Reuse.logger.e(locationData.longitude);

    setState(() {
      _pickLocation =
          PlaceLocation(latitude: lat, longitude: lng, address: address);
    });
    fetchData();
    fetchDataPolice();
    fetchDataFire();

    Future.delayed(
        const Duration(
          seconds: 5,
        ), () {
      addDataToDocument(hospitals, policeStation, fireStation);
    });
  }

  //TODO ends////////////////////////////////////////////////////////////

  //TODO fetch data of departments////////////////////////////////////////////

  Future<void> fetchData() async {
    final lng = _pickLocation?.longitude;
    final lat = _pickLocation?.latitude;

    String apiUrl = "";
    String apiUrlPolice = "";

    if (lng == null || lat == null) {
      return;
    }

    apiUrl =
        "https://maps.googleapis.com/maps/api/place/nearbysearch/json?keyword=hospital&location=$lat,$lng&radius=$radius&type=$searchType&key=$apiKey";

    try {
      final hospitalsResponse = await http.get(Uri.parse(apiUrl));

      if (hospitalsResponse.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(hospitalsResponse.body);
        if (data.containsKey('results')) {
          setState(() {
            hospitals = data['results'];
          });

          Reuse.logger.e("The hospital list of data ${data["results"]}");
        }
      } else {
        throw 'Failed to load data: ${hospitalsResponse.statusCode}';
      }
    } catch (e) {
      throw 'Error fetching data: $e';
    }

    try {
      final policeResponse = await http.get(Uri.parse(apiUrlPolice));

      if (policeResponse.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(policeResponse.body);
        if (data.containsKey('results')) {
          setState(() {
            policeStation = data['results'];
          });

          Reuse.logger.e("The hospital list of data ${data["results"]}");
        }
      } else {
        throw 'Failed to load data: ${policeResponse.statusCode}';
      }
    } catch (e) {
      throw 'Error fetching data: $e';
    }
  }

  Future<void> fetchDataPolice() async {
    final lng = _pickLocation?.longitude;
    final lat = _pickLocation?.latitude;

    String apiUrlPolice = "";

    if (lng == null || lat == null) {
      return;
    }
    apiUrlPolice =
        "https://maps.googleapis.com/maps/api/place/nearbysearch/json?keyword=police&location=$lat,$lng&radius=$radius&type=$searchTypePolice&key=$apiKey";

    try {
      final policeResponse = await http.get(Uri.parse(apiUrlPolice));

      if (policeResponse.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(policeResponse.body);
        if (data.containsKey('results')) {
          setState(() {
            policeStation = data['results'];
          });

          Reuse.logger.e("The police list of data ${data["results"]}");
        }
      } else {
        throw 'Failed to load data: ${policeResponse.statusCode}';
      }
    } catch (e) {
      throw 'Error fetching data: $e';
    }
  }

  Future<void> fetchDataFire() async {
    final lng = _pickLocation?.longitude;
    final lat = _pickLocation?.latitude;
    const fireRadius = 80000;

    String apiUrlFire = "";
    const String searchTypeFire = 'fire_fighter';

    if (lng == null || lat == null) {
      return;
    }
    apiUrlFire =
        "https://maps.googleapis.com/maps/api/place/nearbysearch/json?keyword=fire_station&location=$lat,$lng&radius=$fireRadius&type=$searchTypeFire&key=$apiKey";

    try {
      final fireResponse = await http.get(Uri.parse(apiUrlFire));

      if (fireResponse.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(fireResponse.body);
        if (data.containsKey('results')) {
          setState(() {
            fireStation = data['results'];
          });

          Reuse.logger.e("The fire list of data ${data["results"]}");
        }
      } else {
        throw 'Failed to load data: ${fireResponse.statusCode}';
      }
    } catch (e) {
      throw 'Error fetching data: $e';
    }
  }

  List<Color> itemColors = [];

  Random random = Random();

  Color generateRandomColor() {
    return Color.fromARGB(
      255,
      random.nextInt(256),
      random.nextInt(256),
      random.nextInt(256),
    );
  }

  List<PaymentItem> _paymentItems = [
    PaymentItem(
      label: 'Total',
      amount: '99.99',
      status: PaymentItemStatus.final_price,
    )
  ];
  @override
  void initState() {
    super.initState();
    // getLocationData();
    // Get the location first
    _getCurrentLocation();
    _googlePayConfigFuture =
        PaymentConfiguration.fromAsset('default_google_pay_config.json');
  }

  //pay functions
  void onGooglePayResult(paymentResult) {
    debugPrint(paymentResult.toString());
  }

  void onApplePayResult(paymentResult) {
    debugPrint(paymentResult.toString());
  }

  Future<void> getLocationData() {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          // );
          return CupertinoAlertDialog(
            // backgroundColor:
            // Theme.of(context).primaryColorLight.withOpacity(.9),
            title: const Text(
              textAlign: TextAlign.center,
              'Get your location first',
              style: TextStyle(
                  color: Colors.red, fontSize: 20, fontWeight: FontWeight.w700),
            ),
            content: Text(
              "Lets get your location and get nearby emergency areas.",
              textAlign: TextAlign.center,
              style: TextStyle(color: Theme.of(context).primaryColor),
            ),
            actions: <Widget>[
              Center(
                child: TextButton(
                  onPressed: () async {
                    _getCurrentLocation();
                  },
                  child: Text(
                    'Get',
                    style: TextStyle(
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                ),
              ),
            ],
          );
        });
  }

  @override //
  Widget build(BuildContext context) {
    //Todo starts
    //No image yet
    Widget previewContent = const Text(
      "No location yet",
      style: TextStyle(),
    );

    //get image
    setState(() {
      previewContent = Image.network(
        locationImage,
        fit: BoxFit.cover,
        width: double.infinity,
        height: double.infinity,
        scale: 1,
      );
    });
    // Todo ends

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        automaticallyImplyLeading: false,
        title: Text(
          "View nearby places",
          style: textStyleText.copyWith(
              fontSize: 14, color: Theme.of(context).primaryColorLight),
        ),
        actions: [
          defaultButton
              ? IconButton(
                  onPressed: () {
                    //  default buttons show
                    showPayment();
                    setState(() {
                      if (defaultButton = false) {
                        defaultButton1 = true;
                      } else if (defaultButton1 = true) {
                        defaultButton = false;
                      }
                    });
                  },
                  icon: const Icon(Icons.payments))
              : IconButton(
                  onPressed: () {
                    //  default buttons show
                    setState(() {
                      if (defaultButton1 = false) {
                        defaultButton = true;
                      } else if (defaultButton = true) {
                        defaultButton1 = false;
                      }
                    });
                  },
                  icon: const Icon(Icons.published_with_changes_rounded)),
          _popUpMenuButtons(),
        ],
      ),
      extendBodyBehindAppBar: true,
      extendBody: true,
      backgroundColor: const Color(0xFF072456),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            margin: const EdgeInsets.only(top: 0.0),
            decoration: const BoxDecoration(
              //screen background color
              gradient: LinearGradient(
                  colors: [Color(0xFF072456), Color(0xff000000)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight),
            ),
            child: Column(children: [
              Reuse.spaceBetween(),
              defaultButton
                  ? Text(
                      "Default locations",
                      style: textStyleText.copyWith(
                          fontSize: 13,
                          color: Theme.of(context).primaryColorLight),
                    )
                  : _isGettingLocation
                      ? const CircularProgressIndicator()
                      : Container(
                          height: 150,
                          padding: const EdgeInsets.all(10),
                          width: double.infinity,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            border: Border.all(
                              width: 1,
                              color: Theme.of(context)
                                  .primaryColor
                                  .withOpacity(.2),
                            ),
                          ),
                          child: _isGettingLocation
                              ? const CircularProgressIndicator()
                              : previewContent,
                        ),
              //first is the default buttons
              //secondly are the main buttons
              defaultButton
                  ? Container(
                      margin: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        border: Border.all(
                          width: 1,
                          color: Theme.of(context)
                              .primaryColorLight
                              .withOpacity(.2),
                        ),
                      ),
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: [
                            TextButton.icon(
                              onPressed: () async {
                                setState(() {
                                  hospitalButtonD = true;
                                  if (hospitalButtonD = true) {
                                    policeButtonD = false;
                                    fireFighterButtonD = false;
                                  }
                                });
                                await addDataToDocument(
                                    hospitals, policeStation, fireStation);
                                Reuse.logger.i("1");
                              },
                              icon: const Icon(
                                Icons.car_repair_outlined,
                                color: Colors.green,
                              ),
                              label: Text(
                                "Hospitals",
                                style: textStyleText.copyWith(
                                    fontSize: 12,
                                    color: Theme.of(context).primaryColorLight),
                              ),
                            ),
                            TextButton.icon(
                              onPressed: () {
                                setState(() {
                                  policeButtonD = true;
                                  if (policeButtonD = true) {
                                    hospitalButtonD = false;
                                    fireFighterButtonD = false;
                                  }
                                });
                                Reuse.logger.i("1");
                              },
                              icon: const Icon(
                                Icons.star,
                                color: Colors.blue,
                              ),
                              label: Text(
                                "Police Station",
                                style: textStyleText.copyWith(
                                    fontSize: 12,
                                    color: Theme.of(context).primaryColorLight),
                              ),
                            ),
                            TextButton.icon(
                              onPressed: () {
                                setState(() {
                                  fireFighterButtonD = true;
                                  if (fireFighterButtonD = true) {
                                    hospitalButtonD = false;
                                    policeButtonD = false;
                                  }
                                });
                                Reuse.logger.i("1");
                              },
                              icon: const Icon(
                                Icons.fire_truck,
                                color: Colors.red,
                              ),
                              label: Text(
                                "Fire Station",
                                style: textStyleText.copyWith(
                                    fontSize: 12,
                                    color: Theme.of(context).primaryColorLight),
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                  : SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          TextButton.icon(
                            onPressed: () async {
                              setState(() {
                                hospitalButton = true;
                                if (hospitalButton = true) {
                                  policeButton = false;
                                  fireFighterButton = false;
                                }
                              });
                              await addDataToDocument(
                                  hospitals, policeStation, fireStation);
                            },
                            icon: const Icon(
                              Icons.car_repair_outlined,
                              color: Colors.green,
                            ),
                            label: Text(
                              "Hospitals",
                              style: textStyleText.copyWith(
                                  fontSize: 12,
                                  color: Theme.of(context).primaryColorLight),
                            ),
                          ),
                          TextButton.icon(
                            onPressed: () {
                              setState(() {
                                policeButton = true;
                                if (policeButton = true) {
                                  hospitalButton = false;
                                  fireFighterButton = false;
                                }
                              });
                            },
                            icon: const Icon(
                              Icons.star,
                              color: Colors.blue,
                            ),
                            label: Text(
                              "Police Station",
                              style: textStyleText.copyWith(
                                  fontSize: 12,
                                  color: Theme.of(context).primaryColorLight),
                            ),
                          ),
                          TextButton.icon(
                            onPressed: () {
                              setState(() {
                                fireFighterButton = true;
                                if (fireFighterButton = true) {
                                  hospitalButton = false;
                                  policeButton = false;
                                }
                              });
                            },
                            icon: const Icon(
                              Icons.fire_truck,
                              color: Colors.red,
                            ),
                            label: Text(
                              "Fire Station",
                              style: textStyleText.copyWith(
                                  fontSize: 12,
                                  color: Theme.of(context).primaryColorLight),
                            ),
                          ),
                        ],
                      ),
                    ),
              Visibility(
                visible: hospitalButton,
                child: Expanded(
                  child: ListView.builder(
                      padding: const EdgeInsets.only(bottom: 160),
                      itemCount: hospitals.length,
                      itemBuilder: (BuildContext context, int index) {
                        final hospital = hospitals[index];
                        final name = hospital['name'];
                        final address = hospital['vicinity'];
                        final lat = hospital['geometry']['location']['lat'];
                        final lng = hospital['geometry']['location']['lng'];
                        return GestureDetector(
                          onTap: () {
                            openGoogleMaps(lat, lng);
                          },
                          child: ListTile(
                            leading: CircleAvatar(
                              // backgroundColor: itemColors[index].withOpacity(.6),
                              backgroundColor: Theme.of(context)
                                  .primaryColor
                                  .withOpacity(.2),
                              child: Text(
                                name[0].toString(),
                                style: textStyleText.copyWith(
                                    color: Theme.of(context).primaryColorLight),
                              ),
                            ),
                            title: Text(
                              name,
                              style: textStyleText.copyWith(
                                  fontSize: 13,
                                  color: Theme.of(context).primaryColorLight),
                            ),
                            subtitle: Text(
                              address,
                              style: textStyleText.copyWith(
                                  fontSize: 12,
                                  color: Theme.of(context)
                                      .primaryColorLight
                                      .withOpacity(.8)),
                            ),
                            trailing: const Icon(
                              Icons.car_repair_rounded,
                              size: 20,
                              color: Colors.green,
                            ),
                          ),
                        );
                      }),
                ),
              ),
              Visibility(
                visible: policeButton,
                child: Expanded(
                  child: ListView.builder(
                      padding: const EdgeInsets.only(bottom: 160),
                      itemCount: policeStation.length,
                      itemBuilder: (BuildContext context, int index) {
                        final police = policeStation[index];
                        final name = police['name'];
                        final address = police['vicinity'];
                        final lat = police['geometry']['location']['lat'];
                        final lng = police['geometry']['location']['lng'];

                        return GestureDetector(
                          onTap: () {
                            openGoogleMaps(lat, lng);
                            Reuse.logger.i(lat);
                          },
                          child: ListTile(
                            leading: CircleAvatar(
                              // backgroundColor: itemColors[index].withOpacity(.6),
                              backgroundColor: Theme.of(context)
                                  .primaryColor
                                  .withOpacity(.2),
                              child: Text(
                                name[0].toString(),
                                style: textStyleText.copyWith(
                                    color: Theme.of(context).primaryColorLight),
                              ),
                            ),
                            title: Text(
                              name,
                              style: textStyleText.copyWith(
                                  fontSize: 13,
                                  color: Theme.of(context).primaryColorLight),
                            ),
                            subtitle: Text(
                              address,
                              style: textStyleText.copyWith(
                                  fontSize: 12,
                                  color: Theme.of(context)
                                      .primaryColorLight
                                      .withOpacity(.8)),
                            ),
                            trailing: const Icon(
                              Icons.star,
                              size: 20,
                              color: Colors.blue,
                            ),
                          ),
                        );
                      }),
                ),
              ),
              Visibility(
                visible: fireFighterButton,
                child: Expanded(
                  child: ListView.builder(
                      padding: const EdgeInsets.only(bottom: 160),
                      itemCount: fireStation.length,
                      itemBuilder: (BuildContext context, int index) {
                        final fire = fireStation[index];
                        final name = fire['name'];
                        final address = fire['vicinity'];
                        final lat = fire['geometry']['location']['lat'];
                        final lng = fire['geometry']['location']['lng'];

                        return GestureDetector(
                          onTap: () {
                            openGoogleMaps(lat, lng);
                          },
                          child: ListTile(
                            leading: CircleAvatar(
                              // backgroundColor: itemColors[index].withOpacity(.6),
                              backgroundColor: Theme.of(context)
                                  .primaryColor
                                  .withOpacity(.2),
                              child: Text(
                                name[0].toString(),
                                style: textStyleText.copyWith(
                                    color: Theme.of(context).primaryColorLight),
                              ),
                            ),
                            title: Text(
                              name,
                              style: textStyleText.copyWith(
                                  fontSize: 13,
                                  color: Theme.of(context).primaryColorLight),
                            ),
                            subtitle: Text(
                              address,
                              style: textStyleText.copyWith(
                                  fontSize: 12,
                                  color: Theme.of(context)
                                      .primaryColorLight
                                      .withOpacity(.8)),
                            ),
                            trailing: const Icon(
                              Icons.fire_truck,
                              size: 20,
                              color: Colors.red,
                            ),
                          ),
                        );
                      }),
                ),
              ),
              //TODO show default data here
              Visibility(
                visible: hospitalButtonD && defaultButton,
                child: Expanded(
                  child: StreamBuilder(
                    stream: FirebaseFirestore.instance
                        .collection('userData')
                        .doc('default_data')
                        .snapshots(),
                    builder: (BuildContext context,
                        AsyncSnapshot<dynamic> snapshot) {
                      if (!snapshot.hasData) {
                        return Center(
                          child: CircularProgressIndicator(
                            color: Theme.of(context).primaryColorLight,
                          ),
                        );
                      } else if (snapshot.hasError) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20.0),
                          child: Text(
                              "An error occurred, please check you internet connection",
                              textAlign: TextAlign.center,
                              style: textStyleText.copyWith(
                                  color: Theme.of(context).primaryColorLight)),
                        );
                      }
                      Map<String, dynamic> userData =
                          snapshot.data.data() as Map<String, dynamic>;
                      List<dynamic> dataList = userData['hospitals'];

                      // Sort the dataList by name
                      dataList.sort((a, b) {
                        // Replace 'name' with your actual field name
                        String nameA = a['name'];
                        String nameB = b['name'];
                        return nameA.compareTo(nameB);
                      });

                      return ListView.builder(
                        padding: const EdgeInsets.only(bottom: 180),
                        itemCount: dataList.length,
                        itemBuilder: (context, index) {
                          String iconData = dataList[index]['icon'];

                          return GestureDetector(
                            onTap: () {
                              Reuse.logger.e(dataList);
                            },
                            child: Container(
                              margin: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 1),
                              decoration: BoxDecoration(
                                border: Border.all(
                                  width: 1,
                                  color: Theme.of(context)
                                      .primaryColorLight
                                      .withOpacity(.2),
                                ),
                              ),
                              child: ListTile(
                                leading: iconData.isEmpty
                                    ? ClipRRect(
                                        borderRadius:
                                            BorderRadius.circular(100),
                                        child: Container(
                                          height: 60,
                                          width: 60,
                                          padding: const EdgeInsets.all(10),
                                          color: Theme.of(context)
                                              .primaryColorLight,
                                          child: Text(
                                            "H",
                                            style: textStyleText.copyWith(
                                                color: Colors.red,
                                                fontSize: 14),
                                          ),
                                        ),
                                      )
                                    : ClipRRect(
                                        borderRadius:
                                            BorderRadius.circular(100),
                                        child: Container(
                                          padding: const EdgeInsets.all(10),
                                          color: Theme.of(context)
                                              .primaryColorLight,
                                          child: Image.network(
                                            iconData,
                                            height: 20,
                                            width: 20,
                                          ),
                                        ),
                                      ),
                                title: Text(
                                  dataList[index]["name"],
                                  style: textStyleText.copyWith(
                                      fontSize: 14,
                                      color:
                                          Theme.of(context).primaryColorLight),
                                ),
                                subtitle: Text(
                                  dataList[index]["vicinity"],
                                  style: textStyleText.copyWith(
                                      fontSize: 12,
                                      color: Theme.of(context)
                                          .primaryColorLight
                                          .withOpacity(.8)),
                                ),
                                trailing: SizedBox(
                                  width: 25,
                                  child: _popUpMenuForListButtons(
                                      dataList[index]['name'],
                                      "${dataList[index]['geometry']['location']['lat']} ${dataList[index]['geometry']['location']['lng']}",
                                      "",
                                      "${dataList[index]['vicinity']}"),
                                ),
                              ),
                            ),
                          );
                        },
                      );
                    },
                  ),
                ),
              ),
              Visibility(
                visible: policeButtonD && defaultButton,
                child: Expanded(
                  child: StreamBuilder(
                    stream: FirebaseFirestore.instance
                        .collection('userData')
                        .doc('default_data')
                        .snapshots(),
                    builder: (BuildContext context,
                        AsyncSnapshot<dynamic> snapshot) {
                      if (!snapshot.hasData) {
                        return Center(
                          child: CircularProgressIndicator(
                            color: Theme.of(context).primaryColorLight,
                          ),
                        );
                      } else if (snapshot.hasError) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20.0),
                          child: Text(
                              "An error occurred, please check you internet connection",
                              textAlign: TextAlign.center,
                              style: textStyleText.copyWith(
                                  color: Theme.of(context).primaryColorLight)),
                        );
                      }
                      Map<String, dynamic> userData =
                          snapshot.data.data() as Map<String, dynamic>;
                      List<dynamic> dataList = userData['police'];

                      // Sort the dataList by name
                      dataList.sort((a, b) {
                        // Replace 'name' with your actual field name
                        String nameA = a['name'];
                        String nameB = b['name'];
                        return nameA.compareTo(nameB);
                      });

                      return ListView.builder(
                        padding: const EdgeInsets.only(bottom: 180),
                        itemCount: dataList.length,
                        itemBuilder: (context, index) {
                          String iconData = dataList[index]['icon'];

                          return GestureDetector(
                            onTap: () {
                              Reuse.logger.e(dataList);
                            },
                            child: Container(
                              margin: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 1),
                              decoration: BoxDecoration(
                                border: Border.all(
                                  width: 1,
                                  color: Theme.of(context)
                                      .primaryColorLight
                                      .withOpacity(.2),
                                ),
                              ),
                              child: ListTile(
                                leading: iconData.isEmpty
                                    ? ClipRRect(
                                        borderRadius:
                                            BorderRadius.circular(100),
                                        child: Container(
                                          height: 60,
                                          width: 60,
                                          padding: const EdgeInsets.all(10),
                                          color: Theme.of(context)
                                              .primaryColorLight,
                                          child: Text(
                                            "H",
                                            style: textStyleText.copyWith(
                                                color: Colors.red,
                                                fontSize: 14),
                                          ),
                                        ),
                                      )
                                    : ClipRRect(
                                        borderRadius:
                                            BorderRadius.circular(100),
                                        child: Container(
                                          padding: const EdgeInsets.all(10),
                                          color: Theme.of(context)
                                              .primaryColorLight,
                                          child: Image.network(
                                            iconData,
                                            height: 20,
                                            width: 20,
                                          ),
                                        ),
                                      ),
                                title: Text(
                                  dataList[index]["name"],
                                  style: textStyleText.copyWith(
                                      fontSize: 14,
                                      color:
                                          Theme.of(context).primaryColorLight),
                                ),
                                subtitle: Text(
                                  dataList[index]["vicinity"],
                                  style: textStyleText.copyWith(
                                      fontSize: 12,
                                      color: Theme.of(context)
                                          .primaryColorLight
                                          .withOpacity(.8)),
                                ),
                                trailing: SizedBox(
                                  width: 25,
                                  child: _popUpMenuForListButtons(
                                      dataList[index]['name'],
                                      "${dataList[index]['geometry']['location']['lat']} ${dataList[index]['geometry']['location']['lng']}",
                                      "",
                                      "${dataList[index]['vicinity']}"),
                                ),
                              ),
                            ),
                          );
                        },
                      );
                    },
                  ),
                ),
              ),
              Visibility(
                visible: fireFighterButtonD && defaultButton,
                child: Expanded(
                  child: StreamBuilder(
                    stream: FirebaseFirestore.instance
                        .collection('userData')
                        .doc('default_data')
                        .snapshots(),
                    builder: (BuildContext context,
                        AsyncSnapshot<dynamic> snapshot) {
                      if (!snapshot.hasData) {
                        return Center(
                          child: CircularProgressIndicator(
                            color: Theme.of(context).primaryColorLight,
                          ),
                        );
                      } else if (snapshot.hasError) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20.0),
                          child: Text(
                              "An error occurred, please check you internet connection",
                              textAlign: TextAlign.center,
                              style: textStyleText.copyWith(
                                  color: Theme.of(context).primaryColorLight)),
                        );
                      }
                      Map<String, dynamic> userData =
                          snapshot.data.data() as Map<String, dynamic>;
                      List<dynamic> dataList = userData['fire'];

                      // Sort the dataList by name
                      dataList.sort((a, b) {
                        // Replace 'name' with your actual field name
                        String nameA = a['name'];
                        String nameB = b['name'];
                        return nameA.compareTo(nameB);
                      });
                      return ListView.builder(
                        padding: const EdgeInsets.only(bottom: 180),
                        itemCount: dataList.length,
                        itemBuilder: (context, index) {
                          String iconData = dataList[index]['icon'];

                          return GestureDetector(
                            onTap: () {
                              Reuse.logger.e(dataList);
                            },
                            child: Container(
                              margin: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 1),
                              decoration: BoxDecoration(
                                border: Border.all(
                                  width: 1,
                                  color: Theme.of(context)
                                      .primaryColorLight
                                      .withOpacity(.2),
                                ),
                              ),
                              child: ListTile(
                                leading: iconData.isEmpty
                                    ? ClipRRect(
                                        borderRadius:
                                            BorderRadius.circular(100),
                                        child: Container(
                                          height: 60,
                                          width: 60,
                                          padding: const EdgeInsets.all(10),
                                          color: Theme.of(context)
                                              .primaryColorLight,
                                          child: Text(
                                            "H",
                                            style: textStyleText.copyWith(
                                                color: Colors.red,
                                                fontSize: 14),
                                          ),
                                        ),
                                      )
                                    : ClipRRect(
                                        borderRadius:
                                            BorderRadius.circular(100),
                                        child: Container(
                                          padding: const EdgeInsets.all(10),
                                          color: Theme.of(context)
                                              .primaryColorLight,
                                          child: Image.network(
                                            iconData,
                                            height: 20,
                                            width: 20,
                                          ),
                                        ),
                                      ),
                                title: Text(
                                  dataList[index]["name"],
                                  style: textStyleText.copyWith(
                                      fontSize: 14,
                                      color:
                                          Theme.of(context).primaryColorLight),
                                ),
                                subtitle: Text(
                                  dataList[index]["vicinity"],
                                  style: textStyleText.copyWith(
                                      fontSize: 12,
                                      color: Theme.of(context)
                                          .primaryColorLight
                                          .withOpacity(.8)),
                                ),
                                trailing: SizedBox(
                                  width: 25,
                                  child: _popUpMenuForListButtons(
                                      dataList[index]['name'],
                                      "${dataList[index]['geometry']['location']['lat']} "
                                          "${dataList[index]['geometry']['location']['lng']}",
                                      "",
                                      "${dataList[index]['vicinity']}"),
                                ),
                              ),
                            ),
                          );
                        },
                      );
                    },
                  ),
                ),
              ),
            ]),
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      persistentFooterAlignment: AlignmentDirectional.bottomEnd,
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Visibility(
            visible: !defaultButton,
            child: FloatingActionButton(
              backgroundColor: Theme.of(context).primaryColor.withOpacity(.2),
              heroTag: "button_2",
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.horizontal(
                  left: Radius.circular(30),
                  right: Radius.circular(30),
                ),
              ),
              // onPressed: _getCurrentLocation,
              onPressed: () {
                _getCurrentLocation();

                Reuse.logger.i(hospitals);
              },
              child: const Icon(
                Icons.location_on,
                color: Colors.green,
              ),
            ),
          ),
          Reuse.spaceBetween(),
          Reuse.spaceBetween(),
          Reuse.spaceBetween(),
          Reuse.spaceBetween(),
          Reuse.spaceBetween(),
        ],
      ),
    );
    //   ListView.builder(
    //       padding: const EdgeInsets.only(bottom: 160),
    //       // itemCount: hospitals.length,
    //       itemCount: 1,
    //       itemBuilder: (BuildContext context, int index) {
    //         // final hospital = hospitals[index];
    //         // final name = hospital['name'];
    //         // final address = hospital['vicinity'];
    //         // final lat = hospital['geometry']['location']['lat'];
    //         // final lng = hospital['geometry']['location']['lng'];
    //         return GestureDetector(
    //           onTap: () {
    //             // openGoogleMaps(lat, lng);
    //           },
    //           child: ListTile(
    //             leading: CircleAvatar(
    //               // backgroundColor: itemColors[index].withOpacity(.6),
    //               backgroundColor: Theme.of(context).primaryColor,
    //               child: Text(
    //                 "name[0].toString()" ?? "",
    //                 style: textStyleText.copyWith(
    //                     color: Theme.of(context).primaryColorLight),
    //               ),
    //             ),
    //             title: Text(
    //               "name",
    //               style: textStyleText.copyWith(
    //                   fontSize: 13,
    //                   color: Theme.of(context).primaryColorLight),
    //             ),
    //             subtitle: Text(
    //               "address",
    //               style: textStyleText.copyWith(
    //                   fontSize: 12,
    //                   color: Theme.of(context)
    //                       .primaryColorLight
    //                       .withOpacity(.8)),
    //             ),
    //             trailing: Icon(
    //               Icons.car_repair_rounded,
    //               size: 20,
    //               color: Colors.green,
    //             ),
    //           ),
    //         );
    //       }),
  }

  Widget paymentWidget() {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      color: Colors.white,
      child: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        children: [
          TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text("Pop")),
          Container(
            margin: const EdgeInsets.symmetric(vertical: 20),
            child: const CircularProgressIndicator(),
          ),
          const Text(
            'Amanda\'s Polo Shirt',
            style: TextStyle(
              fontSize: 20,
              color: Color(0xff333333),
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 5),
          const Text(
            '\$50.20',
            style: TextStyle(
              color: Color(0xff777777),
              fontSize: 15,
            ),
          ),
          const SizedBox(height: 15),
          const Text(
            'Description',
            style: TextStyle(
              fontSize: 15,
              color: Color(0xff333333),
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 5),
          const Text(
            'A versatile full-zip that you can wear all day long and even...',
            style: TextStyle(
              color: Color(0xff777777),
              fontSize: 15,
            ),
          ),
          // Example pay button configured using an asset
          FutureBuilder<PaymentConfiguration>(
              future: _googlePayConfigFuture,
              builder: (context, snapshot) => snapshot.hasData
                  ? GooglePayButton(
                      paymentConfiguration: snapshot.data!,
                      paymentItems: _paymentItems,
                      type: GooglePayButtonType.buy,
                      margin: const EdgeInsets.only(top: 15.0),
                      onPaymentResult: onGooglePayResult,
                      loadingIndicator: const Center(
                        child: CircularProgressIndicator(),
                      ),
                    )
                  : const SizedBox.shrink()),
          // Example pay button configured using a string
          // ApplePayButton(
          //   paymentConfiguration: PaymentConfiguration.fromJsonString(
          //       payment_configurations.defaultApplePay),
          //   paymentItems: _paymentItems,
          //   style: ApplePayButtonStyle.black,
          //   type: ApplePayButtonType.buy,
          //   margin: const EdgeInsets.only(top: 15.0),
          //   onPaymentResult: onApplePayResult,
          //   loadingIndicator: const Center(
          //     child: CircularProgressIndicator(),
          //   ),
          // ),
          const SizedBox(height: 15)
        ],
      ),
    );
  }

  Future showPayment() {
    return showCupertinoDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return CupertinoAlertDialog(
            title: const Text(
              textAlign: TextAlign.center,
              'This is a paid services',
              style: TextStyle(
                  color: Colors.red, fontSize: 20, fontWeight: FontWeight.w700),
            ),
            content: Text(
              "Get map services, nearby emergency departments and more for only R50 for a max of 6 Months usage.",
              textAlign: TextAlign.center,
              style: TextStyle(color: Theme.of(context).primaryColor),
            ),
            actions: <Widget>[
              CupertinoDialogAction(
                child: Text(
                  'Extra Services',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Theme.of(context).primaryColor,
                  ),
                ),
                // onPressed: paymentWidget,
                onPressed: () {
                  //Todo  //////////////////
                  // Navigator.of(context).pop();
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(
                      builder: (context) => const PaymentWidget(),
                    ),
                  );
                },
              ),
              CupertinoDialogAction(
                onPressed: () async {
                  setState(() {
                    if (defaultButton1 = false) {
                      defaultButton = true;
                    } else if (defaultButton = true) {
                      defaultButton1 = false;
                    }
                  });
                  Navigator.of(context).pop();
                },
                child: Text(
                  'Free services',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Theme.of(context).primaryColor,
                  ),
                ),
              ),
            ],
          );
        });
  }

  Future<void> addDataToDocument(List<dynamic> hospitalsData,
      List<dynamic> policeData, List<dynamic> fireData) async {
    // Reference to the Firestore document you want to update (replace 'users' and 'documentId' with your specific data)
    DocumentReference userDocument =
        _firestore.collection('userData').doc("default_data");
    // FirebaseAuth.instance.currentUser!.uid
    // Data to add (a map with the new field)
    Map<String, dynamic> newHospitalData = {
      'hospitals': hospitalsData,
    };
    Map<String, dynamic> newPoliceData = {
      'police': policeData,
    };
    Map<String, dynamic> newFireData = {
      'fire': fireData,
    };

    Reuse.logger.i("Added new data $newHospitalData");
    Reuse.logger.i("Added new data $newPoliceData");
    Reuse.logger.i("Added new data  $newFireData");

    // Update the document with the new data
    await userDocument.update(newHospitalData);
    await userDocument.update(newPoliceData);
    await userDocument.update(newFireData);

    throw 'Data added to the existing document in Firestore';
  }

  Widget _popUpMenuButtons() {
    return PopupMenuButton(
      color: Theme.of(context).primaryColorLight,
      itemBuilder: (BuildContext context) => <PopupMenuEntry>[
        PopupMenuItem(
          value: 0,
          child: TextButton(
            onPressed: () async {
              final navContext = Navigator.of(context);

              try {
                FirebaseAuth.instance.signOut();
                navContext.pop();
              } on FirebaseAuthException catch (e) {
                Reuse.callSnack(
                  context,
                  e.toString(),
                );
              } on Exception catch (e) {
                throw "Could not sign out: $e";
              }
            },
            child: Row(
              children: [
                ClipRRect(
                  borderRadius:
                      BorderRadius.circular(150), // Adjust the radius as needed

                  child: SizedBox(
                    height: 30,
                    width: 30,
                    child: SizedBox(
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.height / 3.8,
                        child: const Icon(
                          Icons.logout_outlined,
                          color: Colors.green,
                        )),
                  ),
                ),
                const SizedBox(
                  width: 10,
                ),
                const Text("Sign out"),
              ],
            ),
          ),
        ),
      ],
    );
  }

//  List Pop up
  Widget _popUpMenuForListButtons(String nameOfList, String addressOfList,
      String messageOfList, String addressName) {
    return PopupMenuButton(
      color: Theme.of(context).primaryColorLight,
      itemBuilder: (BuildContext context) => <PopupMenuEntry>[
        PopupMenuItem(
          value: 0,
          child: TextButton(
            onPressed: () async {
              final navContext = Navigator.of(context);
              try {
                Reuse.display(
                    context, nameOfList, addressOfList, messageOfList);
                navContext.pop();
              } on FirebaseAuthException catch (e) {
                Reuse.callSnack(
                  context,
                  e.toString(),
                );
              } on Exception catch (e) {
                throw "Could not share $e";
              }
            },
            child: Row(
              children: [
                ClipRRect(
                  borderRadius:
                      BorderRadius.circular(150), // Adjust the radius as needed

                  child: SizedBox(
                    height: 30,
                    width: 30,
                    child: SizedBox(
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.height / 3.8,
                        child: const Icon(
                          Icons.share,
                          color: Colors.blue,
                        )),
                  ),
                ),
                const SizedBox(
                  width: 10,
                ),
                const Text("Share name"),
              ],
            ),
          ),
        ),
        PopupMenuItem(
          value: 0,
          child: TextButton(
            onPressed: () async {
              final navContext = Navigator.of(context);
              try {
                Reuse.display(
                    context, nameOfList, addressOfList, messageOfList);
                navContext.pop();
              } on FirebaseAuthException catch (e) {
                Reuse.callSnack(
                  context,
                  e.toString(),
                );
              } on Exception catch (e) {
                throw "Could not share $e";
              }
            },
            child: Row(
              children: [
                ClipRRect(
                  borderRadius:
                      BorderRadius.circular(150), // Adjust the radius as needed

                  child: SizedBox(
                    height: 30,
                    width: 30,
                    child: SizedBox(
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.height / 3.8,
                        child: const Icon(
                          Icons.location_on,
                          color: Colors.green,
                        )),
                  ),
                ),
                const SizedBox(
                  width: 10,
                ),
                const Text("Share coordinates"),
              ],
            ),
          ),
        ),
        PopupMenuItem(
          value: 2,
          child: TextButton(
            onPressed: () async {
              final navContext = Navigator.of(context);
              try {
                Reuse.display(context, nameOfList, addressName, messageOfList);
                navContext.pop();
              } on FirebaseAuthException catch (e) {
                Reuse.callSnack(
                  context,
                  e.toString(),
                );
              } on Exception catch (e) {
                throw "Could not share $e";
              }
            },
            child: Row(
              children: [
                ClipRRect(
                  borderRadius:
                      BorderRadius.circular(150), // Adjust the radius as needed

                  child: SizedBox(
                    height: 30,
                    width: 30,
                    child: SizedBox(
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.height / 3.8,
                        child: const Icon(
                          Icons.location_on,
                          color: Colors.green,
                        )),
                  ),
                ),
                const SizedBox(
                  width: 10,
                ),
                const Text("Share Address name"),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

void openGoogleMaps(double latitude, double longitude) async {
  final url =
      'https://www.google.com/maps/search/?api=1&query=$latitude,$longitude';
  if (await canLaunch(url)) {
    await launch(url);
  } else {
    throw 'Could not launch $url';
  }
}
