import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:vetplanet/constant/colors.dart';
import 'package:vetplanet/models/result_model.dart';
import 'package:vetplanet/transitions/slide_route.dart';

import 'dash.dart';


class ForgetPasswordPage extends StatefulWidget {
  @override
  _ForgetPasswordPageState createState() => _ForgetPasswordPageState();
}

class _ForgetPasswordPageState extends State<ForgetPasswordPage> {

  final GlobalKey<FormState> _formStateKey = GlobalKey<FormState>();
  final _globalKey = GlobalKey<ScaffoldMessengerState>();
  String _contactNo;
  String _password;
  String _confirmpassword;

  bool _showPassword1 = false;
  void _togglevisibility1() {
    setState(() {
      _showPassword1 = !_showPassword1;
    });
  }

  bool _showPassword2 = false;
  void _togglevisibility2() {
    setState(() {
      _showPassword2 = !_showPassword2;
    });
  }

  TextEditingController _passwordController = new TextEditingController();

  ResultModel _result;


  Future<ResultModel> forgetPassword( String contactNo, String confirmPassword) async{



    final String apiUrl = "http://sofistsolutions.in/VetPlanetAPPAPI/API/ForgotPassword/ForgotPassword";

    debugPrint('Check Inserted 1 ');

   /* final response = await http.post(apiUrl, body:
    {
      "ContactNo": contactNo,
      "Password": confirmPassword
    }
    );*/
    var response = await http.post(
      Uri.parse(apiUrl),
      headers: {HttpHeaders.contentTypeHeader: 'application/json', HttpHeaders.authorizationHeader: 'bearer VA5kBnSw50cbuJ4YoAVkl4XyFTA312fRtKF4GxlmkUcl3PQJBKvvtogvT_0syd6ZtsZ4-1zFK6_liq5dQpyMq2tOA7vCtZ332qal7LGyBxBvv4mtD461lwGhNtprYd8PyIR40bBsoBc7nMElIniHJXAu1V04eO5c7sNLHOGypeG70Zn06yQr-0i_eFbsCRg6kMWjkao3RZwDfXVra5JQ5I7Pr1CbSgYez6rbYLMbH2LL6K8VcpmUvs45WpLe4UjPpChygW96LCoxVh7YtNa74n1Bje4sDdGLZowZJWwe7F9P7ijy1nVyw_v5K-8MqzlI' },
      body: json.encode(
          {
            "ContactNo":contactNo,
            "Password":confirmPassword
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

  final _scaffoldKey = GlobalKey<ScaffoldState>();
  _displaySnackBar(BuildContext context) {
    final snackBar = SnackBar(content:Text('Invalid Mobile No', style: TextStyle(fontSize: 20),));
    _globalKey.currentState.showSnackBar(snackBar);
  }

  bool _isInAsyncCall = false;

  final TextEditingController _controllerMobileNo = new TextEditingController();
  final TextEditingController _controllerConfirmPassword = new TextEditingController();

  @override
  Widget build(BuildContext context) {

    String pattern = r'(^(?:[+0]9)?[0-9]{10,12}$)';
    RegExp regExp = new RegExp(pattern);
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: appColor,
      body:  ModalProgressHUD(
        inAsyncCall: _isInAsyncCall,
        // demo of some additional parameters
        opacity: 0.5,
        progressIndicator: CircularProgressIndicator(),
        child: SafeArea(
          child: Container(
            decoration: BoxDecoration(
                gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [Color(0xFF6E012B), Color(0xFF6E012B)])),

            child: Form(
              key: _formStateKey,
              child: Container(
                padding: EdgeInsets.only(left: 20, right: 20, top: 2, bottom: 10),
                width: double.infinity,
                height: double.infinity,
                child: SingleChildScrollView(
                  padding: EdgeInsets.only(top: 2, bottom: 10),
                  child: Column(
                    children: <Widget>[
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[

                          InkWell(
                            onTap: (){
                              Navigator.pop(context);
                            },
                            child: Align(
                              alignment: Alignment.topRight,
                              child: FittedBox(
                                fit: BoxFit.fitWidth,
                                child: Padding(
                                  padding: EdgeInsets.only(top: 20),
                                  child: Container(
                                    child: Align(
                                      alignment: Alignment.center,
                                      child: Icon(
                                        Icons.close,
                                        color: Colors.white,
                                        size: 25,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),

                          SizedBox(
                            height: 20,
                          ),

                          Align(
                            alignment: Alignment.topLeft,
                            child:  Text(
                              "Forget Password",
                              style: TextStyle(
                                //decoration: TextDecoration.underline,
                                color: Colors.white,
                                fontFamily: "Camphor",
                                fontWeight: FontWeight.w900,
                                fontSize: 25,
                              ),

                            ),
                          ),

                          SizedBox(
                            height: 30,
                          ),

                          Container(
                            margin: EdgeInsets.symmetric(vertical: 5),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                FittedBox(
                                  fit:BoxFit.fitWidth,
                                  child: Text(
                                    "Mobile No.",
                                    style: TextStyle(fontFamily: "Camphor",
                                        fontWeight: FontWeight.w900, fontSize: 16,color: Colors.white),
                                  ),
                                ),

                                TextFormField(
                                  onSaved: (value) {
                                    _contactNo = value;
                                  },
                                  controller: _controllerMobileNo,
                                  keyboardType: TextInputType.number,
                                  inputFormatters: <TextInputFormatter>[
                                   FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                                  ],
                                  maxLength: 10,
                                  showCursor: true,
                                  cursorColor: Colors.white,
                                  decoration: const InputDecoration(
                                    counterText: "",
                                    enabledBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(color: Colors.white),
                                    ),
                                    focusedBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(color: Colors.white),
                                    ),
                                    hintText: '',
                                    hintStyle: TextStyle(color: Colors.white),
                                  ),
                                  validator: (value) {
                                    if (value.length == 0 || value.isEmpty) {
                                      return "Mobile No can not be empty";
                                    }
                                    else if (!regExp.hasMatch(value)) {
                                      return 'Please Enter valid Mobile No';
                                    }
                                    return null;
                                  },
                                  style: TextStyle(fontFamily: "Camphor",
                                      fontWeight: FontWeight.w500,
                                      color: Colors.white,
                                      fontSize: 16),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Container(
                            margin: EdgeInsets.symmetric(vertical: 5),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                FittedBox(
                                  fit:BoxFit.fitWidth,
                                  child: Text(
                                    "Password",
                                    style: TextStyle(fontFamily: "Camphor",
                                        fontWeight: FontWeight.w900, fontSize: 16,color: Colors.white),
                                  ),
                                ),

                                TextFormField(
                                  onSaved: (value) {
                                    _password = value;
                                  },
                                  controller: _passwordController,
                                  obscureText: !_showPassword1,
                                  showCursor: true,
                                  cursorColor: Colors.white,
                                  style: TextStyle(fontFamily: "Camphor",
                                      fontWeight: FontWeight.w500,
                                      color: Colors.white,
                                      fontSize: 16),
                                  decoration: InputDecoration(
                                    enabledBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(color: Colors.white),
                                    ),
                                    focusedBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(color: Colors.white),
                                    ),
                                    hintText: "",
                                    suffixIcon: GestureDetector(
                                      onTap: () {
                                        _togglevisibility1();
                                      },
                                      child: Icon(
                                        _showPassword1 ? Icons.visibility : Icons
                                            .visibility_off, color: Colors.white,),
                                    ),
                                  ),
                                  validator: (value) {
                                    if (value.isEmpty) {
                                      return 'Please Enter Password';
                                    }
                                    return null;
                                  },
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Container(
                            margin: EdgeInsets.symmetric(vertical: 5),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                FittedBox(
                                  fit:BoxFit.fitWidth,
                                  child: Text(
                                    "Confirm Password",
                                    style: TextStyle(fontFamily: "Camphor",
                                        fontWeight: FontWeight.w900, fontSize: 16,color: Colors.white),
                                  ),
                                ),
                                TextFormField(
                                  onSaved: (value) {
                                    _confirmpassword = value;
                                  },
                                  controller: _controllerConfirmPassword,
                                  obscureText: !_showPassword2,
                                  showCursor: true,
                                  cursorColor: Colors.white,
                                  style: TextStyle(fontFamily: "Camphor",
                                      fontWeight: FontWeight.w500,
                                      color: Colors.white,
                                      fontSize: 16),
                                  decoration: InputDecoration(
                                    enabledBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(color: Colors.white),
                                    ),
                                    focusedBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(color: Colors.white),
                                    ),
                                    hintText: "",
                                    suffixIcon: GestureDetector(
                                      onTap: () {
                                        _togglevisibility2();
                                      },
                                      child: Icon(
                                        _showPassword2 ? Icons.visibility : Icons
                                            .visibility_off, color:Colors.white,),
                                    ),
                                  ),
                                  validator: (value) {
                                    if (value.isEmpty) {
                                      return 'Please Enter Confirm Password';
                                    }
                                    if(value != _passwordController.text){
                                      return 'Password does not match';
                                    }
                                    return null;
                                  },
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 20,
                          ),


                        ],
                      ),
                    ],
                  ),
                ),
                //   ),
              ),
            ),
          ),
        ),
      ),
      bottomNavigationBar: Container(
        height: 50,
        child: Align(
          alignment: Alignment.center,
          child:
          InkWell(
            onTap: () async {
              if (_formStateKey.currentState.validate()) {
                _formStateKey.currentState.save();


                final String contactNo = _contactNo;
                final String password = _password;
                final String confirmPassword = _confirmpassword;

                debugPrint(' contactNo: ${contactNo}');
                debugPrint(' password: ${password}');
                debugPrint(' confirmPassword: ${confirmPassword}');

                _controllerMobileNo.clear();
                _passwordController.clear();
                _controllerConfirmPassword.clear();

                final ResultModel result = await forgetPassword(
                    contactNo, confirmPassword);
                debugPrint('Check Inserted result : $result');
                setState(() {
                  _result = result;
                });

                if (_result.Result == "UPDATED" )
                {
                  Navigator.pop(context);
                }
                else
                {
                  debugPrint('**');
                  _displaySnackBar(context);
                }
              }
            },
            child: Container(
              height: 50,
              alignment: Alignment.center,
              child: Image.asset(
                "assets/countinue_w_btn.png",
              ),
            ),
          ),
        ),
      ),


    );
  }
}


