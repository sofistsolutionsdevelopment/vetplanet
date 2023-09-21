import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vetplanet/constant/colors.dart';
import 'package:vetplanet/models/groomingServices_model.dart';
import 'package:vetplanet/models/pet_model.dart';
import 'package:vetplanet/models/result_model.dart';
import 'package:vetplanet/models/services_model.dart';
import 'package:vetplanet/models/species_model.dart';
import 'package:http/http.dart' as http;
import 'package:vetplanet/screens/bookAppointment.dart';
import 'package:vetplanet/transitions/slide_route.dart';
import 'dash.dart';
import 'drawer.dart';
import 'groomingBookAppointment.dart';

class SelectGroomingServicesPage extends StatefulWidget {
  final Function onPressed;
  final String shopId;
  final String groomingId;
  final String checkPet;
  final String token;

  SelectGroomingServicesPage({ this.shopId, this.groomingId, this.checkPet, this.onPressed, this.token });

  @override
  _SelectGroomingServicesPageState createState() => _SelectGroomingServicesPageState();
}

class _SelectGroomingServicesPageState extends State<SelectGroomingServicesPage> {
  void rebuildPage() {
    setState(() {});
  }


  Future<List> _futureService;
  String _ServiceLenght = "";

  final _globalKey = GlobalKey<ScaffoldMessengerState>();
  Future<List<GroomingServicesModel>> getService() async {
    final _prefs = await SharedPreferences.getInstance();
    String _API_Path = _prefs.getString('API_Path');
    debugPrint('Check getProfile _API_Path $_API_Path ');
    final String apiUrl = "$_API_Path/GetGroomingServices/GetGroomingServices";

    debugPrint('Check Inserted 1 ');
    debugPrint('Check Inserted widget.shopId :${widget.shopId} ');
    debugPrint('Check Inserted widget.groomingId :${widget.groomingId} ');

    var response = await http.post(
      Uri.parse(apiUrl),
      headers: {HttpHeaders.contentTypeHeader: 'application/json', HttpHeaders.authorizationHeader: 'bearer VA5kBnSw50cbuJ4YoAVkl4XyFTA312fRtKF4GxlmkUcl3PQJBKvvtogvT_0syd6ZtsZ4-1zFK6_liq5dQpyMq2tOA7vCtZ332qal7LGyBxBvv4mtD461lwGhNtprYd8PyIR40bBsoBc7nMElIniHJXAu1V04eO5c7sNLHOGypeG70Zn06yQr-0i_eFbsCRg6kMWjkao3RZwDfXVra5JQ5I7Pr1CbSgYez6rbYLMbH2LL6K8VcpmUvs45WpLe4UjPpChygW96LCoxVh7YtNa74n1Bje4sDdGLZowZJWwe7F9P7ijy1nVyw_v5K-8MqzlI' },
      body: json.encode(
          {
            "PetGroomingId":widget.groomingId,
            "ShopId":widget.shopId
          }

      ),
    );
    debugPrint('Check 2}');
    if (response != null && response.statusCode == 200) {
      debugPrint('Check 3}');
      var _response = json.decode(response.body);
      debugPrint('Check 4  ${_response}');

      List<GroomingServicesModel> __Services = _response
          .map<GroomingServicesModel>(
              (_json) => GroomingServicesModel.fromJson(_json))
          .toList();

      debugPrint('Check 5  ${__Services}');
      setState(() {
        _ServiceLenght = __Services.length.toString();
        debugPrint('Check _ServiceLenght &&&&&&&&&&&&&&&&&&&&&&&&&: $_ServiceLenght}');

      });
      return __Services;

    } else {
      debugPrint('Check 6');
      return [];
    }
  }

  List AnswerResponseListnew = List();
  String serviceId;
  String serviceName;

  String checkServices= "";

  ResultModel _result;

  Future<ResultModel> savePrePetService(String _serviceId) async{
    final _prefs = await SharedPreferences.getInstance();
    String _API_Path = _prefs.getString('API_Path');
    String _RegistrationId = _prefs.getInt('id').toString();
    debugPrint('Check Inserted _API_Path $_API_Path ');
    debugPrint('Check Inserted _RegistrationId $_RegistrationId ');

    final String apiUrl = "$_API_Path/SavePreGroomingService/SavePreGroomingService";

    debugPrint('Check Inserted 1 ');

    var response = await http.post(
      Uri.parse(apiUrl),
      headers: {HttpHeaders.contentTypeHeader: 'application/json', HttpHeaders.authorizationHeader: 'bearer VA5kBnSw50cbuJ4YoAVkl4XyFTA312fRtKF4GxlmkUcl3PQJBKvvtogvT_0syd6ZtsZ4-1zFK6_liq5dQpyMq2tOA7vCtZ332qal7LGyBxBvv4mtD461lwGhNtprYd8PyIR40bBsoBc7nMElIniHJXAu1V04eO5c7sNLHOGypeG70Zn06yQr-0i_eFbsCRg6kMWjkao3RZwDfXVra5JQ5I7Pr1CbSgYez6rbYLMbH2LL6K8VcpmUvs45WpLe4UjPpChygW96LCoxVh7YtNa74n1Bje4sDdGLZowZJWwe7F9P7ijy1nVyw_v5K-8MqzlI' },
      body: json.encode(
          {
            "PatientId":_RegistrationId,
            "ServiceId":_serviceId
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
    String _API_Path = _prefs.getString('API_Path');
    String _RegistrationId = _prefs.getInt('id').toString();

    debugPrint('Check Inserted _API_Path $_API_Path');
    debugPrint('Check Inserted _RegistrationId $_RegistrationId');

    final String apiUrl =  "$_API_Path/DeletePreGroomingService/DeletePreGroomingServicePatientId";

    debugPrint('Check Inserted 1 ');

    var response = await http.post(
      Uri.parse(apiUrl),
      headers: {HttpHeaders.contentTypeHeader: 'application/json', HttpHeaders.authorizationHeader: 'bearer VA5kBnSw50cbuJ4YoAVkl4XyFTA312fRtKF4GxlmkUcl3PQJBKvvtogvT_0syd6ZtsZ4-1zFK6_liq5dQpyMq2tOA7vCtZ332qal7LGyBxBvv4mtD461lwGhNtprYd8PyIR40bBsoBc7nMElIniHJXAu1V04eO5c7sNLHOGypeG70Zn06yQr-0i_eFbsCRg6kMWjkao3RZwDfXVra5JQ5I7Pr1CbSgYez6rbYLMbH2LL6K8VcpmUvs45WpLe4UjPpChygW96LCoxVh7YtNa74n1Bje4sDdGLZowZJWwe7F9P7ijy1nVyw_v5K-8MqzlI' },
      body: json.encode(
          {
            "PatientId"	:_RegistrationId
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


  double amount = 0.0;

  Future<List> _futurePet;
  int _PetLenght = 0;
  Future<List<PetModel>> getPet() async {
    final _prefs = await SharedPreferences.getInstance();
    String _API_Path = _prefs.getString('API_Path');
    String _RegistrationId = _prefs.getInt('id').toString();
    debugPrint('Check getProfile _API_Path $_API_Path ');
    final String apiUrl = "$_API_Path/GetPetList/GetPetList";

    print("2 ***");
    print("vetId *** ${widget.groomingId}");
    var response = await http.post(
      Uri.parse(apiUrl),
      headers: {HttpHeaders.contentTypeHeader: 'application/json', HttpHeaders.authorizationHeader: 'bearer VA5kBnSw50cbuJ4YoAVkl4XyFTA312fRtKF4GxlmkUcl3PQJBKvvtogvT_0syd6ZtsZ4-1zFK6_liq5dQpyMq2tOA7vCtZ332qal7LGyBxBvv4mtD461lwGhNtprYd8PyIR40bBsoBc7nMElIniHJXAu1V04eO5c7sNLHOGypeG70Zn06yQr-0i_eFbsCRg6kMWjkao3RZwDfXVra5JQ5I7Pr1CbSgYez6rbYLMbH2LL6K8VcpmUvs45WpLe4UjPpChygW96LCoxVh7YtNa74n1Bje4sDdGLZowZJWwe7F9P7ijy1nVyw_v5K-8MqzlI' },
      body: json.encode(
          {
            "PatientId": _RegistrationId
          }
      ),
    );
    debugPrint('Check 2}');
    if (response != null && response.statusCode == 200) {
      debugPrint('Check 3}');
      var _response = json.decode(response.body);
      debugPrint('Check 4  ${_response}');

      List<PetModel> _Pet = _response
          .map<PetModel>(
              (_json) => PetModel.fromJson(_json))
          .toList();

      debugPrint('Check 5  ${_Pet}');
      setState(() {
        _PetLenght = _Pet.length;
        debugPrint('Check _PetLenght &&&&&&&&&&&&&&&&&&&&&&&&&: $_PetLenght}');

      });
      return _Pet;

    } else {
      debugPrint('Check 6');
      return [];
    }
  }

  @override
  void initState() {
    _futurePet =  getPet();
    super.initState();
  }

  final _scaffoldKey = GlobalKey<ScaffoldState>();
  _displaySnackBar(BuildContext context) {
    final snackBar = SnackBar(content: Text('Please select atleast one Service', style: TextStyle(fontSize: 20),));
    _globalKey.currentState.showSnackBar(snackBar);
  }
  String patientPetId;
  String petName;

  String checkPet= "";
/*
  Widget renderTeams() {
    return   FutureBuilder<GroomingServicesModel>(
        future: _resultServicesList,
        builder: (context, snapshot)
        {

          return  ListView.builder(
            itemCount: _resultServices == null ? 0 : _resultServices.length,
            itemBuilder: (BuildContext context, int index){


              return Column(
                children: <Widget>[
                  ListTile(
                    leading:  Checkbox(
                      //title: Text(_resultServices[index].Service,style: TextStyle(fontSize:16, fontFamily: "Camphor",
                      // fontWeight: FontWeight.w700,color: Colors.black),),
                      value: _resultServices[index].IsChecked,
                      activeColor: appColor,
                      checkColor: Colors.white,
                      onChanged: (val) {
                        setState(() {
                          _resultServices[index].IsChecked = val;

                          serviceId = _resultServices[index].ServiceId.toString();
                          serviceName =  _resultServices[index].Service;

                          print('changed to serviceId $serviceId');
                          print('changed to serviceName $serviceName');

                          var data= AnswerResponseListnew.where((AnswerResponseListnew) => (AnswerResponseListnew[0].contains(_resultServices[index].ServiceId.toString())));
                          print("data : $data");

                          if(_resultServices[index].IsChecked == true){
                            print("data : true");
                            amount = amount + double.parse("${_resultServices[index].Rate}");
                            print("data : true amount $amount");
                            AnswerResponseListnew.removeWhere((AnswerResponseListnew) => (AnswerResponseListnew[0].contains(serviceId)));
                            AnswerResponseListnew.add([serviceId,serviceName]) ;
                          }
                          else{
                            print("data : false");
                            amount = amount - double.parse("${_resultServices[index].Rate}");
                            print("data : false amount $amount");
                            AnswerResponseListnew.removeWhere((AnswerResponseListnew) => (AnswerResponseListnew[0].contains(serviceId)));
                          }

                        },
                        );
                      },
                    ),
                    title: Text(_resultServices[index].Service,style: TextStyle(fontSize:16, fontFamily: "Camphor",
                        fontWeight: FontWeight.w700,color: Colors.black),),
                    trailing:Text("${_resultServices[index].Rate}/-",style: TextStyle(fontSize:16, fontFamily: "Camphor",
                        fontWeight: FontWeight.w700,color: Colors.black),),
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
    );
  }
*/

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
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

      body:   FutureBuilder(
        future: _futurePet,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text(''));
          }
          if (snapshot.hasData) {
            List<PetModel> _resultPet = snapshot.data;
            return ListView.builder(
              physics: ClampingScrollPhysics(),
              shrinkWrap: true,
              itemCount: _PetLenght,
              itemBuilder: (BuildContext context, int index) {
                _futureService = getService();
                return  SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: <Widget>[
                        Text(
                          "${_resultPet[index].PetName}",style: TextStyle(fontSize:18, fontFamily: "Camphor",
                            fontWeight: FontWeight.w700,color: Colors.black),),
                        FutureBuilder(
                          future: _futureService,
                          builder: (context, snapshot) {
                            if (snapshot.hasError) {
                              return Center(child: Text(''));
                            }
                            if (snapshot.hasData) {
                              List<GroomingServicesModel> _resultServices = snapshot.data;
                              return ListView.builder(
                                physics: ClampingScrollPhysics(),
                                shrinkWrap: true,
                                itemCount: _resultServices == null ? 0 : _resultServices.length,
                                itemBuilder: (BuildContext context, int index) {
                                  return SingleChildScrollView(
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Column(
                                        children: <Widget>[
                                          ListTile(
                                            leading: Checkbox(
                                              //title: Text(_resultServices[index].Service,style: TextStyle(fontSize:16, fontFamily: "Camphor",
                                              // fontWeight: FontWeight.w700,color: Colors.black),),
                                              value: _resultServices[index].IsChecked,
                                              activeColor: appColor,
                                              checkColor: Colors.white,
                                              onChanged: (val) {
                                                setState(() {
                                                  _resultServices[index].IsChecked = val;

                                                  serviceId = _resultServices[index].ServiceId.toString();
                                                  serviceName =  _resultServices[index].Service;

                                                  print('changed to serviceId $serviceId');
                                                  print('changed to serviceName $serviceName');

                                                  var data= AnswerResponseListnew.where((AnswerResponseListnew) => (AnswerResponseListnew[0].contains(_resultServices[index].ServiceId.toString())));
                                                  print("data : $data");

                                                  if(_resultServices[index].IsChecked == true){
                                                    print("data : true");
                                                    amount = amount + double.parse("${_resultServices[index].Rate}");
                                                    print("data : true amount $amount");
                                                    AnswerResponseListnew.removeWhere((AnswerResponseListnew) => (AnswerResponseListnew[0].contains(serviceId)));
                                                    AnswerResponseListnew.add([serviceId,serviceName]) ;
                                                  }
                                                  else {
                                                    print("data : false");
                                                    amount = amount - double.parse("${_resultServices[index].Rate}");
                                                    print("data : false amount $amount");
                                                    AnswerResponseListnew.removeWhere((AnswerResponseListnew) => (AnswerResponseListnew[0].contains(serviceId)));
                                                  }

                                                },
                                                );
                                              },
                                            ),
                                            title: Text(_resultServices[index].Service,style: TextStyle(fontSize:16, fontFamily: "Camphor",
                                                fontWeight: FontWeight.w700,color: Colors.black),),
                                            trailing: Text("${_resultServices[index].Rate}/-",style: TextStyle(fontSize:16, fontFamily: "Camphor",
                                                fontWeight: FontWeight.w700,color: Colors.black),),
                                          ),
                                        ],),),);
                                },);
                            }
                            return Center(child: SpinKitRotatingCircle(
                              color: appColor,
                              size: 50.0,));
                          },
                        ),
                      ],
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



      /*
      Column (children: <Widget>[
        Expanded(
          child: FutureBuilder<PetModel>(
              future: _resultPetList,
              builder: (context, snapshot)
              {

                return  ListView.builder(
                  itemCount: _resultPet == null ? 0 : _resultPet.length,
                  itemBuilder: (BuildContext context, int index){

                    return
                      Column(
                        children: <Widget>[
                          Text(_resultPet[index].PetName,style: TextStyle(fontSize:18, fontFamily: "Camphor",
                              fontWeight: FontWeight.w700,color: Colors.black),),

                          Divider(
                            height: 1,
                            thickness: 0.5,
                            color: Colors.grey,
                          ),
                          renderTeams(),
                         
                        ],
                      );


                  },
                );


              }
          ),
        ),



        SizedBox(height: 10,),
        Text("Amount : $amount", style: TextStyle(fontSize:25, fontFamily: "Camphor",
            fontWeight: FontWeight.w900,color: Colors.black),),

        SizedBox(height: 20,),

      ]),
*/


      bottomNavigationBar: Container(
        height: 50,
        width: double.infinity,
        decoration: BoxDecoration(
          border:Border(top: BorderSide(color: Colors.grey, width: 1),),),
        child: Align(
            alignment: Alignment.center,
            child: Padding(
              padding: const EdgeInsets.only(right:10),
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
                       // _resultServicesList =  getServices();
                      }

                    }

                    String _groomingId = widget.groomingId;
                    String _shopId = widget.shopId;
                    String _checkPet = widget.checkPet;
                    String _token = widget.token;

                    print(" checkServices  ============ : ${checkServices} ");
                    print("widget  _groomingId  ============ : ${_groomingId} ");
                    print("widget  _shopId  ============ : ${_shopId} ");
                    print("widget  _checkPet  ============ : ${_checkPet} ");
                    print("widget  _token  ============ : ${_token} ");

                  //  Navigator.push(context, SlideLeftRoute(page: GroomingBookAppointmentPage(shopId:_shopId, groomingId:_groomingId, checkServices: checkServices, checkPet:_checkPet, token:_token)));


                  }



                },
                child: Container(
                  color: appColor,
                  child: Padding(
                    padding: const EdgeInsets.only(top:10, bottom: 10, left: 35, right: 35),
                    child: Text("Continue",style: TextStyle(color: Colors.white,fontFamily: "Camphor",
                        fontWeight: FontWeight.w900, fontSize: 16),),
                  ),
                ),
              ),
            )),

      ),

    );
  }
}
