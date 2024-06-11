import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vetplanet/constant/colors.dart';
import 'package:vetplanet/models/messaging.dart';
import 'package:vetplanet/models/vet_model.dart';
import 'package:vetplanet/screens/veterinaryList.dart';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'package:vetplanet/screens/dash.dart';
import 'drawer.dart';
import 'dash.dart';

class WhyToChangeVet extends StatefulWidget {
  final String latitude;
  final String longitude;
  final String currentAddress;
  WhyToChangeVet({this.latitude, this.longitude, this.currentAddress});

  @override
  _WhyToChangeVetState createState() => _WhyToChangeVetState();
}

class _WhyToChangeVetState extends State<WhyToChangeVet> {

  void rebuildPage() {
    setState(() {});
  }
  final _globalKey = GlobalKey<ScaffoldMessengerState>();
  String _whyTo = "";
  final TextEditingController _controllerWhyTo = new TextEditingController();
  final GlobalKey<FormState> _formStateKey = GlobalKey<FormState>();


  Future<List> _future;

  String _vetLenght = "";

  Future<List<VetModel>> getVetToken() async {
    final _prefs = await SharedPreferences.getInstance();
    
    String _RegistrationId = _prefs.getInt('id').toString();
    debugPrint('Check getProfile apiUrl $apiUrl ');
    final String url = "$apiUrl/GetVetList/GetVetList";

    debugPrint('Check Inserted 1 ');
    debugPrint('Check Inserted _latitude : ${widget.latitude} ');
    debugPrint('Check Inserted longitude : ${widget.longitude} ');
    debugPrint('Check Inserted currentAddress : ${widget.currentAddress} ');

    var response = await http.post(
      Uri.parse(url),
      headers: {HttpHeaders.contentTypeHeader: 'application/json', HttpHeaders.authorizationHeader: bearerToken },
      body: json.encode(
          {
            "Lat":widget.latitude,
            "Long":widget.longitude,
            "Address":widget.currentAddress,
            "PatientId": _RegistrationId,
            "Operation":"D"
          }

      ),
    );
    debugPrint('Check 2}');
    if (response != null && response.statusCode == 200) {
      debugPrint('Check 3}');
      var _response = json.decode(response.body);
      debugPrint('Check 4  ${_response}');


      List<VetModel> _vet = _response
          .map<VetModel>(
              (_json) => VetModel.fromJson(_json))
          .toList();


      debugPrint('Check 5  ${_vet}');
      setState(() {
        _vetLenght = _vet.length.toString();
        debugPrint('Check _vetLenght &&&&&&&&&&&&&&&&&&&&&&&&&: $_vetLenght}');

      });
      return _vet;

    } else {
      debugPrint('Check 6');
      return [];
    }
  }

  final _scaffoldKey = GlobalKey<ScaffoldState>();
  _displaySnackBar(BuildContext context) {
    final snackBar = SnackBar(content:Text('No Visited Vet Found', style: TextStyle(fontSize: 20),));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  Future sendToTest (String Token, String contactNo, String whyTochange) async {
    final _prefs = await SharedPreferences.getInstance();
    String PetOwnerName = _prefs.getString('PetOwnerName');
    print("sendToTest PetOwnerName *******************$PetOwnerName");
    print("sendToTest Token *******************$Token");
    debugPrint('Check sendToTest 1');
    final response = await Messaging.sendTo(
      title:  "Feedback By: $PetOwnerName ContactNo: $contactNo" ,
      body:   whyTochange,
      fcmToken: Token,
    );
    debugPrint('Check sendToTest 2');
    debugPrint('Check sendToTest statusCode : ${response.statusCode}');

    if (response.statusCode == 200) {
      Navigator.pop(context);
    }
    if (response.statusCode != 200) {
      debugPrint('Check sendToTest 3');

      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content:
        Text('[${response.statusCode}] Error message: ${response.body}'),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: (){
        //on Back button press, you can use WillPopScope for another purpose also.
        // Navigator.pop(context); //return data along with pop
        Navigator.of(context)
            .pushReplacement(new MaterialPageRoute(builder: (context) => VeterinaryListPage(onPressed: rebuildPage)));
        return new Future(() => false); //onWillPop is Future<bool> so return false
      },
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

        drawer: DrawerPage(),

        body:Form(
          key: _formStateKey,
          child: SingleChildScrollView(
            child:  Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: <Widget>[
                  SizedBox(height: 50,),

                  TextFormField(
                    onSaved: (value) {
                      _whyTo = value;
                    },
                    maxLines: 5,
                    controller: _controllerWhyTo,
                    keyboardType: TextInputType.text,
                    //maxLength: 4,
                    showCursor: true,
                    decoration: InputDecoration(
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.black),
                        borderRadius: BorderRadius.circular(5.0),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.black),
                        borderRadius: BorderRadius.circular(5.0),
                      ),
                      //filled: true,
                      // fillColor: Color(0xFFF2F3F5),
                      hintStyle: TextStyle(
                        color: appColor, fontSize: 12,fontFamily: "Camphor",
                        fontWeight: FontWeight.w500,
                      ),
                      hintText: "Share your Feedback",
                    ),
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'Please Share your Feedback';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 35,),
                  InkWell(
                    onTap: () async{
                      if (_formStateKey.currentState.validate()) {
                        _formStateKey.currentState.save();

                        final String whyTochange = _whyTo;

                        final List<VetModel> vetTokenResult = await getVetToken();
                        if(vetTokenResult.length > 0){
                          for(var i=0;i<1;i++){

                            String token = vetTokenResult[i].Token;
                            String contactNo = vetTokenResult[i].User_ContactNo;

                            print("token: $token");
                            print("contactNo: $contactNo");
                            print("whyTochange: $whyTochange");
                            sendToTest(token, contactNo, whyTochange);


                          }
                        }
                        else{
                          debugPrint('**');
                          _displaySnackBar(context);

                        }

                      }
                    },
                    child: Container(
                      color: appColor,
                      child: Padding(
                        padding: const EdgeInsets.only(top:15, bottom: 15, left: 85, right: 85),
                        child: Text("Share",style: TextStyle(color: Colors.white,fontFamily: "Camphor",
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
    );
  }
}
