import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vetplanet/constant/colors.dart';
import 'package:vetplanet/models/result_model.dart';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'package:vetplanet/screens/allComments.dart';
import 'package:vetplanet/screens/allComments_groomers.dart';
import 'package:vetplanet/screens/groomingDetails.dart';
import 'package:vetplanet/screens/vetDetails.dart';
import 'dash.dart';
import 'drawer.dart';


class SendCommentforGroomerPage extends StatefulWidget {
  final String userKey;

  SendCommentforGroomerPage({ this.userKey});
  @override
  _SendCommentforGroomerPageState createState() => _SendCommentforGroomerPageState();
}

class _SendCommentforGroomerPageState extends State<SendCommentforGroomerPage> {

  void rebuildPage() {
    setState(() {});
  }
  String _comment = "";

  ResultModel _result;

  Future<ResultModel> saveComment(String comment) async{
    final _prefs = await SharedPreferences.getInstance();
    String _API_Path = _prefs.getString('API_Path');
    String _RegistrationId = _prefs.getInt('id').toString();
    debugPrint('Check saveComment _API_Path $_API_Path ');
    debugPrint('Check saveComment _RegistrationId $_RegistrationId ');

    final String apiUrl = "$_API_Path/SaveComment/SaveComment";

    debugPrint('Check saveComment 1 ');

    var response = await http.post(
      Uri.parse(apiUrl),
      headers: {HttpHeaders.contentTypeHeader: 'application/json', HttpHeaders.authorizationHeader: 'bearer VA5kBnSw50cbuJ4YoAVkl4XyFTA312fRtKF4GxlmkUcl3PQJBKvvtogvT_0syd6ZtsZ4-1zFK6_liq5dQpyMq2tOA7vCtZ332qal7LGyBxBvv4mtD461lwGhNtprYd8PyIR40bBsoBc7nMElIniHJXAu1V04eO5c7sNLHOGypeG70Zn06yQr-0i_eFbsCRg6kMWjkao3RZwDfXVra5JQ5I7Pr1CbSgYez6rbYLMbH2LL6K8VcpmUvs45WpLe4UjPpChygW96LCoxVh7YtNa74n1Bje4sDdGLZowZJWwe7F9P7ijy1nVyw_v5K-8MqzlI' },
      body: json.encode(
          {
            "PatientId":_RegistrationId,
            "VetId":"0",
            "GroomerId":widget.userKey,
            "Comments":comment
          }
      ),
    );

    debugPrint('Check saveComment 2 ');

    if(response.statusCode == 200){

      debugPrint('Check saveComment 3 : ${response.body}');

      final String responseString = response.body;

      debugPrint('Check saveComment 4  ${responseString}');

      return resultModelFromJson(responseString);

    }else{
      debugPrint('Check saveComment 5 ');
      return null;
    }
  }


  final TextEditingController _controllerComment = new TextEditingController();
  final GlobalKey<FormState> _formStateKey = GlobalKey<FormState>();

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

        body:Form(
          key: _formStateKey,
          child: SingleChildScrollView(
            child:  Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: <Widget>[
                  SizedBox(height: 50,),

                  TextFormField(
                    onSaved: (value) {
                      _comment = value;
                    },
                    maxLines: 8,
                    controller: _controllerComment,
                    keyboardType: TextInputType.text,
                    //maxLength: 4,
                    showCursor: true,
                    decoration: InputDecoration(
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.black),
                        borderRadius: BorderRadius.circular(5.0),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.black),
                        borderRadius: BorderRadius.circular(5.0),
                      ),
                      //filled: true,
                     // fillColor: Color(0xFFF2F3F5),
                      hintStyle: TextStyle(
                        color: appColor, fontSize: 12,fontFamily: "Camphor",
                        fontWeight: FontWeight.w500,
                      ),
                      hintText: "Share Your Comment",
                    ),
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'Please Enter Comment';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 35,),
                  InkWell(
                    onTap: () async{
                    if (_formStateKey.currentState.validate()) {
                      _formStateKey.currentState.save();

                      final String comment = _comment;

                      debugPrint('comment : ${comment}');
                      final ResultModel result = await saveComment(comment);
                      debugPrint('Check Inserted result : $result');
                      setState(() {
                        _result = result;
                        _controllerComment.clear();
                      });
                      Navigator.pushReplacement(
                          context, MaterialPageRoute(builder: (context) => AllCommentsGroomersPage(userKey:widget.userKey)));
                    }
                  },
                    child: Container(
                      color: appColor,
                      child: Padding(
                        padding: const EdgeInsets.only(top:15, bottom: 15, left: 85, right: 85),
                        child: Text("Share",style: TextStyle(color: Colors.white,fontFamily: "Camphor",
                            fontWeight: FontWeight.w900, fontSize: 16),),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),

      ),
    );
  }
}
