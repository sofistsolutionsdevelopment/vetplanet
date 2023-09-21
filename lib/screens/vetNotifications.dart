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

class VetNotificationsPage extends StatefulWidget {

  @override
  _VetNotificationsPageState createState() => _VetNotificationsPageState();
}

class _VetNotificationsPageState extends State<VetNotificationsPage> {

  Future<List> _futureVETNotification;

  String _VETNotificationLenght = "";

  Future<List<NotificationModel>> getVETNotification() async {
    final _prefs = await SharedPreferences.getInstance();
    String _API_Path = _prefs.getString('API_Path');
    String _RegistrationId = _prefs.getInt('id').toString();
    debugPrint('Check getProfile _API_Path $_API_Path ');
    final String apiUrl = "$_API_Path/GetNotificationDoctorList/GetNotificationDoctorList";

    debugPrint('Check Inserted 1 ');

    var response = await http.post(
      Uri.parse(apiUrl),
      headers: {HttpHeaders.contentTypeHeader: 'application/json', HttpHeaders.authorizationHeader: 'bearer VA5kBnSw50cbuJ4YoAVkl4XyFTA312fRtKF4GxlmkUcl3PQJBKvvtogvT_0syd6ZtsZ4-1zFK6_liq5dQpyMq2tOA7vCtZ332qal7LGyBxBvv4mtD461lwGhNtprYd8PyIR40bBsoBc7nMElIniHJXAu1V04eO5c7sNLHOGypeG70Zn06yQr-0i_eFbsCRg6kMWjkao3RZwDfXVra5JQ5I7Pr1CbSgYez6rbYLMbH2LL6K8VcpmUvs45WpLe4UjPpChygW96LCoxVh7YtNa74n1Bje4sDdGLZowZJWwe7F9P7ijy1nVyw_v5K-8MqzlI' },
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

      List<NotificationModel> _VETNotification = _response
          .map<NotificationModel>(
              (_json) => NotificationModel.fromJson(_json))
          .toList();

      debugPrint('Check 5  ${_VETNotification}');
      setState(() {
        _VETNotificationLenght = _VETNotification.length.toString();
        debugPrint('Check _VETNotificationLenght &&&&&&&&&&&&&&&&&&&&&&&&&: $_VETNotificationLenght}');

      });
      return _VETNotification;

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

    _futureVETNotification = getVETNotification();
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
          Text("", style: TextStyle(fontSize:22, fontFamily: "Camphor",
              fontWeight: FontWeight.w900,color: Colors.white),),
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


            if(_VETNotificationLenght != "0")
              Expanded(
                child: FutureBuilder(
                  future: _futureVETNotification,
                  builder: (context, snapshot) {
                    if (snapshot.hasError) {
                      return Center(child: Text(''));
                    }
                    if (snapshot.hasData) {
                      List<NotificationModel> _VETNotification = snapshot.data;
                      return ListView.builder(
                        shrinkWrap: true,
                        itemCount: _VETNotification == null ? 0 : _VETNotification.length,
                        itemBuilder: (BuildContext context, int index) {
                          return  Padding(
                            padding: const EdgeInsets.all(8.0),
                            child:Column(
                              children: <Widget>[
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    children: <Widget>[
                                      Align(
                                        alignment:Alignment.topRight,
                                        child: Text(
                                          " ${_VETNotification[index].Date}",
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
                                                  text: '',
                                                  style: TextStyle(fontSize:14, fontFamily: "Camphor",
                                                      fontWeight: FontWeight.w500,color: appColor),
                                                  children: <TextSpan>[
                                                    new TextSpan(
                                                      text:
                                                      "${_VETNotification[index].MsgFrom}",
                                                      style: TextStyle(fontSize:14, fontFamily: "Camphor",
                                                          fontWeight: FontWeight.w700,color: appColor),),
                                                  ],
                                                ),
                                              ),
                                            ),
                                            SizedBox(width: 10),


                                          ],
                                        ),
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
                                                      " ${_VETNotification[index].Feedback}",
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
                                Divider(
                                  height: 1,
                                  thickness: 0.5,
                                  color: Colors.grey,
                                ),
                              ],
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
            if(_VETNotificationLenght == "0")
              Column(
                children: <Widget>[
                  SizedBox(height: 100,),
                  Center(
                    child: Text("No Notification Found", style: TextStyle(fontSize: 22, color: Colors.red,fontFamily: "Camphor",
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











