import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:vetplanet/constant/colors.dart';
import 'package:vetplanet/models/pet_model.dart';
import 'package:vetplanet/models/result_model.dart';
import 'package:vetplanet/models/vet_model.dart';
import 'package:vetplanet/screens/dash.dart';
import 'package:vetplanet/screens/petRegistration.dart';
import 'package:vetplanet/screens/selectClinic.dart';
import 'package:vetplanet/screens/selectPet.dart';
import 'package:vetplanet/screens/vetDetails.dart';
import 'package:vetplanet/screens/whyToChangeVet.dart';
import 'package:vetplanet/transitions/slide_route.dart';
import 'drawer.dart';


class VeterinaryListPage extends StatefulWidget {
  final Function onPressed;

  VeterinaryListPage({ this.onPressed });
  @override
  _VeterinaryListPageState createState() => _VeterinaryListPageState();
}

class _VeterinaryListPageState extends State<VeterinaryListPage> {

  final _scaffoldKey = GlobalKey<ScaffoldState>();

  String searchValue = "";
  TextEditingController editingController = TextEditingController();
  var result;


  void rebuildPage() {
    setState(() {});
  }

  //final Geolocator geolocator = Geolocator()..forceAndroidLocationManager;
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

        //"${place.name},${place.subThoroughfare},${place.subAdministrativeArea},${place.subLocality},${place.thoroughfare},${place.locality},${place.administrativeArea}, ${place.postalCode}, ${place.country}";
        //"${place.locality}, ${place.postalCode}, ${place.country}";

        vetList();
      });
    } catch (e) {
      print(e);
    }
  }

  void vetList() async {
    final String latitude = _latitude;
    final String longitude = _longitude;
    final String currentAddress = _currentAddress;
    final String operation = "D";

    debugPrint('latitude : ${latitude}' );
    debugPrint('longitude : ${longitude}' );
    debugPrint('currentAddress : ${currentAddress}' );
    debugPrint('operation : ${operation}' );
    _future = getVet(latitude, longitude, currentAddress, operation);
    _futurePetCount = getPet();
  }


  Future<List> _future;

  String _vetLenght = "";

  Future<List<VetModel>> getVet(String _latitude, String longitude, String currentAddress, String operation) async {
    final _prefs = await SharedPreferences.getInstance();
    
    String _RegistrationId = _prefs.getInt('id').toString();
    debugPrint('Check getProfile apiUrl $apiUrl ');
    final String url = "$apiUrl/GetVetList/GetVetList";

    debugPrint('Check Inserted 1 ');
    debugPrint('Check Inserted _latitude : $_latitude ');
    debugPrint('Check Inserted longitude : $longitude ');
    debugPrint('Check Inserted currentAddress : $currentAddress ');
    debugPrint('Check Inserted operation : $operation ');

    var response = await http.post(
      Uri.parse(url),
      headers: {HttpHeaders.contentTypeHeader: 'application/json', HttpHeaders.authorizationHeader: bearerToken },
      body: json.encode(
          {
            "Lat":_latitude,
            "Long":longitude,
            "Address":currentAddress,
            "PatientId": _RegistrationId,
            "Operation":operation
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

  ResultModel _resultRating;

  Future<ResultModel> saveRating(String vetId, String rating) async{
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
            "VetId":vetId,
            "GroomerId":"0",
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
                SizedBox(height: 8,),
                if(_vetLenght != "0")
                Align(
                  alignment: Alignment.centerRight,
                  child:
                  Padding(
                    padding: const EdgeInsets.only(right:15),
                    child: InkWell(
                      onTap: (){

                        final String latitude = _latitude;
                        final String longitude = _longitude;
                        final String currentAddress = _currentAddress;
                        final String operation = "L";

                        debugPrint('latitude : ${latitude}' );
                        debugPrint('longitude : ${longitude}' );
                        debugPrint('currentAddress : ${currentAddress}' );
                        debugPrint('operation : ${operation}' );
                        _future = getVet(latitude, longitude, currentAddress, operation);

                        Navigator.push(context, SlideLeftRoute(page: WhyToChangeVet(latitude:latitude, longitude:longitude, currentAddress:currentAddress )));

                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: <Widget>[
                          Icon(
                            Icons.autorenew,
                            color: appColor,
                            size: 16,
                          ),
                          SizedBox(width: 5,),
                          Text('Change Your Vet',style: TextStyle(
                            color: Colors.black, fontSize: 16,fontFamily: "Camphor",
                            fontWeight: FontWeight.w700,),),
                        ],
                      ),
                    ),
                  ),
                ),
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
                            String operation = "L";
                            _searchaddress = editingController.text.toString().trim();
                            print("_searchaddress : $_searchaddress");
                            print("lat : $lat");
                            print("long : $long");
                            _future = getVet(lat, long, _searchaddress,operation);
                            FocusScope.of(context).requestFocus(FocusNode());
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(5.0),
                            child: Icon(Icons.search,color: Colors.grey,size: 20,),
                          ),
                        ),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(10.0)))),
                        onSubmitted: (value) async{
                        String lat = "0";
                        String long = "0";
                        String operation = "L";
                        _searchaddress = editingController.text.toString().trim();
                        print("_searchaddress : $_searchaddress");
                        print("lat : $lat");
                        print("long : $long");
                        _future = getVet(lat, long, _searchaddress,operation);
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
                                          child: Padding(
                                            padding: const EdgeInsets.only(right:10),
                                            child: ElevatedButton(
                                              style: ButtonStyle(
                                                backgroundColor: MaterialStateProperty.all(
                                                  appColorlight
                                                )
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
                if(_vetLenght == "0")
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      SizedBox(height: 25,),
                      Center(
                        child: Text("No Veterinary Doctor Found.Please try another Location.",textAlign: TextAlign.center, style: TextStyle(fontSize: 19, color: Colors.black,fontFamily: "Camphor",
                          fontWeight: FontWeight.w700,),),
                      ),
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
