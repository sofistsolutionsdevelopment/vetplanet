import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:vetplanet/constant/colors.dart';
import 'package:vetplanet/models/appointmentSlot_model.dart';
import 'package:vetplanet/models/clientProfile_model.dart';
import 'package:vetplanet/models/messaging.dart';
import 'package:vetplanet/models/result_model.dart';
import 'package:vetplanet/payment/check_Vet.dart';
import 'package:vetplanet/screens/selectGroomingServices.dart';
import 'package:vetplanet/screens/selectServices.dart';
import 'package:vetplanet/screens/veterinaryList.dart';
import 'package:vetplanet/screens/view_appointment_list.dart';
import 'package:vetplanet/transitions/slide_route.dart';
import 'dash.dart';
import 'drawer.dart';

class BookAppointmentPage extends StatefulWidget {
  final String clinicId;
  final String amount;
  final String vetId;
  final String checkServices;
  final String checkPet;
  final String token;

  BookAppointmentPage({ this.clinicId, this.amount, this.vetId, this.checkServices, this.checkPet, this.token });


  @override
  _BookAppointmentPageState createState() => _BookAppointmentPageState();
}

class _BookAppointmentPageState extends State<BookAppointmentPage> {

  ResultModel _saveappointmentresult;
  String _reasonForAppointment;
  final TextEditingController _controllerReasonForAppointment= new TextEditingController();
  final GlobalKey<FormState> _formStateKey = GlobalKey<FormState>();

  List data;
  var list;
  var random;
  var refreshKey = GlobalKey<RefreshIndicatorState>();

 Future<ResultModel> saveAppointment(String _SlotId, String _SlotDate, String _SlotStart, String _SlotEnd, String _DayId) async{


   final _prefs = await SharedPreferences.getInstance();
   
   debugPrint('Check Inserted apiUrl $apiUrl ');
   String _RegistrationId = _prefs.getInt('id').toString();

   final String url = "$apiUrl/SaveAppointment/SaveAppointmentForPatient";

    debugPrint('Check Inserted 1 ');
   debugPrint('Check Inserted widget.checkPet : ${widget.checkPet} ');
     var response = await http.post(
       Uri.parse(url),
       headers: {HttpHeaders.contentTypeHeader: 'application/json', HttpHeaders.authorizationHeader: bearerToken },
       body: json.encode(
           {
             "SlotId":_SlotId,
             "VetId":widget.vetId,
             "ClinicId":widget.clinicId,
             "SlotDate":_SlotDate,
             "SlotStart":_SlotStart,
             "SlotEnd":_SlotEnd,
             "DayId":_DayId,
             "PatientId":_RegistrationId,
             "ChkServices":widget.checkServices,
             "ChkPet":widget.checkPet
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


  Future<Null> refreshList() async {
    refreshKey.currentState?.show(atTop: false);
    await Future.delayed(Duration(seconds: 2));
    setState(() {
     this.getData();
    });
    return null;
  }
  DateTime when = DateTime.now();
  String _appointmentDate = "Select Appointment Date";

  DateTime selectedDate = DateTime.now() ;
  var customFormat = DateFormat('dd-MM-yyyy');
  DateTime SelectedDate;
  String _SelectedDate ;
  String SelectedDateValue;
  Future<void> _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime.now().subtract(Duration(days: 0)),
        lastDate: DateTime(2021),
        // selectableDayPredicate: setDayPredicate,
        builder: (context, child) {
          return Theme(
            data: ThemeData(
                primaryColor: Colors.orangeAccent,
                disabledColor: Colors.brown,
                textTheme:
                TextTheme(bodyMedium: TextStyle(color: Color(0xFF0F9896))),
                accentColor: Colors.yellow),
            child: child,
          );
        });
    if (picked != null && picked != selectedDate)
      setState(() {
        selectedDate = picked;


        SelectedDateValue = customFormat.format(selectedDate).toString();
        getData();
        //getHolidayDates();

      });
  }



  Future<AppointmentSlotModel> getData() async{
    final _prefs = await SharedPreferences.getInstance();
    
    debugPrint('Check Inserted apiUrl $apiUrl');

    final String url =  "$apiUrl/AppointmentSlot/GetSlotForDay";
    String _RegistrationId = _prefs.getInt('id').toString();
    debugPrint('Check Inserted apiUrl $apiUrl');
    debugPrint('Check Inserted vetId ${widget.vetId}');
    debugPrint('Check Inserted _RegistrationId $_RegistrationId');
    debugPrint('Check Inserted clinicId ${widget.clinicId}');
    debugPrint('Check Inserted checkServices ${widget.checkServices}');

    DateTime now = DateTime.now();
    String TodaysDate = DateFormat('dd-MM-yyyy').format(now);

    if(_appointmentDate =="Select Appointment Date"){
      _appointmentDate = TodaysDate;
    }
    debugPrint('Check Inserted _appointmentDate : $_appointmentDate');

    var response = await http.post(
      Uri.parse(url),
      headers: {HttpHeaders.contentTypeHeader: 'application/json', HttpHeaders.authorizationHeader: bearerToken },
      body: json.encode(
          {
            "SelectedDate":_appointmentDate,
            "ClinicId":widget.clinicId,
            "PatientId":_RegistrationId
          }
      ),
    );
    debugPrint('Check Inserted 2 ');
    debugPrint('Check Inserted 4  ${response.statusCode}');
    if(response.statusCode == 200){

      debugPrint('Check Inserted 3 : ${response.body}');

      final String responseString = response.body;

      debugPrint('Check Inserted 4  ${responseString}');

      this.setState(() {
        data = json.decode(response.body);
      });
      return appointmentSlotModelFromJson(responseString);
    }else{
      debugPrint('Check Inserted 5 ');
      return null;
    }
  }



  ResultModel _saveTransactionResult;
  Future<ResultModel> saveTransaction() async{
    final _prefs = await SharedPreferences.getInstance();
    
    debugPrint('Check Inserted apiUrl $apiUrl ');
    String _RegistrationId = _prefs.getInt('id').toString();
    String now = DateFormat("yyyy-MM-dd hh:mm:ss").format(DateTime.now());

    final String url = "$apiUrl/SaveTransaction/SaveTransaction";

    debugPrint('Check Inserted _RegistrationId : $_RegistrationId ');
    debugPrint('Check Inserted now : $now ');

    var response = await http.post(
      Uri.parse(url),
      headers: {HttpHeaders.contentTypeHeader: 'application/json', HttpHeaders.authorizationHeader: bearerToken },
      body: json.encode(
          {
            "PatientId":_RegistrationId,
            "Amount":widget.amount,
            "Status":"I",
            "TXNREFID":now
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



  void rebuildPage() {
    setState(() {});
  }


  ClientProfileModel _resultClientProfile;

  Future<ClientProfileModel> getClientProfile() async{
    final _prefs = await SharedPreferences.getInstance();
    
    String _RegistrationId = _prefs.getInt('id').toString();
    debugPrint('Check getProfile apiUrl $apiUrl ');
    final String url = "$apiUrl/GetClientDetailsById/GetClientDetailsById";

    debugPrint('Check Inserted 1 ');


    var response = await http.post(
      Uri.parse(url),
      headers: {HttpHeaders.contentTypeHeader: 'application/json', HttpHeaders.authorizationHeader: bearerToken },
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

      debugPrint('Check Inserted 4  ${responseString}');

      return clientProfileModelFromJson(responseString);


    }else{
      debugPrint('Check Inserted 5 ');
      return null;
    }
  }

  String PetOwnerName = "Vet Planet App";



  Future sendToTest (String Token) async {
    final ClientProfileModel resultName = await getClientProfile();
    setState(() {
      _resultClientProfile = resultName;
      if(_resultClientProfile != null){
        PetOwnerName = _resultClientProfile.UserName;
        print("sendToTest PetOwnerName *******************$PetOwnerName");
        print("sendToTest Token *******************$Token");
      }
      //   isSwitched = true;
    });
    debugPrint('Check sendToTest 1');
    final response = await Messaging.sendTo(
      title:  "Appoinment By: $PetOwnerName" ,
      body:   "Appoinment Booked by $PetOwnerName for VET",
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
            content: Text('Thank you! Your Apppointment is Booked',style:TextStyle(fontFamily: "Camphor",
                fontWeight: FontWeight.w500, fontSize: 20,color: Colors.black),),
            actions: <Widget>[
              TextButton(
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


  @override
  void initState() {
    getData();
    super.initState();
  }


  @override
  Widget build(BuildContext context){
    return WillPopScope(
      onWillPop: (){
        Navigator.of(context)
            .pushReplacement(new MaterialPageRoute(builder: (context) => VeterinaryListPage(onPressed: rebuildPage)));
        return new Future(() => false); //onWillPop is Future<bool> so return false
      },
      child: new Scaffold(
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

        body: Container(
          child:Column(
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.only(right:15, left:15, top: 10, bottom: 10),
                child: InkWell(
                  onTap: () async{
                    DateTime picked = await showDatePicker(
                      context: context,
                      initialDate:when,
                      firstDate: DateTime.now(),
                      lastDate: DateTime(3000),
                    );
                    if(picked == null){
                      setState(() {
                        when = DateTime.now();
                      });
                    }
                    else{
                      setState(() {
                        when = picked;
                        String selectedDate = DateFormat("dd-MM-yyyy").format(when);
                        _appointmentDate = selectedDate;
                        print("_appointmentDate: $_appointmentDate");
                      });
                      getData();
                    }
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[

                      Text(_appointmentDate,  style: TextStyle(fontFamily: "Camphor",
                          fontWeight: FontWeight.w500,
                          color: Colors.black,
                          fontSize: 22),),
                      SizedBox(width: 25),
                      InkWell(
                        onTap: () async{
                          DateTime picked = await showDatePicker(
                            context: context,
                            initialDate: when,
                            firstDate: DateTime.now(),
                            lastDate: DateTime(3000),
                          );
                          if(picked == null){
                            setState(() {
                              when = DateTime.now();
                            });
                          }
                          else{
                            setState(() {
                              when = picked;
                              String selectedDate = DateFormat("dd-MM-yyyy").format(when);
                              _appointmentDate = selectedDate;
                              print("_appointmentDate: $_appointmentDate");
                              getData();
                            });
                          }
                        },
                        child: Icon(
                          Icons.calendar_today,
                          color: Colors.black,
                          size: 22,
                        ),
                      ),

                    ],
                  ),
                ),
              ),

              Divider(
                height: 1,
                thickness: 0.5,
                color: Colors.grey,
              ),

              Expanded(
                child:  ListView.builder(
                  itemCount: data == null ? 0 : data.length,
                  itemBuilder: (BuildContext context, int index) {
                    String strSlotStart = "${data[index]["SlotStart"]}";
                    String slotStart = strSlotStart.substring(0, 5);
                    String strSlotEnd= "${data[index]["SlotEnd"]}";
                    String slotEnd = strSlotEnd.substring(0, 5);

                    print("slotStart : $slotStart");
                    print("slotEnd : $slotEnd");

                    if(data[index]["IfExist"].toString() == "2"){
                      return Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Column(
                          children: <Widget>[

                            Card(
                              elevation: 4,
                              shape: RoundedRectangleBorder(
                                //side: BorderSide(
                                // color: Color(0xFFf7418c), width: 1),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              margin: new EdgeInsets.symmetric(
                                  horizontal: 10.0),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  children: <Widget>[
                                    Padding(
                                      padding: const EdgeInsets.all(2.0),
                                      child: Row(
                                        children: <Widget>[
                                          Expanded(
                                            child: Center(
                                              child: RichText(
                                                text: new TextSpan(
                                                  text: '',
                                                  style: TextStyle(
                                                      color: Colors.black,
                                                      fontSize: 11),
                                                  children: <TextSpan>[
                                                    new TextSpan(
                                                      text:
                                                      " Not Available ",
                                                      style: new TextStyle(
                                                        fontWeight:
                                                        FontWeight.bold,
                                                        color: Colors.black,
                                                        fontSize: 12,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),

                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    }

                    else{
                      if (data[index]["IsBooked"].toString() == "1") {

                        debugPrint('Check 1.1 ');
                        return
                          Padding(
                            padding: const EdgeInsets.only(right:8, left: 8, top: 2, bottom: 2),
                            child:   Card(
                              elevation: 4,
                              shape: RoundedRectangleBorder(
                                //side: BorderSide(
                                //    color: Color(0xFFf7418c), width: 1),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              //margin: new EdgeInsets.symmetric(
                              //  horizontal: 10.0),
                              child: Padding(
                                padding: const EdgeInsets.only(right:8, left: 8),
                                child:  Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    Text('$slotStart - $slotEnd ',
                                      style: TextStyle(
                                        fontWeight:
                                        FontWeight.bold,
                                        color: Colors.black,
                                        fontSize: 15,),),
                                    Align(alignment: Alignment.centerRight,
                                      child: IconButton(
                                        icon: new Icon(Icons.check_circle, color: Colors.green,),
                                        tooltip: 'Booked',
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );

                        debugPrint('Check 1 ');
                      }
                      else{
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            children: <Widget>[
                              if(data[index]["IfExist"].toString() != "0")
                                Padding(
                                  padding: const EdgeInsets.only(right:8, left: 8, top: 2, bottom: 2),
                                  child:   Card(
                                    elevation: 4,
                                    shape: RoundedRectangleBorder(
                                      //side: BorderSide(
                                      //    color: Color(0xFFf7418c), width: 1),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    //margin: new EdgeInsets.symmetric(
                                    //  horizontal: 10.0),
                                    child: Padding(
                                      padding: const EdgeInsets.only(right:8, left: 8),
                                      child:  Row(
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: <Widget>[
                                          Text('$slotStart - $slotEnd ',
                                            style: TextStyle(
                                              fontWeight:
                                              FontWeight.bold,
                                              color: Colors.black,
                                              fontSize: 15,),),
                                          Align(alignment: Alignment.centerRight,
                                            child: IconButton(
                                              icon: new Icon(Icons.check_circle, color: Colors.grey,),
                                              tooltip: 'Not Available',
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),

                              if(data[index]["IfExist"].toString() == "0")
                                Column(
                                  children: <Widget>[
                                    if (data[index]["IfAvail"].toString() != "0")
                                      Padding(
                                       padding: const EdgeInsets.only(right:8, left: 8, top: 2, bottom: 2),
                                        child:   Card(
                                         elevation: 4,
                                         shape: RoundedRectangleBorder(
                                          //side: BorderSide(
                                          //    color: Color(0xFFf7418c), width: 1),
                                          borderRadius: BorderRadius.circular(10),
                                         ),
                                        //margin: new EdgeInsets.symmetric(
                                        //  horizontal: 10.0),
                                         child: Padding(
                                          padding: const EdgeInsets.only(right:8, left: 8),
                                          child: Row(
                                            crossAxisAlignment: CrossAxisAlignment.center,
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: <Widget>[
                                              Text('$slotStart - $slotEnd ',
                                                style: TextStyle(
                                                  fontWeight:
                                                  FontWeight.bold,
                                                  color: Colors.black,
                                                  fontSize: 15,),),
                                              Align(alignment: Alignment.centerRight,
                                                child: IconButton(
                                                  icon: new Icon(Icons.check_circle, color: Colors.grey,),
                                                  tooltip: 'Not Available',
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                     ),
                                    if (data[index]["IfAvail"].toString() == "0")
                                      Padding(
                                        padding: const EdgeInsets.only(right:8, left: 8, top: 2, bottom: 2),
                                        child:   Card(
                                          elevation: 4,
                                          shape: RoundedRectangleBorder(
                                            //side: BorderSide(
                                            //    color: Color(0xFFf7418c), width: 1),
                                            borderRadius: BorderRadius.circular(10),
                                          ),
                                          //margin: new EdgeInsets.symmetric(
                                          //  horizontal: 10.0),
                                          child: Padding(
                                            padding: const EdgeInsets.only(right:8, left: 8),
                                            child: Row(
                                              crossAxisAlignment: CrossAxisAlignment.center,
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: <Widget>[
                                                Text('$slotStart - $slotEnd ',
                                                  style: TextStyle(
                                                    fontWeight:
                                                    FontWeight.bold,
                                                    color: Colors.black,
                                                    fontSize: 15,),),
                                                Align(alignment: Alignment.centerRight,
                                                  child: IconButton(
                                                    icon: new Icon(Icons.check_circle, color: appColorlight,),
                                                    tooltip: 'confirm',
                                                    onPressed: () async {

                                                      final ResultModel _saveTransaction = await saveTransaction();
                                                      debugPrint(
                                                          'Check Inserted _saveTransaction : $_saveTransaction');
                                                      setState(() {
                                                        _saveTransactionResult = _saveTransaction;
                                                      });

                                                      if (_saveTransactionResult.Result == "ADDED") {
                                                        String transactionId = _saveTransactionResult.Id.toString();
                                                        debugPrint('_saveTransactionResult transactionId *************$transactionId');

                                                        String _vetId = widget.vetId;
                                                        String _clinicId = widget.clinicId;
                                                        String _token = widget.token;
                                                        String _checkServices = widget.checkServices;
                                                        String _checkPet = widget.checkPet;
                                                        String _slotId = ("${data[index]["SlotId"]}");
                                                        String _slotDate =  ("${data[index]["SlotDate"]}");
                                                        String _slotStart =  ("${data[index]["SlotStart"]}");
                                                        String _slotEnd =  ("${data[index]["SlotEnd"]}");
                                                        String _dayId = ("${data[index]["DayId"]}").toString();

                                                        Navigator.of(context).pushAndRemoveUntil(
                                                          MaterialPageRoute(builder: (context) => CheckRazorVet(amount: widget.amount, transactionId:transactionId, vetId:_vetId, clinicId:_clinicId, token:_token, checkServices:_checkServices, checkPet:_checkPet, slotId:_slotId, slotDate:_slotDate, slotStart:_slotStart, slotEnd:_slotEnd, dayId:_dayId)), (Route<dynamic> route) => false,);
                                                      }
                                                    },
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                  ],
                                ),
                            ],
                          ),
                        );
                        debugPrint('Check 2 ');
                      }
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
