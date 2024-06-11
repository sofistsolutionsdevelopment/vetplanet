import 'dart:convert';
import 'dart:io';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vetplanet/constant/colors.dart';
import 'package:vetplanet/models/hostelMessaging.dart';
import 'package:vetplanet/models/pet_model.dart';
import 'package:vetplanet/models/result_model.dart';
import 'package:vetplanet/transitions/slide_route.dart';
import 'package:intl/intl.dart';
import 'dash.dart';
import 'drawer.dart';
import 'hostelList.dart';
import 'hostelServicesDialog.dart';

class SelectPetForHostelPage extends StatefulWidget {
  final Function onPressed;
  final String hostelId;
  final String token;

  SelectPetForHostelPage({this.onPressed, this.hostelId, this.token });
  @override
  _SelectPetForHostelPageState createState() => _SelectPetForHostelPageState();
}

class _SelectPetForHostelPageState extends State<SelectPetForHostelPage> {

  void rebuildPage() {
    setState(() {});
  }

  final _globalKey = GlobalKey<ScaffoldMessengerState>();

  List AnswerResponseListnew = List();
  String patientPetId;
  String petName;
  double amount = 0.0;
  String checkPet= "";
  String serviceSelected= "NoServicesSelected";

  List<PetModel> _resultPet;
  List petListData = List(); //edited line
  Future<PetModel> _resultPetList;
  Future<PetModel> getPets() async {

    print("1 ***");
    final _prefs = await SharedPreferences.getInstance();
    
    String _RegistrationId = _prefs.getInt('id').toString();
    debugPrint('Check Inserted apiUrl $apiUrl ');
    debugPrint('Check Inserted _RegistrationId $_RegistrationId ');


    final String url = "$apiUrl/GetPetList/GetPetList";

    print("2 ***");
    print("hostelId *** ${widget.hostelId}");
    var response = await http.post(
      Uri.parse(url),
      headers: {HttpHeaders.contentTypeHeader: 'application/json', HttpHeaders.authorizationHeader: bearerToken },
      body: json.encode(
          {
            "PatientId": _RegistrationId
          }
      ),
    );

    print("3 ***");

    print("statusCode *** ${response.statusCode}");
    if(response.statusCode == 200){
      final String responseString = response.body;
      print("responseString *** ${responseString}");

      this.setState(() {
        petListData = json.decode(response.body);
        print("speciesListData *** ${petListData}");

        _resultPet = petListData
            .map<PetModel>(
                (_json) => PetModel.fromJson(_json))
            .toList();
        print("_resultPet *** ${_resultPet}");
        print("_resultPet length*** ${_resultPet.length}");
        for (var i = 0; i < _resultPet.length; i++) {
          amount = amount + double.parse("${_resultPet[i].TotalHostelServiceRate}");
          if(_resultPet[i].HostelServiceCount != 0){
            serviceSelected = "ServicesSelected";
          }
        }
        print("_resultPet amount *** ${amount}");

      });
      return petModelFromJson(responseString);
    }else{
      return null;
    }
  }


  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final GlobalKey<FormState> _formStateKey = GlobalKey<FormState>();

  DateTime fromDate = DateTime.now();
  DateTime toDate = DateTime.now();

  String _fromDate ="Select From Date";
  String _toDate = "Select To Date";
  String _from ="Select From Date";
  String _to = "Select To Date";


  DateTime from;

  TextEditingController _fromDatecontroller = new TextEditingController();
  TextEditingController _toDatecontroller = new TextEditingController();

  var myFormat = DateFormat('dd/MM/yyyy');
  Future<void> _selectFromDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate:  DateTime.now(),
        firstDate: DateTime.now(),
        lastDate: DateTime(3015, 1));
    setState(() {
     _toDate = "Select To Date";
     _to = "Select To Date";
      fromDate = picked ?? fromDate;
      from = picked;
      _from = DateFormat('yyyy-MM-dd').format(fromDate);
      _fromDate = DateFormat('dd/MM/yyyy').format(fromDate);
      debugPrint('_fromDate : $_fromDate' );
    });
  }

  Future<void> _selectToDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: from,
        firstDate: from,
        lastDate: DateTime(3015, 1));
    setState(() {
      toDate = picked ?? toDate;
      _to = DateFormat('yyyy-MM-dd').format(toDate);
      _toDate = DateFormat('dd/MM/yyyy').format(toDate);
      debugPrint('_toDate : $_toDate' );

    });
  }

  ResultModel _result;

  Future<ResultModel> payAtHostel(String _from, String _to, String _fromDate, String _toDate) async{
    final _prefs = await SharedPreferences.getInstance();
    
    String _RegistrationId = _prefs.getInt('id').toString();
    debugPrint('Check Inserted apiUrl $apiUrl ');
    debugPrint('Check Inserted _RegistrationId $_RegistrationId ');
    String PetOwnerName = _prefs.getString('PetOwnerName');
    print("sendToTest PetOwnerName *******************$PetOwnerName");

    final String url = "$apiUrl/SaveHostelSlot/SaveHostelSlot";


    debugPrint('Check Inserted 1 ');

    var response = await http.post(
      Uri.parse(url),
      headers: {HttpHeaders.contentTypeHeader: 'application/json', HttpHeaders.authorizationHeader: bearerToken },
      body: json.encode(
          {
            "HostelId":widget.hostelId,
            "PatientId":_RegistrationId,
            "FromDate":_from,
            "ToDate":_to,
            "StatusId":"1",
            "Feedback":"Services Booked by $PetOwnerName Between $_fromDate - $_toDate"

          }
      ),
    );

    debugPrint('Check Inserted 2 ');
    debugPrint('Check Inserted statusCode ${response.statusCode} ');
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
  _displayBookSnackBar(BuildContext context) {
    final snackBar = SnackBar(content:Text('Unable to Book. Please Try again.', style: TextStyle(fontSize: 20),));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  bool _isInAsyncCall = false;

  Future<String> approved() {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title:Container(
              color: appColor,
              child: Padding(
                padding: const EdgeInsets.only(left:1, right:1, top:12, bottom:12),
                child: Text('Vet Planet',style: TextStyle(fontFamily: "Camphor",
                    fontWeight: FontWeight.w900,fontSize: 18, color: Colors.black),textAlign:TextAlign.center ,),
              ),
            ),
            content: Text('Booked Sucessfully!',style:TextStyle(fontFamily: "Camphor",
                fontWeight: FontWeight.w500, fontSize: 16,color: Colors.black),),
            actions: <Widget>[
              TextButton(
                // color: appColor,
                  child:Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: Text('Ok',style: TextStyle(color: appColorlight,fontSize: 16,  fontFamily: "Camphor",
                      fontWeight: FontWeight.w900,),),
                  ),
                  onPressed: () {

                    Navigator.push(context, SlideLeftRoute(page: DashPage(onPressed: rebuildPage,)));

                    // Navigator.pushReplacement(context, SlideLeftRoute(page: VetRegistration()));
                  }
              ),
            ],
          );
        });
  }


  Future sendToTest (String Token, String _fromDate, String _toDate) async {
    final _prefs = await SharedPreferences.getInstance();
    String PetOwnerName = _prefs.getString('PetOwnerName');
    print("sendToTest PetOwnerName *******************$PetOwnerName");
    print("sendToTest Token *******************$Token");
    debugPrint('Check sendToTest 1');
    final response = await HostelMessaging.sendTo(
      title:  "Appoinment By: $PetOwnerName" ,
      body:   "Services Booked by $PetOwnerName Between $_fromDate - $_toDate",
      fcmToken: Token,
    );
    debugPrint('Check sendToTest 2');

    if (response.statusCode != 200) {
      debugPrint('Check sendToTest 3');

      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content:
        Text('[${response.statusCode}] Error message: ${response.body}'),
      ));
    }
  }


  _displaySnackBar(BuildContext context) {
    final snackBar = SnackBar(content: Text('Please select atleast one Service for Pet', style: TextStyle(fontSize: 20),));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  @override
  void initState() {
    _resultPetList =  getPets();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: (){
        //on Back button press, you can use WillPopScope for another purpose also.
        // Navigator.pop(context); //return data along with pop
        Navigator.of(context)
            .pushReplacement(new MaterialPageRoute(builder: (context) => HostelListPage(onPressed: rebuildPage,)));
        return new Future(() => false); //onWillPop is Future<bool> so return false
      },
      child: ScaffoldMessenger(
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
      
          body:  ModalProgressHUD(
            inAsyncCall: _isInAsyncCall,
            // demo of some additional parameters
            opacity: 0.5,
            progressIndicator: CircularProgressIndicator(),
            child: Form(
              key: _formStateKey,
              child: Column (children: <Widget>[
                Expanded(
                  child: FutureBuilder<PetModel>(
                      future: _resultPetList,
                      builder: (context, snapshot)
                      {
      
                        return  ListView.builder(
                          itemCount: _resultPet == null ? 0 : _resultPet.length,
                          itemBuilder: (BuildContext context, int index){
      
                            return Column(
                                children: <Widget>[
                                  if(_resultPet[index].HostelServiceCount == 0)
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: ListTile(
                                      trailing:  InkWell(
                                        onTap: (){
                                          patientPetId = _resultPet[index].PatientPetId.toString();
                                        print('changed to patientPetId $patientPetId');
                                        Navigator.push(context, SlideLeftRoute(page: HostelServicesDialog(hostelId:widget.hostelId, patientPetId:patientPetId, token:widget.token)));
                                        },
                                        child: Text("Add Services",style: TextStyle(fontSize:18, fontFamily: "Camphor",
                                            fontWeight: FontWeight.w900,color: Colors.grey),),
                                      ),
                                     /* IconButton(
                                        icon: new Icon(Icons.check_circle, color: Colors.grey,),
                                        tooltip: 'Services',
                                        onPressed: () {
                                          patientPetId = _resultPet[index].PatientPetId.toString();
                                          print('changed to patientPetId $patientPetId');
                                          Navigator.push(context, SlideLeftRoute(page: ServicesDialog(groomingId:widget.groomingId, patientPetId:patientPetId, shopId: widget.shopId, token:widget.token)));
                                        },
                                      ),*/
                                      title: Text(_resultPet[index].PetName,style: TextStyle(fontSize:18, fontFamily: "Camphor",
                                          fontWeight: FontWeight.w700,color: Colors.black),),
                                      leading:  ClipRRect(
                                        borderRadius: BorderRadius.circular(50),
                                        child: Image.network(
                                          "${_resultPet[index].Photograph}",
                                          width: 50,
                                          height: 50,
                                          fit: BoxFit.fill,
                                        ),
                                      ),
                                    ),
                                  ),
                                  if(_resultPet[index].HostelServiceCount != 0)
                                  Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: ListTile(
                                        trailing: InkWell(
                                          onTap: (){
                                            patientPetId = _resultPet[index].PatientPetId.toString();
                                            print('changed to patientPetId $patientPetId');
                                            Navigator.push(context, SlideLeftRoute(page: HostelServicesDialog(hostelId:widget.hostelId, patientPetId:patientPetId, token:widget.token)));
                                          },
                                          child: Text("Add Services",style: TextStyle(fontSize:18, fontFamily: "Camphor",
                                              fontWeight: FontWeight.w900,color: Colors.green),),
                                        ),
                                       /* IconButton(
                                          icon: new Icon(Icons.check_circle, color: Colors.green,),
                                          tooltip: 'Services',
                                          onPressed: () {
                                            patientPetId = _resultPet[index].PatientPetId.toString();
                                            print('changed to patientPetId $patientPetId');
                                            Navigator.push(context, SlideLeftRoute(page: ServicesDialog(groomingId:widget.groomingId, patientPetId:patientPetId, shopId: widget.shopId, token:widget.token)));
      
                                          },
                                        ),*/
                                        title: Text(_resultPet[index].PetName,style: TextStyle(fontSize:18, fontFamily: "Camphor",
                                            fontWeight: FontWeight.w700,color: Colors.black),),
                                        leading:  ClipRRect(
                                          borderRadius: BorderRadius.circular(50),
                                          child: Image.network(
                                            "${_resultPet[index].Photograph}",
                                            width: 50,
                                            height: 50,
                                            fit: BoxFit.fill,
                                          ),
                                        ),
                                        subtitle: Text("${_resultPet[index].TotalHostelServiceRate.toString()}/-",style: TextStyle(fontSize:18, fontFamily: "Camphor",
                                            fontWeight: FontWeight.w700,color: Colors.black),),
      
      
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
                  ),
                ),
                //if(amount != 0.0)
      
                if(amount != 0.0)
                  Column(
                    children: <Widget>[
                      SizedBox(height: 15,),
                      Text("Amount : $amount/-", style: TextStyle(fontSize:16, fontFamily: "Camphor",
                          fontWeight: FontWeight.w900,color: appColor),),
      
                      Padding(
                        padding: const EdgeInsets.only(right:25, left:25),
                        child: Container(
                          margin: EdgeInsets.symmetric(vertical: 10),
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
                              SizedBox(height: 5,),
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
                    ],
                  ),
                SizedBox(height: 20,),
      
      
              ]),
            ),
          ),
      
      
          bottomNavigationBar:
      
          Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              if(amount != 0.0)
              Container(
                margin: EdgeInsets.all(10),
                height: 50,
                width: double.infinity,
                //decoration: BoxDecoration(s
                //  border:Border(top: BorderSide(color: Colors.grey, width: 1),),
                //),
                child: ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(appColorlight)
                  ),
                  onPressed: ()async{
                    if (_formStateKey.currentState.validate()) {
                _formStateKey.currentState.save();
      
                setState(() {
                  _isInAsyncCall = true;
                });
                debugPrint('_fromDate : ${_fromDate}' );
                debugPrint('_toDate : $_toDate' );
      
                if(_fromDate == "Select From Date" && _toDate != "Select To Date"){
                  setState(() {
                    _isInAsyncCall = false;
                  });
                  final snackBar = SnackBar(content:Text('Please Select From Date', style: TextStyle(fontSize: 20),));
                  ScaffoldMessenger.of(context).showSnackBar(snackBar);
                }
                if(_fromDate != "Select From Date" && _toDate == "Select To Date" ){
                  setState(() {
                    _isInAsyncCall = false;
                  });
                  final snackBar = SnackBar(content:Text('Please Select To Date', style: TextStyle(fontSize: 20),));
                  ScaffoldMessenger.of(context).showSnackBar(snackBar);
                }
                if(_fromDate == "Select From Date" && _toDate == "Select To Date"){
                  setState(() {
                    _isInAsyncCall = false;
                  });
                  final snackBar = SnackBar(content:Text('Please Select From Date and To Date', style: TextStyle(fontSize: 20),));
                  ScaffoldMessenger.of(context).showSnackBar(snackBar);
                }
                if(_fromDate != "Select From Date" && _toDate != "Select To Date"){
                  print("_from : $_from");
                  print("_to : $_to");
      
                  final ResultModel result = await payAtHostel(_from, _to, _fromDate, _toDate);
                  debugPrint('Check Inserted result : $result');
                  setState(() {
                    _result = result;
                  });
      
                  if (_result.Result == "ADDED" ) {
      
                    if(widget.token != "-"){
                      String token = widget.token;
                      debugPrint('Check _saveappointmentresult token : $token');
                      sendToTest(token, _fromDate, _toDate);
                    }
      
                    debugPrint('SharedPreferences id: ${_result.Id}' );
      
                    approved();
      
                    // Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => LogInPage()));
                    //  Navigator.pop(context);
      
                  }
                  else
                  {
                    setState(() {
                      _isInAsyncCall = false;
                    });
      
                    debugPrint('**');
                    _displaySnackBar(context);
                  }
      
      
                }
                }
                  },
                  child: Text("Confirm Booking",style: TextStyle(color: Colors.white,fontFamily: "Camphor",
                      fontWeight: FontWeight.w900, fontSize: 16),),
                ),
              ),
              if(amount == 0.0)
                Container(),
            ],
          ),
      
      
      
        ),
      ),
    );
  }
}
