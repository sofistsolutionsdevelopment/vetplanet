import 'dart:convert';
import 'dart:io';
import 'dart:ui';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vetplanet/constant/colors.dart';
import 'package:vetplanet/models/clientProfile_model.dart';
import 'package:vetplanet/models/message.dart';
import 'package:vetplanet/models/notification_model.dart';
import 'package:vetplanet/models/pet_model.dart';
import 'package:vetplanet/models/result_model.dart';
import 'package:vetplanet/screens/groomingNotifications.dart';
import 'package:vetplanet/screens/petRegistration.dart';
import 'package:vetplanet/screens/productlist.dart';
import 'package:vetplanet/screens/shop.dart';
import 'package:vetplanet/screens/vetNotifications.dart';
import 'package:vetplanet/screens/veterinaryList.dart';
import 'package:vetplanet/screens/view_appointment_list.dart';
import 'package:vetplanet/transitions/slide_route.dart';
import 'drawer.dart';
import 'groomingList.dart';
import 'hostelList.dart';
import 'login.dart';

class DashPage extends StatefulWidget {
  final Function onPressed;

  DashPage({this.onPressed});
  @override
  _DashPageState createState() => _DashPageState();
}

class _DashPageState extends State<DashPage> {
  Future<bool> _onBackPressed() {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Container(
              color: appColor,
              child: Padding(
                padding: const EdgeInsets.only(
                    left: 1, right: 1, top: 12, bottom: 12),
                child: Text(
                  'Vet Planet',
                  style: TextStyle(
                      fontFamily: "Camphor",
                      fontWeight: FontWeight.w900,
                      fontSize: 18,
                      color: Colors.black),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            content: FittedBox(
              fit: BoxFit.fitWidth,
              child: Text(
                'You are going to exit the application!!',
                style: TextStyle(
                    fontFamily: "Camphor",
                    fontWeight: FontWeight.w500,
                    fontSize: 16),
              ),
            ),
            actions: <Widget>[
              TextButton(
                // color: Colors.red,
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(Colors.red),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: Text(
                    'Yes',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontFamily: "Camphor",
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ),
                onPressed: () => exit(0),
              ),
              TextButton(
                //  color: Colors.green,
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(Colors.green),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: Text(
                    'No',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontFamily: "Camphor",
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ),
                onPressed: () {
                  Navigator.of(context).pop(false);
                },
              ),
            ],
          );
        });
  }

  // final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
  String _message = '';
  final List<Message> messages = [];

  void getMessage() {
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print('A new onMessageOpenedApp event was published!');
      final notification = message.notification;
        setState(() {
          messages.add(Message(
              title: notification.title, body: notification.body));
        });
    });
  }

  Future<List> _future;

  String _petLenght = "";

  Future<List<PetModel>> getPet() async {
    final _prefs = await SharedPreferences.getInstance();
    
    String _RegistrationId = _prefs.getInt('id').toString();
    debugPrint('Check Inserted apiUrl $apiUrl ');
    debugPrint('Check Inserted _RegistrationId $_RegistrationId ');

    final String url =
        "http://sofistsolutions.in/VetPlanetAPPAPI/API/GetPetList/GetPetList";

    debugPrint('Check Inserted 1 ');
    var response = await http.post(
      Uri.parse(url),
      headers: {
        HttpHeaders.contentTypeHeader: 'application/json',
        HttpHeaders.authorizationHeader:
            bearerToken
      },
      body: json.encode({"PatientId": _RegistrationId}),
    );

    /* final response = await http.post(apiUrl,body: {
      "CREATEDBY": _RegistrationId
    }
    );*/
    debugPrint('Check 2}');
    if (response != null && response.statusCode == 200) {
      debugPrint('Check 3}');
      var _response = json.decode(response.body);
      debugPrint('Check 4  ${_response}');

      List<PetModel> _pet =
          _response.map<PetModel>((_json) => PetModel.fromJson(_json)).toList();

      debugPrint('Check 5  ${_pet}');
      setState(() {
        _petLenght = _pet.length.toString();
        debugPrint('Check _petLenght &&&&&&&&&&&&&&&&&&&&&&&&&: $_petLenght}');
      });
      return _pet;
    } else {
      debugPrint('Check 6');
      return [];
    }
  }

  ClientProfileModel _resultClientProfile;

  Future<ClientProfileModel> getClientProfile() async {
    final _prefs = await SharedPreferences.getInstance();
    
    String _RegistrationId = _prefs.getInt('id').toString();
    debugPrint('Check getProfile apiUrl $apiUrl ');
    final String url =
        "$apiUrl/GetClientDetailsById/GetClientDetailsById";

    debugPrint('Check Inserted 1 ');

    var response = await http.post(
      Uri.parse(url),
      headers: {
        HttpHeaders.contentTypeHeader: 'application/json',
        HttpHeaders.authorizationHeader:
            bearerToken
      },
      body: json.encode({"PatientId": _RegistrationId}),
    );
    debugPrint('Check Inserted 2 ');

    if (response.statusCode == 200) {
      debugPrint('Check Inserted 3 : ${response.body}');

      final String responseString = response.body;

      debugPrint('Check Inserted 4  ${responseString}');

      return clientProfileModelFromJson(responseString);
    } else {
      debugPrint('Check Inserted 5 ');
      return null;
    }
  }

  String PetOwnerName = "Vet Planet";

  void appBarClientName() async {
    final ClientProfileModel resultName = await getClientProfile();
    SharedPreferences prefs = await SharedPreferences.getInstance();

    setState(() {
      _resultClientProfile = resultName;
      if (_resultClientProfile != null) {
        PetOwnerName = _resultClientProfile.UserName;

        prefs.setString('PetOwnerName', PetOwnerName);

        print("PetOwnerName *******************$PetOwnerName");
      }
      //   isSwitched = true;
    });
  }

  Future<NotificationModel> _VETNotifyCountresult;

  Future<NotificationModel> getVETNotifyCount() async {
    final _prefs = await SharedPreferences.getInstance();
    
    debugPrint('Check Inserted apiUrl $apiUrl ');
    String _RegistrationId = _prefs.getInt('id').toString();

    final String url =
        "$apiUrl/GetNotificationDoctorCount/GetNotificationDoctorCount";
    debugPrint('Check getData 1 ');
    debugPrint('Check _RegistrationId ****************$_RegistrationId ');
    var response = await http.post(
      Uri.parse(url),
      headers: {
        HttpHeaders.contentTypeHeader: 'application/json',
        HttpHeaders.authorizationHeader:
            bearerToken
      },
      body: json.encode({"PatientId": _RegistrationId}),
    );

    if (response.statusCode == 200) {
      final String responseString = response.body;

      return notificationModelFromJson(responseString);
    } else {
      return null;
    }
  }

  Future<NotificationModel> _GroomingNotifyCountresult;

  Future<NotificationModel> getGroomingNotifyCount() async {
    final _prefs = await SharedPreferences.getInstance();
    
    debugPrint('Check Inserted apiUrl $apiUrl ');
    String _RegistrationId = _prefs.getInt('id').toString();

    final String url =
        "$apiUrl/GetNotificationGroomerCount/GetNotificationGroomerCount";
    debugPrint('Check getData 1 ');
    debugPrint('Check _RegistrationId ****************$_RegistrationId ');
    var response = await http.post(
      Uri.parse(url),
      headers: {
        HttpHeaders.contentTypeHeader: 'application/json',
        HttpHeaders.authorizationHeader:
            bearerToken
      },
      body: json.encode({"PatientId": _RegistrationId}),
    );

    if (response.statusCode == 200) {
      final String responseString = response.body;

      return notificationModelFromJson(responseString);
    } else {
      return null;
    }
  }

  ResultModel _resultActiveUser;

  Future<ResultModel> getActiveUsere() async {
    final _prefs = await SharedPreferences.getInstance();
    
    String _contactNo = _prefs.getString('contactNo');
    debugPrint('Check getActiveUsere apiUrl $apiUrl ');
    debugPrint('Check getActiveUsere _contactNo $_contactNo ');

    final String url = "$apiUrl/CheckPatientActive/CheckPatientActive";

    debugPrint('Check Inserted 1 ');

    var response = await http.post(
      Uri.parse(url),
      headers: {
        HttpHeaders.contentTypeHeader: 'application/json',
        HttpHeaders.authorizationHeader:
            bearerToken
      },
      body: json.encode({"ContactNo": _contactNo}),
    );
    debugPrint('Check Inserted 2 ');

    if (response.statusCode == 200) {
      debugPrint('Check Inserted 3 : ${response.body}');

      final String responseString = response.body;

      debugPrint('Check Inserted 4  ${responseString}');

      return resultModelFromJson(responseString);
    } else {
      debugPrint('Check Inserted 5 ');
      return null;
    }
  }

  void loadActiveUser() async {
    final ResultModel resultActiveUser = await getActiveUsere();
    final _prefs = await SharedPreferences.getInstance();

    setState(() {
      _resultActiveUser = resultActiveUser;
      if (_resultActiveUser != null) {
        if (_resultActiveUser.Result == "A") {
          appBarClientName();
          _future = getPet();
          _VETNotifyCountresult = getVETNotifyCount();
          _GroomingNotifyCountresult = getGroomingNotifyCount();
          getMessage();
        }
        if (_resultActiveUser.Result == "D") {
          _prefs.clear();
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => LogInPage()));
        }
      }
      //   isSwitched = true;
    });
  }

  getLocationPermission()async{
    bool serviceEnabled;
    var status = await Permission.location.status;
    serviceEnabled = await Geolocator.isLocationServiceEnabled();

    if (!serviceEnabled) {
    return Future.error('Location services are disabled.');
  }

    if(status.isDenied){
      Permission.location.request();
    }
    

  }

  @override
  void initState() {
    loadActiveUser();
    getLocationPermission();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return WillPopScope(
      onWillPop: _onBackPressed,
      child: Scaffold(
        backgroundColor: appColor,
        appBar: PreferredSize(
          preferredSize: Size(double.infinity, 300),
          child: AppBar(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(0),
                  bottomRight: Radius.circular(0)),
            ),
            backgroundColor: appColor,
            flexibleSpace: Center(
              child: Stack(
                children: <Widget>[
                  Container(
                    alignment: Alignment.center,
                    child: Container(
                      width: width,
                      height: height * 0.60,
                      child: Image.asset(
                        'assets/doggy_bg.png',
                        fit: BoxFit.fill,
                      ),
                    ),
                  ),
                  Container(
                      alignment: Alignment.centerLeft,
                      child: Padding(
                        padding: const EdgeInsets.only(right: 8, left: 20),
                        child: Column(
                          mainAxisSize:
                              MainAxisSize.min, // Use children total size
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            SizedBox(
                              height: 70,
                            ),

                            Text(
                              '$PetOwnerName',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontFamily: "Camphor",
                                  fontWeight: FontWeight.w900,
                                  fontSize: 22.0),
                            ),
                            //  if(_petLenght == "")
                            FutureBuilder(
                              future: _future,
                              builder: (context, snapshot) {
                                if (snapshot.hasError) {
                                  return Center(child: Text(''));
                                }
                                if (snapshot.hasData) {
                                  List<PetModel> _pet = snapshot.data;
                                  return ListView.builder(
                                    shrinkWrap: true,
                                    itemCount: _pet == null ? 0 : _pet.length,
                                    itemBuilder:
                                        (BuildContext context, int index) {
                                      return Column(
                                        children: <Widget>[
                                          Row(
                                            children: <Widget>[
                                              ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(20),
                                                child: Image.network(
                                                  "${_pet[index].Photograph}",
                                                  width: 20,
                                                  height: 20,
                                                  fit: BoxFit.fill,
                                                ),
                                              ),
                                              SizedBox(
                                                width: 10,
                                              ),
                                              Text(
                                                "${_pet[index].PetName}",
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 16,
                                                  fontFamily: "Camphor",
                                                  fontWeight: FontWeight.w900,
                                                ),
                                              ),
                                            ],
                                          ),
                                          SizedBox(
                                            height: 8,
                                          ),
                                        ],
                                      );
                                    },
                                  );
                                }
                                return Center(
                                    child: SpinKitRotatingCircle(
                                  color: Colors.white,
                                  size: 50.0,
                                ));
                              },
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            InkWell(
                              onTap: () {
                                Navigator.pushReplacement(context,
                                    SlideLeftRoute(page: PetRegistration()));
                              },
                              child: Row(
                                children: <Widget>[
                                  Icon(Icons.add_circle_outline,
                                      color: Colors.white),
                                  Text(
                                    '  Add Pet',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                      fontFamily: "Camphor",
                                      fontWeight: FontWeight.w900,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                              height: 20,
                            ),
                          ],
                        ),
                      )),
                ],
              ),
            ),
            actions: <Widget>[
              Padding(
                padding: const EdgeInsets.only(right: 10.0),
                child: Align(
                  alignment: Alignment.topRight,
                  child: FutureBuilder<NotificationModel>(
                    future: _VETNotifyCountresult,
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        return Container(
                          child: new InkWell(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          VetNotificationsPage()));
                            },
                            child: Container(
                              child: Stack(
                                alignment: Alignment.center,
                                children: [
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      Icon(
                                        Icons.notifications,
                                        size: 35,
                                        color: Colors.white,
                                      ),
                                    ],
                                  ),
                                  Positioned(
                                    top: 3,
                                    right: 2,
                                    child: Container(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 6, vertical: 2),
                                      decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: Colors.green),
                                      alignment: Alignment.center,
                                      child: Text(
                                        snapshot.data.NotificationCount
                                            .toString(),
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 12.0,
                                            fontFamily: "WorkSansBold"),
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                        );
                      } else if (snapshot.hasError) {
                        return Align(
                            alignment: Alignment.center, child: Text(""));
                      }

                      return Center(
                          child: SpinKitRotatingCircle(
                        color: Colors.white,
                        size: 50.0,
                      ));
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
        drawer: DrawerPage(),
        body: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/dashbg.png"),
              fit: BoxFit.cover,
            ),
          ),
          child: Column(
            children: <Widget>[
              Expanded(
                child: ListView(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(right: 10, left: 10),
                      child: InkWell(
                        onTap: () {
                          Navigator.push(context,
                              SlideLeftRoute(page: VeterinaryListPage()));
                        },
                        child: Container(
                          child: Image.asset(
                            "assets/veterinary.png",
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right: 10, left: 10),
                      child: InkWell(
                        onTap: () {
                          Navigator.push(context,
                              SlideLeftRoute(page: GroomingListPage()));
                        },
                        child: Container(
                          child: Image.asset(
                            "assets/petGrooming.png",
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right: 10, left: 10),
                      child: InkWell(
                        onTap: () {
                          Navigator.push(
                              context, SlideLeftRoute(page: HostelListPage()));
                        },
                        child: Container(
                          child: Image.asset(
                            "assets/petHostel.png",
                          ),
                        ),
                      ),
                    ),
                    // Padding(
                    //   padding: const EdgeInsets.only(right: 10, left: 10),
                    //   child: InkWell(
                    //     onTap: () {
                    //       Navigator.push(
                    //           context,
                    //           SlideLeftRoute(
                    //             page: ProductList(),
                    //           ));

                    //       // Navigator.push(
                    //       //     context, SlideLeftRoute(page: ShopPage()));
                    //     },
                    //     child: Container(
                    //       child: Image.asset(
                    //         "assets/petShop.png",
                    //       ),
                    //     ),
                    //   ),
                    // ),
                  ],
                ),
              ),
              SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }
}
