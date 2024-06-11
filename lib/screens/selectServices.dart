import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vetplanet/constant/colors.dart';
import 'package:vetplanet/models/result_model.dart';
import 'package:vetplanet/models/services_model.dart';
import 'package:vetplanet/models/species_model.dart';
import 'package:http/http.dart' as http;
import 'package:vetplanet/screens/bookAppointment.dart';
import 'package:vetplanet/transitions/slide_route.dart';
import 'dash.dart';
import 'drawer.dart';

class SelectServicesPage extends StatefulWidget {
  final Function onPressed;
  final String clinicId;
  final String amount;
  final String vetId;
  final String checkPet;
  final String token;

  SelectServicesPage({ this.clinicId, this.amount, this.vetId, this.checkPet, this.onPressed, this.token });

  @override
  _SelectServicesPageState createState() => _SelectServicesPageState();
}

class _SelectServicesPageState extends State<SelectServicesPage> {
  void rebuildPage() {
    setState(() {});
  }

  final _globalKey = GlobalKey<ScaffoldMessengerState>();

  List<ServicesModel> _resultServices;
  List servicesListData = List(); //edited line
  Future<ServicesModel> _resultServicesList;
  Future<ServicesModel> getServices() async {

    print("1 ***");
    final _prefs = await SharedPreferences.getInstance();
    
    String _RegistrationId = _prefs.getInt('id').toString();
    debugPrint('Check Inserted apiUrl $apiUrl ');
    debugPrint('Check Inserted _RegistrationId $_RegistrationId ');


    final String url = "$apiUrl/GetServices/GetServices";

    print("2 ***");
    print("clinicId *** ${widget.clinicId}");
    print("vetId *** ${widget.vetId}");
    var response = await http.post(
      Uri.parse(url),
      headers: {HttpHeaders.contentTypeHeader: 'application/json', HttpHeaders.authorizationHeader: bearerToken },
      body: json.encode(
          {
            "VetId":widget.vetId,
            "ClinicId":widget.clinicId
          }

      ),
    );

    print("3 ***");

    print("statusCode *** ${response.statusCode}");
    if(response.statusCode == 200){
      final String responseString = response.body;
      print("responseString *** ${responseString}");

      this.setState(() {
        servicesListData = json.decode(response.body);
        print("speciesListData *** ${servicesListData}");

        _resultServices = servicesListData
            .map<ServicesModel>(
                (_json) => ServicesModel.fromJson(_json))
            .toList();
        print("*** ${servicesListData}");

        print("_resultEmp *** ${_resultServices}");
        print("_resultEmp length*** ${_resultServices.length}");
      });
      return servicesModelFromJson(responseString);
    }else{
      return null;
    }
  }

  List AnswerResponseListnew = List();
  String serviceId;
  String serviceName;

  String checkServices= "";

  ResultModel _result;

  Future<ResultModel> savePrePetService(String _serviceId) async{
    final _prefs = await SharedPreferences.getInstance();
    
    String _RegistrationId = _prefs.getInt('id').toString();
    debugPrint('Check Inserted apiUrl $apiUrl ');
    debugPrint('Check Inserted _RegistrationId $_RegistrationId ');

    final String url = "$apiUrl/SavePetService/SavePrePetService";

    debugPrint('Check Inserted 1 ');

    var response = await http.post(
      Uri.parse(url),
      headers: {HttpHeaders.contentTypeHeader: 'application/json', HttpHeaders.authorizationHeader: bearerToken },
      body: json.encode(
          {
            "PatientId":_RegistrationId,
            "ServiceId":_serviceId,
            "VetId":widget.vetId,
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





  ResultModel _deleteServices;

  Future<ResultModel> deleteServices() async{
    final _prefs = await SharedPreferences.getInstance();
    
    String _RegistrationId = _prefs.getInt('id').toString();

    debugPrint('Check Inserted apiUrl $apiUrl');
    debugPrint('Check Inserted _RegistrationId $_RegistrationId');

    final String url =  "$apiUrl/DeletePrePetService/DeletePrePetService";

    debugPrint('Check Inserted 1 ');

    var response = await http.post(
      Uri.parse(url),
      headers: {HttpHeaders.contentTypeHeader: 'application/json', HttpHeaders.authorizationHeader: bearerToken },
      body: json.encode(
          {
            "PatientId"	:_RegistrationId,
            "VetId":widget.vetId
          }

      ),
    );

/*
    final response = await http.post(apiUrl, body:
    {
      "VisitorId": visitorId,
      "SlotId":SlotId
    }

    );*/
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




  @override
  void initState() {
    _resultServicesList =  getServices();
    super.initState();
  }

  final _scaffoldKey = GlobalKey<ScaffoldState>();
  _displaySnackBar(BuildContext context) {
    final snackBar = SnackBar(content: Text('Please select atleast one Service', style: TextStyle(fontSize: 20),));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }


  @override
  Widget build(BuildContext context) {
    return ScaffoldMessenger(
      key: _globalKey,
      child: Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          backgroundColor: appColorlight,
          flexibleSpace: (Container(
            decoration: BoxDecoration(
              color: appColorlight,
              borderRadius: BorderRadius.all(Radius.circular(2)),
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
    
        body: Column (children: <Widget>[
          Expanded(
            child: FutureBuilder<ServicesModel>(
                future: _resultServicesList,
                builder: (context, snapshot)
                {
    
                  return  ListView.builder(
                    itemCount: _resultServices == null ? 0 : _resultServices.length,
                    itemBuilder: (BuildContext context, int index){
    
                      return
                        Column(
                          children: <Widget>[
                            CheckboxListTile(
                              title: Text(_resultServices[index].ServiceName,style: TextStyle(fontSize:18, fontFamily: "Camphor",
                                  fontWeight: FontWeight.w700,color: Colors.black),),
                              value: _resultServices[index].IsChecked,
                              activeColor: appColorlight,
                              checkColor: Colors.white,
                              onChanged: (val) {
                                setState(() {
                                  _resultServices[index].IsChecked = val;
    
                                  serviceId = _resultServices[index].ServiceId.toString();
                                  serviceName =  _resultServices[index].ServiceName;
    
                                  print('changed to serviceId $serviceId');
                                  print('changed to serviceName $serviceName');
    
                                  var data= AnswerResponseListnew.where((AnswerResponseListnew) => (AnswerResponseListnew[0].contains(_resultServices[index].ServiceId.toString())));
                                  print("data : $data");
    
                                  if(_resultServices[index].IsChecked == true){
                                    print("data : true");
                                    AnswerResponseListnew.removeWhere((AnswerResponseListnew) => (AnswerResponseListnew[0].contains(serviceId)));
                                    AnswerResponseListnew.add([serviceId,serviceName]) ;
                                  }
                                  else{
                                    print("data : false");
                                    AnswerResponseListnew.removeWhere((AnswerResponseListnew) => (AnswerResponseListnew[0].contains(serviceId)));
                                  }
    
                                },
                                );
                              },
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
            ),
          ),
    
    
    
        ]),
    
    
        bottomNavigationBar: Container(
          margin: EdgeInsets.all(10),
          height: 50,
          width: double.infinity,
          decoration: BoxDecoration(
            ),
          child: InkWell(
            onTap: () async {
              
              checkServices = "";
    
                    print("AnswerResponseList .................................... : $AnswerResponseListnew");
                    print("AnswerResponseList Length.................................... : ${AnswerResponseListnew.length}");
    
                    final ResultModel deleteServicesResult = await deleteServices();
                    setState(() {
                      _deleteServices = deleteServicesResult;
                      debugPrint('Services in db Successfully : ${_deleteServices.Result}');
                    });
    
    
                    if(AnswerResponseListnew.length == 0){
                      _displaySnackBar(context);
                    }
    
                    if(AnswerResponseListnew.length != 0){
                      for(var i=0; i < AnswerResponseListnew.length; i++) {
    
                        String _serviceId = AnswerResponseListnew[i][0];
                        String _serviceName = AnswerResponseListnew[i][1];
    
                        print(" STRING serviceId  ============ : ${_serviceId} ");
                        print(" STRING serviceName  ============ : ${_serviceName} ");
    
                        checkServices = checkServices + _serviceId  +', ';
    
                        final ResultModel result = await savePrePetService(_serviceId);
                        debugPrint('2');
    
                        setState(() {
                          _result = result;
                        });
                        debugPrint('savePrePetService result : $result');
    
                        debugPrint('3');
    
                        if (_result.Result == "ADDED" ) {
                          debugPrint('****************************************');
                          _resultServicesList =  getServices();
                        }
    
                      }
    
                      String _vetId = widget.vetId;
                      String _clinicId = widget.clinicId;
                      String _checkPet = widget.checkPet;
                      String _token = widget.token;
                      String _amount = widget.amount;
    
                      print(" checkServices  ============ : ${checkServices} ");
                      print("widget  _vetId  ============ : ${_vetId} ");
                      print("widget  _clinicId  ============ : ${_clinicId} ");
                      print("widget  _checkPet  ============ : ${_checkPet} ");
                      print("widget  _token  ============ : ${_token} ");
                      print("widget  _amount  ============ : ${_amount} ");
    
                      Navigator.push(context, SlideLeftRoute(page: BookAppointmentPage(clinicId:_clinicId, amount:_amount, vetId:_vetId, checkServices: checkServices, checkPet:_checkPet, token:_token)));
    
    
                    }
    
    
    
    
            },
            child: Container(
              color: appColor,
              child: ElevatedButton(
                style: ButtonStyle(
                  backgroundColor: 
                  MaterialStateProperty.all(appColorlight)
                ),
                onPressed: ()async{
                  checkServices = "";
    
              print("AnswerResponseList .................................... : $AnswerResponseListnew");
              print("AnswerResponseList Length.................................... : ${AnswerResponseListnew.length}");
    
              final ResultModel deleteServicesResult = await deleteServices();
              setState(() {
              _deleteServices = deleteServicesResult;
              debugPrint('Services in db Successfully : ${_deleteServices.Result}');
              });
    
    
              if(AnswerResponseListnew.length == 0){
              _displaySnackBar(context);
              }
    
              if(AnswerResponseListnew.length != 0){
              for(var i=0; i < AnswerResponseListnew.length; i++) {
    
                String _serviceId = AnswerResponseListnew[i][0];
                String _serviceName = AnswerResponseListnew[i][1];
    
                print(" STRING serviceId  ============ : ${_serviceId} ");
                print(" STRING serviceName  ============ : ${_serviceName} ");
    
                checkServices = checkServices + _serviceId  +', ';
    
                final ResultModel result = await savePrePetService(_serviceId);
                debugPrint('2');
    
                setState(() {
                  _result = result;
                });
                debugPrint('savePrePetService result : $result');
    
                debugPrint('3');
    
                if (_result.Result == "ADDED" ) {
                  debugPrint('****************************************');
                  _resultServicesList =  getServices();
                }
    
              }
    
              String _vetId = widget.vetId;
              String _clinicId = widget.clinicId;
              String _checkPet = widget.checkPet;
              String _token = widget.token;
              String _amount = widget.amount;
    
              print(" checkServices  ============ : ${checkServices} ");
              print("widget  _vetId  ============ : ${_vetId} ");
              print("widget  _clinicId  ============ : ${_clinicId} ");
              print("widget  _checkPet  ============ : ${_checkPet} ");
              print("widget  _token  ============ : ${_token} ");
              print("widget  _amount  ============ : ${_amount} ");
    
              Navigator.push(context, SlideLeftRoute(page: BookAppointmentPage(clinicId:_clinicId, amount:_amount, vetId:_vetId, checkServices: checkServices, checkPet:_checkPet, token:_token)));
    
    
              }
    
                },
                child: Text("Continue",style: TextStyle(color: Colors.white,fontFamily: "Camphor",
                    fontWeight: FontWeight.w900, fontSize: 16),),
              ),
            ),
          ),
    
        ),
    
    
    
      ),
    );
  }
}
