import 'dart:async';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vetplanet/constant/colors.dart';
import 'package:vetplanet/models/message.dart';
import 'package:vetplanet/screens/view_appointment_list.dart';
import 'package:vetplanet/transitions/slide_route.dart';

import 'dash.dart';
import 'login.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  Widget _defaultPage = LogInPage();

  Future<int> _checkIfLoggedIn() async {
    final _prefs = await SharedPreferences.getInstance();
    int _isLoggedIn = _prefs.getInt('id');

    print('(Future) Is Logged In value from shared prefernces is: ' + _isLoggedIn.toString());

    return _isLoggedIn;
  }


  void getTimer() async{

    int _isLoggedIn = await _checkIfLoggedIn();

    if (_isLoggedIn != null && _isLoggedIn > 0) {
      _defaultPage = DashPage();
    }

    Timer(
        Duration(seconds: 4),
            () =>
                Navigator.pushReplacement(context, SlideLeftRoute(page: _defaultPage)),

       // Navigator.of(context).pushReplacement(MaterialPageRoute(
          //      builder: (BuildContext context) =>_defaultPage)),


      //Navigator.pop(context),
    );
  }

  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
  String _message = '';
  final List<Message> messages = [];

  void getMessage() {
    _firebaseMessaging.configure(
      onMessage: (Map<String, dynamic> message) async {
        print("onMessage: $message");
        final notification = message['notification'];
        setState(() {
          messages.add(Message(
              title: notification['title'], body: notification['body']));
        });
      },
      onLaunch: (Map<String, dynamic> message) async {
        print("onLaunch: $message");

        final notification = message['data'];
        setState(() {
          messages.add(Message(
            title: '${notification['title']}',
            body: '${notification['body']}',
          ));
          print ("GETMEASSGAE onLaunch : 1");
          print ("GETMEASSGAE onLaunch : 2");
        });
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => ViewAppointmentPage()));
      },
      onResume: (Map<String, dynamic> message) async {
        print("onResume: $message");
      },
    );
    _firebaseMessaging.requestNotificationPermissions(
        const IosNotificationSettings(sound: true, badge: true, alert: true));
  }

  @override
  void initState() {
    super.initState();
    getTimer();
    getMessage();
  }

  @override
  Widget build(BuildContext context) {
    double width=MediaQuery.of(context).size.width;
    double height=MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: appColor,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              width: 230,
              height: 100,
              alignment: Alignment.center,
              child: Image.asset(
                "assets/splashLogo.png",
              ),
            ),
            SizedBox(height: 40),
            Image.asset('assets/doggy.gif', fit: BoxFit.fill,
              width: width,
              height: height*0.45,
              alignment: Alignment.center,),
            SizedBox(height: 40,),
            Text(
              'Welcome to',
              style: TextStyle(color: Colors.white,
                  fontFamily: "Camphor",
                  fontWeight: FontWeight.w700,
                  fontSize: 22.0),
            ),
            Text(
              'VetPlanet',
              style: TextStyle(color: Colors.white,
                  fontFamily: "Camphor",
                  fontWeight: FontWeight.w700,
                  fontSize: 22.0),
            ),
          ],
        ),
      ),
    );
  }
}