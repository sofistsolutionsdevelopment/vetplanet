import 'package:flutter/material.dart';
import 'package:vetplanet/constant/colors.dart';
import 'package:vetplanet/screens/dash.dart';
import 'package:vetplanet/screens/drawer.dart';
import 'check.dart';

class PaymentPage extends StatefulWidget {
  @override
  _PaymentPageState createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {

  void rebuildPage() {
    setState(() {});
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
        title: Text("", style: TextStyle(fontSize:22, fontFamily: "Camphor",
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
      body: Center(
        child: Container(
          child: ElevatedButton(
            //color: Colors.green,
            onPressed: () => Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(
                    builder: (context) => CheckRazor(),
                  ),
                  (Route<dynamic> route) => false,
                ),
            child: Text(
              "Pay Now",
            ),
          ),
        ),
      ),
    );
  }
}
