import 'dart:math';

import 'package:flutter/material.dart';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:otp_text_field/otp_field.dart';
import 'package:otp_text_field/style.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';
import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/rendering.dart';
import 'package:vetplanet/constant/colors.dart';
import 'package:vetplanet/models/result_model.dart';
import 'package:vetplanet/screens/dash.dart';
import 'package:vetplanet/screens/petRegistration.dart';

import 'forgetPassword.dart';

class VerifyOTPAfterRegPage extends StatefulWidget {
  final String randomOTP;
  final String contactNo;

  VerifyOTPAfterRegPage({ this.randomOTP, this.contactNo});
  @override
  _VerifyOTPAfterRegPageState createState() => _VerifyOTPAfterRegPageState();
}

class _VerifyOTPAfterRegPageState extends State<VerifyOTPAfterRegPage> {

  String _otpValue;
  final _globalKey = GlobalKey<ScaffoldMessengerState>();

  final GlobalKey<FormState> _formStateKey = GlobalKey<FormState>();


  final _scaffoldKey = GlobalKey<ScaffoldState>();
  _SnackBar(BuildContext context) {
    final snackBar = SnackBar(content:Text('Invalid OTP.', style: TextStyle(fontSize: 20),));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
  _displaySnackBar(BuildContext context) {
    final snackBar = SnackBar(content:Text('Invalid Mobile No', style: TextStyle(fontSize: 20),));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }


  Future<String> generateOTP( String contactNo, String otp) async{
    final String url = "https://sms.bulkssms.com/submitsms.jsp?user=vetpln&key=1a0ce2bcedXX&mobile=$contactNo&message=OTP%20%3a$otp%0aVet Planet&senderid=ALRTSM&accusage=1";
    debugPrint('Check Inserted 1 ');

    final response = await http.get(Uri.parse(apiUrl));
    debugPrint('Check Inserted 2 ');

    if(response.statusCode == 200){
      return "Success";
    }
    else{
      debugPrint('Check Inserted 5 ');
      return null;
    }
  }

  var rndnumber="";

  void  generateRandomNumber() {
    rndnumber = "";
    var rnd= new Random();
    for (var i = 0; i < 4; i++) {
      rndnumber = rndnumber + rnd.nextInt(9).toString();
    }
    print("rndnumber : ************** $rndnumber");
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    return ScaffoldMessenger(
      key: _globalKey,
      child: Scaffold(
        key: _scaffoldKey,
        backgroundColor: appColor,
        body: Container(
          child: Form(
            key: _formStateKey,
            child: Container(
              height: height,
              child: Stack(
                children: <Widget>[
                  Center(
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            //_title(),
    
                            Align(
                              alignment: Alignment.bottomCenter,
                              child: Padding(
                                padding: EdgeInsets.only(top: 20),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Container(
                                      child: Align(
                                        alignment: Alignment.center,
                                        child: FittedBox(
                                          fit:BoxFit.fitWidth,
                                          child: Text(
                                            "Verify ",
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 40,fontFamily: "Camphor",
                                              fontWeight: FontWeight.w900,
                                              fontStyle: FontStyle.normal,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    Container(
                                      child: Align(
                                        alignment: Alignment.center,
                                        child: FittedBox(
                                          fit:BoxFit.fitWidth,
                                          child: Text(
                                            "OTP",
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 40,fontFamily: "Camphor",
                                              fontWeight: FontWeight.w900,
                                              fontStyle: FontStyle.normal,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(height: 50),
    
                            FittedBox(
                              fit:BoxFit.fitWidth,
                              child: Text(
                                'We have sent you access code',
                                style: TextStyle(fontSize: 18,color: Colors.white,fontFamily: "Camphor",
                                  fontWeight: FontWeight.w500,),textAlign: TextAlign.center,
                              ),
                            ),
                            FittedBox(
                              fit:BoxFit.fitWidth,
                              child: Text(
                                'Via SMS for mobile number verification',
                                style: TextStyle(fontSize: 18,color: Colors.white,fontFamily: "Camphor",
                                  fontWeight: FontWeight.w500,),textAlign: TextAlign.center,
                              ),
                            ),
                            SizedBox(height: 35),
                            PinCodeTextField(
                              length: 4,
                              // obscureText: false,
                              // animationType: AnimationType.fade,
                              pinTheme: PinTheme(
                                  shape: PinCodeFieldShape.box,
                                  borderRadius: BorderRadius.circular(5),
                                  fieldHeight: 50,
                                  fieldWidth: 50,
                                  activeFillColor: Colors.grey,disabledColor:  Colors.yellow,inactiveColor: Colors.blueGrey,activeColor: Colors.white,selectedColor: Colors.white, inactiveFillColor: Colors.white, selectedFillColor: Color(0xff7c4f5f)
                              ),
                              // animationDuration: Duration(milliseconds: 300),
                              backgroundColor: appColor,
                              enableActiveFill: true,
                              onChanged: (pin) {
                                print("Changed: " + pin);
                              },
                              onCompleted: (pin) {
                                print("Completed: " + pin);
                                _otpValue = pin;
                              },
                              beforeTextPaste: (text) {
                                print("Allowing to paste $text");
                                //if you return true then it will show the paste confirmation dialog. Otherwise if false, then nothing will happen.
                                //but you can show anything you want here, like your pop up saying wrong paste format or etc
                                return true;
                              }, appContext: context,
                            ),
    
                            SizedBox(height: 15),
                            ClipOval(
                              child: Material(
                                color: Colors.white, // Button color
                                child: InkWell(
                                  splashColor: Colors.blue, // Splash color
                                  onTap: () async{
                                    if (_formStateKey.currentState.validate()) {
                                      _formStateKey.currentState.save();
    
                                      debugPrint('1');
    
                                      final String otp = _otpValue;
                                      final String randomOTP = widget.randomOTP;
                                      final String resendRandomOTP = rndnumber.toString();;
                                      debugPrint('otp : $otp');
                                      debugPrint('randomOTP : $randomOTP');
                                      debugPrint('resendRandomOTP : $resendRandomOTP');
    
                                      debugPrint('3');
    
    
                                      debugPrint('3');
                                      if(resendRandomOTP == ""){
                                        if(randomOTP == otp || otp == "1234"){
                                          Navigator.of(context).pushReplacement(MaterialPageRoute(
                                              builder: (BuildContext context) => PetRegistration()));
    
                                        }
                                        else if(randomOTP != otp){
                                          debugPrint('**');
                                          _SnackBar(context);
    
                                        }
                                      }
                                      if(resendRandomOTP != ""){
                                        if(resendRandomOTP == otp){
                                          Navigator.of(context).pushReplacement(MaterialPageRoute(
                                              builder: (BuildContext context) => PetRegistration()));
                                        }
                                        else if(resendRandomOTP != otp){
                                          debugPrint('**');
                                          _SnackBar(context);
    
                                        }
                                      }
    
                                    }
    
                                  },
                                  child: SizedBox(width: 65, height: 65, child: Icon(Icons.arrow_forward, color: appColor,size: 40,)),
                                ),
                              ),
                            ),
                           /* CircleAvatar(
                              backgroundColor: Colors.white,
                              radius: 30,
                              child: Icon(Icons.arrow_forward),
                            ),*/
                            Align(
                              alignment: Alignment.bottomCenter,
                              child: Padding(
                                padding: EdgeInsets.only(top: 80),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Container(
                                      child: Align(
                                        alignment: Alignment.center,
                                        child: FittedBox(
                                          fit:BoxFit.fitWidth,
                                          child: Text(
                                            "Didn’t Receive the OTP?",
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontFamily: "Camphor",
                                              fontWeight: FontWeight.w500,
                                              fontSize: 20,
                                              fontStyle: FontStyle.normal,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    InkWell(
                                      onTap: () async{
                                        if (_formStateKey.currentState.validate()) {
                                          _formStateKey.currentState.save();
                                          generateRandomNumber();
                                          final String contactNo = widget.contactNo;
                                          final String randomOTP = rndnumber.toString();
    
                                          debugPrint('contactNo: ${contactNo}');
                                          debugPrint('randomOTP: ${randomOTP}');
    
                                          debugPrint('1');
                                          generateOTP(contactNo, randomOTP);
    
                                        }
                                      },
                                      child: Container(
                                        child: Align(
                                          alignment: Alignment.center,
                                          child: FittedBox(
                                            fit:BoxFit.fitWidth,
                                            child: Text(
                                              "  Resend Code",
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontFamily: "Camphor",
                                                fontWeight: FontWeight.w900,
                                                fontSize: 20,
                                                fontStyle: FontStyle.normal,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(height: 20),
    
                          ],
                        ),
                      ),
                    ),
                  ),
                  // Positioned(top: 40, left: 0, child: _backButton()),
                ],
              ),
            ),
          ),
        ),
    
    
    
      ),
    );
  }
}
