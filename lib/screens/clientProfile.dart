import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'dart:convert';
import 'dart:io';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:vetplanet/constant/colors.dart';
import 'package:vetplanet/models/result_model.dart';
import 'package:vetplanet/screens/dash.dart';
import 'package:flutter/cupertino.dart';
import 'dart:ui';
import 'package:flutter/rendering.dart';
import 'package:vetplanet/models/clientProfile_model.dart';
import 'drawer.dart';

class MyProfilePage extends StatefulWidget {
  @override
  _MyProfilePageState createState() => _MyProfilePageState();
}

class _MyProfilePageState extends State<MyProfilePage> {

  Future<ClientProfileModel> _resultClientProfile;

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

      debugPrint('Check Inserted 4  ${responseString}');

      return clientProfileModelFromJson(responseString);


    }else{
      debugPrint('Check Inserted 5 ');
      return null;
    }
  }

  final GlobalKey<FormState> _formStateKey = GlobalKey<FormState>();

  String name;
  String contactNo;
  String emailId;
  String location;


  @override
  void initState() {
    _resultClientProfile = getClientProfile();
    super.initState();
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
        body: Container(
          width: double.infinity,
          height: double.infinity,
          /*decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/dashbg_r.png"),
              fit: BoxFit.fill,
            ),
          ),*/
          child: SingleChildScrollView(

            child: FutureBuilder<ClientProfileModel>(
              future: _resultClientProfile,
              builder: (context, snapshot)
              {
                if (snapshot.hasData)
                {
                  return  new   Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                   /*       Container(
                            width: 150,
                            height: 150,
                            alignment: Alignment.center,
                            child: Image.asset(
                              "assets/propic.png",
                            ),
                          ),
*/
                          SizedBox(
                            height: 10.0,
                          ),

                          Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Column(
                                children: <Widget>[

                                  Padding(
                                    padding: const EdgeInsets.only(left:20, top:20, bottom: 20,right: 20),
                                    child: Card(
                                      elevation: 1.0,
                                      child:Container(
                                        child: Padding(
                                          padding: const EdgeInsets.only(left:20, top:20, bottom: 20, right: 20),
                                          child: Column(
                                            children: <Widget>[

                                              InkWell(
                                                onTap: (){
                                                  //  showAlertDialogEdit(context);


                                                  final String UserName =  snapshot.data.UserName;
                                                  final String ContactNo =  snapshot.data.ContactNo;
                                                  final String Email =  snapshot.data.Email;
                                                  final String ADDRESS =  snapshot.data.ADDRESS;
                                                  final String AlternateContactNo =  snapshot.data.AlternateContactNo;
                                                  final String DOB =  snapshot.data.DOB;

                                                  showAlertDialogEdit( UserName, ContactNo, Email, ADDRESS, AlternateContactNo, DOB );

                                                },
                                                child: Container(
                                                  child:  Align(alignment:Alignment.centerRight,child: Icon(Icons.edit,color: Colors.black,)),
                                                ),
                                              ),
                                              Align(
                                                alignment: Alignment.centerLeft,
                                                child: Text(
                                                  'Name : ',
                                                  style: TextStyle(
                                                    color: Color(0xff001B48),
                                                    fontSize: 20,
                                                    fontWeight: FontWeight.w700,
                                                    fontFamily: "Camphor",
                                                  ),
                                                ),
                                              ),
                                              SizedBox(
                                                height: 10.0,
                                              ),
                                              Align(
                                                alignment: Alignment.centerLeft,
                                                child: Text(
                                                  snapshot.data.UserName,
                                                  style: TextStyle(
                                                      fontSize: 18,color: Colors.black,    fontWeight: FontWeight.w500,
                                                    fontFamily: "Camphor",
                                                  ),
                                                ),
                                              ),
                                              SizedBox(
                                                height: 5.0,
                                              ),
                                              Divider(),
                                              SizedBox(
                                                height: 5.0,
                                              ),
                                              Align(
                                                alignment: Alignment.centerLeft,
                                                child: Text(
                                                  'Contact No. : ',
                                                  style: TextStyle(
                                                    color: Color(0xff001B48),
                                                    fontSize: 20,
                                                    fontWeight: FontWeight.w700,
                                                    fontFamily: "Camphor",
                                                  ),
                                                ),
                                              ),
                                              SizedBox(
                                                height: 10.0,
                                              ),
                                              Align(
                                                alignment: Alignment.centerLeft,
                                                child: Text(
                                                  snapshot.data.ContactNo,
                                                  style: TextStyle(
                                                      fontSize: 18,color: Colors.black,    fontWeight: FontWeight.w500,
                                                    fontFamily: "Camphor",
                                                  ),
                                                ),
                                              ),
                                              SizedBox(
                                                height: 5.0,
                                              ),
                                              Divider(),
                                              SizedBox(
                                                height: 5.0,
                                              ),
                                              Align(
                                                alignment: Alignment.centerLeft,
                                                child: Text(
                                                  'E-Mail Id : ',
                                                  style: TextStyle(
                                                    color: Color(0xff001B48),
                                                    fontSize: 20,
                                                    fontWeight: FontWeight.w700,
                                                    fontFamily: "Camphor",

                                                  ),
                                                ),
                                              ),
                                              SizedBox(
                                                height: 10.0,
                                              ),
                                              Align(
                                                alignment: Alignment.centerLeft,
                                                child: Text(
                                                  snapshot.data.Email,
                                                  style: TextStyle(
                                                      fontSize: 18,color: Colors.black,    fontWeight: FontWeight.w500,
                                                    fontFamily: "Camphor",
                                                  ),
                                                ),
                                              ),
                                              SizedBox(
                                                height: 5.0,
                                              ),
                                              Divider(),
                                              SizedBox(
                                                height: 5.0,
                                              ),
                                              Align(
                                                alignment: Alignment.centerLeft,
                                                child: Text(
                                                  'Address : ',
                                                  style: TextStyle(
                                                    color: Color(0xff001B48),
                                                    fontSize: 20,
                                                    fontWeight: FontWeight.w700,
                                                    fontFamily: "Camphor",

                                                  ),
                                                ),
                                              ),
                                              SizedBox(
                                                height: 10.0,
                                              ),
                                              Align(
                                                alignment: Alignment.centerLeft,
                                                child: Text(
                                                  snapshot.data.ADDRESS,
                                                  style: TextStyle(
                                                      fontSize: 18,color: Colors.black,    fontWeight: FontWeight.w500,
                                                    fontFamily: "Camphor",
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),



                                ],
                              )),
                        ],
                      ),

                      SizedBox(height: 30,),
                    ],
                  );

                }
                else if (snapshot.hasError)
                {
                  return Align(alignment: Alignment.center, child: Text(""));
                }

                return Center(child: SpinKitRotatingCircle(
                  color: Colors.white,
                  size: 50.0,
                ));
              },
            ),
          ),
        ),

      ),
    );

  }
  showAlertDialogEdit( String UserName, String ContactNo, String Email, String ADDRESS, String AlternateContactNo, String DOB) {
    ResultModel _result;


    Future<ResultModel> updateProfile(String _name, String _contactNo, String _emailId, String _location, String _alternateContactNo, String _dob ) async{

      final _prefs = await SharedPreferences.getInstance();
      String _API_Path = _prefs.getString('API_Path');
      String _RegistrationId = _prefs.getInt('id').toString();
      debugPrint('Check Inserted _API_Path $_API_Path ');

      final String apiUrl = "$_API_Path/ModifyClient/ModifyClient";

      debugPrint('Check Inserted 1 ');

      var response = await http.post(
        Uri.parse(apiUrl),
        headers: {HttpHeaders.contentTypeHeader: 'application/json', HttpHeaders.authorizationHeader: 'bearer VA5kBnSw50cbuJ4YoAVkl4XyFTA312fRtKF4GxlmkUcl3PQJBKvvtogvT_0syd6ZtsZ4-1zFK6_liq5dQpyMq2tOA7vCtZ332qal7LGyBxBvv4mtD461lwGhNtprYd8PyIR40bBsoBc7nMElIniHJXAu1V04eO5c7sNLHOGypeG70Zn06yQr-0i_eFbsCRg6kMWjkao3RZwDfXVra5JQ5I7Pr1CbSgYez6rbYLMbH2LL6K8VcpmUvs45WpLe4UjPpChygW96LCoxVh7YtNa74n1Bje4sDdGLZowZJWwe7F9P7ijy1nVyw_v5K-8MqzlI' },
        body: json.encode(
            {
              "PatientId":_RegistrationId,
              "UserName":_name,
              "ContactNo":_contactNo,
              "ADDRESS":_location,
              "Email":_emailId,
            }
        ),
      );


      debugPrint('Check Inserted 2');
      debugPrint('Check Inserted response.statusCode : ${response.statusCode}');

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





    Widget addButton =
    Container(
      height: 50,
      width:300,
      decoration: new BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(5.0)),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: appColor,
          ),
          BoxShadow(
            color: appColor,
          ),
        ],
        gradient: new LinearGradient(
            colors: [appColor, appColor],
            begin: const FractionalOffset(0.2, 0.2),
            end: const FractionalOffset(1.0, 1.0),
            stops: [0.0, 1.0],
            tileMode: TileMode.clamp),
      ),
      child: MaterialButton(
        highlightColor: Colors.transparent,
        splashColor: appColor,
        //shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(5.0))),
        child: Padding(
          padding:
          const EdgeInsets.symmetric(vertical: 10.0, horizontal: 42.0),
          child: Text(
            "Update",
            style: TextStyle(
                color: Colors.white,
                fontSize: 22.0,
                fontFamily: "WorkSansBold"),
          ),
        ),
        onPressed: () async {

          if (_formStateKey.currentState.validate()) {
            _formStateKey.currentState.save();



            final String _name = name ;
            final String _contactNo = contactNo;
            final String _emailId = emailId;
            final String _location = location;
            final String _alternateContactNo = AlternateContactNo;
            final String _dob = DOB;

            debugPrint('Check _name  : ${_name}');
            debugPrint('Check _contactNo  : ${_contactNo}');
            debugPrint('Check _emailId  : ${_emailId}');
            debugPrint('Check _location  : ${_location}');
            debugPrint('Check _alternateContactNo  : ${_alternateContactNo}');
            debugPrint('Check _dob  : ${_dob}');


            final ResultModel result = await updateProfile(_name, _contactNo, _emailId, _location, _alternateContactNo, _dob);
             setState(() {
               _result = result;
             });


            if (result.Result == "UPDATED" ) {

              _resultClientProfile = getClientProfile();
              Navigator.pop(context);

            }

            else {
              _resultClientProfile = getClientProfile();
            }


          }
        },),
    );


    AlertDialog alert = AlertDialog(
      contentPadding: EdgeInsets.only(left: 25, right: 25),
      title: Center(child: Text("Update Profile")),
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(20.0))),
      content: Form(
        key: _formStateKey,
        child: Container(
          height: 350,
          width: 300,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                SizedBox(
                  height: 20,
                ),



                Padding(
                  padding: const EdgeInsets.only(right:10, left:10),
                  child: Container(
                    margin: EdgeInsets.symmetric(vertical: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          "Name",
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18,color: Colors.grey),
                        ),

                        TextFormField(
                          initialValue: UserName,
                          onSaved: (value) {
                            name = value;
                          },
                          // controller: _nameController,
                          keyboardType: TextInputType.text, // maxLength: 10,
                          showCursor: true,
                          decoration: const InputDecoration(
                            enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.black),
                            ),
                            focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.black),
                            ),
                            //icon: Icon(Icons.person,color: Colors.white,),
                            hintText: "" ,
                            //labelText: 'Email',
                            hintStyle: TextStyle(color: Colors.black),


                          ),
                          validator: (value) {
                            if (value.isEmpty) {
                              return 'Please Enter Name';
                            }
                            return null;
                          },
                          style: TextStyle(color: Colors.black,fontSize: 18),
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(right:10, left:10),
                  child: Container(
                    margin: EdgeInsets.symmetric(vertical: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          "Contact No",
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18,color: Colors.grey),
                        ),

                        TextFormField(
                          initialValue: ContactNo,
                          onSaved: (value) {
                            contactNo = value;
                          },
                          // controller: _nameController,
                          keyboardType: TextInputType.text,
                          showCursor: true,
                          decoration: const InputDecoration(
                            enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.black),
                            ),
                            focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.black),
                            ),
                            //icon: Icon(Icons.person,color: Colors.white,),
                            hintText: "" ,
                            //labelText: 'Email',
                            hintStyle: TextStyle(color: Colors.black),


                          ),
                          validator: (value) {
                            if (value.isEmpty) {
                              return 'Please Enter Contact No';
                            }
                            return null;
                          },
                          style: TextStyle(color: Colors.black,fontSize: 18),
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(right:10, left:10),
                  child: Container(
                    margin: EdgeInsets.symmetric(vertical: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          "E-Mail Id",
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18,color: Colors.grey),
                        ),

                        TextFormField(
                          initialValue: Email,
                          onSaved: (value) {
                            emailId = value;
                          },
                          // controller: _nameController,
                          keyboardType: TextInputType.text, // maxLength: 10,
                          showCursor: true,
                          decoration: const InputDecoration(
                            enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.black),
                            ),
                            focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.black),
                            ),
                            //icon: Icon(Icons.person,color: Colors.white,),
                            hintText: "" ,
                            //labelText: 'Email',
                            hintStyle: TextStyle(color: Colors.black),


                          ),
                          validator: (value) {
                            if (value.isEmpty) {
                              return 'Please Enter E-Mail Id';
                            }
                            return null;
                          },
                          style: TextStyle(color: Colors.black,fontSize: 18),
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(right:10, left:10),
                  child: Container(
                    margin: EdgeInsets.symmetric(vertical: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          "Address",
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18,color: Colors.grey),
                        ),

                        TextFormField(
                          initialValue: ADDRESS,
                          onSaved: (value) {
                            location = value;
                          },
                          // controller: _nameController,
                          keyboardType: TextInputType.text, // maxLength: 10,
                          showCursor: true,
                          decoration: const InputDecoration(
                            enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.black),
                            ),
                            focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.black),
                            ),
                            //icon: Icon(Icons.person,color: Colors.white,),
                            hintText: "" ,
                            //labelText: 'Email',
                            hintStyle: TextStyle(color: Colors.black),


                          ),
                          validator: (value) {
                            if (value.isEmpty) {
                              return 'Please Enter Address';
                            }
                            return null;
                          },
                          style: TextStyle(color: Colors.black,fontSize: 18),
                        ),
                      ],
                    ),
                  ),
                ),




              ],
            ),
          ),
        ),
      ),
      actions: <Widget>[
        addButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );


  }
}
