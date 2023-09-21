import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:email_validator/email_validator.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:imei_plugin/imei_plugin.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vetplanet/constant/colors.dart';
import 'package:vetplanet/models/result_model.dart';
import 'package:vetplanet/screens/verifyOTP.dart';
import 'package:vetplanet/screens/verifyOTPAfterReg.dart';
import 'package:vetplanet/transitions/slide_route.dart';
import 'login.dart';


class RegistrartionPage extends StatefulWidget {
  @override
  _RegistrartionPageState createState() => _RegistrartionPageState();
}


class _RegistrartionPageState extends State<RegistrartionPage> {

  bool _isInAsyncCall = false;
  final _globalKey = GlobalKey<ScaffoldMessengerState>();

  final GlobalKey<FormState> _formStateKey = GlobalKey<FormState>();
  String _name;
  String _contactNo;
  String _emailId;
  String _password;
  bool _authorization = false;


  bool _showPassword = false;
  void _togglevisibility() {
    setState(() {
      _showPassword = !_showPassword;
    });
  }

  ResultModel _result;

  Future<ResultModel> createUser(String name, String contactNo, String emailId, String password, String currentAddress, String token, String imeiNo) async{
    final String apiUrl = "http://sofistsolutions.in/VetPlanetAPPAPI/API/ClientRegistration/ClientRegistration";

    debugPrint('Check Inserted 1 ');

    var response = await http.post(
      Uri.parse(apiUrl),
      headers: {HttpHeaders.contentTypeHeader: 'application/json', HttpHeaders.authorizationHeader: 'bearer VA5kBnSw50cbuJ4YoAVkl4XyFTA312fRtKF4GxlmkUcl3PQJBKvvtogvT_0syd6ZtsZ4-1zFK6_liq5dQpyMq2tOA7vCtZ332qal7LGyBxBvv4mtD461lwGhNtprYd8PyIR40bBsoBc7nMElIniHJXAu1V04eO5c7sNLHOGypeG70Zn06yQr-0i_eFbsCRg6kMWjkao3RZwDfXVra5JQ5I7Pr1CbSgYez6rbYLMbH2LL6K8VcpmUvs45WpLe4UjPpChygW96LCoxVh7YtNa74n1Bje4sDdGLZowZJWwe7F9P7ijy1nVyw_v5K-8MqzlI' },
      body: json.encode(
          {
            "UserName":name,
            "ContactNo":contactNo,
            "Password":password,
            "ADDRESS":currentAddress,
            "AlternateContactNo":"",
            "Email":emailId,
            "DOB":"",
            "UserType":"Vet Planet User",
            "Token":token,
            "ImeiNo":imeiNo
          }
      ),
    );

    debugPrint('Check Inserted 2 ');
    debugPrint('Check Inserted statusCode ${response.statusCode} ');
    if(response.statusCode == 200){

      debugPrint('Check Inserted 3 : ${response.body}');

      final String responseString = response.body;

      debugPrint('Check Inserted 4  ${responseString}');

      return resultModelFromJson(responseString);


    }else{
      debugPrint('Check Inserted 5 ');
      return null;
    }
  }

  Future<String> generateOTP( String contactNo, String otp) async{
    final String apiUrl = "https://sms.bulkssms.com/submitsms.jsp?user=vetpln&key=1a0ce2bcedXX&mobile=$contactNo&message=OTP%20%3a$otp%0aVet Planet&senderid=ALRTSM&accusage=1";
    debugPrint('Check Inserted 1 ');

    final response = await http.get(Uri.parse(apiUrl));
    debugPrint('Check Inserted 2 ');

    if(response.statusCode == 200){
      return "Success";
    }
    else{
      debugPrint('Check Inserted 5 ');
      return null;
    }
  }


  final _scaffoldKey = GlobalKey<ScaffoldState>();
  _displaySnackBar(BuildContext context) {
    final snackBar = SnackBar(content:Text('User Already Exists', style: TextStyle(fontSize: 20),));
    _globalKey.currentState.showSnackBar(snackBar);
  }


  Future<String> approved(String randomOTP, String contactNo) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title:Container(
              color: appColor,
              child: Padding(
                padding: const EdgeInsets.only(left:1, right:1, top:12, bottom:12),
                child: Text('Vet Planet',style: TextStyle(fontFamily: "Camphor",
                    fontWeight: FontWeight.w900,fontSize: 18, color: Colors.white),textAlign:TextAlign.center ,),
              ),
            ),
            content: Text('Registered Sucessfully!',style:TextStyle(fontFamily: "Camphor",
                fontWeight: FontWeight.w500, fontSize: 16,color: Colors.black),),
            actions: <Widget>[
              TextButton(
                //  color: appColor,
                  child: Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: Text('Ok',style: TextStyle(color: appColor,fontSize: 16,  fontFamily: "Camphor",
                      fontWeight: FontWeight.w900,),),
                  ),
                  onPressed: () {

                    Navigator.push(context, SlideLeftRoute(page: VerifyOTPAfterRegPage(randomOTP:randomOTP, contactNo:contactNo)));

                    // Navigator.pushReplacement(context, SlideLeftRoute(page: VetRegistration()));
                  }
              ),
            ],
          );
        });
  }

 // final Geolocator geolocator = Geolocator()..forceAndroidLocationManager;
  Position _currentPosition;
  String _currentAddress = "null";
  String _latitude="";
  String _longitude="";
  double lat_d;
  double long_d;
  String _address ;


  _getCurrentLocation() {
    Geolocator
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.best)
        .then((Position position) {
      setState(() {
        _currentPosition = position;
      });
      if (_currentPosition != null){
        _latitude = _currentPosition.latitude.toString();   //19.1924479
        _longitude = _currentPosition.longitude.toString();  //72.8457848
        lat_d = double.parse(_latitude);
        long_d = double.parse(_longitude);
        print('_latitude *****************************************************************************: $_latitude');
        print('_longitude ***************************************************************************** : $_longitude');
        print('lat_d *****************************************************************************: $lat_d');
        print('long_d *****************************************************************************: $long_d');
      }
   //    _getAddressFromLatLng();
    }).catchError((e) {
      print(e);
    });
  }

  // _getAddressFromLatLng() async {
  //   try {
  //     List<Placemark> p = await geolocator.placemarkFromCoordinates(
  //         _currentPosition.latitude, _currentPosition.longitude);

  //     Placemark place = p[0];

  //     setState(() {
  //       _currentAddress = "${place.name},${place.subThoroughfare},${place.subAdministrativeArea},${place.subLocality},${place.thoroughfare},${place.locality},${place.administrativeArea}, ${place.postalCode}, ${place.country}";
  //       //"${place.locality}, ${place.postalCode}, ${place.country}";
  //     });
  //   } catch (e) {
  //     print(e);
  //   }
  // }


  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
  String tokenValue = 'Hello World!';
  String _platformImei = 'Unknown';
  String uniqueId = "Unknown";

  _registerOnFirebase() {
    _firebaseMessaging.subscribeToTopic('all');
    _firebaseMessaging.getToken().then((token)
    {
      //=>    print(token)
      if (token != null){
        update(token);
      }
    }
    );
  }

  update(String token) {
    print(token);
    tokenValue = token;
    setState(() {});
  }

  Future<void> initPlatformState() async {
    String platformImei;
    String idunique;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      platformImei =
      await ImeiPlugin.getImei(shouldShowRequestPermissionRationale: false);
      List<String> multiImei = await ImeiPlugin.getImeiMulti();
      print(multiImei);
      idunique = await ImeiPlugin.getId();
    } on PlatformException {
      platformImei = 'Failed to get platform version.';
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      _platformImei = platformImei;
      uniqueId = idunique;
    });
  }


  final TextEditingController _controllerName = new TextEditingController();
  final TextEditingController _controllerMobileNo = new TextEditingController();
  final TextEditingController _controllerPassword = new TextEditingController();
  final TextEditingController _controllerEmailId = new TextEditingController();

  var rndnumber="";

  void  generateRandomNumber() {
    rndnumber = "";
    var rnd= new Random();
    for (var i = 0; i < 4; i++) {
      rndnumber = rndnumber + rnd.nextInt(9).toString();
    }
    print("rndnumber : ************** $rndnumber");
  }


  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
    _registerOnFirebase();
    initPlatformState();
  }
///card_reg
  @override
  Widget build(BuildContext context) {
    String pattern = r'(^(?:[+0]9)?[0-9]{10,12}$)';
    RegExp regExp = new RegExp(pattern);
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: appColor,
      body:  ModalProgressHUD(
        inAsyncCall: _isInAsyncCall,
        // demo of some additional parameters
        opacity: 0.5,
        progressIndicator: CircularProgressIndicator(),
        child:
        Center(
          child: Stack(
            children: <Widget>[
              Container(
                alignment: Alignment.center,
                child:  Container(
                  width: double.infinity,
                  height: double.infinity,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage("assets/vet.png"),
                      fit: BoxFit.fill,
                    ),
                  ),
                ),
              ),
              Form(
                key: _formStateKey,
                child: Container(
                    width: double.infinity,
                    height: double.infinity,
                    alignment: Alignment.center,
                    child: SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.only(right:50, left: 50,top: 100),
                        child: Column(
                          mainAxisSize: MainAxisSize.min, // Use children total size
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Container(
                              margin: EdgeInsets.symmetric(vertical: 1),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  FittedBox(
                                    fit:BoxFit.fitWidth,
                                    child: Text(
                                      "Full Name",
                                      style: TextStyle(fontFamily: "Camphor",
                                          fontWeight: FontWeight.w900, fontSize: 16,color: Colors.black),
                                    ),
                                  ),

                                  TextFormField(
                                    onSaved: (value) {
                                      _name = value;
                                    },
                                    controller: _controllerName,
                                    keyboardType: TextInputType.text,

                                    showCursor: true,
                                    decoration: InputDecoration(
                                      enabledBorder: UnderlineInputBorder(
                                        borderSide: BorderSide(color: Colors.black),
                                      ),
                                      focusedBorder: UnderlineInputBorder(
                                        borderSide: BorderSide(color: Colors.black),
                                      ),
                                    ),
                                    validator: (value) {
                                      if (value.isEmpty) {
                                        return 'Name is Mandatory.';
                                      }
                                      return null;
                                    },
                                    style: TextStyle(fontFamily: "Camphor",
                                        fontWeight: FontWeight.w500,
                                        color: Colors.black,
                                        fontSize: 16),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: 15,),
                            Container(
                              margin: EdgeInsets.symmetric(vertical: 1),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  FittedBox(
                                    fit:BoxFit.fitWidth,
                                    child: Text(
                                      "Mobile No",
                                      style: TextStyle(fontFamily: "Camphor",
                                          fontWeight: FontWeight.w900, fontSize: 16,color: Colors.black),
                                    ),
                                  ),

                                  TextFormField(
                                    controller: _controllerMobileNo,
                                    onSaved: (value) {
                                      _contactNo = value;
                                    },
                                    keyboardType: TextInputType.number,
                                    inputFormatters: <TextInputFormatter>[
                                    FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                                    ],
                                    maxLength: 10,
                                    showCursor: true,
                                    decoration: InputDecoration(
                                      enabledBorder: UnderlineInputBorder(
                                        borderSide: BorderSide(color: Colors.black),
                                      ),
                                      focusedBorder: UnderlineInputBorder(
                                        borderSide: BorderSide(color: Colors.black),
                                      ),
                                      counterText: "",
                                    ),
                                    validator: (value) {
                                      if (value.length == 0 || value.isEmpty) {
                                        return "Mobile No is Mandatory.";
                                      }
                                      else if (!regExp.hasMatch(value)) {
                                        return 'Please Enter valid Mobile No';
                                      }
                                      return null;
                                    },
                                    style: TextStyle(fontFamily: "Camphor",
                                        fontWeight: FontWeight.w500,
                                        color: Colors.black,
                                        fontSize: 16),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: 15,),
                            Container(
                              margin: EdgeInsets.symmetric(vertical: 1),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  FittedBox(
                                    fit:BoxFit.fitWidth,
                                    child: Text(
                                      "E-Mail Id",
                                      style: TextStyle(fontFamily: "Camphor",
                                          fontWeight: FontWeight.w900, fontSize: 15,color: Colors.black),
                                    ),
                                  ),

                                  TextFormField(
                                    onSaved: (value) {
                                      _emailId = value;
                                    },
                                     controller: _controllerEmailId,
                                    decoration: InputDecoration(
                                      enabledBorder: UnderlineInputBorder(
                                        borderSide: BorderSide(color: Colors.black),
                                      ),
                                      focusedBorder: UnderlineInputBorder(
                                        borderSide: BorderSide(color: Colors.black),
                                      ),
                                    ),
                                    keyboardType: TextInputType.emailAddress,
                                    showCursor: true,
                                    style: TextStyle(fontFamily: "Camphor",
                                        fontWeight: FontWeight.w500,
                                        color: Colors.black,
                                        fontSize: 16),
                                    validator: (value) {
                                      if (value.isEmpty) {
                                        return 'E-Mail is Mandatory.';
                                      }
                                      if(!EmailValidator.validate(value)){
                                        return 'Invalid E-Mail Id';
                                      }
                                      return null;
                                    },
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                              height: 15,
                            ),
                            Align(
                              alignment: Alignment.center,
                              child:
                              InkWell(
                                onTap: () async {
                                  if (_formStateKey.currentState.validate()) {
                                    _formStateKey.currentState.save();

                                      setState(() {
                                        _isInAsyncCall = true;
                                      });

                                    generateRandomNumber();

                                    final String OTP = "-";
                                    final String name = _name;
                                    final String contactNo = _contactNo;
                                    final String emailId = _emailId;
                                    final String password = "-";
                                    final String latitude = _latitude;
                                    final String longitude = _longitude;
                                    final String currentAddress = _currentAddress;
                                    final String token = tokenValue;
                                    final String imeiNo = _platformImei;
                                    final String randomOTP = rndnumber.toString();

                                    debugPrint('name : ${name}' );
                                    debugPrint('contactNo : ${contactNo}' );
                                    debugPrint('emailId : ${emailId}' );
                                    debugPrint('password : ${password}' );
                                    debugPrint('latitude : ${latitude}' );
                                    debugPrint('longitude : ${longitude}' );
                                    debugPrint('currentAddress : ${currentAddress}' );
                                    debugPrint('token : ${token}' );
                                    debugPrint('imeiNo : ${imeiNo}' );
                                    debugPrint('randomOTP : ${randomOTP}');

                                    _controllerName.clear();
                                    _controllerMobileNo.clear();
                                    _controllerPassword.clear();
                                    _controllerEmailId.clear();
                                    // Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => VetRegistration()));
                                    // Navigator.push(context, SlideLeftRoute(page: VetRegistration()));

                                    final ResultModel result = await createUser(name, contactNo, emailId, password, currentAddress, token, imeiNo);
                                    debugPrint('Check Inserted result : $result');
                                    setState(() {
                                      _result = result;
                                    });

                                    if (_result.Result == "ADDED" ) {

                                      generateOTP(contactNo, randomOTP);

                                      SharedPreferences prefs = await SharedPreferences.getInstance();
                                      String API_Path = "http://sofistsolutions.in/VetPlanetAPPAPI/API";
                                      prefs.setString('API_Path', API_Path);
                                      prefs.setInt('id', _result.Id);
                                      prefs.setString('contactNo', contactNo);
                                      prefs.setString('token', token);
                                      prefs.setString('imeiNo', imeiNo);

                                      debugPrint('SharedPreferences id: ${_result.Id}' );
                                      debugPrint('SharedPreferences contactNo: ${contactNo}' );
                                      debugPrint('SharedPreferences token: ${token}' );
                                      debugPrint('SharedPreferences imeiNo: ${imeiNo}' );
                                      _isInAsyncCall = false;
                                      approved(randomOTP,contactNo);

                                      // Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => LogInPage()));
                                      //  Navigator.pop(context);

                                    }
                                    else
                                    {
                                      setState(() {
                                        _isInAsyncCall = false;
                                      });

                                      debugPrint('**');
                                      _displaySnackBar(context);
                                    }

                                  }
                                },
                                child: Container(
                                  height: 80,
                                  alignment: Alignment.center,
                                  child: Image.asset(
                                    "assets/verify_r_btn.png",
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    )),
              ),
            ],
          ),
        ),
      ),

    );
  }
}



