import 'dart:convert';
import 'dart:io';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:galleryimage/galleryimage.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:vetplanet/constant/colors.dart';
import 'package:vetplanet/models/comment_model.dart';
import 'package:vetplanet/models/gelleryPhotos_model.dart';
import 'package:vetplanet/models/groomingProfileDetails_model.dart';
import 'package:vetplanet/models/groomingServices_model.dart';
import 'package:vetplanet/models/groomingShop_model.dart';
import 'package:vetplanet/models/hostelComment_model.dart';
import 'package:vetplanet/models/hostelServices_model.dart';
import 'package:vetplanet/models/hostel_model.dart';
import 'package:vetplanet/models/pet_model.dart';
import 'package:vetplanet/models/result_model.dart';
import 'package:vetplanet/models/vetProfileDetails_model.dart';
import 'package:vetplanet/screens/allComments_groomers.dart';
import 'package:vetplanet/screens/groomingList.dart';
import 'package:vetplanet/screens/petRegistration.dart';
import 'package:vetplanet/screens/selectGroomingCenter.dart';
import 'package:vetplanet/screens/selectPetForGrooming.dart';
import 'package:vetplanet/screens/selectPetForHostel.dart';
import 'package:vetplanet/screens/sendComments_forGroomer.dart';
import 'package:vetplanet/screens/sendComments_forHostel.dart';
import 'package:vetplanet/transitions/slide_route.dart';
import 'allComments_hostel.dart';
import 'dash.dart';
import 'drawer.dart';
import 'hostelList.dart';

class HostelDetails extends StatefulWidget {
  final String userKey;
  final String token;
  final Function onPressed;

  HostelDetails({ this.userKey, this.token, this.onPressed });
  @override
  _HostelDetailsState createState() => _HostelDetailsState();
}

class _HostelDetailsState extends State<HostelDetails> {

  Future<HostelModel> _resultHostelDetails;
  HostelModel _resultHostel;
  Future<HostelModel> getHostelDetails() async{
    final _prefs = await SharedPreferences.getInstance();
    String _RegistrationId = _prefs.getInt('id').toString();
    
    debugPrint('Check getProfile apiUrl $apiUrl ');
    final String url = "$apiUrl/GetHostelDetailsByHostelId/GetHostelDetailsByHostelId";

    debugPrint('Check Inserted 1 ');
    debugPrint('Check Inserted widget.userKey : ${widget.userKey} ');

    var response = await http.post(
      Uri.parse(url),
      headers: {HttpHeaders.contentTypeHeader: 'application/json', HttpHeaders.authorizationHeader: bearerToken },
      body: json.encode(
          {
            "HostelId":widget.userKey,
            "PatientId":_RegistrationId
          }


      ),
    );
    debugPrint('Check Inserted 2 ');
    debugPrint('Check Inserted statusCode :  ${response.statusCode} ');
    if(response.statusCode == 200){

      debugPrint('Check Inserted 3 : ${response.body}');

      final String responseString = response.body;

      debugPrint('Check Inserted 4  ${responseString}');

      return hostelModelFromJson(responseString);
    }
    else{
      debugPrint('Check Inserted 5 ');
      return null;
    }
  }

  String userKey = "";
  String token = "";
  String hostelName = "";
  List<String> listOfGalleryPhotos;

  String galleryPhotos;



  void appBarTitle() async {
    final HostelModel resultName = await getHostelDetails();

    setState(() {
      _resultHostel = resultName;
      if(_resultHostel != null){
        userKey = _resultHostel.HostelId.toString();
        token = _resultHostel.Token;
        hostelName = _resultHostel.HostelName;
       // listOfGalleryPhotos = [_resultHostel.Photos];
        //galleryPhotos = _resultHostel.Photos;
       // "http://sofistsolutions.in/VetPlanetAPPAPI/HostelPhotos/15_11_2021_06_46_56walt-disney - Copy.jpg", "http://sofistsolutions.in/VetPlanetAPPAPI/HostelPhotos/15_11_2021_06_47_26Marvel.png", "http://sofistsolutions.in/VetPlanetAPPAPI/HostelPhotos/24_11_2021_12_47_39logo-dark.png", "http://sofistsolutions.in/VetPlanetAPPAPI/HostelPhotos/24_11_2021_12_47_39Logo.png", "http://sofistsolutions.in/VetPlanetAPPAPI/HostelPhotos/24_11_2021_12_47_39logov.png", "http://sofistsolutions.in/VetPlanetAPPAPI/HostelPhotos/24_11_2021_12_47_39mygs.png", "http://sofistsolutions.in/VetPlanetAPPAPI/HostelPhotos/24_11_2021_12_47_39petH.png", "http://sofistsolutions.in/VetPlanetAPPAPI/HostelPhotos/24_11_2021_12_47_39petHostel.jpg", "http://sofistsolutions.in/VetPlanetAPPAPI/HostelPhotos/24_11_2021_12_47_39SQL-server.jpg", "http://sofistsolutions.in/VetPlanetAPPAPI/HostelPhotos/24_11_2021_12_47_39vet-favicon.png"
        print("userKey *******************$userKey");
        print("token *******************$token");
        print("hostelName *******************$hostelName");
       // print("listOfGalleryPhotos *******************$listOfGalleryPhotos");
       //print("galleryPhotos *******************$galleryPhotos");

        _resultHostelDetails = getHostelDetails();
        _futureHostelServices = getHostelServices();
        _futurePetCount = getPet();
        _futureComment = getComment();
        _galleryPhotosfuture  = getGalleryPhotos();
      }
      //   isSwitched = true;
    });
  }
 // ["http://sofistsolutions.in/VetPlanetAPPAPI/HostelLogo/15_11_2021_06_59_56Marvel.png", "http://sofistsolutions.in/VetPlanetAPPAPI/HostelLogo/16_11_2021_10_30_57Amarnath.jpg"]

  Future<List> _futureHostelServices;
  String _hostelServicesLenght = "";
  Future<List<HostelServicesModel>> getHostelServices() async {
    final _prefs = await SharedPreferences.getInstance();
    
    debugPrint('Check getProfile apiUrl $apiUrl ');
    final String url = "$apiUrl/GetHostelServices/GetHostelServices";

    debugPrint('Check Inserted 1 ');

    var response = await http.post(
      Uri.parse(url),
      headers: {HttpHeaders.contentTypeHeader: 'application/json', HttpHeaders.authorizationHeader: bearerToken },
      body: json.encode(
          {
            "HostelId":widget.userKey
          }
      ),
    );
    debugPrint('Check 2}');
    if (response != null && response.statusCode == 200) {
      debugPrint('Check 3}');
      var _response = json.decode(response.body);
      debugPrint('Check 4  ${_response}');

      List<HostelServicesModel> _hostelServices = _response
          .map<HostelServicesModel>(
              (_json) => HostelServicesModel.fromJson(_json))
          .toList();

      debugPrint('Check 5  ${_hostelServices}');
      setState(() {
        _hostelServicesLenght = _hostelServices.length.toString();
        debugPrint('Check _hostelServicesLenght &&&&&&&&&&&&&&&&&&&&&&&&&: $_hostelServicesLenght}');

      });
      return _hostelServices;

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
          _onePet = "${_pet[0].PatientPetId.toString()}";
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

  Future<List> _futureComment;

  String _commentLenght = "";

  Future<List<HostelCommentModel>> getComment() async {
    final _prefs = await SharedPreferences.getInstance();
    
    String _RegistrationId = _prefs.getInt('id').toString();
    debugPrint('Check Inserted apiUrl $apiUrl ');
    debugPrint('Check Inserted _RegistrationId $_RegistrationId ');


    final String url = "$apiUrl/GetHostelCommentList/GetHostelCommentList";

    debugPrint('Check Inserted 1 ');
    var response = await http.post(
      Uri.parse(url),
      headers: {HttpHeaders.contentTypeHeader: 'application/json', HttpHeaders.authorizationHeader: bearerToken },
      body: json.encode(
          {
            "HostelId":widget.userKey,
            "Operation":"top5"
          }
      ),
    );

    debugPrint('Check 2}');
    if (response != null && response.statusCode == 200) {
      debugPrint('Check 3}');
      var _response = json.decode(response.body);
      debugPrint('Check 4  ${_response}');


      List<HostelCommentModel> _comment = _response
          .map<HostelCommentModel>(
              (_json) => HostelCommentModel.fromJson(_json))
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


  ResultModel _resultRating;

  Future<ResultModel> saveRating(String rating) async{
    final _prefs = await SharedPreferences.getInstance();
    
    String _RegistrationId = _prefs.getInt('id').toString();
    debugPrint('Check Inserted apiUrl $apiUrl ');
    debugPrint('Check Inserted _RegistrationId $_RegistrationId ');

    final String url = "$apiUrl/SaveHostelRating/SaveHostelRating";

    debugPrint('Check Inserted 1 ');

    var response = await http.post(
      Uri.parse(url),
      headers: {HttpHeaders.contentTypeHeader: 'application/json', HttpHeaders.authorizationHeader: bearerToken },
      body: json.encode(
          {
          "PatientId":_RegistrationId,
          "HostelId":widget.userKey,
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



  void launchMap(String address) async {
    String query = Uri.encodeComponent(address);
    String googleUrl = "https://www.google.com/maps/search/?api=1&query=$query";

    if (await canLaunch(googleUrl)) {
      await launch(googleUrl);
    }
  }
  final GlobalKey<FormState> _formStateKey = GlobalKey<FormState>();
  Future<List> _galleryPhotosfuture;
  String _gelleryPhotosLenght = "";
  String photo = "";
  List<String> listGalleryPhotos = List<String>();
  Future<List<GalleryPhotosModel>> getGalleryPhotos() async {
    final _prefs = await SharedPreferences.getInstance();
    
    debugPrint('Check getGalleryPhotos apiUrl $apiUrl ');
    final String url = "$apiUrl/GetHostelPhotos/GetHostelPhotos";

    debugPrint('Check getGalleryPhotos 1 ');
    var response = await http.post(
      Uri.parse(url),
      headers: {HttpHeaders.contentTypeHeader: 'application/json', HttpHeaders.authorizationHeader: bearerToken },
      body: json.encode(
          {
            "HostelId": userKey
          }
      ),
    );
    debugPrint('Check getGalleryPhotos 2}');
    if (response != null && response.statusCode == 200) {
      debugPrint('Check getGalleryPhotos 3}');
      var _response = json.decode(response.body);
      debugPrint('Check getGalleryPhotos 4  ${_response}');


      List<GalleryPhotosModel> _galleryPhotos = _response
          .map<GalleryPhotosModel>(
              (_json) => GalleryPhotosModel.fromJson(_json))
          .toList();


      debugPrint('Check getGalleryPhotos 5  ${_galleryPhotos}');


      setState(() {
        _gelleryPhotosLenght = _galleryPhotos.length.toString();
        debugPrint('Check _gelleryPhotosLenght &&&&&&&&&&&&&&&&&&&&&&&&&: $_gelleryPhotosLenght}');

        for (var i = 0; i < _galleryPhotos.length; i++) {
          photo = '${_galleryPhotos[i].Photograph}';
          debugPrint('Check photo &&&&&&&&&&&&&&&&&&&&&&&&&: $photo');

          listGalleryPhotos.add(photo) ;
        }


        debugPrint('Check listGalleryPhotos &&&&&&&&&&&&&&&&&&&&&&&&&: $listGalleryPhotos');

      });


      return _galleryPhotos;

    } else {
      debugPrint('Check getGalleryPhotos 6');
      return [];
    }
  }

  ResultModel _deleteServices;

  Future<ResultModel> deleteServices() async{
    final _prefs = await SharedPreferences.getInstance();
    
    String _RegistrationId = _prefs.getInt('id').toString();

    debugPrint('Check Inserted apiUrl $apiUrl');
    debugPrint('Check Inserted _RegistrationId $_RegistrationId');

    final String url =  "$apiUrl/DeleteTempHostelService/DeleteTempHostelService";

    debugPrint('Check Inserted 1 ');

    var response = await http.post(
      Uri.parse(url),
      headers: {HttpHeaders.contentTypeHeader: 'application/json', HttpHeaders.authorizationHeader: bearerToken },
      body: json.encode(
          {
            "PatientId"	:_RegistrationId
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

  ResultModel _deletePreServices;

  Future<ResultModel> deletePreServices(String hostelId) async{
    final _prefs = await SharedPreferences.getInstance();
    
    String _RegistrationId = _prefs.getInt('id').toString();

    debugPrint('Check Inserted apiUrl $apiUrl');
    debugPrint('Check Inserted _RegistrationId $_RegistrationId');

    final String url =  "$apiUrl/DeletePreHostelService/DeletePreHostelService";

    debugPrint('Check Inserted 1 ');

    var response = await http.post(
      Uri.parse(url),
      headers: {HttpHeaders.contentTypeHeader: 'application/json', HttpHeaders.authorizationHeader: bearerToken },
      body: json.encode(
          {
            "PatientId"	:_RegistrationId,
            "HostelId":hostelId
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

  void deleteService(hostelId) async {
    final ResultModel resultdelete = await deleteServices();
    final ResultModel resultPredelete = await deletePreServices(hostelId);
    setState(() {
      _deleteServices = resultdelete;
      _deletePreServices = resultPredelete;
      if(_deleteServices != null){
        if(_deleteServices.Result == "Deleted"){
          print("_deleteServices *******************${_deleteServices.Result}");
        }
      }
      if(_deletePreServices != null){
        if(_deletePreServices.Result == "Deleted"){
          print("_deletePreServices *******************${_deletePreServices.Result}");
        }
      }
    });

  }

  // List<String> listOfGalleryPhotos = [
 //   "http://sofistsolutions.in/VetPlanetAPPAPI/HostelPhotos/15_11_2021_06_46_56walt-disney - Copy.jpg", "http://sofistsolutions.in/VetPlanetAPPAPI/HostelPhotos/15_11_2021_06_47_26Marvel.png", "http://sofistsolutions.in/VetPlanetAPPAPI/HostelPhotos/24_11_2021_12_47_39logo-dark.png", "http://sofistsolutions.in/VetPlanetAPPAPI/HostelPhotos/24_11_2021_12_47_39Logo.png", "http://sofistsolutions.in/VetPlanetAPPAPI/HostelPhotos/24_11_2021_12_47_39logov.png", "http://sofistsolutions.in/VetPlanetAPPAPI/HostelPhotos/24_11_2021_12_47_39mygs.png", "http://sofistsolutions.in/VetPlanetAPPAPI/HostelPhotos/24_11_2021_12_47_39petH.png", "http://sofistsolutions.in/VetPlanetAPPAPI/HostelPhotos/24_11_2021_12_47_39petHostel.jpg", "http://sofistsolutions.in/VetPlanetAPPAPI/HostelPhotos/24_11_2021_12_47_39SQL-server.jpg", "http://sofistsolutions.in/VetPlanetAPPAPI/HostelPhotos/24_11_2021_12_47_39vet-favicon.png"
//  ];

  @override
  void initState() {
    _galleryPhotosfuture  = getGalleryPhotos();
    appBarTitle();
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
            .pushReplacement(new MaterialPageRoute(builder: (context) => HostelListPage(onPressed: rebuildPage)));
        return new Future(() => false); //onWillPop is Future<bool> so return false
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: appColor,
          title:  Text(hostelName,style: TextStyle(
            color: Colors.white, fontSize: 18,fontFamily: "Camphor",
            fontWeight: FontWeight.w700,),),
          actions: <Widget>[
            new IconButton(
              icon: new Icon(Icons.home, color: Colors.white,),
              tooltip: 'Home',
              onPressed: () {
                Navigator.push(
                    context, MaterialPageRoute(builder: (context) => DashPage(onPressed: rebuildPage)));
              },
            ),
          /*  new IconButton(
              icon: new Icon(Icons.share, color: Colors.white,),
              tooltip: 'Share',
              onPressed: () {
                Share.share(getShareText());
              },
            ),*/
          ],
        ),


        drawer: DrawerPage(),
        body:Form(
          key: _formStateKey,
          child: SingleChildScrollView(
            child: FutureBuilder<HostelModel>(
              future: _resultHostelDetails,
              builder: (context, snapshot)
              {
                if (snapshot.hasData)
                {
                  return  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      SizedBox(height: 20,),
                      Padding(
                        padding: const EdgeInsets.only(right:5, left: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[

                            ClipRRect(
                              borderRadius: BorderRadius.circular(100),
                              child: Image.network(
                                snapshot.data.Logo,
                                width: 100,
                                height: 100,
                                fit: BoxFit.fill),
                            ),
                            SizedBox(width: 10,),
                            Expanded(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  SizedBox(height: 5,),
                                  Text(snapshot.data.HostelName, style: TextStyle(
                                    color: Colors.black, fontSize: 18,fontFamily: "Camphor",
                                    fontWeight: FontWeight.w700,),),
                                  Text("Owner Name : ${snapshot.data.HostelOwnerName}", style: TextStyle(
                                    color: Colors.black, fontSize: 17,fontFamily: "Camphor",
                                    fontWeight: FontWeight.w500,),),
                                  Text("Address : ${snapshot.data.HostelAddress}", style: TextStyle(
                                    color: Colors.black, fontSize: 17,fontFamily: "Camphor",
                                    fontWeight: FontWeight.w500,),),
                                  Text("${snapshot.data.ContactPerson} : ${snapshot.data.ContactNo}", style: TextStyle(
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
                                          Text("${snapshot.data.TotalRating}", style: TextStyle(
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
                                          Text("${snapshot.data.TotalCommentCount}", style: TextStyle(
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
                                          Text("${snapshot.data.TotalVisitorCount}", style: TextStyle(
                                            color: Colors.black, fontSize: 17,fontFamily: "Camphor",
                                            fontWeight: FontWeight.w500,),),
                                        ],
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      Divider(
                        thickness: 8,
                        color: Color(0xffEBEBEB),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left:15, right: 15),
                        child: Column(
                          children: <Widget>[

                            SizedBox(height: 10,),
                            Padding(
                              padding: const EdgeInsets.only(left:8, right: 8),
                              child: Align(
                                alignment:Alignment.centerLeft,
                                child: Text("${snapshot.data.Description}",  style: TextStyle(
                                  color: Colors.black, fontSize: 16,fontFamily: "Camphor",
                                  fontWeight: FontWeight.w500,),),
                              ),
                            ),
                            SizedBox(height: 10,),
                          ],
                        ),
                      ),
                      Divider(
                        thickness: 8,
                        color: Color(0xffEBEBEB),),

                      Padding(
                        padding: const EdgeInsets.only(left:15, right: 15),
                        child: Column(
                          children: <Widget>[
                            SizedBox(height: 10,),
                            Align(
                              alignment: Alignment.topLeft,
                              child: FittedBox(
                                fit:BoxFit.fitWidth,
                                child: Text(
                                  "Amenities",
                                  style: TextStyle(fontFamily: "Camphor",
                                      fontWeight: FontWeight.w700, fontSize: 20,color: Colors.black),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left:8, right: 8),
                              child: Align(
                                alignment:Alignment.centerLeft,
                                child: Html(data:snapshot.data.Amenities,defaultTextStyle: TextStyle(
                                  color: Colors.black, fontSize: 16,fontFamily: "Camphor",
                                  fontWeight: FontWeight.w500,),),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Divider(
                        thickness: 8,
                        color: Color(0xffEBEBEB),),
                      Padding(
                        padding: const EdgeInsets.only(left:15, right: 15),
                        child: Column(
                          children: <Widget>[
                            SizedBox(height: 10,),
                            Align(
                              alignment: Alignment.topLeft,
                              child: FittedBox(
                                fit:BoxFit.fitWidth,
                                child: Text(
                                  "Timings",
                                  style: TextStyle(fontFamily: "Camphor",
                                      fontWeight: FontWeight.w700, fontSize: 20,color: Colors.black),
                                ),
                              ),
                            ),

                            Padding(
                              padding: const EdgeInsets.only(left:8, right: 8, top:8, bottom: 8),
                              child: Align(
                                alignment:Alignment.centerLeft,
                                child: Html(data:snapshot.data.Timing,defaultTextStyle: TextStyle(
                                  color: Colors.black, fontSize: 16,fontFamily: "Camphor",
                                  fontWeight: FontWeight.w500,),),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Divider(
                        thickness: 8,
                        color: Color(0xffEBEBEB),),
                      Padding(
                        padding: const EdgeInsets.only(right:10, left: 10, top:10),
                        child: Card(
                          child: Column(
                            children: <Widget>[
                              Container(
                                height: 35,
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.all(Radius.circular(2)),
                                  gradient: LinearGradient(
                                    colors: [appColor, appColor],
                                    begin: Alignment.centerLeft,
                                    end: Alignment.centerRight,
                                  ),
                                ),
                                child: Align(
                                    alignment: Alignment.center,
                                    child: Padding(
                                      padding: const EdgeInsets.only(right:10),
                                      child:  Padding(
                                        padding: const EdgeInsets.all(5),
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          children: <Widget>[
                                            SizedBox(width: 10,),
                                            Image.asset(
                                              "assets/hostelgw.png",width: 20,height: 15,
                                            ),
                                            SizedBox(width: 10,),
                                            Flexible(
                                              child: Text("Services",style: TextStyle(color: Colors.white,fontFamily: "Camphor",
                                                  fontWeight: FontWeight.w900, fontSize: 16),),
                                            ),
                                          ],
                                        ),
                                      ),
                                    )),

                              ),

                              Padding(
                                padding: const EdgeInsets.only(left:15, right: 15),
                                child: Column(
                                  children: <Widget>[


                                    SizedBox(height: 10,),
                                    FutureBuilder(
                                      future: _futureHostelServices,
                                      builder: (context, snapshot) {
                                        if (snapshot.hasError) {
                                          return Center(child: Text(''));
                                        }
                                        if (snapshot.hasData) {
                                          List<HostelServicesModel> _hostelServices = snapshot.data;
                                          return ListView.builder(
                                            physics: ClampingScrollPhysics(),
                                            shrinkWrap: true,
                                            itemCount: _hostelServices == null ? 0 : _hostelServices.length,
                                            itemBuilder: (BuildContext context, int index) {
                                              return SingleChildScrollView(
                                                child:
                                                Column(
                                                  children: <Widget>[
                                                    Row(
                                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      children: <Widget>[
                                                        Flexible(
                                                          child: Text("${_hostelServices[index].Service}",
                                                            style: TextStyle(fontSize:16, fontFamily: "Camphor",
                                                                fontWeight: FontWeight.w500,color: Colors.black),),
                                                        ),
                                                        SizedBox(width: 5,),
                                                        Text("${_hostelServices[index].Rate}/-",
                                                          style: TextStyle(fontSize:16, fontFamily: "Camphor",
                                                              fontWeight: FontWeight.w500,color: Colors.black),),
                                                      ],
                                                    ),
                                                    SizedBox(height: 10,),
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

                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      if(_gelleryPhotosLenght != "0")
                        Column(
                          children: <Widget>[
                            SizedBox(height:10),
                            Divider(
                              thickness: 8,
                              color: Color(0xffEBEBEB),
                            ),
                            SizedBox(height:10),
                            Align(
                              alignment: Alignment.topLeft,
                              child: FittedBox(
                                fit: BoxFit.fitWidth,
                                child: Padding(
                                  padding: const EdgeInsets.only(left:15, right: 15),
                                  child: FittedBox(
                                    fit:BoxFit.fitWidth,
                                    child: Text(
                                      "Hostel Photos",
                                      style: TextStyle(fontFamily: "Camphor",
                                          fontWeight: FontWeight.w700, fontSize: 20,color: Colors.black),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(height:5),

                            GalleryImage(
                                // titileGallery: hostelName,
                                imageUrls: listGalleryPhotos
                            ),

                          ],
                        ),

                      SizedBox(height:5),
                      if(snapshot.data.VisitorCount == 1)
                        Divider(
                        thickness: 8,
                        color: Color(0xffEBEBEB),
                      ),
                      if(snapshot.data.VisitorCount == 1)
                        SizedBox(height:5),
                      if(snapshot.data.VisitorCount == 1)
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Align(
                              alignment: Alignment.topLeft,
                              child: FittedBox(
                                fit: BoxFit.fitWidth,
                                child: Padding(
                                  padding: const EdgeInsets.all(15.0),
                                  child: FittedBox(
                                    fit:BoxFit.fitWidth,
                                    child: Text(
                                      "Rate Your Groomer  ",
                                      style: TextStyle(fontFamily: "Camphor",
                                          fontWeight: FontWeight.w700, fontSize: 20,color: Colors.black),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(right:25),
                              child: Align(
                                alignment: Alignment.topRight,
                                child:  Column(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    if(snapshot.data.IsRated == 1)
                                      InkWell(
                                        onTap: () async{
                                          String rating = "0";
                                          print("rating : $rating");
                                          final ResultModel result = await saveRating(rating);
                                          debugPrint('Check Inserted result : $result');
                                          setState(() {
                                            _resultRating = result;
                                            _resultHostelDetails = getHostelDetails();
                                            _futureHostelServices = getHostelServices();
                                            _futurePetCount = getPet();
                                            _futureComment = getComment();
                                            _galleryPhotosfuture  = getGalleryPhotos();
                                          });
                                        },
                                        child: Container(
                                          child: Image.asset(
                                            "assets/like.png",
                                            width: 20,height: 30,
                                          ),
                                        ),
                                      ),
                                    if(snapshot.data.IsRated == 0)
                                      InkWell(
                                        onTap: () async{
                                          String rating = "1";
                                          print("rating : $rating");

                                          final ResultModel result = await saveRating(rating);
                                          debugPrint('Check Inserted result : $result');
                                          setState(() {
                                            _resultRating = result;
                                            _resultHostelDetails = getHostelDetails();
                                            _futureHostelServices = getHostelServices();
                                            _futurePetCount = getPet();
                                            _futureComment = getComment();
                                            _galleryPhotosfuture  = getGalleryPhotos();
                                          });
                                        },
                                        child: Container(
                                          child:Image.asset(
                                            "assets/unlike.png",
                                            width: 20,height: 30,
                                          ),
                                        ),
                                      ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),


                      SizedBox(height:10),
                      Divider(
                        thickness: 8,
                        color: Color(0xffEBEBEB),
                      ),
                      SizedBox(height:5),
                      Align(
                        alignment: Alignment.topLeft,
                        child: FittedBox(
                          fit: BoxFit.fitWidth,
                          child: Padding(
                            padding: const EdgeInsets.all(15.0),
                            child: FittedBox(
                              fit:BoxFit.fitWidth,
                              child: Text(
                                "Comments  ",
                                style: TextStyle(fontFamily: "Camphor",
                                    fontWeight: FontWeight.w700, fontSize: 20,color: Colors.black),
                              ),
                            ),
                          ),
                        ),
                      ),




                      if(_commentLenght != "0")
                        Container(
                          child: FutureBuilder(
                            future: _futureComment,
                            builder: (context, snapshot) {
                              if (snapshot.hasError) {
                                return Center(child: Text(''));
                              }
                              if (snapshot.hasData) {
                                List<HostelCommentModel> _comment = snapshot.data;
                                return ListView.builder(
                                  physics: ClampingScrollPhysics(),
                                  shrinkWrap: true,
                                  itemCount: _comment == null ? 0 : _comment.length,
                                  itemBuilder: (BuildContext context, int index) {
                                    return  Padding(
                                      padding: const EdgeInsets.only(right:15, left: 15, top:8, bottom: 8),
                                      child:  RichText(
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
                        Center(
                          child: Text("No Comments to show", style: TextStyle(fontSize: 18, color: Colors.black,fontFamily: "Camphor",
                            fontWeight: FontWeight.w500,),textAlign: TextAlign.center,),
                        ),


                      SizedBox(height: 20,),


                      if(snapshot.data.VisitorCount == 0 && _commentLenght != "0")
                        InkWell(
                          onTap: (){
                            Navigator.pushReplacement(context, SlideLeftRoute(page: AllCommentsHostelPage(userKey:userKey,visitorCount:snapshot.data.VisitorCount.toString() )));
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              border:Border(top: BorderSide(color: Colors.black, width: 1),bottom: BorderSide(color: Colors.black, width: 1),left: BorderSide(color: Colors.black, width: 1),right: BorderSide(color: Colors.black, width: 1),),),
                            child: Padding(
                              padding: const EdgeInsets.only(top:10, bottom: 10, left: 15, right: 15),
                              child: Text("Read All Comments",style: TextStyle(color: Colors.black,fontFamily: "Camphor",
                                  fontWeight: FontWeight.w900, fontSize: 16),),
                            ),
                          ),
                        ),
                      if(snapshot.data.VisitorCount == 1 && _commentLenght != "0")
                        FittedBox(
                          fit: BoxFit.fitWidth,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[

                              InkWell(
                                onTap: (){
                                  Navigator.pushReplacement(context, SlideLeftRoute(page: SendCommentforHostelPage(userKey:userKey)));
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                    border:Border(top: BorderSide(color: Colors.black, width: 1),bottom: BorderSide(color: Colors.black, width: 1),left: BorderSide(color: Colors.black, width: 1),right: BorderSide(color: Colors.black, width: 1),),),
                                  child: Padding(
                                    padding: const EdgeInsets.only(top:10, bottom: 10, left: 15, right: 15),
                                    child: Text("Share Your Comment",style: TextStyle(color: Colors.black,fontFamily: "Camphor",
                                        fontWeight: FontWeight.w900, fontSize: 16),),
                                  ),
                                ),
                              ),
                              SizedBox(width: 20,),
                              InkWell(
                                onTap: (){
                                  Navigator.pushReplacement(context, SlideLeftRoute(page: AllCommentsHostelPage(userKey:userKey, visitorCount:snapshot.data.VisitorCount.toString())));
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                    border:Border(top: BorderSide(color: Colors.black, width: 1),bottom: BorderSide(color: Colors.black, width: 1),left: BorderSide(color: Colors.black, width: 1),right: BorderSide(color: Colors.black, width: 1),),),
                                  child: Padding(
                                    padding: const EdgeInsets.only(top:10, bottom: 10, left: 15, right: 15),
                                    child: Text("Read All Comments",style: TextStyle(color: Colors.black,fontFamily: "Camphor",
                                        fontWeight: FontWeight.w900, fontSize: 16),),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      if(snapshot.data.VisitorCount == 1 && _commentLenght == "0")
                        InkWell(
                          onTap: (){
                            Navigator.pushReplacement(context, SlideLeftRoute(page: SendCommentforHostelPage(userKey:userKey)));
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              border:Border(top: BorderSide(color: Colors.black, width: 1),bottom: BorderSide(color: Colors.black, width: 1),left: BorderSide(color: Colors.black, width: 1),right: BorderSide(color: Colors.black, width: 1),),),
                            child: Padding(
                              padding: const EdgeInsets.only(top:10, bottom: 10, left: 15, right: 15),
                              child: Text("Share Your Comment",style: TextStyle(color: Colors.black,fontFamily: "Camphor",
                                  fontWeight: FontWeight.w900, fontSize: 16),),
                            ),
                          ),
                        ),


                      SizedBox(height: 25,),


                    ],
                  );
                }
                else if (snapshot.hasError)
                {
                  return Align(alignment: Alignment.center, child: Text(""));
                }

                return Center(child: SpinKitRotatingCircle(
                  color: appColor,
                  size: 50.0,
                ));
              },
            ),
          ),
        ),



        bottomNavigationBar: Container(
          height: 50,
          width: double.infinity,
          decoration: BoxDecoration(
            border:Border(top: BorderSide(color: Colors.grey, width: 1),),),
          child: Align(
              alignment: Alignment.center,
              child: Padding(
                padding: const EdgeInsets.only(right:10),
                child: InkWell(
                  onTap:(){


                    if(_petLenght == "0"){
                      //Navigator.push(context, SlideLeftRoute(page: VetRegistration()));\

                      addPet();

                    }
                    if(_petLenght != "0"){

                      String hostelId =  userKey;
                      String _token =  token;

                      print("_petLenght == 1 hostelId : $hostelId");
                      print("_petLenght == 1 _token : $_token");
                      deleteService(hostelId);
                      Navigator.push(context, SlideLeftRoute(page: SelectPetForHostelPage(hostelId:hostelId, token:token)));

                    }

                  },
                  child: Container(
                    color: appColor,
                    child: Padding(
                      padding: const EdgeInsets.only(top:10, bottom: 10, left: 25, right: 25),
                      child: Text("Book Now",style: TextStyle(color: Colors.white,fontFamily: "Camphor",
                          fontWeight: FontWeight.w900, fontSize: 16),),
                    ),
                  ),
                ),
              )),

        ),


      ),
    );
  }
}

