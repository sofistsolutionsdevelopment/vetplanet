import 'dart:convert';
import 'dart:io';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:share/share.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:vetplanet/constant/colors.dart';
import 'package:vetplanet/models/comment_model.dart';
import 'package:vetplanet/models/groomingProfileDetails_model.dart';
import 'package:vetplanet/models/groomingServices_model.dart';
import 'package:vetplanet/models/groomingShop_model.dart';
import 'package:vetplanet/models/pet_model.dart';
import 'package:vetplanet/models/result_model.dart';
import 'package:vetplanet/models/vetProfileDetails_model.dart';
import 'package:vetplanet/screens/allComments_groomers.dart';
import 'package:vetplanet/screens/groomingList.dart';
import 'package:vetplanet/screens/petRegistration.dart';
import 'package:vetplanet/screens/selectGroomingCenter.dart';
import 'package:vetplanet/screens/selectPetForGrooming.dart';
import 'package:vetplanet/screens/sendComments_forGroomer.dart';
import 'package:vetplanet/transitions/slide_route.dart';
import 'dash.dart';
import 'drawer.dart';

class GroomingDetails extends StatefulWidget {
  final String userKey;
  final String token;
  final Function onPressed;

  GroomingDetails({ this.userKey, this.token, this.onPressed });
  @override
  _GroomingDetailsState createState() => _GroomingDetailsState();
}

class _GroomingDetailsState extends State<GroomingDetails> {

  Future<GroomingProfileDetailsModel> _resultGroomingDetails;
  GroomingProfileDetailsModel _resultGroomingProfile;
  Future<GroomingProfileDetailsModel> getGroomingDetails() async{
    final _prefs = await SharedPreferences.getInstance();
    String _RegistrationId = _prefs.getInt('id').toString();
    String _API_Path = _prefs.getString('API_Path');
    debugPrint('Check getProfile _API_Path $_API_Path ');
    final String apiUrl = "$_API_Path/PetGroomingDetailsByPetGroomingId/PetGroomingDetailsByPetGroomingId";

    debugPrint('Check Inserted 1 ');
    debugPrint('Check Inserted widget.userKey : ${widget.userKey} ');

    var response = await http.post(
      Uri.parse(apiUrl),
      headers: {HttpHeaders.contentTypeHeader: 'application/json', HttpHeaders.authorizationHeader: 'bearer VA5kBnSw50cbuJ4YoAVkl4XyFTA312fRtKF4GxlmkUcl3PQJBKvvtogvT_0syd6ZtsZ4-1zFK6_liq5dQpyMq2tOA7vCtZ332qal7LGyBxBvv4mtD461lwGhNtprYd8PyIR40bBsoBc7nMElIniHJXAu1V04eO5c7sNLHOGypeG70Zn06yQr-0i_eFbsCRg6kMWjkao3RZwDfXVra5JQ5I7Pr1CbSgYez6rbYLMbH2LL6K8VcpmUvs45WpLe4UjPpChygW96LCoxVh7YtNa74n1Bje4sDdGLZowZJWwe7F9P7ijy1nVyw_v5K-8MqzlI' },
      body: json.encode(
          {
            "PetGroomingId":widget.userKey,
            "PatientId": _RegistrationId
          }

      ),
    );
    debugPrint('Check Inserted 2 ');
    debugPrint('Check Inserted statusCode :  ${response.statusCode} ');
    if(response.statusCode == 200){

      debugPrint('Check Inserted 3 : ${response.body}');

      final String responseString = response.body;

      debugPrint('Check Inserted 4  ${responseString}');

      return groomingProfileDetailsModelFromJson(responseString);
    }
    else{
      debugPrint('Check Inserted 5 ');
      return null;
    }
  }

  String userKey = "";
  String token = "";
  String groomerName = "";


  void appBarTitle() async {
    final GroomingProfileDetailsModel resultName = await getGroomingDetails();

    setState(() {
      _resultGroomingProfile = resultName;
      if(_resultGroomingProfile != null){
        userKey = _resultGroomingProfile.PetGroomingId.toString();
        token = _resultGroomingProfile.Token;
        groomerName = _resultGroomingProfile.GroomingCenterName;

        print("userKey *******************$userKey");
        print("token *******************$token");
        print("groomerName *******************$groomerName");
        _resultGroomingDetails = getGroomingDetails();
        _futureShopListByPet = getShopListByPetGrooming();
        _futurePetCount = getPet();
        _futureComment = getComment();
      }
      //   isSwitched = true;
    });
  }

  String getShareText() {
    return "Found $groomerName on VET Planet";
  }


  List<GroomingServicesModel> _resultServices;
  List servicesListData = List(); //edited line
  Future<GroomingServicesModel> _resultServicesList;
  Future<GroomingServicesModel> getServices(String ShopId) async {

    print("1 ***");
    final _prefs = await SharedPreferences.getInstance();
    String _API_Path = _prefs.getString('API_Path');
    String _RegistrationId = _prefs.getInt('id').toString();
    debugPrint('Check Inserted _API_Path $_API_Path ');
    debugPrint('Check Inserted _RegistrationId $_RegistrationId ');


    final String apiUrl = "$_API_Path/GetGroomingServices/GetGroomingServices";

    print("2 ***");

    var response = await http.post(
      Uri.parse(apiUrl),
      headers: {HttpHeaders.contentTypeHeader: 'application/json', HttpHeaders.authorizationHeader: 'bearer VA5kBnSw50cbuJ4YoAVkl4XyFTA312fRtKF4GxlmkUcl3PQJBKvvtogvT_0syd6ZtsZ4-1zFK6_liq5dQpyMq2tOA7vCtZ332qal7LGyBxBvv4mtD461lwGhNtprYd8PyIR40bBsoBc7nMElIniHJXAu1V04eO5c7sNLHOGypeG70Zn06yQr-0i_eFbsCRg6kMWjkao3RZwDfXVra5JQ5I7Pr1CbSgYez6rbYLMbH2LL6K8VcpmUvs45WpLe4UjPpChygW96LCoxVh7YtNa74n1Bje4sDdGLZowZJWwe7F9P7ijy1nVyw_v5K-8MqzlI' },
      body: json.encode(
          {
            "PetGroomingId":userKey,
            "ShopId":ShopId
          }

      ),
    );

    print("3 ***");

    print("statusCode *** ${response.statusCode}");
    if(response.statusCode == 200){
      final String responseString = response.body;
      print("responseString *** ${responseString}");

      this.setState(() {
        servicesListData = json.decode(response.body);
        print("speciesListData *** ${servicesListData}");

        _resultServices = servicesListData
            .map<GroomingServicesModel>(
                (_json) => GroomingServicesModel.fromJson(_json))
            .toList();
        print("*** ${servicesListData}");

        print("_resultEmp *** ${_resultServices}");
        print("_resultEmp length*** ${_resultServices.length}");
      });
      return groomingServicesModelFromJson(responseString);
    }else{
      return null;
    }
  }


  Future<List> _futureGroomingServices;
  String _groomingServicesLenght = "";
  Future<List<GroomingServicesModel>> getGroomingServices(String ShopId) async {
    final _prefs = await SharedPreferences.getInstance();
    String _API_Path = _prefs.getString('API_Path');
    debugPrint('Check getProfile _API_Path $_API_Path ');
    final String apiUrl = "$_API_Path/GetGroomingServices/GetGroomingServices";

    debugPrint('Check Inserted 1 ');

    var response = await http.post(
      Uri.parse(apiUrl),
      headers: {HttpHeaders.contentTypeHeader: 'application/json', HttpHeaders.authorizationHeader: 'bearer VA5kBnSw50cbuJ4YoAVkl4XyFTA312fRtKF4GxlmkUcl3PQJBKvvtogvT_0syd6ZtsZ4-1zFK6_liq5dQpyMq2tOA7vCtZ332qal7LGyBxBvv4mtD461lwGhNtprYd8PyIR40bBsoBc7nMElIniHJXAu1V04eO5c7sNLHOGypeG70Zn06yQr-0i_eFbsCRg6kMWjkao3RZwDfXVra5JQ5I7Pr1CbSgYez6rbYLMbH2LL6K8VcpmUvs45WpLe4UjPpChygW96LCoxVh7YtNa74n1Bje4sDdGLZowZJWwe7F9P7ijy1nVyw_v5K-8MqzlI' },
      body: json.encode(
          {
            "PetGroomingId":userKey,
            "ShopId":ShopId
          }
      ),
    );
    debugPrint('Check 2}');
    if (response != null && response.statusCode == 200) {
      debugPrint('Check 3}');
      var _response = json.decode(response.body);
      debugPrint('Check 4  ${_response}');

      List<GroomingServicesModel> _groomingServices = _response
          .map<GroomingServicesModel>(
              (_json) => GroomingServicesModel.fromJson(_json))
          .toList();

      debugPrint('Check 5  ${_groomingServices}');
      _groomingServicesLenght = _groomingServices.length.toString();
      debugPrint('Check _groomingServicesLenght &&&&&&&&&&&&&&&&&&&&&&&&&: $_groomingServicesLenght}');

      return _groomingServices;

    } else {
      debugPrint('Check 6');
      return [];
    }
  }




  Future<List> _futureShopListByPet;

  String _groomingShopLenght = "";

  Future<List<GroomingShopModel>> getShopListByPetGrooming() async {
    final _prefs = await SharedPreferences.getInstance();
    String _API_Path = _prefs.getString('API_Path');
    String _RegistrationId = _prefs.getInt('id').toString();
    debugPrint('Check getProfile _API_Path $_API_Path ');
    final String apiUrl = "$_API_Path/GetShopListByPetGroomingId/GetShopListByPetGroomingId";

    debugPrint('Check Inserted 1 ');

    var response = await http.post(
      Uri.parse(apiUrl),
      headers: {HttpHeaders.contentTypeHeader: 'application/json', HttpHeaders.authorizationHeader: 'bearer VA5kBnSw50cbuJ4YoAVkl4XyFTA312fRtKF4GxlmkUcl3PQJBKvvtogvT_0syd6ZtsZ4-1zFK6_liq5dQpyMq2tOA7vCtZ332qal7LGyBxBvv4mtD461lwGhNtprYd8PyIR40bBsoBc7nMElIniHJXAu1V04eO5c7sNLHOGypeG70Zn06yQr-0i_eFbsCRg6kMWjkao3RZwDfXVra5JQ5I7Pr1CbSgYez6rbYLMbH2LL6K8VcpmUvs45WpLe4UjPpChygW96LCoxVh7YtNa74n1Bje4sDdGLZowZJWwe7F9P7ijy1nVyw_v5K-8MqzlI' },
      body: json.encode(
          {
            "PetGroomingId":userKey,
          }
      ),
    );
    debugPrint('Check 2}');
    if (response != null && response.statusCode == 200) {
      debugPrint('Check 3}');
      var _response = json.decode(response.body);
      debugPrint('Check 4  ${_response}');

      List<GroomingShopModel> _groomingShop = _response
          .map<GroomingShopModel>(
              (_json) => GroomingShopModel.fromJson(_json))
          .toList();

      debugPrint('Check 5  ${_groomingShop}');
      setState(() {
        _groomingShopLenght = _groomingShop.length.toString();
        debugPrint('Check _groomingShopLenght &&&&&&&&&&&&&&&&&&&&&&&&&: $_groomingShopLenght}');

      });
      return _groomingShop;

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


  Future<List<CommentModel>> getComment() async {
    final _prefs = await SharedPreferences.getInstance();
    String _API_Path = _prefs.getString('API_Path');
    String _RegistrationId = _prefs.getInt('id').toString();
    debugPrint('Check Inserted _API_Path $_API_Path ');
    debugPrint('Check Inserted _RegistrationId $_RegistrationId ');


    final String apiUrl = "$_API_Path/GetGroomerCommentList/GetGroomerCommentList";

    debugPrint('Check Inserted 1 ');
    var response = await http.post(
      Uri.parse(apiUrl),
      headers: {HttpHeaders.contentTypeHeader: 'application/json', HttpHeaders.authorizationHeader: 'bearer VA5kBnSw50cbuJ4YoAVkl4XyFTA312fRtKF4GxlmkUcl3PQJBKvvtogvT_0syd6ZtsZ4-1zFK6_liq5dQpyMq2tOA7vCtZ332qal7LGyBxBvv4mtD461lwGhNtprYd8PyIR40bBsoBc7nMElIniHJXAu1V04eO5c7sNLHOGypeG70Zn06yQr-0i_eFbsCRg6kMWjkao3RZwDfXVra5JQ5I7Pr1CbSgYez6rbYLMbH2LL6K8VcpmUvs45WpLe4UjPpChygW96LCoxVh7YtNa74n1Bje4sDdGLZowZJWwe7F9P7ijy1nVyw_v5K-8MqzlI' },
      body: json.encode(
          {
            "GroomerId": userKey,
            "Operation":"top5"
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
            "GroomerId":userKey,
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
  String _comment = "";


  ResultModel _resultRating;

  Future<ResultModel> saveRating(String rating) async{
    final _prefs = await SharedPreferences.getInstance();
    String _API_Path = _prefs.getString('API_Path');
    String _RegistrationId = _prefs.getInt('id').toString();
    debugPrint('Check Inserted _API_Path $_API_Path ');
    debugPrint('Check Inserted _RegistrationId $_RegistrationId ');

    final String apiUrl = "$_API_Path/SaveRating/SaveRating";

    debugPrint('Check Inserted 1 ');

    var response = await http.post(
      Uri.parse(apiUrl),
      headers: {HttpHeaders.contentTypeHeader: 'application/json', HttpHeaders.authorizationHeader: 'bearer VA5kBnSw50cbuJ4YoAVkl4XyFTA312fRtKF4GxlmkUcl3PQJBKvvtogvT_0syd6ZtsZ4-1zFK6_liq5dQpyMq2tOA7vCtZ332qal7LGyBxBvv4mtD461lwGhNtprYd8PyIR40bBsoBc7nMElIniHJXAu1V04eO5c7sNLHOGypeG70Zn06yQr-0i_eFbsCRg6kMWjkao3RZwDfXVra5JQ5I7Pr1CbSgYez6rbYLMbH2LL6K8VcpmUvs45WpLe4UjPpChygW96LCoxVh7YtNa74n1Bje4sDdGLZowZJWwe7F9P7ijy1nVyw_v5K-8MqzlI' },
      body: json.encode(
          {
            "PatientId":_RegistrationId,
            "VetId":"0",
            "GroomerId":userKey,
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


  @override
  void initState() {
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
            .pushReplacement(new MaterialPageRoute(builder: (context) => GroomingListPage(onPressed: rebuildPage)));
        return new Future(() => false); //onWillPop is Future<bool> so return false
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: appColor,
          title:  Text(groomerName,style: TextStyle(
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
            child: FutureBuilder<GroomingProfileDetailsModel>(
              future: _resultGroomingDetails,
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
                                snapshot.data.Photograph,
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
                                  Text(snapshot.data.GroomingCenterName, style: TextStyle(
                                    color: Colors.black, fontSize: 18,fontFamily: "Camphor",
                                    fontWeight: FontWeight.w700,),),
                                  Text("Contact No : ${snapshot.data.ContactNo}", style: TextStyle(
                                    color: Colors.black, fontSize: 17,fontFamily: "Camphor",
                                    fontWeight: FontWeight.w500,),),
                                  Text("E-Mail Id : ${snapshot.data.Email}", style: TextStyle(
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
                      SizedBox(height: 10,),
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
                        color: Color(0xffEBEBEB),
                      ),

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
                                              "assets/groomingw.png",width: 20,height: 15,
                                            ),
                                            SizedBox(width: 10,),
                                            Flexible(
                                              child: Text("Shop Details and Services",style: TextStyle(color: Colors.white,fontFamily: "Camphor",
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
                                      future: _futureShopListByPet,
                                      builder: (context, snapshot) {
                                        if (snapshot.hasError) {
                                          return Center(child: Text(''));
                                        }
                                        if (snapshot.hasData) {
                                          List<GroomingShopModel> _groomingShop = snapshot.data;
                                          return ListView.builder(
                                            physics: ClampingScrollPhysics(),
                                            shrinkWrap: true,
                                            itemCount: _groomingShop == null ? 0 : _groomingShop.length,
                                            itemBuilder: (BuildContext context, int index) {
                                              String ShopId = "${_groomingShop[index].ShopId.toString()}";

                                              _futureGroomingServices =getGroomingServices(ShopId);

                                              return Padding(
                                                padding: const EdgeInsets.only(left:5, top: 10,right: 5),
                                                child:   ExpansionTile(

                                                  title:  Text(
                                                    "${_groomingShop[index].ShopName}",
                                                    style: TextStyle(fontSize:18, fontFamily: "Camphor",
                                                        fontWeight: FontWeight.w700,color: Colors.black),
                                                  ),
                                                  leading: InkWell(
                                                      onTap: (){
                                                        String address =  "${_groomingShop[index].ShopAddress}";

                                                        print("address : $address");
                                                        launchMap(address);
                                                      },
                                                      child: Icon(Icons.location_on, color: appColor,size: 20,)),
                                                  trailing: Icon(Icons.expand_more, color: appColor,size: 35,),

                                                  subtitle:  Text(
                                                    "${_groomingShop[index].ShopAddress}",
                                                    style: TextStyle(fontSize:14, fontFamily: "Camphor",
                                                        fontWeight: FontWeight.w700,color: Colors.black),
                                                  ),
                                                  children: <Widget>[
                                                    SingleChildScrollView(
                                                      child: FutureBuilder(
                                                        future: _futureGroomingServices,
                                                        builder: (context, snapshot) {
                                                          if (snapshot.hasError) {
                                                            return Center(child: Text(''));
                                                          }
                                                          if (snapshot.hasData) {
                                                            List<GroomingServicesModel> _groominService = snapshot.data;
                                                            return ListView.builder(
                                                              physics: ClampingScrollPhysics(),
                                                              shrinkWrap: true,
                                                              itemCount: _groominService == null ? 0 : _groominService.length,
                                                              itemBuilder: (BuildContext context, int index) {
                                                                return SingleChildScrollView(
                                                                  child: Padding(
                                                                    padding: const EdgeInsets.all(8.0),
                                                                    child:   Row(
                                                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                                      children: <Widget>[
                                                                        Flexible(
                                                                          child: Text("${_groominService[index].Service}",
                                                                            style: TextStyle(fontSize:15, fontFamily: "Camphor",
                                                                                fontWeight: FontWeight.w500,color: Colors.black),),
                                                                        ),
                                                                        SizedBox(width: 5,),
                                                                        Text("${_groominService[index].Rate}/-",
                                                                          style: TextStyle(fontSize:15, fontFamily: "Camphor",
                                                                              fontWeight: FontWeight.w500,color: Colors.black),),
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
                      if(snapshot.data.VisitorCount == 1)
                      Divider(
                        thickness: 8,
                        color: Color(0xffEBEBEB),
                      ),
                      if(snapshot.data.VisitorCount == 1)
                      SizedBox(height:10),
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
                                          _resultGroomingDetails = getGroomingDetails();
                                          _futureShopListByPet = getShopListByPetGrooming();
                                          _futurePetCount = getPet();
                                          _futureComment = getComment();
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
                                          _resultGroomingDetails = getGroomingDetails();
                                          _futureShopListByPet = getShopListByPetGrooming();
                                          _futurePetCount = getPet();
                                          _futureComment = getComment();
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
                              List<CommentModel> _comment = snapshot.data;
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
                            Navigator.pushReplacement(context, SlideLeftRoute(page: AllCommentsGroomersPage(userKey:userKey,visitorCount:snapshot.data.VisitorCount.toString() )));
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
                                  Navigator.pushReplacement(context, SlideLeftRoute(page: SendCommentforGroomerPage(userKey:userKey)));
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
                                  Navigator.pushReplacement(context, SlideLeftRoute(page: AllCommentsGroomersPage(userKey:userKey, visitorCount:snapshot.data.VisitorCount.toString())));
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
                            Navigator.pushReplacement(context, SlideLeftRoute(page: SendCommentforGroomerPage(userKey:userKey)));
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

                      String groomingId =  userKey;
                      String _token =  token;

                      print("_petLenght == 1 groomingId : $groomingId");
                      print("_petLenght == 1 _token : $_token");

                      Navigator.push(context, SlideLeftRoute(page: SelectGroomingShopPage(groomingId:groomingId, token:_token)));
                    }

                  },
                  child: Container(
                    color: appColor,
                    child: Padding(
                      padding: const EdgeInsets.only(top:10, bottom: 10, left: 25, right: 25),
                      child: Text("Book Appointment",style: TextStyle(color: Colors.white,fontFamily: "Camphor",
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