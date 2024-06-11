import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:imei_plugin/imei_plugin.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:vetplanet/constant/colors.dart';
import 'package:vetplanet/models/message.dart';
import 'package:vetplanet/models/result_model.dart';
import 'package:vetplanet/screens/gallery.dart';
import 'package:vetplanet/screens/resigtration.dart';
import 'package:vetplanet/screens/verifyOTP.dart';
import 'package:vetplanet/screens/view_appointment_list.dart';
import 'package:vetplanet/transitions/slide_route.dart';

import 'dash.dart';

class   LogInPage extends StatefulWidget {
  @override
  _LogInPageState createState() => _LogInPageState();
}

class _LogInPageState extends State<LogInPage> {
  final _globalKey = GlobalKey<ScaffoldMessengerState>();
  TextEditingController passwordController = TextEditingController();
  bool _isInAsyncCall = false;

  final GlobalKey<FormState> _formStateKey = GlobalKey<FormState>();
  String _contactNo;
  String _password;

  // FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
  String tokenValue = 'Hello World!';
  String _platformImei = 'Unknown';
  String uniqueId = "Unknown";

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

    

  _registerOnFirebase() {
    FirebaseMessaging.instance.subscribeToTopic('all');
    FirebaseMessaging.instance.getToken().then((token) {
      //=>    print(token)
      if (token != null) {
        update(token);
      }
    });
  }

  update(String token) {
    print(token);
    // DatabaseReference databaseReference = new FirebaseDatabase().reference();
    //databaseReference.child('fcm-token/${token}').set({"token": token});
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

  ResultModel _result;

  Future<ResultModel> validateUser(
      String contactNo, String token, String imeiNo,dynamic password) async {
    final _prefs = await SharedPreferences.getInstance();
    
    debugPrint('Check Inserted apiUrl $apiUrl ');

    final String url = "$apiUrl/Login/ValidateLogin";

    debugPrint('Check Inserted 1 ');

    var response = await http.post(
      Uri.parse(url),
      headers: {
        HttpHeaders.contentTypeHeader: 'application/json',
        HttpHeaders.authorizationHeader:
            bearerToken
      },
      body: json.encode({
        "ContactNo": contactNo,
        "Password": password,
        "Token": token,
        "ImeiNo": imeiNo
      }),
    );
    print(json.encode({
        "ContactNo": contactNo,
        "Password": password,
        "Token": token,
        "ImeiNo": imeiNo
      }));
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

  Future<String> generateOTP(String contactNo, String otp) async {
    final String url =
        "https://sms.bulkssms.com/submitsms.jsp?user=vetpln&key=1a0ce2bcedXX&mobile=$contactNo&message=OTP%20%3a$otp%0aVet Planet&senderid=ALRTSM&accusage=1";
    debugPrint('Check Inserted 1 ');

    final response = await http.get(Uri.parse(apiUrl));
    debugPrint('Check Inserted 2 ');

    if (response.statusCode == 200) {
      return "Success";
    } else {
      debugPrint('Check Inserted 5 ');
      return null;
    }
  }

  final _scaffoldKey = GlobalKey<ScaffoldState>();
  _SnackBar(BuildContext context) {
    final snackBar = SnackBar(
        content: Text(
      'Your Contact No is not Registered with us. Please Register yourself.',
      style: TextStyle(
        fontSize: 16,
        fontFamily: "Camphor",
        fontWeight: FontWeight.w500,
      ),
    ));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  _displaySnackBar(BuildContext context) {
    final snackBar = SnackBar(
        content: Text(
      'Your Account is Deactivated. Please E-Mail us on support@vetplanet.in',
      style: TextStyle(
        fontSize: 16,
        fontFamily: "Camphor",
        fontWeight: FontWeight.w500,
      ),
    ));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  Future<String> accountDeactivated() {
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
                      color: Colors.white),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            content: Text(
              'Your Account is Deactivated. Please E-Mail us on support@vetplanet.in',
              style: TextStyle(
                  fontFamily: "Camphor",
                  fontWeight: FontWeight.w500,
                  fontSize: 16,
                  color: Colors.black),
            ),
            actions: <Widget>[
              TextButton(
                  //  color: appColor,
                  child: Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: Text(
                      'Ok',
                      style: TextStyle(
                        color: appColor,
                        fontSize: 16,
                        fontFamily: "Camphor",
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                    // Navigator.pushReplacement(context, SlideLeftRoute(page: VetRegistration()));
                  }),
            ],
          );
        });
  }

  bool _showPassword = false;
  void _togglevisibility() {
    setState(() {
      _showPassword = !_showPassword;
    });
  }

  var rndnumber = "";

  void generateRandomNumber() {
    rndnumber = "";
    var rnd = new Random();
    for (var i = 0; i < 4; i++) {
      rndnumber = rndnumber + rnd.nextInt(9).toString();
    }
    print("rndnumber : ************** $rndnumber");
  }

  @override
  void initState() {
    _registerOnFirebase();
    initPlatformState();
    getMessage();
    super.initState();
  }

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
                      color: Colors.white),
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

  final TextEditingController _controllerMobileNo = new TextEditingController();
  final TextEditingController _controllerPassword = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    String pattern = r'(^(?:[+0]9)?[0-9]{10,12}$)';
    RegExp regExp = new RegExp(pattern);

    return WillPopScope(
      onWillPop: _onBackPressed,
      child: ScaffoldMessenger(
        key: _globalKey,
        child: Scaffold(
          key: _scaffoldKey,
          body: ModalProgressHUD(
            inAsyncCall: _isInAsyncCall,
            // demo of some additional parameters
            opacity: 0.5,
            progressIndicator: CircularProgressIndicator(),
            child: Center(
              child: Stack(
                children: <Widget>[
                  Container(
                    alignment: Alignment.center,
                    child: Container(
                      width: double.infinity,
                      height: double.infinity,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage("assets/login_bg.png"),
                          fit: BoxFit.fill,
                        ),
                      ),
                    ),
                  ),
                  Form(
                    key: _formStateKey,
                    child: Container(
                        alignment: Alignment.center,
                        child: Padding(
                          padding: const EdgeInsets.only(
                              right: 50, left: 50, top: 10),
                          child: Column(
                            mainAxisSize:
                                MainAxisSize.min, // Use children total size
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Align(
                                alignment: Alignment.center,
                                child: Text(
                                  "Log-In",
                                  style: TextStyle(
                                    //decoration: TextDecoration.underline,
                                    color: Colors.white,
                                    fontFamily: "Camphor",
                                    fontWeight: FontWeight.w900,
                                    fontSize: 28,
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 50,
                              ),
                              Padding(
                                padding: EdgeInsets.only(
                                    left: 10, right: 10, top: 0, bottom: 0),
                                child: TextFormField(
                                  onSaved: (value) {
                                    _contactNo = value;
                                  },
                                  controller: _controllerMobileNo,
                                  keyboardType: TextInputType.number,
                                  inputFormatters: <TextInputFormatter>[
                                    FilteringTextInputFormatter.allow(
                                        RegExp(r'[0-9]')),
                                  ],
                                  maxLength: 10,
                                  showCursor: true,
                                  decoration: InputDecoration(
                                    enabledBorder: OutlineInputBorder(
                                      borderSide:
                                          BorderSide(color: Colors.white),
                                      borderRadius: BorderRadius.circular(10.0),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide:
                                          BorderSide(color: Colors.white),
                                      borderRadius: BorderRadius.circular(10.0),
                                    ),
                                    counterText: "",
                                    contentPadding: new EdgeInsets.symmetric(
                                        vertical: 10.0, horizontal: 10.0),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10.0),
                                    ),
                                    /*border: OutlineInputBorder(
                                      borderRadius: BorderRadius.all(Radius.circular(10.0)),
                                      borderSide: BorderSide(
                                        width: 0,
                                        style: BorderStyle.none,
                                      ),
                                    ),*/
                                    //filled: true,
                                    prefixIcon: Padding(
                                      padding: const EdgeInsets.only(
                                          left: 10, right: 10),
                                      child: Image.asset(
                                        'assets/phone.png',
                                        width: 5,
                                        height: 5,
                                      ),
                                    ),
                                    hintStyle: TextStyle(
                                        fontFamily: "Camphor",
                                        fontWeight: FontWeight.w500,
                                        color: Colors.white,
                                        fontSize: 14),
                                    hintText: "Enter Your Mobile No",
                                  ),
                                  validator: (value) {
                                    /* if (value.isEmpty) {
                                      return 'Please Enter Mobile No';
                                    }*/
                                    if (value.length == 0 || value.isEmpty) {
                                      Navigator.of(context).pushReplacement(
                                          MaterialPageRoute(
                                              builder: (BuildContext context) =>
                                                  DashPage()));
                                      return "Mobile No can not be empty";
                                    } else if (!regExp.hasMatch(value)) {
                                      Navigator.of(context).pushReplacement(
                                          MaterialPageRoute(
                                              builder: (BuildContext context) =>
                                                  DashPage()));
                                      return 'Please Enter valid Mobile No';
                                    }
                                    return null;
                                  },
                                  style: TextStyle(
                                      fontFamily: "Camphor",
                                      fontWeight: FontWeight.w500,
                                      color: Colors.white,
                                      fontSize: 16),
                                ),
                              ),
                              SizedBox(
                                height: 30,
                              ),
                              Padding(
                                padding: EdgeInsets.only(
                                    left: 10, right: 10, top: 0, bottom: 0),
                                child: TextFormField(
                                  obscureText: true,
                                  controller: passwordController,
                                  showCursor: true,
                                  decoration: InputDecoration(
                                    enabledBorder: OutlineInputBorder(
                                      borderSide:
                                          BorderSide(color: Colors.white),
                                      borderRadius: BorderRadius.circular(10.0),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide:
                                          BorderSide(color: Colors.white),
                                      borderRadius: BorderRadius.circular(10.0),
                                    ),
                                    counterText: "",
                                    contentPadding: new EdgeInsets.symmetric(
                                        vertical: 10.0, horizontal: 10.0),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10.0),
                                    ),
                                    /*border: OutlineInputBorder(
                                      borderRadius: BorderRadius.all(Radius.circular(10.0)),
                                      borderSide: BorderSide(
                                        width: 0,
                                        style: BorderStyle.none,
                                      ),
                                    ),*/
                                    //filled: true,
                                    prefixIcon: Padding(
                                      padding: const EdgeInsets.only(
                                          left: 10, right: 10),
                                      child: Icon(Icons.lock)
                                    ),
                                    hintStyle: TextStyle(
                                        fontFamily: "Camphor",
                                        fontWeight: FontWeight.w500,
                                        color: Colors.white,
                                        fontSize: 14),
                                    hintText: "Enter Your Password",
                                  ),
                                  validator: (value) {  
                                    /* if (value.isEmpty) {
                                      return 'Please Enter Mobile No';
                                    }*/
                                    if (value.length == 0 || value.isEmpty) {
                                      return "Password can not be empty";
                                    }
                                    return null;
                                  },
                                  style: TextStyle(
                                      fontFamily: "Camphor",
                                      fontWeight: FontWeight.w500,
                                      color: Colors.white,
                                      fontSize: 16),
                                ),
                              ),
                              SizedBox(
                                height: 30,
                              ),
                              InkWell(
                                onTap: () async {
                                  if (_formStateKey.currentState.validate()) {
                                    _formStateKey.currentState.save();

                                    setState(() {
                                      _isInAsyncCall = true;
                                    });

                                    generateRandomNumber();

                                    final String contactNo = _contactNo;
                                    final String token = tokenValue;
                                    final String imeiNo = _platformImei;
                                    final String randomOTP =
                                        rndnumber.toString();

                                    debugPrint('contactNo : ${contactNo}');
                                    //debugPrint('password : ${password}');
                                    debugPrint('token : ${token}');
                                    debugPrint('imeiNo : ${imeiNo}');
                                    debugPrint('randomOTP : ${randomOTP}');
                                    _controllerMobileNo.clear();
                                    // _controllerPassword.clear();

                                    final ResultModel result =
                                        await validateUser(
                                            contactNo, token, imeiNo,passwordController.text);
                                    debugPrint(
                                        'Check Inserted result : $result');
                                    setState(() {
                                      _result = result;
                                    });

                                    if (_result.Result == "LoginSuccessfully") {
                                      //generateOTP(contactNo, randomOTP);

                                      SharedPreferences prefs =
                                          await SharedPreferences.getInstance();
                                      prefs.setInt('id', _result.Id);
                                      prefs.setString('contactNo', contactNo);
                                      prefs.setString('token', token);
                                      prefs.setString('imeiNo', imeiNo);

                                      debugPrint(
                                          'SharedPreferences id: ${_result.Id}');
                                      debugPrint(
                                          'SharedPreferences Result: ${_result.Result}');
                                      debugPrint(
                                          'SharedPreferences contactNo: ${contactNo}');
                                      debugPrint(
                                          'SharedPreferences token: ${token}');
                                      debugPrint(
                                          'SharedPreferences imeiNo: ${imeiNo}');

                                      _isInAsyncCall = false;
                                      Navigator.of(context).pushReplacement(
                                          MaterialPageRoute(
                                              builder: (BuildContext context) =>
                                                  DashPage()));
                                    } else if (_result.Result ==
                                        "InvalidateLogin") {
                                      setState(() {
                                        _isInAsyncCall = false;
                                      });

                                      debugPrint('***');
                                      _SnackBar(context);
                                    } else if (_result.Result ==
                                        "Your Account is Deactive") {
                                      setState(() {
                                        _isInAsyncCall = false;
                                      });

                                      debugPrint('***');
                                      accountDeactivated();
                                    }
                                  }
                                },
                                child: Container(
                                  height: 70,
                                  alignment: Alignment.center,
                                  child: Image.asset(
                                    "assets/login_btn.png",
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Align(
                                alignment: Alignment.center,
                                child: InkWell(
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        SlideLeftRoute(
                                            page: RegistrartionPage()));
                                  },
                                  child: FittedBox(
                                    fit: BoxFit.fitWidth,
                                    child: Text(
                                      "New User? Register Here",
                                      style: TextStyle(
                                        decoration: TextDecoration.underline,
                                        color: Colors.white,
                                        fontFamily: "Camphor",
                                        fontWeight: FontWeight.w500,
                                        fontSize: 16,
                                        fontStyle: FontStyle.normal,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 30,
                              ),
                            ],
                          ),
                        )),
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
