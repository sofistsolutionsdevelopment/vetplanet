import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vetplanet/constant/colors.dart';
import 'package:vetplanet/models/clientProfile_model.dart';
import 'package:vetplanet/models/groomerMessaging.dart';
import 'package:vetplanet/models/result_model.dart';
import 'package:vetplanet/payment/paymentFailed.dart';
import 'package:vetplanet/payment/paymentSuccess.dart';
import 'package:vetplanet/screens/dash.dart';
import 'razorpay_flutter.dart';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;


class CheckRazor extends StatefulWidget {
  final String amount;
  final String transactionId;
  final String groomingId;
  final String shopId;
  final String token;
  final String slotId;
  final String slotDate;
  final String slotStart;
  final String slotEnd;
  final String dayId;

  CheckRazor({ this.amount, this.transactionId, this.groomingId, this.shopId, this.token, this.slotId, this.slotDate, this.slotStart, this.slotEnd, this.dayId });
  @override
  _CheckRazorState createState() => _CheckRazorState();
}

class _CheckRazorState extends State<CheckRazor> {
  Razorpay _razorpay = Razorpay();
  var options;
  Future payData() async {
    try {
      _razorpay.open(options);
    } catch (e) {
      print("errror occured here is ......................./:$e");
    }

    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
  }

  ClientProfileModel _resultClientProfile;

  Future<ClientProfileModel> getClientProfile() async{
    final _prefs = await SharedPreferences.getInstance();
    String _API_Path = _prefs.getString('API_Path');
    String _RegistrationId = _prefs.getInt('id').toString();
    debugPrint('Check getProfile _API_Path $_API_Path ');
    final String apiUrl = "$_API_Path/GetClientDetailsById/GetClientDetailsById";

    debugPrint('Check Inserted 1 ');


    var response = await http.post(
      Uri.parse(apiUrl),
      headers: {HttpHeaders.contentTypeHeader: 'application/json', HttpHeaders.authorizationHeader: 'bearer VA5kBnSw50cbuJ4YoAVkl4XyFTA312fRtKF4GxlmkUcl3PQJBKvvtogvT_0syd6ZtsZ4-1zFK6_liq5dQpyMq2tOA7vCtZ332qal7LGyBxBvv4mtD461lwGhNtprYd8PyIR40bBsoBc7nMElIniHJXAu1V04eO5c7sNLHOGypeG70Zn06yQr-0i_eFbsCRg6kMWjkao3RZwDfXVra5JQ5I7Pr1CbSgYez6rbYLMbH2LL6K8VcpmUvs45WpLe4UjPpChygW96LCoxVh7YtNa74n1Bje4sDdGLZowZJWwe7F9P7ijy1nVyw_v5K-8MqzlI' },
      body: json.encode(
          {
            "PatientId":_RegistrationId
          }
      ),
    );
    debugPrint('Check Inserted 2 ');

    if(response.statusCode == 200){

      debugPrint('Check Inserted 3 : ${response.body}');

      final String responseString = response.body;

      debugPrint('Check Inserted 4  $responseString');

      return clientProfileModelFromJson(responseString);


    }else{
      debugPrint('Check Inserted 5 ');
      return null;
    }
  }

  String contactNo = "";
  String emailId = "";
  double amtToPay = 0.0;
  double finalAMT = 0.0;

  int a = 0;


  void appBarClientName() async {
    final ClientProfileModel resultName = await getClientProfile();
    setState(() {
      _resultClientProfile = resultName;
      if(_resultClientProfile != null){
        contactNo = _resultClientProfile.ContactNo;
        emailId = _resultClientProfile.Email;
        amtToPay = double.parse(widget.amount);
        finalAMT =  amtToPay*100;

        print("widget.amount *******************${widget.amount}");
        print("amtToPay *******************$amtToPay");
        print("finalAMT *******************$finalAMT");
        print("contactNo *******************$contactNo");
        print("emailId *******************$emailId");

      }
      options = {
        'key': "rzp_live_QiWQFyEVOzSNtN", // Enter the Key ID generated from the Dashboard
        //rzp_test_VfdvJmkxXj8o3B
        'amount': amtToPay*100, //in the smallest currency sub-unit.
        'name': 'Vet Planet',
        'currency': "INR",
        'theme.color': "#F37254",
        'buttontext': "Pay with Razorpay",
        'description': '',
        'prefill': {
          'contact': contactNo,
          'email': emailId,
        }
      };
      //   isSwitched = true;
    });

  }


  ResultModel _updateTransactionResult;
  Future<ResultModel> updateTransaction(String paymentId, String patientSlotId) async{

    final _prefs = await SharedPreferences.getInstance();
    String _API_Path = _prefs.getString('API_Path');
    debugPrint('Check Inserted _API_Path $_API_Path ');

    final String apiUrl = "$_API_Path/UpdateTransaction/UpdateTransaction";

    var response = await http.post(
      Uri.parse(apiUrl),
      headers: {HttpHeaders.contentTypeHeader: 'application/json', HttpHeaders.authorizationHeader: 'bearer VA5kBnSw50cbuJ4YoAVkl4XyFTA312fRtKF4GxlmkUcl3PQJBKvvtogvT_0syd6ZtsZ4-1zFK6_liq5dQpyMq2tOA7vCtZ332qal7LGyBxBvv4mtD461lwGhNtprYd8PyIR40bBsoBc7nMElIniHJXAu1V04eO5c7sNLHOGypeG70Zn06yQr-0i_eFbsCRg6kMWjkao3RZwDfXVra5JQ5I7Pr1CbSgYez6rbYLMbH2LL6K8VcpmUvs45WpLe4UjPpChygW96LCoxVh7YtNa74n1Bje4sDdGLZowZJWwe7F9P7ijy1nVyw_v5K-8MqzlI' },
      body: json.encode(
          {
            "TransactionId":widget.transactionId,
            "PaymentId":paymentId,
            "PatientSlotId":patientSlotId,
            "IsSlot":"G"
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


  ResultModel _updateTransactionStatusResult;
  Future<ResultModel> updateTransactionStatus(String status) async{

    final _prefs = await SharedPreferences.getInstance();
    String _API_Path = _prefs.getString('API_Path');
    debugPrint('Check Inserted _API_Path $_API_Path ');

    final String apiUrl = "$_API_Path/UpdateTransactionStatus/UpdateTransactionStatus";

    var response = await http.post(
      Uri.parse(apiUrl),
      headers: {HttpHeaders.contentTypeHeader: 'application/json', HttpHeaders.authorizationHeader: 'bearer VA5kBnSw50cbuJ4YoAVkl4XyFTA312fRtKF4GxlmkUcl3PQJBKvvtogvT_0syd6ZtsZ4-1zFK6_liq5dQpyMq2tOA7vCtZ332qal7LGyBxBvv4mtD461lwGhNtprYd8PyIR40bBsoBc7nMElIniHJXAu1V04eO5c7sNLHOGypeG70Zn06yQr-0i_eFbsCRg6kMWjkao3RZwDfXVra5JQ5I7Pr1CbSgYez6rbYLMbH2LL6K8VcpmUvs45WpLe4UjPpChygW96LCoxVh7YtNa74n1Bje4sDdGLZowZJWwe7F9P7ijy1nVyw_v5K-8MqzlI' },
      body: json.encode(
          {
            "TransactionId":widget.transactionId,
            "Status":status
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

  ResultModel _saveappointmentresult;
  Future<ResultModel> saveAppointment() async{
    final _prefs = await SharedPreferences.getInstance();
    String _API_Path = _prefs.getString('API_Path');
    debugPrint('Check Inserted _API_Path $_API_Path ');
    String _RegistrationId = _prefs.getInt('id').toString();
    String PetOwnerName = _prefs.getString('PetOwnerName');
    print("sendToTest PetOwnerName *******************$PetOwnerName");
    final String apiUrl = "$_API_Path/SaveAppointmentForGrooming/SaveAppointmentForGrooming";

    debugPrint('Check Inserted 1 ');

    var response = await http.post(
      Uri.parse(apiUrl),
      headers: {HttpHeaders.contentTypeHeader: 'application/json', HttpHeaders.authorizationHeader: 'bearer VA5kBnSw50cbuJ4YoAVkl4XyFTA312fRtKF4GxlmkUcl3PQJBKvvtogvT_0syd6ZtsZ4-1zFK6_liq5dQpyMq2tOA7vCtZ332qal7LGyBxBvv4mtD461lwGhNtprYd8PyIR40bBsoBc7nMElIniHJXAu1V04eO5c7sNLHOGypeG70Zn06yQr-0i_eFbsCRg6kMWjkao3RZwDfXVra5JQ5I7Pr1CbSgYez6rbYLMbH2LL6K8VcpmUvs45WpLe4UjPpChygW96LCoxVh7YtNa74n1Bje4sDdGLZowZJWwe7F9P7ijy1nVyw_v5K-8MqzlI' },
      body: json.encode(
          {
            "SlotId":widget.slotId,
            "PetGroomingId":widget.groomingId,
            "ShopId":widget.shopId,
            "SlotDate":widget.slotDate,
            "SlotStart":widget.slotStart,
            "SlotEnd":widget.slotEnd,
            "DayId":widget.dayId,
            "PatientId":_RegistrationId,
            "ChkGroomingServices":"-",
            "ChkGroomingPet":"-",
            "Feedback":"Appoinment Booked by $PetOwnerName on ${widget.slotDate} Between ${widget.slotStart} - ${widget.slotEnd}. Please Confirm Accordingly."

          }
      ),
    );

    debugPrint('Check Inserted 2 ');
    debugPrint('Check statusCode : ${response.statusCode} ');

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

  Future sendToTest (String Token) async {
    final _prefs = await SharedPreferences.getInstance();
    String PetOwnerName = _prefs.getString('PetOwnerName');
    print("sendToTest PetOwnerName *******************$PetOwnerName");
    print("sendToTest Token *******************$Token");
    debugPrint('Check sendToTest 1');
    final response = await GroomerMessaging.sendTo(
      title:  "Appoinment By: $PetOwnerName" ,
      body:   "Appoinment Booked by $PetOwnerName on ${widget.slotDate} Between ${widget.slotStart} - ${widget.slotEnd}. Please Confirm Accordingly.",
      fcmToken: Token,
    );
    debugPrint('Check sendToTest 2');

    if (response.statusCode != 200) {
      debugPrint('Check sendToTest 3');

      // Scaffold.of(context).showSnackBar(SnackBar(
      //   content:
      //   Text('[${response.statusCode}] Error message: ${response.body}'),
      // ));
    }
  }


  Future<String> approved() {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('', style:TextStyle(color: Colors.black,fontSize: 19,
                fontWeight: FontWeight.bold),),
            content: Text('Apppointment for Groomer Booked Sucessfully!',style:TextStyle(fontFamily: "Camphor",
                fontWeight: FontWeight.w500, fontSize: 20,color: Colors.black),),
            actions: <Widget>[
              ElevatedButton(
                
                  // color: appColor,
                  child: Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: Text('OK',style: TextStyle(fontFamily: "Camphor",
                      fontWeight: FontWeight.w500, fontSize: 18,color: Colors.white,),),
                  ),
                  onPressed: () {
                    Navigator.of(context)
                        .pushReplacement(new MaterialPageRoute(builder: (context) => DashPage(onPressed: rebuildPage)));

                    // Navigator.pushReplacement(context, SlideLeftRoute(page: VetRegistration()));
                  }
              ),
            ],
          );
        });
  }

  ResultModel _deletePreServices;

  Future<ResultModel> deletePreServices() async{
    final _prefs = await SharedPreferences.getInstance();
    String _API_Path = _prefs.getString('API_Path');
    String _RegistrationId = _prefs.getInt('id').toString();

    debugPrint('Check Inserted _API_Path $_API_Path');
    debugPrint('Check Inserted _RegistrationId $_RegistrationId');

    final String apiUrl =  "$_API_Path/DeletePreGroomingService/DeletePreGroomingService";

    debugPrint('Check Inserted 1 ');

    var response = await http.post(
      Uri.parse(apiUrl),
      headers: {HttpHeaders.contentTypeHeader: 'application/json', HttpHeaders.authorizationHeader: 'bearer VA5kBnSw50cbuJ4YoAVkl4XyFTA312fRtKF4GxlmkUcl3PQJBKvvtogvT_0syd6ZtsZ4-1zFK6_liq5dQpyMq2tOA7vCtZ332qal7LGyBxBvv4mtD461lwGhNtprYd8PyIR40bBsoBc7nMElIniHJXAu1V04eO5c7sNLHOGypeG70Zn06yQr-0i_eFbsCRg6kMWjkao3RZwDfXVra5JQ5I7Pr1CbSgYez6rbYLMbH2LL6K8VcpmUvs45WpLe4UjPpChygW96LCoxVh7YtNa74n1Bje4sDdGLZowZJWwe7F9P7ijy1nVyw_v5K-8MqzlI' },
      body: json.encode(
          {
            "PatientId"	:_RegistrationId,
            "GroomerId":widget.groomingId
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

  void onSuccess(paymentId) async {
    a = a+1;
    if(a == 1){
      print("aaaa start if a == 1: $a");
      final ResultModel saveAppointmentresult = await saveAppointment();
      if(saveAppointmentresult.Result == "ADDED")
      {
        String patientSlotId = saveAppointmentresult.Id.toString();
        debugPrint('Check _saveappointmentresult patientSlotId : $patientSlotId');
        debugPrint('Check _saveappointmentresult paymentId : $paymentId');
        final ResultModel resultpredelete = await deletePreServices();
        if(resultpredelete.Result == "Deleted"){
          print("resultpredelete *******************${resultpredelete.Result}");
        }
        final ResultModel _updateTransaction = await updateTransaction(paymentId,patientSlotId);
        if(_updateTransaction.Result == "UPDATED")
        {
          String status = "S";
          final ResultModel _updateTransactionStatus = await updateTransactionStatus(status);
          if(_updateTransactionStatus.Result == "Status UPDATED")
          {
            if(widget.token != "-"){
              String token = widget.token;
              debugPrint('Check _saveappointmentresult token : $token');
              sendToTest(token);
            }
            //  approved();
            _razorpay.clear();
            Navigator.of(context)
                .pushReplacement(new MaterialPageRoute(builder: (context) => SuccessPage()));

          }
        }

      }
      print("aaaaaa End  if a == 1: $a");
    }
    print("aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa: $a");
  }


  void _handlePaymentSuccess(PaymentSuccessResponse response) async {
    print("payment has succedded");
    String paymentId = response.paymentId;
    print("payment Id  : ${response.paymentId}");
    onSuccess(paymentId);
  }


  void _handlePaymentError(PaymentFailureResponse response) async {
    print("payment has error00000000000000000000000000000000000000");
    print("Your payment is Failed and the response is\n Code: ${response.code}\nMessage: ${response.message}");
    print("payment has error code : ${response.code}");
    print("payment has error message : ${response.message}");

    String patientSlotId = "0";
    String paymentId = "-";
    debugPrint('Check  patientSlotId : $patientSlotId');
    debugPrint('Check  paymentId : $paymentId');
    final ResultModel _updateTransaction = await updateTransaction(paymentId,patientSlotId);
    if(_updateTransaction.Result == "UPDATED")
    {
      String status = "F";
      final ResultModel _updateTransactionStatus = await updateTransactionStatus(status);
      if(_updateTransactionStatus.Result == "Status UPDATED")
      {
        _razorpay.clear();
        Navigator.of(context)
            .pushReplacement(new MaterialPageRoute(builder: (context) => FailedPage()));



      }
    }
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    print("payment has externalWallet33333333333333333333333333");

    _razorpay.clear();
    // Do something when an external wallet is selected
  }


  void rebuildPage() {
    setState(() {});
  }


  @override
  void initState() {
    appBarClientName();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // print("razor runtime --------: ${_razorpay.runtimeType}");
    return WillPopScope(
      onWillPop: (){
        Navigator.of(context)
            .pushReplacement(new MaterialPageRoute(builder: (context) => FailedPage()));
        return new Future(() => false); //onWillPop is Future<bool> so return false
      },
      child: Scaffold(
        body: FutureBuilder(
            future: payData(),
            builder: (context, snapshot) {
              return Container(
                child:Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Center(child: SpinKitRotatingCircle(
                      color: appColor,
                      size: 50.0,
                    )),
                    SizedBox(height: 20,),
                    Text("Loading......", style: TextStyle(fontSize:22, fontFamily: "Camphor",
                 fontWeight: FontWeight.w900,color: Colors.black),),
                  ],
                ),
              );
            }),
      ),
    );
  }
}
