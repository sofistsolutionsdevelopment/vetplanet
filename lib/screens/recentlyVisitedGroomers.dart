import 'dart:convert';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:geolocator/geolocator.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:vetplanet/constant/colors.dart';
import 'package:vetplanet/models/grooming_model.dart';
import 'package:vetplanet/models/pet_model.dart';
import 'package:vetplanet/models/vet_model.dart';
import 'package:vetplanet/screens/petRegistration.dart';
import 'package:vetplanet/screens/selectClinic.dart';
import 'package:vetplanet/screens/selectGroomingCenter.dart';
import 'package:vetplanet/screens/selectPet.dart';
import 'package:vetplanet/screens/selectPetForGrooming.dart';
import 'package:vetplanet/screens/vetDetails.dart';
import 'package:vetplanet/transitions/slide_route.dart';
import 'bookAppointment.dart';
import 'dash.dart';
import 'drawer.dart';
import 'groomingDetails.dart';
import 'login.dart';



class RecentlyVisitedGroomersPage extends StatefulWidget {
  final Function onPressed;

  RecentlyVisitedGroomersPage({ this.onPressed });
  @override
  _RecentlyVisitedGroomersPageState createState() => _RecentlyVisitedGroomersPageState();
}

class _RecentlyVisitedGroomersPageState extends State<RecentlyVisitedGroomersPage> {



  void rebuildPage() {
    setState(() {});
  }



  Future<List> _future;

  String _groomingLenght = "";

  Future<List<GroomingModel>> getGrooming() async {
    final _prefs = await SharedPreferences.getInstance();
    String _API_Path = _prefs.getString('API_Path');
    String _RegistrationId = _prefs.getInt('id').toString();
    debugPrint('Check getProfile _API_Path $_API_Path ');
    final String apiUrl = "$_API_Path/GetRecentlyGroomerList/GetRecentlyGroomerList";

    debugPrint('Check Inserted 1 ');
    debugPrint('Check Inserted _RegistrationId : $_RegistrationId ');
    var response = await http.post(
      Uri.parse(apiUrl),
      headers: {HttpHeaders.contentTypeHeader: 'application/json', HttpHeaders.authorizationHeader: 'bearer VA5kBnSw50cbuJ4YoAVkl4XyFTA312fRtKF4GxlmkUcl3PQJBKvvtogvT_0syd6ZtsZ4-1zFK6_liq5dQpyMq2tOA7vCtZ332qal7LGyBxBvv4mtD461lwGhNtprYd8PyIR40bBsoBc7nMElIniHJXAu1V04eO5c7sNLHOGypeG70Zn06yQr-0i_eFbsCRg6kMWjkao3RZwDfXVra5JQ5I7Pr1CbSgYez6rbYLMbH2LL6K8VcpmUvs45WpLe4UjPpChygW96LCoxVh7YtNa74n1Bje4sDdGLZowZJWwe7F9P7ijy1nVyw_v5K-8MqzlI' },
      body: json.encode(
          {
            "PatientId":_RegistrationId
          }
      ),
    );
    debugPrint('Check 2}');
    if (response != null && response.statusCode == 200) {
      debugPrint('Check 3}');
      var _response = json.decode(response.body);
      debugPrint('Check 4  ${_response}');


      List<GroomingModel> _grooming = _response
          .map<GroomingModel>(
              (_json) => GroomingModel.fromJson(_json))
          .toList();


      debugPrint('Check 5  ${_grooming}');
      setState(() {
        _groomingLenght = _grooming.length.toString();
        debugPrint('Check _groomingLenght &&&&&&&&&&&&&&&&&&&&&&&&&: $_groomingLenght}');

      });
      return _grooming;

    } else {
      debugPrint('Check 6');
      return [];
    }
  }






  Future<List> _futurePetCount;

  String _petLenght = "";

  String _onePet = "";

  Future<List<PetModel>> getPet() async {
    final _prefs = await SharedPreferences.getInstance();
    String _API_Path = _prefs.getString('API_Path');
    String _RegistrationId = _prefs.getInt('id').toString();
    debugPrint('Check Inserted _API_Path $_API_Path ');
    debugPrint('Check Inserted _RegistrationId $_RegistrationId ');


    final String apiUrl = "$_API_Path/GetPetList/GetPetList";

    debugPrint('Check Inserted 1 ');
    var response = await http.post(
      Uri.parse(apiUrl),
      headers: {HttpHeaders.contentTypeHeader: 'application/json', HttpHeaders.authorizationHeader: 'bearer VA5kBnSw50cbuJ4YoAVkl4XyFTA312fRtKF4GxlmkUcl3PQJBKvvtogvT_0syd6ZtsZ4-1zFK6_liq5dQpyMq2tOA7vCtZ332qal7LGyBxBvv4mtD461lwGhNtprYd8PyIR40bBsoBc7nMElIniHJXAu1V04eO5c7sNLHOGypeG70Zn06yQr-0i_eFbsCRg6kMWjkao3RZwDfXVra5JQ5I7Pr1CbSgYez6rbYLMbH2LL6K8VcpmUvs45WpLe4UjPpChygW96LCoxVh7YtNa74n1Bje4sDdGLZowZJWwe7F9P7ijy1nVyw_v5K-8MqzlI' },
      body: json.encode(
          {
            "PatientId": _RegistrationId
          }
      ),
    );

    debugPrint('Check 2}');
    if (response != null && response.statusCode == 200) {
      debugPrint('Check 3}');
      var _response = json.decode(response.body);
      debugPrint('Check 4  ${_response}');


      List<PetModel> _pet = _response
          .map<PetModel>(
              (_json) => PetModel.fromJson(_json))
          .toList();


      debugPrint('Check 5  ${_pet}');
      setState(() {
        _petLenght = _pet.length.toString();
        debugPrint('Check _petLenght &&&&&&&&&&&&&&&&&&&&&&&&&: $_petLenght}');

        if(_petLenght == "1"){
          _onePet = "${_pet[0].PatientPetId.toString()},";
          debugPrint('_onePet   : $_onePet');
        }

      });
      return _pet;

    } else {
      debugPrint('Check 6');
      return [];
    }
  }


  Future<String> addPet() {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title:   Container(
              color: appColor,
              child: Padding(
                padding: const EdgeInsets.only(left:1, right:1, top:12, bottom:12),
                child: Text('Vet Planet',style: TextStyle(fontFamily: "Camphor",
                    fontWeight: FontWeight.w900,fontSize: 18, color: Colors.white),textAlign:TextAlign.center ,),
              ),
            ),
            content: Text('Your Pet is not Registered with us. Please Register your Pet.',style:TextStyle(fontFamily: "Camphor",
                fontWeight: FontWeight.w700, fontSize: 20,color: Colors.black),),
            actions: <Widget>[
              TextButton(
                // color: appColor,
                  child: Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: Text('OK',style: TextStyle(fontFamily: "Camphor",
                        fontWeight: FontWeight.w900, fontSize: 16,color:appColor),),
                  ),
                  onPressed: () {
                    Navigator.push(context, SlideLeftRoute(page: PetRegistration()));

                    // Navigator.pushReplacement(context, SlideLeftRoute(page: VetRegistration()));
                  }
              ),
            ],
          );
        });
  }


  @override
    void initState() {
    _future = getGrooming();
    _futurePetCount = getPet();
      super.initState();
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

        body:Column(
          children: <Widget>[


            if(_groomingLenght != "0")
              Expanded(
                child: FutureBuilder(
                  future: _future,
                  builder: (context, snapshot) {
                    if (snapshot.hasError) {
                      return Center(child: Text(''));
                    }
                    if (snapshot.hasData) {
                      List<GroomingModel> _grooming = snapshot.data;
                      return ListView.builder(
                        shrinkWrap: true,
                        itemCount: _grooming == null ? 0 : _grooming.length,
                        itemBuilder: (BuildContext context, int index) {
                          return InkWell(
                            onTap: (){

                              String userKey = "${_grooming[index].PetGroomingId}".toString();
                              String token = "${_grooming[index].Token}";

                              Navigator.push(context, SlideLeftRoute(page: GroomingDetails(userKey : userKey, token:token)));
                            },
                            child: Padding(
                              padding: const EdgeInsets.only(left:10, top: 10,right: 5),
                              child: Column(
                                children: <Widget>[
                                  Row(
                                    children: <Widget>[
                                      ClipRRect(
                                        borderRadius: BorderRadius.circular(100),
                                        child: Image.network(
                                          "${_grooming[index].Photograph}",
                                          width: 100,
                                          height: 100,
                                          fit: BoxFit.fill,
                                        ),
                                      ),
                                      SizedBox(width: 10,),
                                      Expanded(
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: <Widget>[
                                            SizedBox(height: 5,),
                                            Text("${_grooming[index].GroomingCenterName}", style: TextStyle(
                                              color: Colors.black, fontSize: 18,fontFamily: "Camphor",
                                              fontWeight: FontWeight.w700,),),
                                            Text("Contact No : ${_grooming[index].ContactNo}", style: TextStyle(
                                              color: Colors.black, fontSize: 17,fontFamily: "Camphor",
                                              fontWeight: FontWeight.w500,),),
                                            Text("E-Mail Id : ${_grooming[index].Email}", style: TextStyle(
                                              color: Colors.black, fontSize: 17,fontFamily: "Camphor",
                                              fontWeight: FontWeight.w500,),),

                                            SizedBox(height: 10,),

                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.start,
                                              crossAxisAlignment: CrossAxisAlignment.center,
                                              children: <Widget>[
                                                Row(
                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                  children: <Widget>[
                                                    Container(
                                                      child: Icon(Icons.thumb_up,color: appColor,size: 20,),
                                                    ),
                                                    SizedBox(width: 10,),
                                                    Text("${_grooming[index].TotalRating}", style: TextStyle(
                                                      color: Colors.black, fontSize: 17,fontFamily: "Camphor",
                                                      fontWeight: FontWeight.w500,),),
                                                  ],
                                                ),
                                                SizedBox(width: 20,),
                                                Row(
                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                  children: <Widget>[
                                                    Container(
                                                      child: Icon(Icons.message,color: appColor,size: 20,),
                                                    ),
                                                    SizedBox(width: 17,),
                                                    Text("${_grooming[index].TotalCommentCount}", style: TextStyle(
                                                      color: Colors.black, fontSize: 16,fontFamily: "Camphor",
                                                      fontWeight: FontWeight.w500,),),
                                                  ],
                                                ),
                                                SizedBox(width: 20,),
                                                Row(
                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                  children: <Widget>[
                                                    Container(
                                                      child: Icon(Icons.people,color: appColor,size: 20,),
                                                    ),
                                                    SizedBox(width: 17,),
                                                    Text("${_grooming[index].TotalVisitorCount}", style: TextStyle(
                                                      color: Colors.black, fontSize: 16,fontFamily: "Camphor",
                                                      fontWeight: FontWeight.w500,),),
                                                  ],
                                                ),
                                              ],
                                            ),

                                            SizedBox(height: 10,),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 5,),
                                  Divider(),

                                  Align(
                                      alignment: Alignment.centerRight,
                                      child: Padding(
                                        padding: const EdgeInsets.only(right:10),
                                        child: InkWell(
                                          onTap:(){
                                            if(_petLenght == "0"){
                                              addPet();
                                            }
                                            if(_petLenght != "0"){

                                              String groomingId = "${_grooming[index].PetGroomingId}".toString();
                                              String token = "${_grooming[index].Token}".toString();

                                              print("_petLenght == 1 groomingId : $groomingId");
                                              print("_petLenght == 1 token : $token");


                                              Navigator.push(context, SlideLeftRoute(page: SelectGroomingShopPage(groomingId:groomingId, token:token)));
                                            }
                                            /* if(_petLenght != "1" && _petLenght != "0"){

                                                  String groomingId = "${_grooming[index].PetGroomingId}".toString();
                                                  String token = "${_grooming[index].Token}".toString();

                                                  print("_petLenght == 0&1 groomingId : $groomingId");
                                                  print("_petLenght == 0&1 token : $token");

                                                  Navigator.push(context, SlideLeftRoute(page: SelectPetForGroomingPage(groomingId:groomingId, token:token)));
                                                }*/

                                          },
                                          child: Card(
                                              color:appColor,
                                              // color:Color(0xffFEC63D),
                                              child: Padding(
                                                padding: const EdgeInsets.only(right:35, left: 35, bottom: 15, top: 15),
                                                child: Text("Book Appointment",style: TextStyle(color: Colors.white,fontFamily: "Camphor",
                                                    fontWeight: FontWeight.w900, fontSize: 15),),
                                              )),
                                        ),
                                      )),
                                  SizedBox(height: 5,),
                                  Divider(
                                    thickness: 8,
                                    color: Color(0xffEBEBEB),
                                  ),
                                ],
                              ),
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
            if(_groomingLenght == "0")
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  SizedBox(height: 25,),
                  Center(child: Align(
                    child: Text("No Grooming Center Found.",textAlign: TextAlign.center, style: TextStyle(fontSize: 20, color: Colors.black,fontFamily: "Camphor",
                      fontWeight: FontWeight.w700,),),
                  )),
                ],
              ),

          ],
        ),
      ),
    );
  }


}
