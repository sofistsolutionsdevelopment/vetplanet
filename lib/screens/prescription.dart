import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
// import 'package:ext_storage/ext_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vetplanet/constant/colors.dart';
import 'package:intl/intl.dart';
import 'package:vetplanet/models/prescriptionNote_model.dart';
import 'dash.dart';
import 'drawer.dart';
import 'package:http/http.dart' as http;


class PrescriptionPage extends StatefulWidget {
  final String vetId;
  final String petId;

  PrescriptionPage({ this.vetId, this.petId });
  @override
  _PrescriptionPageState createState() => _PrescriptionPageState();
}

class _PrescriptionPageState extends State<PrescriptionPage> {
  DateTime fromDate = DateTime.now();
  DateTime toDate = DateTime.now();

  String _fromDate ="Select From Date";
  String _toDate = "Select To Date";

  String _from ="Select From Date";
  String _to ="Select To Date";
  String operation = "";

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final GlobalKey<FormState> _formStateKey = GlobalKey<FormState>();

  TextEditingController _fromDatecontroller = new TextEditingController();
  TextEditingController _toDatecontroller = new TextEditingController();
  DateTime from;
  var myFormat = DateFormat('dd/MM/yyyy');
  Future<void> _selectFromDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(2000),
        lastDate: DateTime.now());
    setState(() {
      _toDate = "Select To Date";
      _to = "Select To Date";
      fromDate = picked ?? fromDate;
      from = picked;
      _fromDate = DateFormat('dd-MM-yyyy').format(fromDate);
      _from = DateFormat('yyyy-MM-dd').format(fromDate);
      debugPrint('_fromDate : $_fromDate' );
      debugPrint('_from : $_from' );
    });
  }

  Future<void> _selectToDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: from,
        firstDate: from,
        lastDate: DateTime.now());
    setState(() {
      toDate = picked ?? toDate;
      _toDate = DateFormat('dd-MM-yyyy').format(toDate);
      _to = DateFormat('yyyy-MM-dd').format(toDate);
      debugPrint('_toDate : $_toDate' );
      debugPrint('_toDate : $_to' );

    });
  }

  var splitPrescription1;
  var splitPrescription2;
  Future<List> _futurPrescription;
  String _prescriptionLenght = "";
  Future<List<PrescriptionNoteModel>> getPrescription(String _from, String _to, String operation) async {
    final _prefs = await SharedPreferences.getInstance();
    
    String _RegistrationId = _prefs.getInt('id').toString();
    debugPrint('Check Inserted apiUrl $apiUrl ');
    debugPrint('Check Inserted _RegistrationId $_RegistrationId ');
    debugPrint('Check Inserted _from ${_from} ');
    debugPrint('Check Inserted _to ${_to} ');
    debugPrint('Check Inserted vetId ${widget.vetId} ');
    debugPrint('Check Inserted petId ${widget.petId} ');
    debugPrint('Check Inserted petId ${_RegistrationId} ');

    final String url = "$apiUrl/GetPrescriptionById/GetPrescriptionById";

    debugPrint('Check Inserted 1 ');
    var response = await http.post(
      Uri.parse(url),
      headers: {HttpHeaders.contentTypeHeader: 'application/json', HttpHeaders.authorizationHeader: bearerToken },
      body: json.encode(
          {
            "VetId":widget.vetId,
            "PatientId":_RegistrationId,
            "PatientPetId":widget.petId,
            "FromDate":_from,
            "ToDate":_to,
            "Operation":operation
          }


      ),
    );

    debugPrint('Check 2}');
    if (response != null && response.statusCode == 200) {
      debugPrint('Check 3}');
      var _response = json.decode(response.body);
      debugPrint('Check 4  ${_response}');


      List<PrescriptionNoteModel> _prescription= _response
          .map<PrescriptionNoteModel>(
              (_json) => PrescriptionNoteModel.fromJson(_json))
          .toList();


      debugPrint('Check 5  ${_prescription}');
      setState(() {
        _prescriptionLenght = _prescription.length.toString();
        debugPrint('Check _prescriptionLenght &&&&&&&&&&&&&&&&&&&&&&&&&: $_prescriptionLenght}');

      });
      return _prescription;

    } else {
      debugPrint('Check 6');
      return [];
    }
  }


  Future<String> approved() {
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
            content: Text('Prescription Downloaded Sucessfully!',style:TextStyle(fontFamily: "Camphor",
                fontWeight: FontWeight.w500, fontSize: 16,color: Colors.black),),
            actions: <Widget>[

              ElevatedButton(
                // color: Colors.red,
                child: Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: Text('Ok',style: TextStyle(color: appColor,fontSize: 16,  fontFamily: "Camphor",
                    fontWeight: FontWeight.w900,),),
                ),
                onPressed: () async{
                  Navigator.pop(context);
                },
                // onPressed: ()=> exit(0),

              ),
            ],
          );
        });
  }



  Future download(Dio dio, String url, String savePath) async {
    try {
      Response response = await dio.get(
        url,
        onReceiveProgress: showDownloadProgress,
        //Received data with List<int>
        options: Options(
            responseType: ResponseType.bytes,
            followRedirects: false,
            validateStatus: (status) {
              return status < 500;
            }),
      );
      print(response.headers);
      File file = File(savePath);
      var raf = file.openSync(mode: FileMode.write);
      // response.data is List<int> type
      raf.writeFromSync(response.data);
      await raf.close();
    } catch (e) {
      print(e);
    }
  }

  void showDownloadProgress(received, total) {
    if (total != -1) {
      print((received / total * 100).toStringAsFixed(0) + "%");
      if((received / total * 100).toStringAsFixed(0) + "%" == "100%")
        {
          print("Successfully Downloaded");
          approved();
        }
    }
  }

  var dio = Dio();

  void getPermission() async {
    print("getPermission");
    Map<Permission, PermissionStatus> permissions =
    await [Permission.storage].request();
  }



  @override
  void initState() {
    getPermission();
    DateTime today = DateTime.now();
    _from = DateFormat('yyyy-MM-dd').format(today);
    _to = DateFormat('yyyy-MM-dd').format(today);
    operation = "L";
    _futurPrescription =  getPrescription(_from, _to, operation);
    super.initState();
  }


  void rebuildPage() {
    setState(() {});
  }


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
      body: Form(
        key: _formStateKey,
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(right:15, left:15),
              child: Container(
                margin: EdgeInsets.symmetric(vertical: 5),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    InkWell(
                      onTap: () => _selectFromDate(context),
                      child: IgnorePointer(
                        child: TextField(
                          controller: _fromDatecontroller,
                          decoration: InputDecoration(
                            labelText:('$_fromDate'),labelStyle: TextStyle(fontFamily: "Camphor", fontWeight: FontWeight.w500,fontSize: 14,color: Colors.black),
                            hintText: ('$_fromDate'),hintStyle: TextStyle(fontFamily: "Camphor", fontWeight: FontWeight.w500,fontSize: 14),
                            // hintText: ("Select Date"),
                          ),


                        ),
                      ),
                    ),
                    SizedBox(height: 25,),
                    InkWell(
                      onTap: () => _selectToDate(context),
                      child: IgnorePointer(
                        child: TextField(
                          controller: _toDatecontroller,
                          decoration: InputDecoration(
                            labelText:('$_toDate'),labelStyle: TextStyle(fontFamily: "Camphor", fontWeight: FontWeight.w500,fontSize: 14,color: Colors.black),
                            hintText: ('$_toDate'),hintStyle: TextStyle(fontFamily: "Camphor", fontWeight: FontWeight.w500,fontSize: 14),
                            // hintText: ("Select Date"),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 35,),
            InkWell(
              onTap: () async {


                if (_formStateKey.currentState.validate()) {
                  _formStateKey.currentState.save();


                  debugPrint('_fromDate : ${_fromDate}' );
                  debugPrint('_toDate : $_toDate' );

                  if(_fromDate == "Select From Date" && _toDate != "Select To Date"){
                    // final snackBar = SnackBar(content:Text('Please Select From Date', style: TextStyle(fontSize: 20),));
                    // _scaffoldKey.currentState.showSnackBar(snackBar);
                  }
                  if(_fromDate != "Select From Date" && _toDate == "Select To Date" ){
                    // final snackBar = SnackBar(content:Text('Please Select To Date', style: TextStyle(fontSize: 20),));
                    // _scaffoldKey.currentState.showSnackBar(snackBar);
                  }
                  if(_fromDate == "Select From Date" && _toDate == "Select To Date"){
                    // final snackBar = SnackBar(content:Text('Please Select From Date and To Date', style: TextStyle(fontSize: 20),));
                    // _scaffoldKey.currentState.showSnackBar(snackBar);
                  }
                  if(_fromDate != "Select From Date" && _toDate != "Select To Date"){
                     operation = "D";
                    _futurPrescription = getPrescription(_from, _to, operation);
                  }
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
            SizedBox(height: 10,),

            if(_prescriptionLenght != "0")
            Expanded(
              child: FutureBuilder(
                future: _futurPrescription,
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return Center(child: Text(''));
                  }
                  if (snapshot.hasData) {
                    List<PrescriptionNoteModel> _prescription = snapshot.data;
                    return ListView.builder(
                      shrinkWrap: true,
                      itemCount: _prescription == null ? 0 : _prescription.length,
                      itemBuilder: (BuildContext context, int index) {
                        return SingleChildScrollView(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: ExpansionTile(
                              title: Text(
                                "${_prescription[index].Date}",style: TextStyle(fontSize:18, fontFamily: "Camphor",
                                  fontWeight: FontWeight.w700,color: Colors.black),
                              ),
                              children: <Widget>[
                                if("${_prescription[index].PrescriptionUpload}" != "-")
                                  ClipRRect(
                                    // borderRadius: BorderRadius.circular(100),
                                    child: Image.network(
                                      "${_prescription[index].PrescriptionUpload}",
                                      width: 100,
                                      height: 100,
                                      fit: BoxFit.fill,
                                    ),
                                  ),
                                ListTile(
                                  dense: true,
                                  contentPadding: EdgeInsets.fromLTRB(20, -80, 0, -80),
                                  title: Text("Prescription : ${_prescription[index].Prescription}",style: TextStyle(fontSize:16, fontFamily: "Camphor",
                                      fontWeight: FontWeight.w500,color: Colors.black),),
                                ),
                                ListTile(
                                  dense: true,
                                  contentPadding: EdgeInsets.fromLTRB(20, -80, 0, -80),
                                  title: Text("Dosage : ${_prescription[index].Dosage}",style: TextStyle(fontSize:16, fontFamily: "Camphor",
                                      fontWeight: FontWeight.w500,color: Colors.black),),
                                ),
                                ListTile(
                                  dense: true,
                                  contentPadding: EdgeInsets.fromLTRB(20, -80, 0, -80),
                                  title: Text("Duration : ${_prescription[index].Duration}",style: TextStyle(fontSize:16, fontFamily: "Camphor",
                                      fontWeight: FontWeight.w500,color: Colors.black),),
                                ),
                                ListTile(
                                  dense: true,
                                  contentPadding: EdgeInsets.fromLTRB(20, -80, 0, -80),
                                  title: Text("Remarks : ${_prescription[index].Remarks}",style: TextStyle(fontSize:16, fontFamily: "Camphor",
                                      fontWeight: FontWeight.w500,color: Colors.black),),
                                ),
                                if ("${_prescription[index].PrescriptionUpload}" != "-")
                                  Align(
                                    alignment:Alignment.centerRight,
                                    child: ElevatedButton.icon(
                                      onPressed: () async {
                                        String imgUrl = "${_prescription[index].PrescriptionUpload}";
                                        var splitString = imgUrl.split(".");
                                        splitPrescription1 = splitString[1];
                                        splitPrescription2 = splitString[2];

                                        print("splitPrescription1 : $splitPrescription1");
                                        print("splitPrescription2 : $splitPrescription2");
                                        // // String path =
                                        // // await ExtStorage.getExternalStoragePublicDirectory(
                                        // //     ExtStorage.DIRECTORY_DOWNLOADS);
                                        // // //String fullPath = tempDir.path + "/boo2.pdf'";
                                        // // String fullPath = "$path/Prescription.$splitPrescription2";
                                        // //String fullPath = "$path";
                                        // print('full path ${fullPath}');

                                        // download(dio, imgUrl, fullPath);
                                      },
                                      icon: Icon(
                                        Icons.file_download,
                                        color: Colors.white,
                                      ),
                                      // color: Colors.green,
                                      // textColor: Colors.white,
                                      label: Text('Download',style: TextStyle(fontSize:16, fontFamily: "Camphor",
                                          fontWeight: FontWeight.w700,color: Colors.white),),),
                                  ),

                                SizedBox(height: 5,),
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
            ),
            if(_prescriptionLenght == "0")
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[

                  SizedBox(height: 25,),

                  Center(child: Align(
                    child: Text("No Prescription Details Found", style: TextStyle(fontSize: 20, color: Colors.black,fontFamily: "Camphor",
                      fontWeight: FontWeight.w700,),),
                  )),
                ],
              ),


          ],
        ),
      ),
    );
  }
}



