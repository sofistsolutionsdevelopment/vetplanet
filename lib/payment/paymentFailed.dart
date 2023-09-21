import 'package:flutter/material.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:vetplanet/constant/colors.dart';
import 'package:vetplanet/screens/dash.dart';
import 'package:vetplanet/screens/drawer.dart';




class FailedPage extends StatefulWidget {
  @override
  _FailedPageState createState() => _FailedPageState();
}

class _FailedPageState extends State<FailedPage> {
  void rebuildPage() {
    setState(() {});
  }


  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: (){
        Navigator.of(context)
            .pushReplacement(new MaterialPageRoute(builder: (context) => DashPage(onPressed: rebuildPage)));
        return new Future(() => false); //onWillPop is Future<bool> so return false
      },
      child: Scaffold(
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
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                  width: 60,height: 60,
                  child: Image.asset(
                    "assets/fail.png",),),
                SizedBox(height: 20,),
                Padding(
                  padding: const EdgeInsets.only(right:20, left: 20),
                  child: Text(
                    "Your payment is Failed, Please Book your Appointment again.",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize:22, fontFamily: "Camphor",
                        fontWeight: FontWeight.w500,color: Colors.red),),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
