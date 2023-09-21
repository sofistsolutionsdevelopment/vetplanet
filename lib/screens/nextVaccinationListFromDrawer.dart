import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vetplanet/constant/colors.dart';
import 'package:vetplanet/models/vaccination_model.dart';
import 'package:http/http.dart' as http;
import 'package:vetplanet/transitions/slide_route.dart';

import 'dash.dart';
import 'drawer.dart';

class NextVaccinationDateFormDrawerPage extends StatefulWidget {
  final String petId;
  final String vetId;

  NextVaccinationDateFormDrawerPage({ this.petId, this.vetId });
  @override
  _NextVaccinationDateFormDrawerPageState createState() => _NextVaccinationDateFormDrawerPageState();
}

class _NextVaccinationDateFormDrawerPageState extends State<NextVaccinationDateFormDrawerPage> {
  void rebuildPage() {
    setState(() {});
  }


  Future<List> _futureVaccination;
  String _vaccinationLenght = "";
  Future<List<VaccinationModel>> getVaccination() async {
    final _prefs = await SharedPreferences.getInstance();
    String _API_Path = _prefs.getString('API_Path');
    String _RegistrationId = _prefs.getInt('id').toString();
    debugPrint('Check Inserted _API_Path $_API_Path ');
    debugPrint('Check Inserted _RegistrationId $_RegistrationId ');

    debugPrint('Check Inserted vetId ${widget.vetId} ');
    debugPrint('Check Inserted petId ${widget.petId} ');


    final String apiUrl = "$_API_Path/GetVaccinationByVetId/GetVaccinationByVetId";

    debugPrint('Check Inserted 1 ');
    var response = await http.post(
      Uri.parse(apiUrl),
      headers: {HttpHeaders.contentTypeHeader: 'application/json', HttpHeaders.authorizationHeader: 'bearer VA5kBnSw50cbuJ4YoAVkl4XyFTA312fRtKF4GxlmkUcl3PQJBKvvtogvT_0syd6ZtsZ4-1zFK6_liq5dQpyMq2tOA7vCtZ332qal7LGyBxBvv4mtD461lwGhNtprYd8PyIR40bBsoBc7nMElIniHJXAu1V04eO5c7sNLHOGypeG70Zn06yQr-0i_eFbsCRg6kMWjkao3RZwDfXVra5JQ5I7Pr1CbSgYez6rbYLMbH2LL6K8VcpmUvs45WpLe4UjPpChygW96LCoxVh7YtNa74n1Bje4sDdGLZowZJWwe7F9P7ijy1nVyw_v5K-8MqzlI' },
      body: json.encode(
          {
            "VetId":widget.vetId,
            "PatientId":_RegistrationId,
            "PatientPetId":widget.petId
          }
      ),
    );

    debugPrint('Check 2}');
    if (response != null && response.statusCode == 200) {
      debugPrint('Check 3}');
      var _response = json.decode(response.body);
      debugPrint('Check 4  ${_response}');


      List<VaccinationModel> _vaccination = _response
          .map<VaccinationModel>(
              (_json) => VaccinationModel.fromJson(_json))
          .toList();


      debugPrint('Check 5  ${_vaccination}');
      setState(() {
        _vaccinationLenght = _vaccination.length.toString();
        debugPrint('Check _vaccinationLenght &&&&&&&&&&&&&&&&&&&&&&&&&: $_vaccinationLenght}');

      });
      return _vaccination;

    } else {
      debugPrint('Check 6');
      return [];
    }
  }


  @override
  void initState() {
    _futureVaccination = getVaccination();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: (){
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
            if(_vaccinationLenght != "0")
              FutureBuilder(
                future: _futureVaccination,
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return Center(child: Text(''));
                  }
                  if (snapshot.hasData) {
                    List<VaccinationModel> _vaccination = snapshot.data;
                    return ListView.builder(
                      shrinkWrap: true,
                      itemCount: _vaccination == null ? 0 : _vaccination.length,
                      itemBuilder: (BuildContext context, int index) {
                        return Padding(
                          padding: const EdgeInsets.only(right:15, left:15, bottom:8, top:8),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              Image.asset(
                                "assets/inj.png",width: 20,height: 25,
                              ),
                              RichText(
                                //    maxLines: 10,
                                text: new TextSpan(
                                  text: ' Vaccinated By : ',
                                  style: TextStyle(
                                    color: Colors.black, fontSize: 15,fontFamily: "Camphor",
                                    fontWeight: FontWeight.w500,),
                                  children: <TextSpan>[
                                    new TextSpan(
                                      text:
                                      " ${_vaccination[index].VaccinatedBy}",
                                      style: TextStyle(
                                        color: Colors.black, fontSize: 15,fontFamily: "Camphor",
                                        fontWeight: FontWeight.w700,),),
                                  ],
                                ),
                              ),

                              RichText(
                                //    maxLines: 10,
                                text: new TextSpan(
                                  text: ' Vaccinated on : ',
                                  style: TextStyle(
                                    color: Colors.black, fontSize: 13,fontFamily: "Camphor",
                                    fontWeight: FontWeight.w500,),
                                  children: <TextSpan>[
                                    new TextSpan(
                                      text:
                                      " ${_vaccination[index].Date}",
                                      style: TextStyle(
                                        color: Colors.black, fontSize: 13,fontFamily: "Camphor",
                                        fontWeight: FontWeight.w700,),),
                                  ],
                                ),
                              ),
                              RichText(
                                //    maxLines: 10,
                                text: new TextSpan(
                                  text: ' Vacination : ',
                                  style: TextStyle(
                                    color: Colors.black, fontSize: 13,fontFamily: "Camphor",
                                    fontWeight: FontWeight.w500,),
                                  children: <TextSpan>[
                                    new TextSpan(
                                      text:
                                      " ${_vaccination[index].ItemName}",
                                      style: TextStyle(
                                        color: Colors.black, fontSize: 13,fontFamily: "Camphor",
                                        fontWeight: FontWeight.w700,),),
                                  ],
                                ),
                              ),

                              RichText(
                                //    maxLines: 10,
                                text: new TextSpan(
                                  text: ' Type : ',
                                  style: TextStyle(
                                    color: Colors.black, fontSize: 13,fontFamily: "Camphor",
                                    fontWeight: FontWeight.w500,),
                                  children: <TextSpan>[
                                    new TextSpan(
                                      text:
                                      " ${_vaccination[index].Type}",
                                      style: TextStyle(
                                        color: Colors.black, fontSize: 13,fontFamily: "Camphor",
                                        fontWeight: FontWeight.w700,),),
                                  ],
                                ),
                              ),

                              RichText(
                                //    maxLines: 10,
                                text: new TextSpan(
                                  text: ' Remarks : ',
                                  style: TextStyle(
                                    color: Colors.black, fontSize: 13,fontFamily: "Camphor",
                                    fontWeight: FontWeight.w500,),
                                  children: <TextSpan>[
                                    new TextSpan(
                                      text:
                                      " ${_vaccination[index].Remarks}",
                                      style: TextStyle(
                                        color: Colors.black, fontSize: 13,fontFamily: "Camphor",
                                        fontWeight: FontWeight.w700,),),
                                  ],
                                ),
                              ),


                              RichText(
                                //    maxLines: 10,
                                text: new TextSpan(
                                  text: ' Next Vaccination Date : ',
                                  style: TextStyle(
                                    color: appColor, fontSize: 15,fontFamily: "Camphor",
                                    fontWeight: FontWeight.w500,),
                                  children: <TextSpan>[
                                    new TextSpan(
                                      text:
                                      " ${_vaccination[index].NextVaccDate}",
                                      style: TextStyle(
                                        color: appColor, fontSize: 15,fontFamily: "Camphor",
                                        fontWeight: FontWeight.w700,),),
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
            if(_vaccinationLenght == "0")
              Column(
                children: <Widget>[
                  SizedBox(height: 100,),
                  Center(
                    child: Text("No Vaccination Details Found", style: TextStyle(fontSize: 20, color: Colors.black,fontFamily: "Camphor",
                      fontWeight: FontWeight.w700,),textAlign: TextAlign.center,),
                  ),
                ],
              ),
          ],
        ),


      ),
    );
  }
}
