import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:vetplanet/constant/colors.dart';
import 'package:vetplanet/models/groomingServices_model.dart';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/widgets.dart';
import 'package:vetplanet/models/hostelServices_model.dart';
import 'package:vetplanet/models/result_model.dart';
import 'package:vetplanet/screens/selectPetForGrooming.dart';
import 'package:vetplanet/screens/selectPetForHostel.dart';
import 'package:vetplanet/transitions/slide_route.dart';


class   HostelServicesDialog extends StatefulWidget {
  final String hostelId;
  final String patientPetId;
  final String token;

  HostelServicesDialog({ this.hostelId, this.patientPetId, this.token });
  @override
  _HostelServicesDialogState createState() => new _HostelServicesDialogState();
}

class _HostelServicesDialogState extends State<HostelServicesDialog> {


  Future<List> _futureService;
  String _ServiceLenght = "";
  Future<List<HostelServicesModel>> getService() async {
    final _prefs = await SharedPreferences.getInstance();
    
    debugPrint('Check getProfile apiUrl $apiUrl ');
    final String url = "$apiUrl/GetHostelServices/GetHostelServices";

    debugPrint('Check Inserted 1 ');

    var response = await http.post(
      Uri.parse(url),
      headers: {HttpHeaders.contentTypeHeader: 'application/json', HttpHeaders.authorizationHeader: bearerToken },
      body: json.encode(
          {
            "HostelId":widget.hostelId
          }
      ),
    );
    debugPrint('Check 2}');
    if (response != null && response.statusCode == 200) {
      debugPrint('Check 3}');
      var _response = json.decode(response.body);
      debugPrint('Check 4  ${_response}');

      List<HostelServicesModel> __Services = _response
          .map<HostelServicesModel>(
              (_json) => HostelServicesModel.fromJson(_json))
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

  void rebuildPage() {
    setState(() {});
  }

  @override
  void initState() {
    _futureService = getService();
    super.initState();
  }

  List AnswerResponseListnew = List();
  String petId;
  String serviceId;
  String serviceName;
  double amount = 0.0;

  String checkServices= "";


  ResultModel _result;

  Future<ResultModel> saveTempPetService(String checkServices) async{
    final _prefs = await SharedPreferences.getInstance();
    
    String _RegistrationId = _prefs.getInt('id').toString();
    debugPrint('Check saveTempPetService apiUrl $apiUrl ');
    debugPrint('Check saveTempPetService _RegistrationId $_RegistrationId ');
    debugPrint('Check saveTempPetService patientPetId ${widget.patientPetId} ');
    debugPrint('Check saveTempPetService checkServices $checkServices');
    final String url = "$apiUrl/SavePreHostelService/SavePreHostelService";

    debugPrint('Check saveTempPetService 1 ');

    var response = await http.post(
      Uri.parse(url),
      headers: {HttpHeaders.contentTypeHeader: 'application/json', HttpHeaders.authorizationHeader: bearerToken },
      body: json.encode(
          {
            "PatientId":_RegistrationId,
            "PatientPetId":widget.patientPetId,
            "ServiceId":checkServices,
            "HostelId":widget.hostelId
          }
      ),
    );
    debugPrint('Check saveTempPetService 2 ');

    if(response.statusCode == 200){

      debugPrint('Check saveTempPetService 3 : ${response.body}');

      final String responseString = response.body;

      debugPrint('Check saveTempPetService 4  ${responseString}');

      return resultModelFromJson(responseString);

    }else{
      debugPrint('Check saveTempPetService 5 ');
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
   return WillPopScope(
      onWillPop: () {
        //on Back button press, you can use WillPopScope for another purpose also.
        // Navigator.pop(context); //return data along with pop
        Navigator.of(context)
            .pushReplacement(new MaterialPageRoute(builder: (context) =>
            SelectPetForHostelPage(onPressed: rebuildPage,
              hostelId: widget.hostelId,
              token: widget.token,)));
        return new Future(() => false); //onWillPop is Future<bool> so return false
      },
      child: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/bg_red.png"),
            fit: BoxFit.cover,
          ),
        ),
        child: AlertDialog(
          title: Container(
            color: appColor,
            child: Padding(
              padding: const EdgeInsets.only(
                  left: 1, right: 1, top: 12, bottom: 12),
              child: Text('Services', style: TextStyle(fontFamily: "Camphor",
                  fontWeight: FontWeight.w900,
                  fontSize: 18,
                  color: Colors.white), textAlign: TextAlign.center,),
            ),
          ),
          content:  Column(
            children: <Widget>[
              Expanded(
                child: FutureBuilder(
                  future: _futureService,
                  builder: (context, snapshot) {
                    if (snapshot.hasError) {
                      return Center(child: Text(''));
                    }
                    if (snapshot.hasData) {
                      List<HostelServicesModel> _resultServices = snapshot.data;
                      return Container(
                        width: double.maxFinite,
                        child: ListView.builder(
                          physics: ClampingScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: _resultServices == null ? 0 : _resultServices
                              .length,
                          itemBuilder: (BuildContext context, int index) {
                            return SingleChildScrollView(




                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Padding(
                                    padding: const EdgeInsets.only(top: 15),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Table(
                                          defaultColumnWidth: FixedColumnWidth(75.0),
                                          border: TableBorder.all(
                                              color: Colors.black,
                                              style: BorderStyle.none,
                                              width: 0),
                                          children: [
                                            TableRow(
                                                children: [
                                                  Column(
                                                      mainAxisAlignment: MainAxisAlignment.start,
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      children:[ Text(
                                                        "${_resultServices[index].Service}",
                                                        style: TextStyle(fontSize: 16,
                                                            fontFamily: "Camphor",
                                                            fontWeight: FontWeight.w700,
                                                            color: Colors.black),textAlign: TextAlign.left,),]),
                                                  Column(
                                                      mainAxisAlignment: MainAxisAlignment.center,
                                                      crossAxisAlignment: CrossAxisAlignment.center,
                                                      children:[Text("${_resultServices[index].Rate}/-",
                                                        style: TextStyle(fontSize: 16,
                                                            fontFamily: "Camphor",
                                                            fontWeight: FontWeight.w700,
                                                            color: Colors.black),),]),
                                                  Column(
                                                      mainAxisAlignment: MainAxisAlignment.end,
                                                      crossAxisAlignment: CrossAxisAlignment.end,
                                                      children:[Checkbox(
                                                        //title: Text(_resultServices[index].Service,style: TextStyle(fontSize:16, fontFamily: "Camphor",
                                                        // fontWeight: FontWeight.w700,color: Colors.black),),
                                                        value: _resultServices[index].IsChecked,
                                                        activeColor: appColorlight,
                                                        checkColor: Colors.white,
                                                        onChanged: (val) {
                                                          setState(() {
                                                            _resultServices[index].IsChecked = val;
                                                            petId = widget.patientPetId;
                                                            serviceId =
                                                                _resultServices[index].ServiceId
                                                                    .toString();
                                                            serviceName =
                                                                _resultServices[index].Service;

                                                            print('changed to serviceId $serviceId');
                                                            print(
                                                                'changed to serviceName $serviceName');

                                                            var data = AnswerResponseListnew.where((
                                                                AnswerResponseListnew) =>
                                                            (AnswerResponseListnew[1].contains(
                                                                _resultServices[index].ServiceId
                                                                    .toString())));
                                                            print("data : $data");

                                                            if (_resultServices[index].IsChecked ==
                                                                true) {
                                                              print("data : true");
                                                              amount = amount + double.parse(
                                                                  "${_resultServices[index].Rate}");
                                                              print("data : true amount $amount");
                                                              AnswerResponseListnew.removeWhere((
                                                                  AnswerResponseListnew) =>
                                                              (AnswerResponseListnew[1].contains(
                                                                  serviceId)));
                                                              AnswerResponseListnew.add(
                                                                  [petId, serviceId]);
                                                            }
                                                            else {
                                                              print("data : false");
                                                              amount = amount - double.parse(
                                                                  "${_resultServices[index].Rate}");
                                                              print("data : false amount $amount");
                                                              AnswerResponseListnew.removeWhere((
                                                                  AnswerResponseListnew) =>
                                                              (AnswerResponseListnew[1].contains(
                                                                  serviceId)));
                                                            }
                                                          },
                                                          );
                                                        },
                                                      ),]),


                                                ]),

                                          ],
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
                              ),);
                          },),
                      );
                    }
                    return Center(child: SpinKitRotatingCircle(
                      color: appColor,
                      size: 50.0,));
                  },
                ),
              ),
            ],
          ),
          actions: <Widget>[

            TextButton(
              //  color: Colors.green,
              child: Padding(
                padding: const EdgeInsets.all(5.0),
                child: Text('Cancel', style: TextStyle(
                  color: appColorlight, fontSize: 16, fontFamily: "Camphor",
                  fontWeight: FontWeight.w900,),),
              ),
              onPressed: () {
                debugPrint('^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^');
                Navigator.push(context, SlideLeftRoute(
                    page: SelectPetForHostelPage(hostelId: widget.hostelId,
                        token: widget.token)));
              },
            ),

            TextButton(
              // color: Colors.red,
                child: Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: Text('Confirm', style: TextStyle(
                    color: appColorlight, fontSize: 16, fontFamily: "Camphor",
                    fontWeight: FontWeight.w900,),),
                ),
                onPressed: () async {
                  debugPrint(
                      '**************************************************************');
                  checkServices = "";

                  print(
                      "AnswerResponseList .................................... : $AnswerResponseListnew");
                  print(
                      "AnswerResponseList Length.................................... : ${AnswerResponseListnew
                          .length}");


                  if (AnswerResponseListnew.length == 0) {
                    //_displaySnackBar(context);
                    debugPrint('&&&&&&&&&&&&&&&&&&&&');
                  }

                  if (AnswerResponseListnew.length != 0) {
                    for (var i = 0; i < AnswerResponseListnew.length; i++) {
                      String _petId = AnswerResponseListnew[i][0];
                      String _serviceId = AnswerResponseListnew[i][1];

                      print(" STRING _petId  ============ : ${_petId} ");
                      print(" STRING serviceId  ============ : ${_serviceId} ");

                      checkServices = checkServices + _serviceId + ', ';
                    }
                    print(
                        " STRING checkServices  ============ : ${checkServices} ");

                    final ResultModel result = await saveTempPetService(
                        checkServices);
                    debugPrint('2');

                    setState(() {
                      _result = result;
                    });
                    debugPrint('savePrePetService result : $result');

                    debugPrint('3');

                    if (_result.Result == "ADDED") {
                      debugPrint('****************************************');
                      // _resultServicesList =  getServices();
                      Navigator.push(context, SlideLeftRoute(
                          page: SelectPetForHostelPage(hostelId: widget.hostelId,
                              token: widget.token)));
                    }
                  }
                }
            ),


          ],
        ),
      ),
    );
  }
}