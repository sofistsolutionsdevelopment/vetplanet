import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vetplanet/constant/colors.dart';
import 'package:vetplanet/models/notification_model.dart';
import 'package:vetplanet/screens/dash.dart';
import 'dart:io';
import 'package:vetplanet/models/groomingShop_model.dart';
import 'package:vetplanet/screens/drawer.dart';
import 'dash.dart';

class GroomingNotificationsPage extends StatefulWidget {

  @override
  _GroomingNotificationsPageState createState() => _GroomingNotificationsPageState();
}

class _GroomingNotificationsPageState extends State<GroomingNotificationsPage> {

  Future<List> _futureGroomingNotification;

  String _GroomingNotificationLenght = "";

  Future<List<NotificationModel>> getGroomingNotification() async {
    final _prefs = await SharedPreferences.getInstance();
    
    String _RegistrationId = _prefs.getInt('id').toString();
    debugPrint('Check getProfile apiUrl $apiUrl ');
    final String url = "$apiUrl/GetNotificationGroomerList/GetNotificationGroomerList";

    debugPrint('Check Inserted 1 ');

    var response = await http.post(
      Uri.parse(url),
      headers: {HttpHeaders.contentTypeHeader: 'application/json', HttpHeaders.authorizationHeader: bearerToken },
      body: json.encode(
          {
            "PatientId":_RegistrationId,
          }
      ),
    );
    debugPrint('Check 2}');
    if (response != null && response.statusCode == 200) {
      debugPrint('Check 3}');
      var _response = json.decode(response.body);
      debugPrint('Check 4  ${_response}');

      List<NotificationModel> _GroomerNotification = _response
          .map<NotificationModel>(
              (_json) => NotificationModel.fromJson(_json))
          .toList();

      debugPrint('Check 5  ${_GroomerNotification}');
      setState(() {
        _GroomingNotificationLenght = _GroomerNotification.length.toString();
        debugPrint('Check _GroomingNotificationLenght &&&&&&&&&&&&&&&&&&&&&&&&&: $_GroomingNotificationLenght}');

      });
      return _GroomerNotification;

    } else {
      debugPrint('Check 6');
      return [];
    }
  }

  void rebuildPage() {
    setState(() {});
  }


  @override
  void initState() {
    super.initState();
    _futureGroomingNotification = getGroomingNotification();
  }





  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: (){
        //on Back button press, you can use WillPopScope for another purpose also.
        // Navigator.pop(context); //return data along with pop
        Navigator.of(context)
            .pushReplacement(new MaterialPageRoute(builder: (context) => DashPage(onPressed: rebuildPage)));
        return new Future(() => false); //onWillPop is Future<bool> so return false
      },
      child: Scaffold(
        appBar: AppBar(
          flexibleSpace: (Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(2)),
              gradient: LinearGradient(
                colors: [appColor, appColor],
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
              ),
            ),
          )),
          elevation: 0,
          iconTheme: IconThemeData(color: Colors.white),
          centerTitle: true,
          title:
          FittedBox(
            fit:BoxFit.fitWidth,
            child: Text("Grooming Notification", style: TextStyle(fontSize:22, fontFamily: "Camphor",
                fontWeight: FontWeight.w900,color: Colors.white),),
          ),
          actions: <Widget>[

            new IconButton(
              icon: new Icon(Icons.home, color: Colors.white,),
              tooltip: 'Home',
              onPressed: () {
                Navigator.push(
                    context, MaterialPageRoute(builder: (context) => DashPage(onPressed: rebuildPage)));
              },
            ),
          ],
        ),

        drawer: DrawerPage(),

        body:Column(
          children: <Widget>[


            if(_GroomingNotificationLenght != "0")
              Expanded(
                child: FutureBuilder(
                  future: _futureGroomingNotification,
                  builder: (context, snapshot) {
                    if (snapshot.hasError) {
                      return Center(child: Text(''));
                    }
                    if (snapshot.hasData) {
                      List<NotificationModel> _groomingNotification = snapshot.data;
                      return ListView.builder(
                        shrinkWrap: true,
                        itemCount: _groomingNotification == null ? 0 : _groomingNotification.length,
                        itemBuilder: (BuildContext context, int index) {
                          return  Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Card(
                              elevation: 4,
                              shape: RoundedRectangleBorder(
                                side:
                                BorderSide(color: Colors.white, width: 1),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              margin: new EdgeInsets.symmetric(horizontal: 10.0),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  children: <Widget>[
                                    Align(
                                      alignment:Alignment.topRight,
                                      child: Text(
                                        " ${_groomingNotification[index].Date}",
                                        style: TextStyle(fontSize:16, fontFamily: "Camphor",
                                            fontWeight: FontWeight.w700,color: Colors.black),textAlign: TextAlign.right,),
                                    ),

                                    Padding(
                                      padding: const EdgeInsets.all(5.0),
                                      child: Row(
                                        children: <Widget>[

                                          Expanded(
                                            child: RichText(
                                              //    maxLines: 10,
                                              text: new TextSpan(
                                                text: 'Message : ',
                                                style: TextStyle(fontSize:14, fontFamily: "Camphor",
                                                    fontWeight: FontWeight.w500,color: Colors.black),
                                                children: <TextSpan>[
                                                  new TextSpan(
                                                    text:
                                                    " ${_groomingNotification[index].Feedback}",
                                                    style: TextStyle(fontSize:12, fontFamily: "Camphor",
                                                        fontWeight: FontWeight.w700,color: Colors.black),),
                                                ],
                                              ),
                                            ),
                                          ),
                                          SizedBox(width: 10),


                                        ],
                                      ),
                                    ),

                                  ],
                                ),
                              ),
                            ),
                          );

                        },
                      );
                    }
                    return Center(child: SpinKitRotatingCircle(
                      color: appColor,
                      size: 50.0,
                    ));
                  },
                ),
              ),
            if(_GroomingNotificationLenght == "0")
              Column(
                children: <Widget>[
                  SizedBox(height: 100,),
                  Center(
                    child: Text("No Grooming Notification Found", style: TextStyle(fontSize: 22, color: Colors.red,fontFamily: "Camphor",
                      fontWeight: FontWeight.w900,),textAlign: TextAlign.center,),
                  ),
                ],
              ),

          ],
        ),
      ),
    );
  }

 }











