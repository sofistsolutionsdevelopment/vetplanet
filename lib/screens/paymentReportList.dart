import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:vetplanet/constant/colors.dart';
import 'package:vetplanet/models/paymentReport_model.dart';
import 'dash.dart';
import 'drawer.dart';

class PaymentReportListPage extends StatefulWidget {

  @override
  _PaymentReportListPageState createState() => _PaymentReportListPageState();
}

class _PaymentReportListPageState extends State<PaymentReportListPage> {

  String vendorName = "";
  String reportListLenght = "";

  Future<List<PaymentReportModel>> getPaymentReport() async {
    final _prefs = await SharedPreferences.getInstance();
    
    String _RegistrationId = _prefs.getInt('id').toString();
    debugPrint('Check Inserted apiUrl $apiUrl ');
    final String url = "$apiUrl/GetPaymentReport/GetPaymentReport";

    debugPrint('Check Inserted 1 ');
    debugPrint('Check Inserted regId $_RegistrationId');
    var response = await http.post(
      Uri.parse(url),
      headers: {HttpHeaders.contentTypeHeader: 'application/json', HttpHeaders.authorizationHeader: bearerToken },
    );

    debugPrint('Check 2}');
    if (response != null && response.statusCode == 200) {
      debugPrint('Check 3}');
      var _response = json.decode(response.body);
      debugPrint('Check 4  ${_response}');

      List<PaymentReportModel> _paymentReportList = _response
          .map<PaymentReportModel>(
              (_json) => PaymentReportModel.fromJson(_json))
          .toList();
      debugPrint('Check 5  ${_paymentReportList}');
      setState(() {
        reportListLenght = _paymentReportList.length.toString();
      });
      return _paymentReportList;

    } else {
      debugPrint('Check 6');
      return [];
    }
  }


  void rebuildPage() {
    setState(() {});
  }


  String splitString1Amount = "";
  String splitString2Amount = "";

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: (){
        //on Back button press, you can use WillPopScope for another purpose also.
        // Navigator.pop(context); //return data along with pop
        Navigator.of(context)
            .pushReplacement(new MaterialPageRoute(builder: (context) => DashPage(onPressed: rebuildPage)));
        return new Future(() => false); //onWillPop is Future<bool> so return false
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: appColorlight,
          flexibleSpace: (Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(2)),
              color: appColorlight
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

          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              SizedBox(height: 10,),

              if(reportListLenght == "0")
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    SizedBox(height: 25,),
                    Center(
                      child: Text("No Payment Transaction Details Found.",textAlign: TextAlign.center, style: TextStyle(fontSize: 19, color: Colors.black,fontFamily: "Camphor",
                        fontWeight: FontWeight.w700,),),
                    ),
                  ],
                ),
              if(reportListLenght != "0")
              Container(
                color: Color(0xffAD3463),
                 child: Padding(
                  padding: const EdgeInsets.only(right:20, left: 20, top: 5, bottom: 5),
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text('Date', style: TextStyle(fontFamily: "Camphor",fontSize: 16,color: Colors.white,
                          fontWeight: FontWeight.w700,),),
                        Text('Payment To', style: TextStyle(fontFamily: "Camphor",fontSize: 16,color: Colors.white,
                          fontWeight: FontWeight.w700,)),
                        Text('Pet', style: TextStyle(fontFamily: "Camphor",fontSize: 16,color: Colors.white,
                          fontWeight: FontWeight.w700,)),
                        Text('Amount', style: TextStyle(fontFamily: "Camphor",fontSize: 16,color: Colors.white,
                          fontWeight: FontWeight.w700,)),
                      ]
                  ),
                ),
              ),
              if(reportListLenght != "0")
                Expanded(
                  child:  FutureBuilder(
                    future: getPaymentReport(),
                    builder: (context, snapshot) {
                      if (snapshot.hasError) {
                        return Center(child: Text(''));
                      }
                      if (snapshot.hasData) {
                        List<PaymentReportModel> _PaymentReportList = snapshot.data;
                        return ListView.builder(
                          itemCount: _PaymentReportList == null ? 0 : _PaymentReportList.length,
                          itemBuilder: (BuildContext context, int index) {
                            String amount = "${_PaymentReportList[index].Amount}";
                            var splitAmount = amount.split(".");
                            splitString1Amount = splitAmount[0];
                            splitString2Amount = splitAmount[1];
                            print("splitString1Amount : $splitString1Amount");
                            print("splitString2Amount : $splitString2Amount");

                            return  Container(
                              //color: Colors.white,
                              color: index % 2 == 0 ? Colors.white : Color(0xffd6d6d6),
                              child: Table(
                                defaultColumnWidth: FixedColumnWidth(50),
                                border: TableBorder.all(
                                    color: Colors.grey,
                                    style: BorderStyle.solid,
                                    width: 1),
                                children: [
                                  TableRow( children: [


                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children:[Padding(
                                      padding: const EdgeInsets.all(5),
                                      child: Text("${_PaymentReportList[index].Date}",style: TextStyle(fontSize: 15,fontFamily: "Camphor",
                                          fontWeight: FontWeight.w500,color: Colors.black),),
                                    ),]),

                                    Column(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children:[Padding(
                                          padding: const EdgeInsets.all(5),
                                          child: Text("${_PaymentReportList[index].UserName}",style: TextStyle(fontSize: 15,fontFamily: "Camphor",
                                              fontWeight: FontWeight.w500,color: Colors.black),),
                                        ),]),

                                    Column(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children:[Padding(
                                          padding: const EdgeInsets.all(5),
                                          child: Text("${_PaymentReportList[index].PetNames}",style: TextStyle(fontSize: 15,fontFamily: "Camphor",
                                              fontWeight: FontWeight.w500,color: Colors.black),),
                                        ),]),

                                    Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children:[Padding(
                                          padding: const EdgeInsets.all(5),
                                          child: Text("\u20B9$splitString1Amount",style: TextStyle(fontSize: 15,fontFamily: "Camphor",
                                              fontWeight: FontWeight.w700,color: Colors.black),),
                                        ),]),

                                  ]),
                                ],
                              ),
                            );
                          },
                        );
                      }
                      return Center(child: SpinKitRotatingCircle(
                        color: Colors.indigo,
                        size: 50.0,
                      ));
                    },
                  ),
                ),
              SizedBox(height: 10,),
            ],
          ),




        ),


      ),

    );

  }
}

