import 'dart:convert';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:vetplanet/constant/colors.dart';
import 'package:vetplanet/models/grooming_model.dart';
import 'package:vetplanet/models/pet_model.dart';
import 'package:vetplanet/models/result_model.dart';
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



class GroomingListPage extends StatefulWidget {
  final Function onPressed;

  GroomingListPage({ this.onPressed });
  @override
  _GroomingListPageState createState() => _GroomingListPageState();
}

class _GroomingListPageState extends State<GroomingListPage> {

  final _scaffoldKey = GlobalKey<ScaffoldState>();

  String searchValue = "";
  TextEditingController editingController = TextEditingController();
  var result;


  void rebuildPage() {
    setState(() {});
  }

//  final Geolocator geolocator = Geolocator()..forceAndroidLocationManager;
  Position _currentPosition;
  String _currentAddress = "null";
  String _latitude="";
  String _longitude="";
  double lat_d;
  double long_d;
  String _searchaddress= "";

  _getCurrentLocation() {
    Geolocator
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.best)
        .then((Position position) {
      setState(() {
        _currentPosition = position;
      });
      if (_currentPosition != null){
        _latitude = _currentPosition.latitude.toString();   //19.1924479
        _longitude = _currentPosition.longitude.toString();  //72.8457848
        lat_d = double.parse(_latitude);
        long_d = double.parse(_longitude);
        print('_latitude *****************************************************************************: $_latitude');
        print('_longitude ***************************************************************************** : $_longitude');
        print('lat_d *****************************************************************************: $lat_d');
        print('long_d *****************************************************************************: $long_d');
      }
     _getAddressFromLatLng();
    }).catchError((e) {
      print(e);
    });
  }

  _getAddressFromLatLng() async {
    try {
      List<Placemark> p = await placemarkFromCoordinates(
          _currentPosition.latitude, _currentPosition.longitude);

      Placemark place = p[0];

      setState(() {
        _currentAddress = "${place.subLocality}";
        ///
        //"${place.name},${place.subThoroughfare},${place.subAdministrativeArea},${place.subLocality},${place.thoroughfare},${place.locality},${place.administrativeArea}, ${place.postalCode}, ${place.country}";
        //"${place.locality}, ${place.postalCode}, ${place.country}";

        groomingList();
      });
    } catch (e) {
      print(e);
    }
  }

  void groomingList() async {
    final String latitude = _latitude;
    final String longitude = _longitude;
    final String currentAddress = _currentAddress;

    debugPrint('latitude : ${latitude}' );
    debugPrint('longitude : ${longitude}' );
    debugPrint('currentAddress : ${currentAddress}' );

    _future = getGrooming(latitude, longitude, currentAddress);
    _futurePetCount = getPet();
  }


  Future<List> _future;

  String _groomingLenght = "";

  Future<List<GroomingModel>> getGrooming(String _latitude, String longitude, String currentAddress) async {
    final _prefs = await SharedPreferences.getInstance();
    
    String _RegistrationId = _prefs.getInt('id').toString();
    debugPrint('Check getProfile apiUrl $apiUrl ');
    final String url = "$apiUrl/GetGroomingList/GetGroomingList";

    debugPrint('Check Inserted 1 ');
    debugPrint('Check Inserted _latitude : $_latitude ');
    debugPrint('Check Inserted longitude : $longitude ');
    debugPrint('Check Inserted currentAddress : $currentAddress ');
    var response = await http.post(
      Uri.parse(url),
      headers: {HttpHeaders.contentTypeHeader: 'application/json', HttpHeaders.authorizationHeader: bearerToken },
      body: json.encode(
          {
            "Lat":_latitude,
            "Long":longitude,
            "ShopAddress":currentAddress,
            "PatientId": _RegistrationId
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
    
    String _RegistrationId = _prefs.getInt('id').toString();
    debugPrint('Check Inserted apiUrl $apiUrl ');
    debugPrint('Check Inserted _RegistrationId $_RegistrationId ');


    final String url = "$apiUrl/GetPetList/GetPetList";

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


  ResultModel _resultRating;

  Future<ResultModel> saveRating(String groomingId, String rating) async{
    final _prefs = await SharedPreferences.getInstance();
    
    String _RegistrationId = _prefs.getInt('id').toString();
    debugPrint('Check Inserted apiUrl $apiUrl ');
    debugPrint('Check Inserted _RegistrationId $_RegistrationId ');

    final String url = "$apiUrl/SaveRating/SaveRating";

    debugPrint('Check Inserted 1 ');

    var response = await http.post(
      Uri.parse(url),
      headers: {HttpHeaders.contentTypeHeader: 'application/json', HttpHeaders.authorizationHeader: bearerToken },
      body: json.encode(
          {
            "PatientId":_RegistrationId,
            "VetId":"0",
            "GroomerId":groomingId,
            "Rating":rating
          }

      ),
    );

    debugPrint('Check Inserted 2 ');

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




  @override
    void initState() {
     _getCurrentLocation();
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
          flexibleSpace: (Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(2)),
              gradient: LinearGradient(
                colors: [ Colors.white,  Colors.white],
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
              ),
            ),
          )),
          elevation: 0,
          iconTheme: IconThemeData(color: appColor),
          centerTitle: true,
          title:Text(""),
          actions: <Widget>[
            Padding(
              padding: const EdgeInsets.only(right:15),
              child: Row(
                children: <Widget>[
                  Icon(
                    Icons.location_on,
                    color: appColor,
                    size: 16,
                  ),
                  SizedBox(width: 5),
                  Text(_currentAddress,  style: TextStyle(fontFamily: "Camphor",
                      fontWeight: FontWeight.w500,
                      color: Colors.black,
                      fontSize: 16),),

                ],
              ),
            ),
          ],
        ),

        drawer: DrawerPage(),

        body:GestureDetector(

          onTap: () {
            FocusScopeNode currentFocus = FocusScope.of(context);

            if (!currentFocus.hasPrimaryFocus) {
              currentFocus.unfocus();
            }
          },
          child: Container(
            width: double.infinity,
            height: double.infinity,
            child: Column(
              children: <Widget>[
                SizedBox(height: 5,),

                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    controller: editingController,
                    decoration: InputDecoration(
                        isDense: true,
                        contentPadding: EdgeInsets.fromLTRB(10, 15, 10, 15),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: appColor),
                        ),
                        hintText: "Search Location",
                        // fillColor: Color(0xffEBEBEB), filled: true,
                        prefixIcon: InkWell(
                          onTap: ()async{
                            String lat = "0";
                            String long = "0";
                            _searchaddress = editingController.text.toString().trim();
                            print("_searchaddress : $_searchaddress");
                            print("lat : $lat");
                            print("long : $long");
                            _future = getGrooming(lat, long, _searchaddress);
                            FocusScope.of(context).requestFocus(FocusNode());
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(5.0),
                            child: Icon(Icons.search,color: Colors.grey,size: 25,),
                          ),
                        ),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(10.0)))),
                    onSubmitted: (value) async{
                      String lat = "0";
                      String long = "0";
                      _searchaddress = editingController.text.toString().trim();
                      print("_searchaddress : $_searchaddress");
                      print("lat : $lat");
                      print("long : $long");
                      _future = getGrooming(lat, long, _searchaddress);
                      FocusScope.of(context).requestFocus(FocusNode());
                    },
                    textInputAction: TextInputAction.search,

                  ),
                ),
                SizedBox(height: 3),
                Divider(
                  thickness: 8,
                  color: Color(0xffEBEBEB),
                ),
                SizedBox(height: 3),

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
                        child: Text("No Grooming Center Found. Please try another Location.",textAlign: TextAlign.center, style: TextStyle(fontSize: 20, color: Colors.black,fontFamily: "Camphor",
                          fontWeight: FontWeight.w700,),),
                      )),
                    ],
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }


}
