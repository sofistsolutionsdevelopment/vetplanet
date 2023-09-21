
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vetplanet/constant/colors.dart';
import 'package:vetplanet/models/pet_model.dart';
import 'package:vetplanet/screens/clientProfile.dart';
import 'package:vetplanet/screens/patientHistory.dart';
import 'package:vetplanet/screens/paymentReportList.dart';
import 'package:vetplanet/screens/recentlyVisitedGroomers.dart';
import 'package:vetplanet/screens/recentlyVisitedHostel.dart';
import 'package:vetplanet/screens/recentlyVisitedVET.dart';
import 'package:vetplanet/screens/selectPetForHistory.dart';
import 'package:vetplanet/screens/selectPetForModify.dart';
import 'package:vetplanet/screens/selectPetForNextVaccDate.dart';
import 'package:vetplanet/screens/vetNotifications.dart';
import 'package:vetplanet/screens/viewGrommingAppointment_list.dart';
import 'package:vetplanet/screens/viewHostelBooking_list.dart';
import 'package:vetplanet/screens/view_appointment_list.dart';
import 'dash.dart';
import 'dateSelectionForHistory.dart';
import 'gallery.dart';
import 'groomingNotifications.dart';
import 'historyData.dart';
import 'login.dart';
import 'nextVaccinationList.dart';

class DrawerPage extends StatefulWidget {
  @override
  _DrawerPageState createState() => _DrawerPageState();
}

class _DrawerPageState extends State<DrawerPage> {
  final _globalKey = GlobalKey<ScaffoldMessengerState>();


  Future<bool> _logOut() {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title:  Container(
              color: appColor,
              child: Padding(
                padding: const EdgeInsets.only(left:1, right:1, top:12, bottom:12),
                child: Text('Vet Planet',style: TextStyle(fontFamily: "Camphor",
                    fontWeight: FontWeight.w900,fontSize: 18, color: Colors.white),textAlign:TextAlign.center ,),
              ),
            ),

            content:Text('You really want to Logout ?',style: TextStyle(fontFamily: "Camphor",
                fontWeight: FontWeight.w500,fontSize: 16),),
            actions: <Widget>[
              TextButton(
                // color: Colors.red,
                child: Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: Text('Logout',style: TextStyle(color: appColor,fontSize: 16,  fontFamily: "Camphor",
                    fontWeight: FontWeight.w900,),),
                ),
                onPressed: () async{
                  final _prefs = await SharedPreferences.getInstance();
                  _prefs.clear();
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => LogInPage()));
                },
                // onPressed: ()=> exit(0),

              ),
              TextButton(
                //color: Colors.green,
                child: Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: Text('Cancel',style: TextStyle(color: appColor,fontSize: 16, fontFamily: "Camphor",
                    fontWeight: FontWeight.w900,),),
                ),
                onPressed: () {
                  Navigator.of(context).pop(false);
                },
              ),

            ],
          );
        });
  }

  Future<List> _future;
  String _onePet = "";
  String _petLenght = "";

  Future<List<PetModel>> getPet() async {
    final _prefs = await SharedPreferences.getInstance();
    String _API_Path = _prefs.getString('API_Path');
    String _RegistrationId = _prefs.getInt('id').toString();
    debugPrint('Check Inserted _API_Path $_API_Path ');
    debugPrint('Check Inserted _RegistrationId $_RegistrationId ');


    final String apiUrl = "$_API_Path/GetPetList/GetPetList";

    debugPrint('Check Inserted 1 ');
    var response = await http.post(
      Uri.parse(apiUrl),
      headers: {HttpHeaders.contentTypeHeader: 'application/json', HttpHeaders.authorizationHeader: 'bearer VA5kBnSw50cbuJ4YoAVkl4XyFTA312fRtKF4GxlmkUcl3PQJBKvvtogvT_0syd6ZtsZ4-1zFK6_liq5dQpyMq2tOA7vCtZ332qal7LGyBxBvv4mtD461lwGhNtprYd8PyIR40bBsoBc7nMElIniHJXAu1V04eO5c7sNLHOGypeG70Zn06yQr-0i_eFbsCRg6kMWjkao3RZwDfXVra5JQ5I7Pr1CbSgYez6rbYLMbH2LL6K8VcpmUvs45WpLe4UjPpChygW96LCoxVh7YtNa74n1Bje4sDdGLZowZJWwe7F9P7ijy1nVyw_v5K-8MqzlI' },
      body: json.encode(
          {
            "PatientId": _RegistrationId
          }
      ),
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


      List<PetModel> _pet = _response
          .map<PetModel>(
              (_json) => PetModel.fromJson(_json))
          .toList();


      debugPrint('Check 5  ${_pet}');
      setState(() {
        _petLenght = _pet.length.toString();
        debugPrint('Check _petLenght &&&&&&&&&&&&&&&&&&&&&&&&&: $_petLenght}');

        if(_petLenght == "1"){
          _onePet = "${_pet[0].PatientPetId.toString()}";
          debugPrint('_onePet   : $_onePet');
        }

      });
      return _pet;

    } else {
      debugPrint('Check 6');
      return [];
    }
  }


  @override
  void initState() {
    _future = getPet();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: new ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
              decoration: BoxDecoration(
                  gradient: LinearGradient(colors: <Color>[
                    appColor,
                    appColor
                  ])
              ),
              child: Container(
                child: FittedBox(
                  fit: BoxFit.fitHeight,
                  child: Column(
                    children: <Widget>[
                      Material(
                        borderRadius: BorderRadius.all(Radius.circular(50.0)),
                        elevation: 10,
                        child: Padding(padding: EdgeInsets.all(8.0),
                          child: Image.asset("assets/logo.png", height: 90, width: 90),
                        ),
                      ),

                    ],
                  ),
                ),
              )),
          new  Column(
            children: <Widget>[


              ListTile(
                dense: true,
                contentPadding: EdgeInsets.fromLTRB(20, -20, 0, -20),
                onTap: () {
                  //  Navigator.of(context).pop();
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (BuildContext context) => DashPage()));
                },
                leading: Image.asset(
                  "assets/home.png",width: 20,height: 20,
                ),
                //Icon(Icons.home,color: appColor),
                title: Text('Home',style: TextStyle(fontFamily: "Camphor",
                    fontWeight: FontWeight.w900,fontSize: 15),),
              ),

              ListTile(
                dense: true,
                contentPadding: EdgeInsets.fromLTRB(20, -20, 0, -20),
                onTap: () {
                  //  Navigator.of(context).pop();
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (BuildContext context) => ViewAppointmentPage()));
                },
                leading: Image.asset(
                  "assets/vetApp.png",width: 20,height: 20,
                ),
                //Icon(Icons.assignment,color: appColor),
                title: Text('Vet Appointments',style: TextStyle(fontFamily: "Camphor",
                    fontWeight: FontWeight.w900,fontSize: 15),),
              ),

              ListTile(
                dense: true,
                contentPadding: EdgeInsets.fromLTRB(20, -20, 0, -20),
                onTap: () {
                  //  Navigator.of(context).pop();
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (BuildContext context) => ViewGroomingAppointmentPage()));
                },
                leading: Image.asset(
                  "assets/groomingApp.png",width: 20,height: 20,
                ),
                title: Text('Grooming Appointments',style: TextStyle(fontFamily: "Camphor",
                    fontWeight: FontWeight.w900,fontSize: 15),),
              ),

              ListTile(
                dense: true,
                contentPadding: EdgeInsets.fromLTRB(20, -20, 0, -20),
                onTap: () {
                  //  Navigator.of(context).pop();
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (BuildContext context) => ViewHostelBookingPage()));
                },
                leading: Image.asset(
                  "assets/hostelBooking.png",width: 20,height: 20,
                ),
                title: Text('Hostel Booking',style: TextStyle(fontFamily: "Camphor",
                    fontWeight: FontWeight.w900,fontSize: 15),),
              ),

              ListTile(
                dense: true,
                contentPadding: EdgeInsets.fromLTRB(20, -20, 0, -20),
                onTap: () {
                  //  Navigator.of(context).pop();
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (BuildContext context) => RecentlyVisitedVETPage()));
                },
                leading: Image.asset(
                  "assets/visited.png",width: 20,height: 20,
                ),
                title: Text('Recently Visited Vet',style: TextStyle(fontFamily: "Camphor",
                    fontWeight: FontWeight.w900,fontSize: 15),),
              ),

              ListTile(
                dense: true,
                contentPadding: EdgeInsets.fromLTRB(20, -20, 0, -20),
                onTap: () {
                  //  Navigator.of(context).pop();
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (BuildContext context) => RecentlyVisitedGroomersPage()));
                },
                leading: Image.asset(
                  "assets/visited.png",width: 20,height: 20,
                ),
                title: Text('Recently Visited Groomers',style: TextStyle(fontFamily: "Camphor",
                    fontWeight: FontWeight.w900,fontSize: 15),),
              ),

              ListTile(
                dense: true,
                contentPadding: EdgeInsets.fromLTRB(20, -20, 0, -20),
                onTap: () {
                  //  Navigator.of(context).pop();
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (BuildContext context) => RecentlyVisitedHostelPage()));
                },
                leading: Image.asset(
                  "assets/visited.png",width: 20,height: 20,
                ),
                title: Text('Recently Visited Hostel',style: TextStyle(fontFamily: "Camphor",
                    fontWeight: FontWeight.w900,fontSize: 15),),
              ),

              ListTile(
                dense: true,
                contentPadding: EdgeInsets.fromLTRB(20, -20, 0, -20),
                onTap: () {
                  //  Navigator.of(context).pop();
                  if(_petLenght != "0" && _petLenght != "1"){
                    String vetId = "0";
                    String from = "drawer";
                    print("_petLenght != 1 vetId : $vetId");
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (BuildContext context) => SelectPetForNextVaccDatePage(vetId:vetId, from:from)));
                  }
                  if(_petLenght == "1"){

                    String petId = _onePet;
                    String vetId = "0";

                    print("_petLenght == 1 petId : $petId");
                    print("_petLenght == 1 vetId : $vetId");
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (BuildContext context) => NextVaccinationDatePage(petId:petId, vetId:vetId)));
                  }
                },
                leading: Image.asset(
                  "assets/vaccination.png",width: 20,height: 20,
                ),
                title: Text('Next Vaccination Date',style: TextStyle(fontFamily: "Camphor",
                    fontWeight: FontWeight.w900,fontSize: 15),),
              ),

              ListTile(
                dense: true,
                contentPadding: EdgeInsets.fromLTRB(20, -20, 0, -20),
                onTap: () {
                  //  Navigator.of(context).pop();
                  if(_petLenght != "0" && _petLenght != "1"){
                    String vetId = "0";
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (BuildContext context) => SelectPetForHistoryPage(vetId:vetId)));
                  }
                  if(_petLenght == "1"){
                    String vetId = "0";
                    String petId = _onePet;

                    print("vetId :  $vetId");
                    print("petID :  $petId");

                    print("_petLenght == 1 petId : $petId");
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (BuildContext context) => DateSelectionForHistoryPage(petId:petId, vetId:vetId)));
                  }
                },
                leading:  Image.asset(
                  "assets/medicalReport.png",width: 20,height: 20,
                ),
                title: Text('Medical Reports',style: TextStyle(fontFamily: "Camphor",
                    fontWeight: FontWeight.w900,fontSize: 15),),
              ),

              ListTile(
                dense: true,
                contentPadding: EdgeInsets.fromLTRB(20, -20, 0, -20),
                onTap: () {
                  //  Navigator.of(context).pop();
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (BuildContext context) => MyProfilePage()));
                },
                leading:  Image.asset(
                  "assets/myProfile.png",width: 20,height: 20,
                ),
                title: Text('My Profile',style: TextStyle(fontFamily: "Camphor",
                    fontWeight: FontWeight.w900,fontSize: 15),),
              ),

              ListTile(
                dense: true,
                contentPadding: EdgeInsets.fromLTRB(20, -20, 0, -20),
                onTap: () {
                  //  Navigator.of(context).pop();
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (BuildContext context) => SelectPetForModifyPage()));
                },
                leading:  Image.asset(
                  "assets/petProfile.png",width: 20,height: 20,
                ),
                title: Text('Pet Profile',style: TextStyle(fontFamily: "Camphor",
                    fontWeight: FontWeight.w900,fontSize: 15),),
              ),

              ListTile(
                dense: true,
                contentPadding: EdgeInsets.fromLTRB(20, -20, 0, -20),
                onTap: () {
                  //  Navigator.of(context).pop();
                  Navigator.of(context).push(MaterialPageRoute(
                     builder: (BuildContext context) => PaymentReportListPage()));
                },
                leading: Image.asset(
                  "assets/payment.png",width: 20,height: 20,
                ),
                title: Text('My Payments',style: TextStyle(fontFamily: "Camphor",
                    fontWeight: FontWeight.w900,fontSize: 15),),
              ),

              ListTile(
                dense: true,
                contentPadding: EdgeInsets.fromLTRB(20, -20, 0, -20),
                onTap: () async {
                  _logOut();
                },
                leading: Image.asset(
                  "assets/logout.png",width: 20,height: 20,
                ),
                title: Text('Logout',style: TextStyle(fontFamily: "Camphor",
                    fontWeight: FontWeight.w900,fontSize: 15),),
              ),

            ],
          ),

          SizedBox(height: 50),
          Divider(
            height: 1,
            thickness: 0.5,
            color: Colors.grey,
          ),


          Container(
              padding: EdgeInsets.all(10),
              height: 100,
              child: Align(
                  alignment: Alignment.center,
                  child: Text("Version  :  1.0",style: TextStyle(fontFamily: "Camphor",
                    fontWeight: FontWeight.w900,),))),
        ],
      ),

    );

  }



}

