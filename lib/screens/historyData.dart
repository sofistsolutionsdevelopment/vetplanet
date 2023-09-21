import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:vetplanet/constant/colors.dart';
import 'dash.dart';
import 'drawer.dart';

class HistoryPage extends StatefulWidget {
  final Function onPressed;

 HistoryPage({ this.onPressed });
  @override
  _HistoryPageState createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
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
        firstDate: DateTime(2015, 8),
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

    return WillPopScope(
      onWillPop: (){
        //on Back button press, you can use WillPopScope for another purpose also.
        // Navigator.pop(context); //return data along with pop
        Navigator.of(context)
            .pushReplacement(new MaterialPageRoute(builder: (context) => DashPage(onPressed: rebuildPage)));
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
            FittedBox(
              fit:BoxFit.fitWidth,
              child: Text("History", style: TextStyle(fontSize:22, fontFamily: "Camphor",
                  fontWeight: FontWeight.w900,color: Colors.white),),
            ),
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
          body: Container(
           /* padding: EdgeInsets.only(left: 20, right: 20, top: 35, bottom: 30),
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/dashbg.png"),
                fit: BoxFit.fill,
              ),
            ),*/
            child: Form(
              key: _formStateKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  SizedBox(height: 50,),
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
                  SizedBox(height: 35,),
                  InkWell(
                    onTap: () async {
      
      
                      if (_formStateKey.currentState.validate()) {
                        _formStateKey.currentState.save();
      
      
                        debugPrint('_fromDate : ${_fromDate}' );
                        debugPrint('_toDate : $_toDate' );
      
                        if(_fromDate == "Select From Date" && _toDate != "Select To Date"){
                          final snackBar = SnackBar(content:Text('Please Select From Date', style: TextStyle(fontSize: 20),));
                          _globalKey.currentState.showSnackBar(snackBar);
                        }
                        if(_fromDate != "Select From Date" && _toDate == "Select To Date" ){
                          final snackBar = SnackBar(content:Text('Please Select To Date', style: TextStyle(fontSize: 20),));
                          _globalKey.currentState.showSnackBar(snackBar);
                        }
                        if(_fromDate == "Select From Date" && _toDate == "Select To Date"){
                          final snackBar = SnackBar(content:Text('Please Select From Date and To Date', style: TextStyle(fontSize: 20),));
                          _globalKey.currentState.showSnackBar(snackBar);
                        }
                        if(_fromDate != "Select From Date" && _toDate != "Select To Date"){
      
      
                          //Navigator.push(
                           //   context, MaterialPageRoute(builder: (context) =>
                           //   ConsumerLoanReportListPage(fromDate: _from, toDate: _to)));
                        }
      
      
                      }
                    },
                    child: Container(
                      height: 50,
                      width: 200,
                      alignment: Alignment.center,
                      child: Image.asset(
                        "assets/countinue_r_btn.png",
                      ),
                    ),
                  ),
      
                  SizedBox(height: 10,),
                ],
              ),
            ),
          ),
          drawer: DrawerPage(),
      
      
        ),
      ),

    );

  }
}

