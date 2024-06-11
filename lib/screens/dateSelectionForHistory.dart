import 'package:flutter/material.dart';
import 'package:vetplanet/constant/colors.dart';
import 'package:intl/intl.dart';
import 'package:vetplanet/screens/patientHistory.dart';
import 'dash.dart';
import 'drawer.dart';


class DateSelectionForHistoryPage extends StatefulWidget {
  final String petId;
  final String vetId;

  DateSelectionForHistoryPage({ this.petId, this.vetId });
  @override
  _DateSelectionForHistoryPageState createState() => _DateSelectionForHistoryPageState();
}

class _DateSelectionForHistoryPageState extends State<DateSelectionForHistoryPage> {
  final _globalKey = GlobalKey<ScaffoldMessengerState>();

  DateTime fromDate = DateTime.now();
  DateTime toDate = DateTime.now();

  String _fromDate ="Select From Date";
  String _toDate = "Select To Date";

  String _from ="Select From Date";
  String _to ="Select To Date";

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final GlobalKey<FormState> _formStateKey = GlobalKey<FormState>();

  TextEditingController _fromDatecontroller = new TextEditingController();
  TextEditingController _toDatecontroller = new TextEditingController();

  var myFormat = DateFormat('dd/MM/yyyy');
  Future<void> _selectFromDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: fromDate,
        firstDate: DateTime(2000),
        lastDate: DateTime.now());
    setState(() {
      fromDate = picked ?? fromDate;
      _fromDate = DateFormat('dd-MM-yyyy').format(fromDate);
      _from = DateFormat('yyyy-MM-dd').format(fromDate);
      debugPrint('_fromDate : $_fromDate' );
      debugPrint('_from : $_from' );
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
      _toDate = DateFormat('dd-MM-yyyy').format(toDate);
      _to = DateFormat('yyyy-MM-dd').format(toDate);
      debugPrint('_toDate : $_toDate' );
      debugPrint('_toDate : $_to' );

    });
  }


  void rebuildPage() {
    setState(() {});
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
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
      body: Form(
        key: _formStateKey,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0),
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(right:5, left:5),
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
                        final snackBar = SnackBar(content:Text('Please Select From Date', style: TextStyle(fontSize: 20),));
                        ScaffoldMessenger.of(context).showSnackBar(snackBar);
                      }
                      if(_fromDate != "Select From Date" && _toDate == "Select To Date" ){
                        final snackBar = SnackBar(content:Text('Please Select To Date', style: TextStyle(fontSize: 20),));
                        ScaffoldMessenger.of(context).showSnackBar(snackBar);
                      }
                      if(_fromDate == "Select From Date" && _toDate == "Select To Date"){
                        final snackBar = SnackBar(content:Text('Please Select From Date and To Date', style: TextStyle(fontSize: 20),));
                        ScaffoldMessenger.of(context).showSnackBar(snackBar);
                      }
                      if(_fromDate != "Select From Date" && _toDate != "Select To Date"){
                        //_futuregSOAPNote = getSOAPNote(_from,_to);
                        Navigator.push(
                            context, MaterialPageRoute(builder: (context) =>
                            PatientHistoryPage(fromDate: _from, toDate: _to, petId: widget.petId, vetId: widget.vetId)));

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





              ],
            ),
          ),
        ),
      ),
    );
  }
}



