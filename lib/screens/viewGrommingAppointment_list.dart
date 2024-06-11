import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:vetplanet/constant/colors.dart';
import 'package:vetplanet/models/result_model.dart';
import 'package:vetplanet/models/viewGroomingAppointment_model.dart';
import 'package:vetplanet/models/view_appointment_model.dart';
import 'dash.dart';
import 'drawer.dart';

class ViewGroomingAppointmentPage extends StatefulWidget {

  @override
  _ViewGroomingAppointmentPageState createState() => _ViewGroomingAppointmentPageState();
}

class _ViewGroomingAppointmentPageState extends State<ViewGroomingAppointmentPage> {



  ResultModel _cancelAppointmentresult;

  Future<ResultModel> cancelAppointment(String SlotId ) async{
    final _prefs = await SharedPreferences.getInstance();
    
    String _RegistrationId = _prefs.getInt('id').toString();

    debugPrint('Check Inserted apiUrl $apiUrl');
    debugPrint('Check Inserted _RegistrationId $_RegistrationId');

    final String url =  "$apiUrl/CancelShopAppointment/CancelShopAppointment";

    debugPrint('Check Inserted 1 ');

    var response = await http.post(
      Uri.parse(url),
      headers: {HttpHeaders.contentTypeHeader: 'application/json', HttpHeaders.authorizationHeader: bearerToken },
      body: json.encode(
          {
            "PatientId":_RegistrationId,
            "SlotId":SlotId
          }

      ),
    );

    debugPrint('Check Inserted 2 ');

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






  ViewGroomingAppointmentResultModel _viewappointmentresult;
  List data;

  String _dataLenght = "";

  Future<ViewGroomingAppointmentResultModel> getData() async{
    final _prefs = await SharedPreferences.getInstance();
    
    String _RegistrationId = _prefs.getInt('id').toString();

    debugPrint('Check Inserted apiUrl $apiUrl');
    debugPrint('Check Inserted _RegistrationId $_RegistrationId');

    final String url =  "$apiUrl/ViewAppointmentForShop/ViewAppointmentForShop";

    var response = await http.post(
      Uri.parse(url),
      headers: {HttpHeaders.contentTypeHeader: 'application/json', HttpHeaders.authorizationHeader: bearerToken },
      body: json.encode(
          {
            "PatientId":_RegistrationId
          }
      ),
    );
    debugPrint('Check Inserted 2 ');
    debugPrint('Check Inserted 4  ${response.statusCode}');
    if(response.statusCode == 200){

      debugPrint('Check Inserted 3 : ${response.body}');

      final String responseString = response.body;

      debugPrint('Check Inserted 4  ${responseString}');

      this.setState(() {
        data = json.decode(response.body);
        _dataLenght = data.length.toString();
        debugPrint('Check _VETNotificationLenght &&&&&&&&&&&&&&&&&&&&&&&&&: $_dataLenght}');
      });

      return viewGroomingAppointmentResultModelFromJson(responseString);
    }else{
      debugPrint('Check Inserted 5 ');
      return null;
    }
  }





  var list;
  var random;

  var refreshKey = GlobalKey<RefreshIndicatorState>();


  Future<Null> refreshList() async {
    refreshKey.currentState?.show(atTop: false);
    await Future.delayed(Duration(seconds: 2));

    setState(() {
      this.getData();
    });

    return null;
  }


  @override
  void initState(){
    this.getData();

  }

  void rebuildPage() {
    setState(() {});
  }

  final _scaffoldKey = GlobalKey<ScaffoldState>();


  Future<String> delete(String SlotId) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Container(
              color: appColor,
              child: Padding(
                padding: const EdgeInsets.only(left:1, right:1, top:12, bottom:12),
                child: Text('Vet Planet',style: TextStyle(fontFamily: "Camphor",
                    fontWeight: FontWeight.w900,fontSize: 18, color: Colors.white),textAlign:TextAlign.center ,),
              ),
            ),
            content: Text('Do you want to Cancel the Appointment?',style: TextStyle(fontFamily: "Camphor",
                fontWeight: FontWeight.w500,fontSize: 16),),
            actions: <Widget>[
              TextButton(
                  //color: Colors.red,
                  child: Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: Text('Yes',style: TextStyle(color:appColor,fontSize: 16,  fontFamily: "Camphor",
                      fontWeight: FontWeight.w900,),),
                  ),
                  onPressed: () async{
                    final ResultModel cancelAppointmentresult = await cancelAppointment(SlotId );
                    debugPrint('Check Inserted result : $cancelAppointmentresult');
                    setState(() {
                      _cancelAppointmentresult = cancelAppointmentresult;

                      debugPrint('Cancel Appointment Successfully');

                      random = Random();
                      refreshList();

                    });


                    if(_cancelAppointmentresult.Result == "Deleted"){
                      // Navigator.push(context, MaterialPageRoute(builder: (context) => DashPage()));
                      this.getData();
                      Navigator.pop(context);
                    }
                    else {
                      Navigator.pop(context);
                    }
                  }

              ),
              TextButton(
               // color: Colors.green,
                child: Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: Text('No',style: TextStyle(color: appColor,fontSize: 16, fontFamily: "Camphor",
                    fontWeight: FontWeight.w900,),),
                ),
                onPressed: () {
                  getData();
                  Navigator.pop(context);
                },
              ),

            ],
          );
        });
  }

  @override
  Widget build(BuildContext context){
    return WillPopScope(
      onWillPop: (){
        //on Back button press, you can use WillPopScope for another purpose also.
        // Navigator.pop(context); //return data along with pop
        Navigator.of(context)
            .pushReplacement(new MaterialPageRoute(builder: (context) => DashPage(onPressed: rebuildPage)));
        return new Future(() => false); //onWillPop is Future<bool> so return false
      },
      child: new Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          backgroundColor: appColorlight,
          flexibleSpace: (Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(2)),
              color: appColorlight
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
        body:

        Column(
          children: <Widget>[


            if(_dataLenght != "0")
              Expanded(
                child: ListView.builder(
                  itemCount: data == null ? 0 : data.length,
                  itemBuilder: (BuildContext context, int index) {
                    return  Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: <Widget>[

                          Padding(
                            padding: const EdgeInsets.only(top:10.0),
                            child: Card(
                              elevation: 4,
                              shape: RoundedRectangleBorder(
                                //side: BorderSide(
                                //   color: Color(0xFFf7418c), width: 1),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              margin: new EdgeInsets.symmetric(
                                  horizontal: 10.0),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  children: <Widget>[
                                    Padding(
                                      padding: const EdgeInsets.all(5.0),
                                      child: Row(
                                        children: <Widget>[
                                          Expanded(
                                            child: RichText(
                                              text: new TextSpan(
                                                text: 'Name :   ',
                                                style: TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 12),
                                                children: <TextSpan>[
                                                  new TextSpan(
                                                    text:
                                                    " ${data[index]["GroomingCenterName"]}",
                                                    style: new TextStyle(
                                                      fontWeight:
                                                      FontWeight.bold,
                                                      color: Colors.black,
                                                      fontSize: 12,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(5.0),
                                      child: Row(
                                        children: <Widget>[
                                          Expanded(
                                            child: RichText(
                                              text: new TextSpan(
                                                text: 'Date   :    ',
                                                style: TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 12),
                                                children: <TextSpan>[
                                                  new TextSpan(
                                                      text:
                                                      "${data[index]["SlotDate"]}",
                                                      style: new TextStyle(
                                                          fontWeight:
                                                          FontWeight.bold,
                                                          color: Colors.black,
                                                          fontSize: 12)),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(5.0),
                                      child: Row(
                                        children: <Widget>[
                                          Expanded(
                                            child: RichText(
                                              text: new TextSpan(
                                                text: 'Time   :   ',
                                                style: TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 12),
                                                children: <TextSpan>[
                                                  new TextSpan(
                                                      text:
                                                      "${data[index]["SlotTime"]}  ",
                                                      style: new TextStyle(
                                                          fontWeight:
                                                          FontWeight.bold,
                                                          color: Colors.black,
                                                          fontSize: 12)),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(5.0),
                                      child: Row(
                                        children: <Widget>[
                                          Expanded(
                                            child: RichText(
                                              text: new TextSpan(
                                                text: 'Status :   ',
                                                style: TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 12),
                                                children: <TextSpan>[
                                                  new TextSpan(
                                                    text:
                                                    "${data[index]["Status"]}",
                                                    style: new TextStyle(
                                                      fontWeight:
                                                      FontWeight.bold,
                                                      color: Colors.black,
                                                      fontSize: 12,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    if("${data[index]["Status"]}" == "Pending")
                                      Align(
                                        alignment: Alignment.centerRight,
                                        child: IconButton(
                                          icon: new Icon(Icons.delete,color: Colors.red,),
                                          tooltip: 'Delete',
                                          onPressed: () async {
                                            final String SlotId =  ("${data[index]["SlotId"]}").toString();
                                            debugPrint('Check Inserted SlotId : $SlotId');

                                            delete(SlotId);

                                            //Navigator.push(context, MaterialPageRoute(builder: (context) => MyApp()));
                                            ///  _displayDialog(context);
                                          },
                                        ),
                                      ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            if(_dataLenght == "0")
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                SizedBox(height: 25,),
                Center(
                  child: Text("No Appointment for Grommers",textAlign: TextAlign.center, style: TextStyle(fontSize: 19, color: Colors.black,fontFamily: "Camphor",
                    fontWeight: FontWeight.w700,),),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

