import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vetplanet/constant/colors.dart';
import 'package:vetplanet/models/comment_model.dart';
import 'package:vetplanet/screens/dash.dart';
import 'dart:io';
import 'package:vetplanet/screens/drawer.dart';
import 'package:vetplanet/screens/groomingDetails.dart';
import 'package:vetplanet/screens/sendComments_forGroomer.dart';
import 'dash.dart';

class AllCommentsGroomersPage extends StatefulWidget {
  final String userKey;
  final String visitorCount;

  AllCommentsGroomersPage({ this.userKey, this.visitorCount});

  @override
  _AllCommentsGroomersPageState createState() => _AllCommentsGroomersPageState();
}

class _AllCommentsGroomersPageState extends State<AllCommentsGroomersPage> {

  Future<List> _futureComment;

  String _commentLenght = "";


  Future<List<CommentModel>> getComment() async {
    final _prefs = await SharedPreferences.getInstance();
    
    String _RegistrationId = _prefs.getInt('id').toString();
    debugPrint('Check Inserted apiUrl $apiUrl ');
    debugPrint('Check Inserted _RegistrationId $_RegistrationId ');


    final String url = "$apiUrl/GetGroomerCommentList/GetGroomerCommentList";

    debugPrint('Check Inserted 1 ');
    var response = await http.post(
      Uri.parse(url),
      headers: {HttpHeaders.contentTypeHeader: 'application/json', HttpHeaders.authorizationHeader: bearerToken },
      body: json.encode(
          {
            "GroomerId": widget.userKey,
            "Operation":"all"
          }
      ),
    );

    debugPrint('Check 2}');
    if (response != null && response.statusCode == 200) {
      debugPrint('Check 3}');
      var _response = json.decode(response.body);
      debugPrint('Check 4  ${_response}');


      List<CommentModel> _comment = _response
          .map<CommentModel>(
              (_json) => CommentModel.fromJson(_json))
          .toList();


      debugPrint('Check 5  ${_comment}');
      setState(() {
        _commentLenght = _comment.length.toString();
        debugPrint('Check _commentLenght &&&&&&&&&&&&&&&&&&&&&&&&&: $_commentLenght}');


      });
      return _comment;

    } else {
      debugPrint('Check 6');
      return [];
    }
  }


  void rebuildPage() {
    setState(() {});
  }


  @override
  void initState() {
    super.initState();

    _futureComment = getComment();
  }



  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: (){
        //on Back button press, you can use WillPopScope for another purpose also.
        // Navigator.pop(context); //return data along with pop
        Navigator.of(context)
            .pushReplacement(new MaterialPageRoute(builder: (context) => GroomingDetails(onPressed: rebuildPage, userKey:widget.userKey)));
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

        body:Column(
          children: <Widget>[

            if(_commentLenght != "0")
              Expanded(
                child: FutureBuilder(
                  future: _futureComment,
                  builder: (context, snapshot) {
                    if (snapshot.hasError) {
                      return Center(child: Text(''));
                    }
                    if (snapshot.hasData) {
                      List<CommentModel> _comment = snapshot.data;
                      return ListView.builder(
                        shrinkWrap: true,
                        itemCount: _comment == null ? 0 : _comment.length,
                        itemBuilder: (BuildContext context, int index) {
                          return  Padding(
                            padding: const EdgeInsets.all(8.0),
                            child:Column(
                              children: <Widget>[
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    children: <Widget>[

                                      Padding(
                                        padding: const EdgeInsets.all(5.0),
                                        child: Row(
                                          children: <Widget>[

                                            Expanded(
                                              child: RichText(
                                                //    maxLines: 10,
                                                text: new TextSpan(
                                                  text: '${_comment[index].PatientName} : ',
                                                  style: TextStyle(fontSize:14, fontFamily: "Camphor",
                                                      fontWeight: FontWeight.w500,color: Colors.black),
                                                  children: <TextSpan>[
                                                    new TextSpan(
                                                      text:
                                                      " ${_comment[index].Comments}",
                                                      style: TextStyle(fontSize:12, fontFamily: "Camphor",
                                                          fontWeight: FontWeight.w700,color: Colors.black),),
                                                  ],
                                                ),
                                              ),
                                            ),
                                            SizedBox(width: 10),


                                          ],
                                        ),
                                      ),


                                    ],
                                  ),
                                ),
                                Divider(
                                  height: 1,
                                  thickness: 0.5,
                                  color: Colors.grey,
                                ),
                              ],
                            ),
                          );

                        },
                      );
                    }
                    return Center(child: SpinKitRotatingCircle(
                      color: appColor,
                      size: 50.0,
                    ));
                  },
                ),
              ),
            if(_commentLenght == "0")
              Column(
                children: <Widget>[
                  SizedBox(height: 100,),
                  Center(
                    child: Text("No Comment Found", style: TextStyle(fontSize: 22, color: Colors.red,fontFamily: "Camphor",
                      fontWeight: FontWeight.w900,),textAlign: TextAlign.center,),
                  ),
                ],
              ),

          ],
        ),

        bottomNavigationBar:   Container(
          height: 50,
          width: double.infinity,
          child: Column(
            children: <Widget>[
              if(widget.visitorCount == "1")
              Align(
                  alignment: Alignment.center,
                  child: Padding(
                    padding: const EdgeInsets.only(right:10),
                    child: InkWell(
                      onTap:(){
                        Navigator.pushReplacement(
                            context, MaterialPageRoute(builder: (context) => SendCommentforGroomerPage(userKey:widget.userKey)));
                      },
                      child: Container(
                        color: appColor,
                        child: Padding(
                          padding: const EdgeInsets.only(top:10, bottom: 10, left: 25, right: 25),
                          child: Text("Share Your Comment",style: TextStyle(color: Colors.white,fontFamily: "Camphor",
                              fontWeight: FontWeight.w900, fontSize: 16),),
                        ),
                      ),
                    ),
                  )),
            ],
          ),

        ),
      ),
    );
  }

 }











