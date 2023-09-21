import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:vetplanet/constant/colors.dart';
import 'package:vetplanet/models/groomingAppointmentSlot_model.dart';
import 'package:vetplanet/models/result_model.dart';
import 'package:vetplanet/payment/check.dart';
import 'dash.dart';
import 'drawer.dart';
import 'groomingList.dart';

class GroomingBookAppointmentPage extends StatefulWidget {
  final String shopId;
  final String groomingId;
  final String token;
  final String amount;

  GroomingBookAppointmentPage({ this.shopId, this.groomingId, this.token, this.amount});


  @override
  _GroomingBookAppointmentPageState createState() => _GroomingBookAppointmentPageState();
}

class _GroomingBookAppointmentPageState extends State<GroomingBookAppointmentPage> {



  List data;
  var list;
  var random;
  var refreshKey = GlobalKey<RefreshIndicatorState>();


  ResultModel _saveTransactionResult;
  Future<ResultModel> saveTransaction() async{
    final _prefs = await SharedPreferences.getInstance();
    String _API_Path = _prefs.getString('API_Path');
    debugPrint('Check Inserted _API_Path $_API_Path ');
    String _RegistrationId = _prefs.getInt('id').toString();
    String now = DateFormat("yyyy-MM-dd hh:mm:ss").format(DateTime.now());

    final String apiUrl = "$_API_Path/SaveTransaction/SaveTransaction";

    debugPrint('Check Inserted _RegistrationId : $_RegistrationId ');
    debugPrint('Check Inserted now : $now ');

    var response = await http.post(
      Uri.parse(apiUrl),
      headers: {HttpHeaders.contentTypeHeader: 'application/json', HttpHeaders.authorizationHeader: 'bearer VA5kBnSw50cbuJ4YoAVkl4XyFTA312fRtKF4GxlmkUcl3PQJBKvvtogvT_0syd6ZtsZ4-1zFK6_liq5dQpyMq2tOA7vCtZ332qal7LGyBxBvv4mtD461lwGhNtprYd8PyIR40bBsoBc7nMElIniHJXAu1V04eO5c7sNLHOGypeG70Zn06yQr-0i_eFbsCRg6kMWjkao3RZwDfXVra5JQ5I7Pr1CbSgYez6rbYLMbH2LL6K8VcpmUvs45WpLe4UjPpChygW96LCoxVh7YtNa74n1Bje4sDdGLZowZJWwe7F9P7ijy1nVyw_v5K-8MqzlI' },
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



  Future<GroomingAppointmentSlotModel> getData() async{
    final _prefs = await SharedPreferences.getInstance();
    String _API_Path = _prefs.getString('API_Path');
    debugPrint('Check Inserted _API_Path $_API_Path');

    final String apiUrl =  "$_API_Path/AppointmentShopSlot/GetSlotForDay";
    String _RegistrationId = _prefs.getInt('id').toString();
    debugPrint('Check Inserted _API_Path $_API_Path');
    debugPrint('Check Inserted groomingId ${widget.groomingId}');
    debugPrint('Check Inserted _RegistrationId $_RegistrationId');
    debugPrint('Check Inserted shopId ${widget.shopId}');


    DateTime now = DateTime.now();
   String TodaysDate = DateFormat('dd-MM-yyyy').format(now);

    if(_appointmentDate =="Select Appointment Date"){
      _appointmentDate = TodaysDate;
    }
    debugPrint('Check Inserted _appointmentDate : $_appointmentDate');

    var response = await http.post(
      Uri.parse(apiUrl),
      headers: {HttpHeaders.contentTypeHeader: 'application/json', HttpHeaders.authorizationHeader: 'bearer VA5kBnSw50cbuJ4YoAVkl4XyFTA312fRtKF4GxlmkUcl3PQJBKvvtogvT_0syd6ZtsZ4-1zFK6_liq5dQpyMq2tOA7vCtZ332qal7LGyBxBvv4mtD461lwGhNtprYd8PyIR40bBsoBc7nMElIniHJXAu1V04eO5c7sNLHOGypeG70Zn06yQr-0i_eFbsCRg6kMWjkao3RZwDfXVra5JQ5I7Pr1CbSgYez6rbYLMbH2LL6K8VcpmUvs45WpLe4UjPpChygW96LCoxVh7YtNa74n1Bje4sDdGLZowZJWwe7F9P7ijy1nVyw_v5K-8MqzlI' },
      body: json.encode(
          {
            "SelectedDate":_appointmentDate,
            "ShopId":widget.shopId,
            "PatientId":_RegistrationId
          }
      ),
    );

/*
    final response = await http.post(apiUrl, body:
    {
      "SelectedDate":_appointmentDate,
      "ClinicId":widget.clinicId,
      "PatientId":_RegistrationId
    }
    );*/
    debugPrint('Check Inserted 2 ');
    debugPrint('Check Inserted 4  ${response.statusCode}');
    if(response.statusCode == 200){

      debugPrint('Check Inserted 3 : ${response.body}');

      final String responseString = response.body;

      debugPrint('Check Inserted 4  ${responseString}');

      this.setState(() {
        data = json.decode(response.body);
      });
      return groomingAppointmentSlotModelFromJson(responseString);
    }else{
      debugPrint('Check Inserted 5 ');
      return null;
    }
  }


  void rebuildPage() {
    setState(() {});
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
            .pushReplacement(new MaterialPageRoute(builder: (context) => GroomingListPage(onPressed: rebuildPage)));
        return new Future(() => false); //onWillPop is Future<bool> so return false
      },
      child: new Scaffold(
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
                      // Navigator.of(context)
                      //   .pushReplacement(new MaterialPageRoute(builder: (context) => FamilyDetailsListPage(onPressed: rebuildPage, regId: widget.registerationId,)));
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
                                                    icon: new Icon(Icons.check_circle, color: appColor,),
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
                                                        debugPrint(
                                                            '_saveTransactionResult transactionId *************$transactionId');

                                                        String _groomingId = widget.groomingId;
                                                        String _shopId = widget.shopId;
                                                        String _token = widget.token;
                                                        String _slotId = ("${data[index]["SlotId"]}");
                                                        String _slotDate =  ("${data[index]["SlotDate"]}");
                                                        String _slotStart =  ("${data[index]["SlotStart"]}");
                                                        String _slotEnd =  ("${data[index]["SlotEnd"]}");
                                                        String _dayId = ("${data[index]["DayId"]}").toString();



                                                        Navigator.of(context).pushAndRemoveUntil(
                                                          MaterialPageRoute(builder: (context) => CheckRazor(amount: widget.amount, transactionId:transactionId, groomingId:_groomingId, shopId:_shopId, token:_token, slotId:_slotId, slotDate:_slotDate, slotStart:_slotStart, slotEnd:_slotEnd, dayId:_dayId)), (Route<dynamic> route) => false,
                                                        );
                                                      }
                                                    }
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
