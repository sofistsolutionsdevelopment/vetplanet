import 'dart:convert';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:geolocator/geolocator.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:simple_html_css/simple_html_css.dart';
import 'package:vetplanet/constant/colors.dart';
import 'package:vetplanet/models/pet_model.dart';
import 'package:vetplanet/models/vet_model.dart';
import 'package:vetplanet/screens/dash.dart';
import 'package:vetplanet/screens/petRegistration.dart';
import 'package:vetplanet/screens/selectClinic.dart';
import 'package:vetplanet/screens/selectPet.dart';
import 'package:vetplanet/screens/vetDetails.dart';
import 'package:vetplanet/transitions/slide_route.dart';
import 'drawer.dart';



class RecentlyVisitedVETPage extends StatefulWidget {
  final Function onPressed;

  RecentlyVisitedVETPage({ this.onPressed });
  @override
  _RecentlyVisitedVETPageState createState() => _RecentlyVisitedVETPageState();
}

class _RecentlyVisitedVETPageState extends State<RecentlyVisitedVETPage> {

  final _scaffoldKey = GlobalKey<ScaffoldState>();

  void rebuildPage() {
    setState(() {});
  }

  Future<List> _future;

  String _vetLenght = "";

  Future<List<VetModel>> getVet() async {
    final _prefs = await SharedPreferences.getInstance();
    
    String _RegistrationId = _prefs.getInt('id').toString();
    debugPrint('Check getProfile apiUrl $apiUrl ');
    final String url = "$apiUrl/GetRecentlyDoctorList/GetRecentlyDoctorList";

    debugPrint('Check Inserted 1 ');
    debugPrint('Check Inserted _RegistrationId : $_RegistrationId ');

    var response = await http.post(
      Uri.parse(url),
      headers: {HttpHeaders.contentTypeHeader: 'application/json', HttpHeaders.authorizationHeader: bearerToken },
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


      List<VetModel> _vet = _response
          .map<VetModel>(
              (_json) => VetModel.fromJson(_json))
          .toList();


      debugPrint('Check 5  ${_vet}');
      setState(() {
        _vetLenght = _vet.length.toString();
        debugPrint('Check _vetLenght &&&&&&&&&&&&&&&&&&&&&&&&&: $_vetLenght}');

      });
      return _vet;

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
    
    String _RegistrationId = _prefs.getInt('id').toString();
    debugPrint('Check Inserted apiUrl $apiUrl ');
    debugPrint('Check Inserted _RegistrationId $_RegistrationId ');


    final String url = "http://sofistsolutions.in/VetPlanetAPPAPI/API/GetPetList/GetPetList";

    debugPrint('Check Inserted 1 ');
    var response = await http.post(
      Uri.parse(url),
      headers: {HttpHeaders.contentTypeHeader: 'application/json', HttpHeaders.authorizationHeader: bearerToken },
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
    _future = getVet();
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

        body:Column(
          children: <Widget>[
            if(_vetLenght != "0")
              Expanded(
                child: FutureBuilder(
                  future: _future,
                  builder: (context, snapshot) {
                    if (snapshot.hasError) {
                      return Center(child: Text(''));
                    }
                    if (snapshot.hasData) {
                      List<VetModel> _vet = snapshot.data;
                      return ListView.builder(
                        shrinkWrap: true,
                        itemCount: _vet == null ? 0 : _vet.length,
                        itemBuilder: (BuildContext context, int index) {
                          return InkWell(
                            onTap:(){
                              String userKey = "${_vet[index].UserKey}".toString();
                              String token = "${_vet[index].Token}";
                              Navigator.push(context, SlideLeftRoute(page: VetDetails(userKey : userKey, token:token)));
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
                                          "${_vet[index].Photograph}",
                                          width: 100,
                                          height: 100,
                                          fit: BoxFit.fill,
                                        ),
                                      ),
                                      SizedBox(width: 15,),
                                      Expanded(
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: <Widget>[
                                            SizedBox(height: 5,),
                                            Text("${_vet[index].User_Name}", style: TextStyle(
                                              color: Colors.black, fontSize: 18,fontFamily: "Camphor",
                                              fontWeight: FontWeight.w700,),),
                                            /*Html(data:"${_vet[index].Specialization}",defaultTextStyle: TextStyle(
                                                    color: Colors.black, fontSize: 16,fontFamily: "Camphor",
                                                    fontWeight: FontWeight.w500,),),*/
                                            Text("${_vet[index].Specialization}", style: TextStyle(
                                              color: Colors.black, fontSize: 17,fontFamily: "Camphor",
                                              fontWeight: FontWeight.w500,),),
                                            //Html(data:"${_vet[index].Education}"),
                                            Text("${_vet[index].TotalYearOfExp} years experience overall", style: TextStyle(
                                              color: Colors.black, fontSize: 17,fontFamily: "Camphor",
                                              fontWeight: FontWeight.w500,),),
                                            SizedBox(height: 10,),
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: <Widget>[

                                                Row(
                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                  children: <Widget>[
                                                    Container(
                                                      child: Icon(Icons.thumb_up,color: appColor,size: 20,),
                                                    ),
                                                    SizedBox(width: 10,),
                                                    Text("${_vet[index].TotalRating}", style: TextStyle(
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
                                                    SizedBox(width: 10,),
                                                    Text("${_vet[index].TotalCommentCount}", style: TextStyle(
                                                      color: Colors.black, fontSize: 17,fontFamily: "Camphor",
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
                                                    SizedBox(width: 10,),
                                                    Text("${_vet[index].TotalVisitorCount}", style: TextStyle(
                                                      color: Colors.black, fontSize: 17,fontFamily: "Camphor",
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
                                      child: ElevatedButton(
                                        style: ButtonStyle(
                                          backgroundColor: MaterialStateProperty.all(appColorlight)
                                        ),
                                        onPressed: (){
                                          if(_petLenght == "0"){
                                      //Navigator.push(context, SlideLeftRoute(page: VetRegistration()));\

                                      addPet();

                                      }
                                      if(_petLenght == "1"){


                                      String onePet = _onePet;

                                      String vetId = "${_vet[index].UserKey}".toString();
                                      String token = "${_vet[index].Token}".toString();

                                      print("_petLenght == 1 onePet : $onePet");
                                      print("_petLenght == 1 vetId : $vetId");
                                      print("_petLenght == 1 token : $token");

                                      Navigator.push(context, SlideLeftRoute(page: SelectClinicPage(vetId:vetId, checkPet:onePet, token:token)));
                                      }
                                      if(_petLenght != "1" && _petLenght != "0"){

                                      String vetId = "${_vet[index].UserKey}".toString();
                                      String token = "${_vet[index].Token}".toString();

                                      print("_petLenght == 0&1 vetId : $vetId");
                                      print("_petLenght == 0&1 token : $token");
                                      Navigator.push(context, SlideLeftRoute(page: SelectPetPage(vetId:vetId,  token:token)));
                                      }
                                        },
                                        child: Text("Book Appointment",style: TextStyle(color: Colors.white,fontFamily: "Camphor",
                                            fontWeight: FontWeight.w900, fontSize: 15),),
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
            if(_vetLenght == "0")
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  SizedBox(height: 25,),
                  Center(
                    child: Text("No Veterinary Doctor Found.",textAlign: TextAlign.center, style: TextStyle(fontSize: 19, color: Colors.black,fontFamily: "Camphor",
                      fontWeight: FontWeight.w700,),),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }


}
