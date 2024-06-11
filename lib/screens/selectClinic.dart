import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:vetplanet/constant/colors.dart';
import 'package:vetplanet/models/clinic_model.dart';
import 'package:vetplanet/screens/dash.dart';
import 'package:http/http.dart' as http;
import 'package:vetplanet/screens/selectServices.dart';
import 'package:vetplanet/transitions/slide_route.dart';
import 'bookAppointment.dart';
import 'drawer.dart';

class SelectClinicPage extends StatefulWidget {
  final String vetId;
  final String checkPet;
  final String token;

  SelectClinicPage({ this.vetId, this.checkPet, this.token });
  @override
  _SelectClinicPageState createState() => _SelectClinicPageState();
}

class _SelectClinicPageState extends State<SelectClinicPage> {

  void rebuildPage() {
    setState(() {});
  }


  Future<List> _future;

  String _clinicLenght = "";

  Future<List<ClinicModel>> getClinic() async {
    final _prefs = await SharedPreferences.getInstance();
    
    String _RegistrationId = _prefs.getInt('id').toString();
    debugPrint('Check Inserted apiUrl $apiUrl ');
    debugPrint('Check Inserted _RegistrationId $_RegistrationId ');


    final String url = "$apiUrl/GetClinicListByVetId/GetClinicListByVetId";

    debugPrint('Check Inserted 1 ');
    var response = await http.post(
      Uri.parse(url),
      headers: {HttpHeaders.contentTypeHeader: 'application/json', HttpHeaders.authorizationHeader: bearerToken },
      body: json.encode(
          {
            "VetId": widget.vetId
          }
      ),
    );

    debugPrint('Check 2}');
    if (response != null && response.statusCode == 200) {
      debugPrint('Check 3}');
      var _response = json.decode(response.body);
      debugPrint('Check 4  ${_response}');


      List<ClinicModel> _clinic = _response
          .map<ClinicModel>(
              (_json) => ClinicModel.fromJson(_json))
          .toList();

      debugPrint('Check 5  ${_clinic}');
      setState(() {
        _clinicLenght = _clinic.length.toString();
        debugPrint('Check _petLenght &&&&&&&&&&&&&&&&&&&&&&&&&: $_clinicLenght}');

      });
      return _clinic;

    } else {
      debugPrint('Check 6');
      return [];
    }
  }


  @override
  void initState() {
    _future = getClinic();
    super.initState();
  }

  void launchMap(String address) async {
    String query = Uri.encodeComponent(address);
    String googleUrl = "https://www.google.com/maps/search/?api=1&query=$query";

    if (await canLaunch(googleUrl)) {
      await launch(googleUrl);
    }
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: appColorlight,
        flexibleSpace: (Container(
          decoration: BoxDecoration(
            color: appColorlight,
            borderRadius: BorderRadius.all(Radius.circular(2)),
          ),
        )),
        elevation: 0,
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

      body:    FutureBuilder(
        future: _future,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text(''));
          }
          if (snapshot.hasData) {
            List<ClinicModel> _clinic =  snapshot.data;
            return ListView.builder(
              shrinkWrap: true,
              itemCount: _clinic == null ? 0 : _clinic.length,
              itemBuilder: (BuildContext context, int index) {
                return Column(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: InkWell(
                        onTap: (){
                          String _clinicId = "${_clinic[index].ClinicId.toString()}";
                          String _amount = "${_clinic[index].AppointmentCharges.toString()}";
                          String _vetId = widget.vetId;
                          String _checkPet = widget.checkPet;
                          String _token = widget.token;
                          Navigator.push(context, SlideLeftRoute(page: SelectServicesPage(clinicId:_clinicId, amount:_amount, vetId:_vetId, checkPet:_checkPet, token:_token)));
                          //Navigator.push(context, SlideLeftRoute(page: BookAppointmentPage(clinicId:_clinicId, vetId:_vetId)));


                        },
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child:   Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: <Widget>[
                                    Image.asset(
                                      "assets/clinic_r.png",width: 20,height: 15,
                                    ),
                                    SizedBox(height: 5,),
                                    Text(
                                      "${_clinic[index].ClinicName}",
                                      style: TextStyle(
                                        color: Colors.black, fontSize: 18,fontFamily: "Camphor",
                                        fontWeight: FontWeight.w700,),
                                    ),
                                    Text(
                                      "${_clinic[index].ClinicContactNo}",
                                      style: TextStyle(
                                        color: Colors.black, fontSize: 16,fontFamily: "Camphor",
                                        fontWeight: FontWeight.w700,),
                                    ),
                                    Text(
                                      "${_clinic[index].ClinicAddress}",
                                      style: TextStyle(
                                        color: Colors.black, fontSize: 16,fontFamily: "Camphor",
                                        fontWeight: FontWeight.w700,),
                                    ),
                                    Text(
                                      "Appointment Booking Amount : ${_clinic[index].AppointmentCharges.toString()}",
                                      style: TextStyle(
                                        color: appColor, fontSize: 18,fontFamily: "Camphor",
                                        fontWeight: FontWeight.w700,),
                                    ),
                                  ],
                                ),
                              ),
                              InkWell(
                                  onTap: (){
                                    String address = "${_clinic[index].ClinicAddress}";

                                    print("address : $address");
                                    launchMap(address);
                                  },
                                  child: Icon(Icons.location_on, color: appColor,size: 30,)),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Divider(
                      height: 1,
                      thickness: 0.5,
                      color: Colors.grey,
                    ),
                  ],
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

    );
  }
}
