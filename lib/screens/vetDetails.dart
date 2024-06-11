import 'dart:convert';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
// import 'package:share/share.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:simple_html_css/simple_html_css.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:vetplanet/constant/colors.dart';
import 'package:vetplanet/models/clinic_model.dart';
import 'package:vetplanet/models/comment_model.dart';
import 'package:vetplanet/models/pet_model.dart';
import 'package:vetplanet/models/result_model.dart';
import 'package:vetplanet/models/services_model.dart';
import 'package:vetplanet/models/vetProfileDetails_model.dart';
import 'package:vetplanet/screens/allComments.dart';
import 'package:vetplanet/screens/nextVaccinationList.dart';
import 'package:vetplanet/screens/petRegistration.dart';
import 'package:vetplanet/screens/prescription.dart';
import 'package:vetplanet/screens/selectClinic.dart';
import 'package:vetplanet/screens/selectPet.dart';
import 'package:vetplanet/screens/selectPetForCertification.dart';
import 'package:vetplanet/screens/selectPetForHistory.dart';
import 'package:vetplanet/screens/selectPetForNextVaccDate.dart';
import 'package:vetplanet/screens/selectPetForPrescription.dart';
import 'package:vetplanet/screens/sendComments.dart';
import 'package:vetplanet/screens/veterinaryList.dart';
import 'package:vetplanet/transitions/slide_route.dart';
import 'certificates.dart';
import 'dash.dart';
import 'dateSelectionForHistory.dart';
import 'drawer.dart';

class VetDetails extends StatefulWidget {
  final String userKey;
  final String token;
  final Function onPressed;

  VetDetails({ this.userKey, this.token, this.onPressed});
  @override
  _VetDetailsState createState() => _VetDetailsState();
}

class _VetDetailsState extends State<VetDetails> {

  String _comment = "";

  Future<VetProfileDetailsModel> _resultVetDetails;
  VetProfileDetailsModel _resultVetProfile;
  Future<VetProfileDetailsModel> getVetDetails() async{
    final _prefs = await SharedPreferences.getInstance();
    String _RegistrationId = _prefs.getInt('id').toString();
    
    debugPrint('Check getProfile apiUrl $apiUrl ');
    final String url = "$apiUrl/GetVetDetailsByVetId/GetVetDetailsByVetId";

    debugPrint('Check Inserted 1 ');
    debugPrint('Check Inserted widget.userKey : ${widget.userKey} ');

    var response = await http.post(
      Uri.parse(url),
      headers: {HttpHeaders.contentTypeHeader: 'application/json', HttpHeaders.authorizationHeader: bearerToken },
      body: json.encode(
          {
            "UserKey":widget.userKey,
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

      return vetProfileDetailsModelFromJson(responseString);


    }else{
      debugPrint('Check Inserted 5 ');
      return null;
    }
  }


  Future<List> _future;
  String _onePet = "";
  String _petLenght = "";
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


    /* final response = await http.post(apiUrl,body: {
      "CREATEDBY": _RegistrationId
    }
    );*/
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

  String userKey = "";
  String token = "";
  String vetName = "";
  String specialization = "";
  String education = "";

  void appBarTitle() async {
    final VetProfileDetailsModel resultName = await getVetDetails();


    setState(() {
      _resultVetProfile = resultName;
      if(_resultVetProfile != null){
        userKey = _resultVetProfile.UserKey.toString();
        token = _resultVetProfile.Token;
        vetName = _resultVetProfile.User_Name;
        specialization = _resultVetProfile.Specialization;
        education = _resultVetProfile.Education;

        print("userKey *******************$userKey");
        print("token *******************$token");
        print("vetName *******************$vetName");
        print("specialization *******************$specialization");
        print("education *******************$education");
        _future = getPet();
        _resultVetDetails = getVetDetails();
        _futureComment = getComment();
        _futureClinic = getClinic();
        _futureVetServices = getVetServices();
      }
      //   isSwitched = true;
    });

  }

  Future<List> _futureComment;

  String _commentLenght = "";

  Future<List<CommentModel>> getComment() async {
    final _prefs = await SharedPreferences.getInstance();
    
    String _RegistrationId = _prefs.getInt('id').toString();
    debugPrint('Check Inserted apiUrl $apiUrl ');
    debugPrint('Check Inserted _RegistrationId $_RegistrationId ');


    final String url = "$apiUrl/GetCommentList/GetCommentList";

    debugPrint('Check Inserted 1 ');
    var response = await http.post(
      Uri.parse(url),
      headers: {HttpHeaders.contentTypeHeader: 'application/json', HttpHeaders.authorizationHeader: bearerToken },
      body: json.encode(
          {
            "VetId": userKey,
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
    
    String _RegistrationId = _prefs.getInt('id').toString();
    debugPrint('Check Inserted apiUrl $apiUrl ');
    debugPrint('Check Inserted _RegistrationId $_RegistrationId ');

    final String url = "$apiUrl/SaveComment/SaveComment";

    debugPrint('Check Inserted 1 ');

    var response = await http.post(
      Uri.parse(url),
      headers: {HttpHeaders.contentTypeHeader: 'application/json', HttpHeaders.authorizationHeader: bearerToken },
      body: json.encode(
          {
            "PatientId":_RegistrationId,
            "VetId":userKey,
            "GroomerId":"0",
            "Comments":comment
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

  ResultModel _resultRating;

  Future<ResultModel> saveRating(String rating) async{
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
            "VetId":userKey,
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

  final TextEditingController _controllerComment = new TextEditingController();
  final GlobalKey<FormState> _formStateKey = GlobalKey<FormState>();

  Future<List> _futureClinic;

  String _clinicLenght = "";

  Future<List<ClinicModel>> getClinic() async {
    final _prefs = await SharedPreferences.getInstance();
    
    String _RegistrationId = _prefs.getInt('id').toString();
    debugPrint('Check Inserted apiUrl $apiUrl ');
    debugPrint('Check Inserted _RegistrationId $_RegistrationId ');


    final String url = "$apiUrl/GetClinicListByVetId/GetClinicListByVetId";

    debugPrint('Check Inserted 1 ');
    var response = await http.post(
      Uri.parse(url),
      headers: {HttpHeaders.contentTypeHeader: 'application/json', HttpHeaders.authorizationHeader: bearerToken },
      body: json.encode(
          {
            "VetId": userKey
          }
      ),
    );

    debugPrint('Check 2}');
    if (response != null && response.statusCode == 200) {
      debugPrint('Check 3}');
      var _response = json.decode(response.body);
      debugPrint('Check 4  ${_response}');


      List<ClinicModel> _clinic = _response
          .map<ClinicModel>(
              (_json) => ClinicModel.fromJson(_json))
          .toList();

      debugPrint('Check 5  ${_clinic}');
      setState(() {
        _clinicLenght = _clinic.length.toString();
        debugPrint('Check _petLenght &&&&&&&&&&&&&&&&&&&&&&&&&: $_clinicLenght}');

      });
      return _clinic;

    } else {
      debugPrint('Check 6');
      return [];
    }
  }


  Future<List> _futureVetServices;
  String _vetServicesLenght = "";
  Future<List<ServicesModel>> getVetServices() async {
    final _prefs = await SharedPreferences.getInstance();
    
    debugPrint('Check getProfile apiUrl $apiUrl ');
    final String url = "$apiUrl/GetVetServices/GetVetServices";

    debugPrint('Check Inserted 1 ');

    var response = await http.post(
      Uri.parse(url),
      headers: {HttpHeaders.contentTypeHeader: 'application/json', HttpHeaders.authorizationHeader: bearerToken },
      body: json.encode(
          {
            "UserKey":userKey
          }
      ),
    );
    debugPrint('Check 2}');
    if (response != null && response.statusCode == 200) {
      debugPrint('Check 3}');
      var _response = json.decode(response.body);
      debugPrint('Check 4  ${_response}');

      List<ServicesModel> _services = _response
          .map<ServicesModel>(
              (_json) => ServicesModel.fromJson(_json))
          .toList();

      debugPrint('Check 5  ${_services}');
      setState(() {
        _vetServicesLenght = _services.length.toString();
        debugPrint('Check _vetServicesLenght &&&&&&&&&&&&&&&&&&&&&&&&&: $_vetServicesLenght}');

      });
      return _services;

    } else {
      debugPrint('Check 6');
      return [];
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

  String getShareText() {
    return "Found $vetName on VET Planet\n $education";
  }


  void launchMap(String address) async {
    String query = Uri.encodeComponent(address);
    String googleUrl = "https://www.google.com/maps/search/?api=1&query=$query";

    if (await canLaunch(googleUrl)) {
      await launch(googleUrl);
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: (){
        //on Back button press, you can use WillPopScope for another purpose also.
        // Navigator.pop(context); //return data along with pop
        Navigator.of(context)
            .pushReplacement(new MaterialPageRoute(builder: (context) => VeterinaryListPage(onPressed: rebuildPage)));
        return new Future(() => false); //onWillPop is Future<bool> so return false
      },
      child: Scaffold(
       appBar: AppBar(
         backgroundColor: appColor,
         title:  Text(vetName,style: TextStyle(
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
           /*new IconButton(
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
            child: FutureBuilder<VetProfileDetailsModel>(
              future: _resultVetDetails,
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
                            SizedBox(width: 10,),
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
                                  Text(snapshot.data.User_Name, style: TextStyle(
                                    color: Colors.black, fontSize: 18,fontFamily: "Camphor",
                                    fontWeight: FontWeight.w700,),),

                                  /* Html(data:snapshot.data.Education,defaultTextStyle: TextStyle(
                                        color: Colors.black, fontSize: 18,fontFamily: "Camphor",
                                        fontWeight: FontWeight.w900,),),*/
                                  Text("${snapshot.data.Specialization}", style: TextStyle(
                                    color: Colors.black, fontSize: 17,fontFamily: "Camphor",
                                    fontWeight: FontWeight.w500,),),
                                  Text("${snapshot.data.TotalYearOfExp} years experience overall", style: TextStyle(
                                    color: Colors.black, fontSize: 17,fontFamily: "Camphor",
                                    fontWeight: FontWeight.w500,),),
                                  // SizedBox(height: 10,),
                                  /*Text("Visitor Count : ${snapshot.data.VisitorCount}", style: TextStyle(
                                        color: Colors.black, fontSize: 16,fontFamily: "Camphor",
                                        fontWeight: FontWeight.w500,),),*/

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

                      SizedBox(height: 5,),
                      Divider(
                        thickness: 8,
                        color: Color(0xffEBEBEB),
                      ),
                      if(snapshot.data.VisitorCount != 0)
                      Padding(
                          padding: const EdgeInsets.only(left:15, right: 15),
                          child: Column(
                            children: <Widget>[

                              SizedBox(height: 10,),
                              InkWell(
                                onTap: (){
                                  if(_petLenght != "0" && _petLenght != "1"){
                                    String vetId = snapshot.data.UserKey.toString();
                                    String from = "vetDetails";
                                    print("_petLenght != 1 vetId : $vetId");
                                    Navigator.push(context, SlideLeftRoute(page: SelectPetForNextVaccDatePage(vetId:vetId, from:from)));

                                    //  Navigator.of(context).push(MaterialPageRoute(
                                    //   builder: (BuildContext context) => SelectPetForNextVaccDatePage(vetId:vetId)));
                                  }
                                  if(_petLenght == "1"){

                                    String petId = _onePet;
                                    String vetId = snapshot.data.UserKey.toString();
                                    print("_petLenght == 1 petId : $petId");
                                    print("_petLenght == 1 vetId : $vetId");
                                    Navigator.push(context, SlideLeftRoute(page: NextVaccinationDatePage(petId:petId, vetId:vetId)));

                                    // Navigator.of(context).push(MaterialPageRoute(
                                    //  builder: (BuildContext context) => NextVaccinationDatePage(petId:petId, vetId:vetId)));
                                  }
                                },
                                child: Container(
                                    child: Padding(
                                      padding: const EdgeInsets.only(right:15, left: 15, bottom: 10, top: 10),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Text("Next Vaccination Date",style: TextStyle(fontSize:16, fontFamily: "Camphor",
                                              fontWeight: FontWeight.w700,color: Colors.black),),
                                          Icon(Icons.arrow_forward_ios, color: Colors.black,size: 17,)
                                        ],
                                      ),
                                    )),
                              ),
                              InkWell(
                                onTap: (){
                                  if(_petLenght != "0" && _petLenght != "1"){
                                    String vetId = snapshot.data.UserKey.toString();
                                    print("_petLenght != 1 vetId : $vetId");
                                    //Navigator.of(context).push(MaterialPageRoute(
                                    //   builder: (BuildContext context) => SelectPetForPrescriptionPage(vetId:vetId)));

                                    Navigator.push(context, SlideLeftRoute(page: SelectPetForPrescriptionPage(vetId:vetId)));

                                  }
                                  if(_petLenght == "1"){
                                    String petId = _onePet;
                                    String vetId = snapshot.data.UserKey.toString();
                                    print("_petLenght == 1 petId : $petId");
                                    print("_petLenght == 1 vetId : $vetId");

                                    Navigator.push(context, SlideLeftRoute(page: PrescriptionPage(petId:petId, vetId:vetId)));
                                  }
                                },
                                child: Container(

                                    child: Padding(
                                      padding: const EdgeInsets.only(right:15, left: 15, bottom: 10, top: 10),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Text("Prescription Details",style: TextStyle(fontSize:16, fontFamily: "Camphor",
                                              fontWeight: FontWeight.w700,color: Colors.black),),
                                          Icon(Icons.arrow_forward_ios, color: Colors.black,size: 17)
                                        ],
                                      ),
                                    )),
                              ),
                              InkWell(
                                onTap: (){
                                  if(_petLenght != "0" && _petLenght != "1"){
                                    String vetId = snapshot.data.UserKey.toString();
                                    print("_petLenght != 1 vetId : $vetId");

                                    Navigator.push(context, SlideLeftRoute(page: SelectPetForHistoryPage(vetId:vetId)));

                                    //Navigator.of(context).push(MaterialPageRoute(
                                    //   builder: (BuildContext context) => SelectPetForHistoryPage(vetId:vetId)));
                                  }
                                  if(_petLenght == "1"){
                                    String petId = _onePet;
                                    String vetId = snapshot.data.UserKey.toString();
                                    print("_petLenght == 1 petId : $petId");
                                    print("_petLenght == 1 vetId : $vetId");

                                    Navigator.push(context, SlideLeftRoute(page: DateSelectionForHistoryPage(petId:petId, vetId:vetId)));

                                    //   Navigator.of(context).push(MaterialPageRoute(
                                    //     builder: (BuildContext context) => DateSelectionForHistoryPage(petId:petId, vetId:vetId)));
                                  }
                                },
                                child: Container(

                                    child: Padding(
                                      padding: const EdgeInsets.only(right:15, left: 15, bottom: 10, top: 10),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Text("Medical Reports",style: TextStyle(fontSize:16, fontFamily: "Camphor",
                                              fontWeight: FontWeight.w700,color: Colors.black),),
                                          Icon(Icons.arrow_forward_ios, color: Colors.black,size: 17,)
                                        ],
                                      ),
                                    )),
                              ),
                              InkWell(
                                onTap: (){
                                  if(_petLenght != "0" && _petLenght != "1"){
                                    String vetId = snapshot.data.UserKey.toString();
                                    String from = "vetDetails";
                                    print("_petLenght != 1 vetId : $vetId");
                                    Navigator.push(context, SlideLeftRoute(page: SelectPetForCertificationPage(vetId:vetId, from:from)));

                                    //  Navigator.of(context).push(MaterialPageRoute(
                                    //   builder: (BuildContext context) => SelectPetForNextVaccDatePage(vetId:vetId)));
                                  }
                                  if(_petLenght == "1"){

                                    String petId = _onePet;
                                    String vetId = snapshot.data.UserKey.toString();
                                    print("_petLenght == 1 petId : $petId");
                                    print("_petLenght == 1 vetId : $vetId");
                                    Navigator.push(context, SlideLeftRoute(page: CertificatesPage(petId:petId, vetId:vetId)));

                                    // Navigator.of(context).push(MaterialPageRoute(
                                    //  builder: (BuildContext context) => NextVaccinationDatePage(petId:petId, vetId:vetId)));
                                  }
                                },
                                child: Container(
                                    child: Padding(
                                      padding: const EdgeInsets.only(right:15, left: 15, bottom: 10, top: 10),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Text("Certificate Details",style: TextStyle(fontSize:16, fontFamily: "Camphor",
                                              fontWeight: FontWeight.w700,color: Colors.black),),
                                          Icon(Icons.arrow_forward_ios, color: Colors.black,size: 17,)
                                        ],
                                      ),
                                    )),
                              ),
                              Divider(
                                thickness: 8,
                                color: Color(0xffEBEBEB),
                              ),
                            ],
                          ),
                        ),

                      Padding(
                        padding: const EdgeInsets.only(right:10, left: 10, top:10),
                        child: Card(
                          child: Column(
                            children: <Widget>[

                              SizedBox(height: 10,),
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
                                              "assets/clinic.png",width: 20,height: 15,
                                            ),
                                            SizedBox(width: 10,),
                                            Text("Clinic Details",style: TextStyle(color: Colors.white,fontFamily: "Camphor",
                                                fontWeight: FontWeight.w900, fontSize: 16),),
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
                                      future: _futureClinic,
                                      builder: (context, snapshot) {
                                        if (snapshot.hasError) {
                                          return Center(child: Text(''));
                                        }
                                        if (snapshot.hasData) {
                                          List<ClinicModel> _clinic =  snapshot.data;
                                          return ListView.builder(
                                            physics: ClampingScrollPhysics(),
                                            shrinkWrap: true,
                                            itemCount: _clinic == null ? 0 : _clinic.length,
                                            itemBuilder: (BuildContext context, int index) {
                                              return Padding(
                                                padding: const EdgeInsets.all(8.0),
                                                child:   Row(
                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                  children: <Widget>[
                                                    Expanded(
                                                      child: Column(
                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                        mainAxisAlignment: MainAxisAlignment.start,
                                                        children: <Widget>[
                                                          Text(
                                                            "${_clinic[index].ClinicName}",
                                                            style: TextStyle(
                                                              color: Colors.black, fontSize: 16,fontFamily: "Camphor",
                                                              fontWeight: FontWeight.w700,),
                                                          ),
                                                          Text(
                                                            "${_clinic[index].ClinicContactNo}",
                                                            style: TextStyle(
                                                              color: Colors.black, fontSize: 16,fontFamily: "Camphor",
                                                              fontWeight: FontWeight.w700,),
                                                          ),
                                                          Text(
                                                            "${_clinic[index].ClinicAddress}",
                                                            style: TextStyle(
                                                              color: Colors.black, fontSize: 16,fontFamily: "Camphor",
                                                              fontWeight: FontWeight.w700,),
                                                          ),
                                                          Text(
                                                            "Appointment Booking Amount : ${_clinic[index].AppointmentCharges.toString()}",
                                                            style: TextStyle(
                                                              color: Colors.black, fontSize: 16,fontFamily: "Camphor",
                                                              fontWeight: FontWeight.w700,),
                                                          ),
                                                        ],
                                                      ),
                                                    ),

                                                    InkWell(
                                                        onTap: (){
                                                          String address = "${_clinic[index].ClinicAddress}";

                                                          print("address : $address");
                                                          launchMap(address);
                                                        },
                                                        child: Icon(Icons.location_on, color: appColor,size: 20,)),

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
                      SizedBox(height:10),
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
                                      "Rate Your Doctor  ",
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
                                child: Column(
                                  //mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                                            _resultVetDetails = getVetDetails();
                                            _futureComment = getComment();
                                            _futureVetServices = getVetServices();
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
                                            _resultVetDetails = getVetDetails();
                                            _futureComment = getComment();
                                            _futureVetServices = getVetServices();
                                          });
                                        },
                                        child: Container(
                                          child: Image.asset(
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
                        child:
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Flexible(
                              child: Padding(
                                padding: const EdgeInsets.only(right:15, left: 15, top: 15, bottom: 5),
                                child: Text(
                                  "Services by $vetName ",
                                  style: TextStyle(fontFamily: "Camphor",
                                      fontWeight: FontWeight.w700, fontSize: 20,color: Colors.black),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left:15, right: 15),
                        child: Column(
                          children: <Widget>[


                            SizedBox(height: 10,),
                            FutureBuilder(
                              future: _futureVetServices,
                              builder: (context, snapshot) {
                                if (snapshot.hasError) {
                                  return Center(child: Text(''));
                                }
                                if (snapshot.hasData) {
                                  List<ServicesModel> _services = snapshot.data;
                                  return ListView.builder(
                                    physics: ClampingScrollPhysics(),
                                    shrinkWrap: true,
                                    itemCount: _services == null ? 0 : _services.length,
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
                                                  child: Text("${_services[index].ServiceName}",
                                                    style: TextStyle(fontSize:17, fontFamily: "Camphor",
                                                        fontWeight: FontWeight.w500,color: Colors.black),),
                                                ),
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
                      SizedBox(height:10),
                      Divider(
                        thickness: 8,
                        color: Color(0xffEBEBEB),
                      ),
                      SizedBox(height:5),
                      Align(
                        alignment: Alignment.topLeft,
                        child:
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Flexible(
                              child: Padding(
                                padding: const EdgeInsets.only(right:15, left: 15, top: 15, bottom: 5),
                                child: Text(
                                  "More About $vetName ",
                                  style: TextStyle(fontFamily: "Camphor",
                                      fontWeight: FontWeight.w700, fontSize: 20,color: Colors.black),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      Padding(
                        padding: const EdgeInsets.only(left:15, right: 15),
                        child: Align(
                          alignment:Alignment.centerLeft,
                          child: Text("${snapshot.data.Description}",  style: TextStyle(
                            color: Colors.black, fontSize: 16,fontFamily: "Camphor",
                            fontWeight: FontWeight.w500,),),
                        ),
                      ),
                      SizedBox(height: 10,),
                      ListTileTheme(
                        dense: true,
                        contentPadding: EdgeInsets.fromLTRB(20, -100, 20, -100),
                        child: ExpansionTile(
                          title: Text(
                            "Specialization",
                            style: TextStyle(fontSize:18, fontFamily: "Camphor",
                                fontWeight: FontWeight.w700,color: Colors.black),
                          ),
                          children: <Widget>[

                            Align(
                              alignment: Alignment.centerLeft,
                              child: Padding(
                                padding: const EdgeInsets.only(right:15, left: 15, top: 8, bottom: 8),
                                child:  Text(snapshot.data.Specialization,style: TextStyle(
                                  color: Colors.black, fontSize: 18,fontFamily: "Camphor",
                                  fontWeight: FontWeight.w500,),textAlign: TextAlign.start,),
                              ),
                            ),

                          ],
                        ),
                      ),
                      Divider(color: Colors.grey),

                      ListTileTheme(
                        dense: true,
                        contentPadding: EdgeInsets.fromLTRB(20, -100, 20, -100),
                        child: ExpansionTile(

                          title: Text(
                            "Education",
                            style: TextStyle(fontSize:18, fontFamily: "Camphor",
                                fontWeight: FontWeight.w700,color: Colors.black),
                          ),
                          children: <Widget>[

                            Padding(
                              padding: const EdgeInsets.only(right:15, left: 15, top: 8, bottom: 8),
                              child:  Html(data:snapshot.data.Education,defaultTextStyle: TextStyle(
                                color: Colors.black, fontSize: 18,fontFamily: "Camphor",
                                fontWeight: FontWeight.w500,),),
                            ),

                          ],
                        ),
                      ),
                      Divider(color: Colors.grey),

                      ListTileTheme(
                        dense: true,
                        contentPadding: EdgeInsets.fromLTRB(20, -100, 20, -100),
                        child: ExpansionTile(

                          title: Text(
                            "Experience",
                            style: TextStyle(fontSize:18, fontFamily: "Camphor",
                                fontWeight: FontWeight.w700,color: Colors.black),
                          ),
                          children: <Widget>[

                            Padding(
                              padding: const EdgeInsets.only(right:15, left: 15, top: 8, bottom: 8),
                              child:  Align(
                                alignment:Alignment.centerLeft,
                                child: Text("${snapshot.data.TotalYearOfExp} years experience overall",style: TextStyle(
                                  color: Colors.black, fontSize: 18,fontFamily: "Camphor",
                                  fontWeight: FontWeight.w500,),textAlign: TextAlign.start,),
                              ),
                            ),

                          ],
                        ),
                      ),
                      Divider(color: Colors.grey),
                      ListTileTheme(
                        dense: true,
                        contentPadding: EdgeInsets.fromLTRB(20, -100, 20, -100),
                        child: ExpansionTile(

                          title: Text(
                            "Award Recognition",
                            style: TextStyle(fontSize:18, fontFamily: "Camphor",
                                fontWeight: FontWeight.w700,color: Colors.black),
                          ),
                          children: <Widget>[

                            Padding(
                              padding: const EdgeInsets.only(right:15, left: 15, top: 8, bottom: 8),
                              child:  Html(data:snapshot.data.AwardRecognition,defaultTextStyle: TextStyle(
                                color: Colors.black, fontSize: 18,fontFamily: "Camphor",
                                fontWeight: FontWeight.w500,),),
                            ),

                          ],
                        ),
                      ),
                      Divider(
                        thickness: 8,
                        color: Color(0xffEBEBEB),
                      ),

                      SizedBox(height: 10,),
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
                            Navigator.pushReplacement(context, SlideLeftRoute(page: AllCommentsPage(userKey:userKey,visitorCount:snapshot.data.VisitorCount.toString() )));
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
                                  Navigator.pushReplacement(context, SlideLeftRoute(page: SendCommentPage(userKey:userKey)));
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
                                  Navigator.pushReplacement(context, SlideLeftRoute(page: AllCommentsPage(userKey:userKey, visitorCount:snapshot.data.VisitorCount.toString())));
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
                            Navigator.pushReplacement(context, SlideLeftRoute(page: SendCommentPage(userKey:userKey)));
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
                    if(_petLenght == "1"){

                      String petId = "$_onePet,";
                      String onePet = petId;

                      String _vetId = userKey;
                      String _token = token;

                      print("_petLenght == 1 onePet : $onePet");
                      print("_petLenght == 1 _vetId : $_vetId");
                      print("_petLenght == 1 _token : $_token");

                      Navigator.push(context, SlideLeftRoute(page: SelectClinicPage(vetId:_vetId,checkPet: onePet, token:_token)));
                    }
                    if(_petLenght != "1" && _petLenght != "0"){

                      String _vetId = userKey;
                      String _token = token;

                      print("_petLenght == 1 _vetId : $_vetId");
                      print("_petLenght == 1 _token : $_token");
                      Navigator.push(context, SlideLeftRoute(page: SelectPetPage(vetId:_vetId, token:_token)));
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