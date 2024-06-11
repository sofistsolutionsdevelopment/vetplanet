import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vetplanet/constant/colors.dart';
import 'package:vetplanet/models/result_model.dart';
import 'package:vetplanet/screens/selectPetForHostel.dart';
import 'package:vetplanet/transitions/slide_route.dart';
import 'dash.dart';
import 'package:intl/intl.dart';

class BookNowPayAtHostelPage extends StatefulWidget {

  final String hostelId;
  final String token;
  final Function onPressed;

  BookNowPayAtHostelPage({ this.hostelId, this.token, this.onPressed});
  @override
  _BookNowPayAtHostelPageState createState() => _BookNowPayAtHostelPageState();
}

class _BookNowPayAtHostelPageState extends State<BookNowPayAtHostelPage> {


  DateTime fromDate = DateTime.now();
  final _globalKey = GlobalKey<ScaffoldMessengerState>();
  DateTime toDate = DateTime.now();

  String _fromDate ="Select From Date";
  String _toDate = "Select To Date";
  String _from ="Select From Date";
  String _to = "Select To Date";


  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final GlobalKey<FormState> _formStateKey = GlobalKey<FormState>();

  void rebuildPage() {
    setState(() {});
  }

 // DateTime date =  DateTime.now();

  TextEditingController _fromDatecontroller = new TextEditingController();
  TextEditingController _toDatecontroller = new TextEditingController();

  var myFormat = DateFormat('dd/MM/yyyy');
  Future<void> _selectFromDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: fromDate,
        firstDate: DateTime(2015, 8),
        lastDate: DateTime.now());
    setState(() {
      fromDate = picked ?? fromDate;
      _from = DateFormat('yyyy-MM-dd').format(fromDate);
      _fromDate = DateFormat('dd/MM/yyyy').format(fromDate);
      debugPrint('_fromDate : $_fromDate' );

    });
  }

  Future<void> _selectToDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: fromDate,
        firstDate: fromDate,
        lastDate: DateTime.now());
    setState(() {
      toDate = picked ?? toDate;
      _to = DateFormat('yyyy-MM-dd').format(toDate);
      _toDate = DateFormat('dd/MM/yyyy').format(toDate);
      debugPrint('_toDate : $_toDate' );

    });
  }

  ResultModel _result;

  Future<ResultModel> payAtHostel(String _from, String _to) async{
    final _prefs = await SharedPreferences.getInstance();
    
    String _RegistrationId = _prefs.getInt('id').toString();
    debugPrint('Check Inserted apiUrl $apiUrl ');
    debugPrint('Check Inserted _RegistrationId $_RegistrationId ');


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
            "StatusId":"1"
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
  _displaySnackBar(BuildContext context) {
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
                    fontWeight: FontWeight.w900,fontSize: 18, color: Colors.white),textAlign:TextAlign.center ,),
              ),
            ),
            content: Text('Booked Sucessfully!',style:TextStyle(fontFamily: "Camphor",
                fontWeight: FontWeight.w500, fontSize: 16,color: Colors.black),),
            actions: <Widget>[
              TextButton(
                 // color: appColor,
                  child:Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: Text('Ok',style: TextStyle(color: appColor,fontSize: 16,  fontFamily: "Camphor",
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



  @override
  Widget build(BuildContext context) {

    return WillPopScope(
      onWillPop: (){
        //on Back button press, you can use WillPopScope for another purpose also.
        // Navigator.pop(context); //return data along with pop
        Navigator.of(context)
            .pushReplacement(new MaterialPageRoute(builder: (context) => SelectPetForHostelPage(onPressed: rebuildPage, token:widget.token, hostelId:widget.hostelId)));
        return new Future(() => false); //onWillPop is Future<bool> so return false
      },
      child: ScaffoldMessenger(
        key: _globalKey,
        child: Scaffold(
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
          body:ModalProgressHUD(
            inAsyncCall: _isInAsyncCall,
            // demo of some additional parameters
            opacity: 0.5,
            progressIndicator: CircularProgressIndicator(),
            child: Container(
              child: SingleChildScrollView(
                child: Form(
                  key: _formStateKey,
                  child: Column(
                    children: <Widget>[
                      SizedBox(height: 100),
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
                                      labelText:('$_fromDate'),labelStyle: TextStyle(fontFamily: "Camphor", fontWeight: FontWeight.w900,fontSize: 20,color: Colors.black),
                                      hintText: ('$_fromDate'),hintStyle: TextStyle(fontFamily: "Camphor", fontWeight: FontWeight.w900,fontSize: 20),
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
                                      labelText:('$_toDate'),labelStyle: TextStyle(fontFamily: "Camphor", fontWeight: FontWeight.w900,fontSize: 20,color: Colors.black),
                                      hintText: ('$_toDate'),hintStyle: TextStyle(fontFamily: "Camphor", fontWeight: FontWeight.w900,fontSize: 20),
                                      // hintText: ("Select Date"),
                                    ),
      
      
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
      
                     SizedBox(height: 50.0),
      
                      InkWell(
                        onTap: () async {
      
      
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
      
                              final ResultModel result = await payAtHostel(_from,_to);
                              debugPrint('Check Inserted result : $result');
                              setState(() {
                                _result = result;
                              });
      
                              if (_result.Result == "ADDED" ) {
      
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
                        child: Container(
                          color: appColor,
                          child: Padding(
                            padding: const EdgeInsets.only(top:10, bottom: 10, left: 35, right: 35),
                            child: Text("Pay at Hotel",style: TextStyle(color: Colors.white,fontFamily: "Camphor",
                                fontWeight: FontWeight.w900, fontSize: 16),),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
      
            ),
          ),
        ),
      ),
    );

  }
}
