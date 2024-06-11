import 'dart:convert';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:path/path.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:vetplanet/constant/colors.dart';
import 'package:vetplanet/models/breed_model.dart';
import 'package:vetplanet/models/pet_model.dart';
import 'package:vetplanet/models/result_model.dart';
import 'package:vetplanet/models/species_model.dart';
import 'package:vetplanet/screens/selectPetForModify.dart';
import 'package:vetplanet/transitions/slide_route.dart';

import 'dash.dart';


class PetModify extends StatefulWidget {

  final String patientPetId;
  final String petName;
  final String dob;
  final String age;
  final String speciesId;
  final String breedId;
  final String gender;
  final String color;

  PetModify({ this.patientPetId, this.petName, this.dob, this.age, this.speciesId, this.breedId, this.gender, this.color});

  @override
  _PetModifyState createState() => _PetModifyState();
}

class _PetModifyState extends State<PetModify> {

  bool _isInAsyncCall = false;

  final GlobalKey<FormState> _formStateKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  // _displaySnackBar(BuildContext context) {
  //   final snackBar = SnackBar(
  //       content: Text('Pet Already Exists', style: TextStyle(fontSize: 20),));
  //   _scaffoldKey.currentState.showSnackBar(snackBar);
  // }
  String valueOnChangedSpecies;
  String _petName = "";
  String _dob = "Select DOB";
  String _age = "";
  String _species = "";
  String _breed = "";
  String _color = "";
  String _gender = "Male";
  String _photograph;
  XFile selectedPhotograph;
  Response responsePhotograph;
  String progressPhotograph;
  Dio dioPhotograph = new Dio();
  final ImagePicker _picker = ImagePicker();

  _photoFromCamera() async {
    setState(() {
      _photograph = null;
    });
    selectedPhotograph = await  _picker.pickImage(
        source: ImageSource.camera, imageQuality: 50
    );

    String now = DateFormat("yyyy-MM-dd hh:mm:ss").format(DateTime.now());
    print ("now ****************************************************** $now");
    String _fileName = "${now}_${basename(selectedPhotograph.path)}";
    print ("selectedPhotograph filename ****************************************************** $_fileName");
    String result1 = _fileName.replaceAll('-', '_');
    String result2 = result1.replaceAll(' ', '_');
    String finalFileName = result2.replaceAll(':', '_');
    print ("selectedPhotograph finalFileName ****************************************************** $finalFileName");
    setState(() {
      _photograph = finalFileName;
      // _photograph = basename(selectedPhotograph.path);
      uploadPhotograph();
    }); //update the UI so that file name is shown


  }

  _photoFromGallery() async {
    setState(() {
      _photograph = null;
    });
    selectedPhotograph = await  _picker.pickImage(
        source: ImageSource.gallery, imageQuality: 50
    );

    String now = DateFormat("yyyy-MM-dd hh:mm:ss").format(DateTime.now());
    print ("now ****************************************************** $now");
    String _fileName = "${now}_${basename(selectedPhotograph.path)}";
    print ("selectedPhotograph filename ****************************************************** $_fileName");
    String result1 = _fileName.replaceAll('-', '_');
    String result2 = result1.replaceAll(' ', '_');
    String finalFileName = result2.replaceAll(':', '_');
    print ("selectedPhotograph finalFileName ****************************************************** $finalFileName");
    setState(() {
      _photograph = finalFileName;
      // _photograph = basename(selectedPhotograph.path);
      uploadPhotograph();
    }); //update the UI so that file name is shown

  }

  uploadPhotograph() async {
    final _prefs = await SharedPreferences.getInstance();
    
    debugPrint('Check Inserted apiUrl $apiUrl ');

    String now = DateFormat("yyyy-MM-dd hh:mm:ss").format(DateTime.now());
    print ("now ****************************************************** $now");
    String _fileName = "${now}_${basename(selectedPhotograph.path)}";
    print ("uploadPhotograph filename ****************************************************** $_fileName");
    String result1 = _fileName.replaceAll('-', '_');
    String result2 = result1.replaceAll(' ', '_');
    String finalFileName = result2.replaceAll(':', '_');
    print ("uploadPhotograph finalFileName ****************************************************** $finalFileName");



    final String uploadurl = "http://sofistsolutions.in/VetPlanetAPPAPI/API/UploadPetProfile/UploadPetProfile";


    FormData formdata = FormData.fromMap({
      "file": await MultipartFile.fromFile(selectedPhotograph.path, filename: finalFileName
        //show only filename from path
      ),
    });

    responsePhotograph = await dioPhotograph.post(
      uploadurl,
      data: formdata,
      options: Options(headers: <String, dynamic>{HttpHeaders.contentTypeHeader: 'application/json', HttpHeaders.authorizationHeader: bearerToken}),
      onSendProgress: (int sent, int total) {
        String percentagePanCard = (sent / total * 100).toStringAsFixed(2);
        progressPhotograph = percentagePanCard + " % uploaded";
        /*  setState(() {
          // progress = "$sent" + " Bytes of " "$total Bytes - " +  percentage + " % uploaded";
          progressPic =   percentagePic + " % uploaded";
          //update the progress
        });*/
      },
    );

    if (responsePhotograph.statusCode == 200) {
      print(responsePhotograph.toString());
      //print response from server
    } else {
      print("Error during connection to server.");
    }
  }

  void _photoPicker(context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return SafeArea(
            child: Container(
              child: new Wrap(
                children: <Widget>[
                  new ListTile(
                      leading: new Icon(Icons.photo_library),
                      title: new Text('Photo Library'),
                      onTap: () {
                        _photoFromGallery();
                        Navigator.of(context).pop();
                      }),
                  new ListTile(
                    leading: new Icon(Icons.photo_camera),
                    title: new Text('Camera'),
                    onTap: () {
                      _photoFromCamera();
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ),
            ),
          );
        }
    );
  }

  String _speciesController;

  bool showList = false;

  List speciesListData = List(); //edited line

  Future<SpeciesModel> getSpecies() async{

    //final _prefs = await SharedPreferences.getInstance();
   // 
   // debugPrint('Check Inserted apiUrl $apiUrl ');


    final String url = "http://sofistsolutions.in/VetPlanetAPPAPI/API/GetSpecies/GetSpecies";

   // final response = await http.post(apiUrl);
    var response = await http.post(
      Uri.parse(url),
      headers: {HttpHeaders.contentTypeHeader: 'application/json', HttpHeaders.authorizationHeader: bearerToken },
    );
    if(response.statusCode == 200){
      final String responseString = response.body;
      this.setState(() {
        speciesListData = json.decode(response.body);

        if (widget.speciesId !=  null) {
          _speciesController = widget.speciesId;
          _species = _speciesController;
          getBreed(_species);
          _dob = widget.dob;
          _gender = widget.gender;
        }
      });
      return speciesModelFromJson(responseString);
    }else{
      return null;
    }
  }


  String _breedController;

  List breedListData = List(); //edited line

  Future<BreedResultModel> getBreed(String speciesId) async{

    debugPrint('Check getBreed speciesId $speciesId ');

    final String url = "http://sofistsolutions.in/VetPlanetAPPAPI/API/GetBreedBySpecies/GetBreedBySpecies";
    debugPrint('Check getBreed 1 ');

    var response = await http.post(
      Uri.parse(url),
      headers: {HttpHeaders.contentTypeHeader: 'application/json', HttpHeaders.authorizationHeader: bearerToken },
      body: json.encode(
          {
            "speciesId":speciesId
          }
      ),
    );
    debugPrint('Check getBreed 2 ');
    debugPrint('Check getBreed statusCode : ${response.statusCode} ');
    if(response.statusCode == 200){
      final String responseString = response.body;
      debugPrint('Check getBreed 3 ');
      this.setState(() {
        breedListData = json.decode(response.body);

        if (widget.breedId !=  null && valueOnChangedSpecies == "") {
          _breedController = widget.breedId;
          _breed = _breedController;
        }
        if (widget.breedId !=  null  && valueOnChangedSpecies == "onChangeEventSpecies") {
          breedListData = json.decode(response.body);
        }
      });
      debugPrint('Check getBreed 4 ');

      return breedResultModelFromJson(responseString);
    }else{
      debugPrint('Check getBreed 5 ');

      return null;
    }
  }


  ResultModel _result;

  Future<ResultModel> modifyPet(String petName, String dob, String age, String species, String breed, String color, String gender, String photograph ) async{debugPrint('Check Inserted 1 ');
    final _prefs = await SharedPreferences.getInstance();
    
    debugPrint('Check Inserted apiUrl $apiUrl');

    final String url =  "$apiUrl/ModifyPet/ModifyPet";
     String id = _prefs.getInt('id').toString();
     debugPrint('Check Inserted id $id ');
    debugPrint('Check Inserted dob $dob ');
    var response = await http.post(
      Uri.parse(url),
      headers: {HttpHeaders.contentTypeHeader: 'application/json', HttpHeaders.authorizationHeader: bearerToken },
      body: json.encode(
          {
            "PatientPetId":widget.patientPetId,
            "PatientId":id,
            "PetName":petName,
            "DOB":dob,
            "Age":age,
            "Weight":"-",
            "SpeciesId":species,
            "BreedId":breed,
            "Gender":gender,
            "Color":color,
            "Photograph":photograph
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


  Future<List> _future;

  String _petLenght = "";

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

      });
      return _pet;

    } else {
      debugPrint('Check 6');
      return [];
    }
  }







  @override
  void initState() {
    super.initState();
    valueOnChangedSpecies = "";
    _future = getPet();
    this.getSpecies();
  }


  void rebuildPage() {
    setState(() {});
  }
  DateTime when = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: appColor,
      body: ModalProgressHUD(
        inAsyncCall: _isInAsyncCall,
        // demo of some additional parameters
        opacity: 0.5,
        progressIndicator: CircularProgressIndicator(),
        child: WillPopScope(
          onWillPop: (){
            //on Back button press, you can use WillPopScope for another purpose also.
            // Navigator.pop(context); //return data along with pop
            Navigator.push(context, SlideLeftRoute(page: SelectPetForModifyPage(onPressed: rebuildPage)));
          // Navigator.of(context)
              //  .pushReplacement(new MaterialPageRoute(builder: (context) => DashPage(onPressed: rebuildPage)));
            return new Future(() => false); //onWillPop is Future<bool> so return false
          },
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min, // Use children total size
              children: [
                Container(
                  child: Form(
                    key: _formStateKey,
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      children: <Widget>[
                        Container(
                          child: Padding(
                            padding: const EdgeInsets.only(right:20, left:20),
                            child: Column(
                              children: <Widget>[
                                SizedBox(
                                  height: 20,
                                ),
                                InkWell(
                                  onTap: (){
                                    Navigator.push(context, SlideLeftRoute(page: DashPage()));                                },
                                  child: Align(
                                    alignment: Alignment.topRight,
                                    child: FittedBox(
                                      fit: BoxFit.fitWidth,
                                      child: Padding(
                                        padding: EdgeInsets.only(top: 20),
                                        child: Container(
                                          child: Align(
                                            alignment: Alignment.center,
                                            child:  Card(
                                              color: Colors.white,
                                              child: Padding(
                                                padding: const EdgeInsets.all(8.0),
                                                child: FittedBox(
                                                  fit:BoxFit.fitWidth,
                                                  child: Text(
                                                    "Skip",
                                                    style: TextStyle(fontFamily: "Camphor",
                                                        fontWeight: FontWeight.w900, fontSize: 16,color: appColor),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),

                                SizedBox(
                                  height: 20,
                                ),

                                Align(
                                  alignment: Alignment.topLeft,
                                  child:  Text(
                                    "Pet Registration",
                                    style: TextStyle(
                                      //decoration: TextDecoration.underline,
                                      color: Colors.white,
                                      fontFamily: "Camphor",
                                      fontWeight: FontWeight.w900,
                                      fontSize: 25,
                                    ),

                                  ),
                                ),

                                SizedBox(
                                  height: 30,
                                ),



                                Container(
                                  margin: EdgeInsets.symmetric(vertical: 5),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: <Widget>[
                                      FittedBox(
                                        fit:BoxFit.fitWidth,
                                        child: Text(
                                          "Pet Name",
                                          style: TextStyle(fontFamily: "Camphor",
                                              fontWeight: FontWeight.w900, fontSize: 16,color: Colors.white),
                                        ),
                                      ),

                                      TextFormField(
                                        initialValue: widget.petName,
                                        onSaved: (value) {
                                          _petName = value;
                                        },
                                        keyboardType: TextInputType.text,
                                        showCursor: true,
                                        decoration: InputDecoration(
                                          enabledBorder: UnderlineInputBorder(
                                            borderSide: BorderSide(color: Colors.white),
                                          ),
                                          focusedBorder: UnderlineInputBorder(
                                            borderSide: BorderSide(color: Colors.white),
                                          ),
                                        ),
                                        validator: (value) {
                                          if (value.isEmpty) {
                                            return 'Please Enter Pet Name';
                                          }
                                          return null;
                                        },
                                        style: TextStyle(fontFamily: "Camphor",
                                            fontWeight: FontWeight.w500,
                                            color: Colors.white,
                                            fontSize: 16),
                                      ),
                                    ],
                                  ),
                                ),




                                SizedBox(
                                  height: 15,
                                ),

                                Container(
                                  margin: EdgeInsets.symmetric(vertical: 5),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: <Widget>[
                                      FittedBox(
                                        fit:BoxFit.fitWidth,
                                        child: Text(
                                          "Date of Birth",
                                          style: TextStyle(fontFamily: "Camphor",
                                              fontWeight: FontWeight.w900, fontSize: 16,color: Colors.white),
                                        ),
                                      ),
                                      SizedBox(height: 15,),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: <Widget>[

                                          Text(_dob,  style: TextStyle(fontFamily: "Camphor",
                                              fontWeight: FontWeight.w500,
                                              color: Colors.white,
                                              fontSize: 16),),
                                          SizedBox(width: 25),
                                          InkWell(
                                            onTap: () async{
                                              DateTime picked = await showDatePicker(
                                                context: context,
                                                initialDate: when,
                                                firstDate:  DateTime(2000),
                                                lastDate: DateTime(3000),
                                              );
                                              if(picked == null){
                                                setState(() {
                                                  when = DateTime.now();
                                                });
                                                // Navigator.of(context)
                                                //   .pushReplacement(new MaterialPageRoute(builder: (context) => FamilyDetailsListPage(onPressed: rebuildPage, regId: widget.registerationId,)));
                                              }
                                              else{
                                                setState(() {
                                                  when = picked;
                                                  String selectedDate = DateFormat("dd/MM/yyyy").format(when);
                                                  _dob = selectedDate;
                                                  print("dob: $_dob");
                                                });
                                              }
                                            },
                                            child: Icon(
                                              Icons.calendar_today,
                                              color: Colors.white,
                                              size: 16,
                                            ),
                                          ),

                                        ],
                                      ),
                                    ],
                                  ),
                                ),

                                SizedBox(
                                  height: 15,
                                ),

                                Container(
                                  margin: EdgeInsets.symmetric(vertical: 5),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: <Widget>[
                                      FittedBox(
                                        fit:BoxFit.fitWidth,
                                        child: Text(
                                          "Age",
                                          style: TextStyle(fontFamily: "Camphor",
                                              fontWeight: FontWeight.w900, fontSize: 16,color: Colors.white),
                                        ),
                                      ),

                                      TextFormField(
                                        initialValue: widget.age,
                                        onSaved: (value) {
                                          _age = value;
                                        },

                                        keyboardType: TextInputType.text,
                                        showCursor: true,
                                        decoration: InputDecoration(
                                          enabledBorder: UnderlineInputBorder(
                                            borderSide: BorderSide(color: Colors.white),
                                          ),
                                          focusedBorder: UnderlineInputBorder(
                                            borderSide: BorderSide(color: Colors.white),
                                          ),
                                        ),
                                        validator: (value) {
                                          if (value.isEmpty) {
                                            return 'Please Enter Age';
                                          }
                                          /* else if (value.length !=10){
                                              return 'Mobile Number must be of 10 digit';
                                            }*/
                                          return null;
                                        },
                                        style: TextStyle(fontFamily: "Camphor",
                                            fontWeight: FontWeight.w500,
                                            color: Colors.white,
                                            fontSize: 16),
                                      ),
                                    ],
                                  ),
                                ),


                                SizedBox(
                                  height: 15,
                                ),

                                Container(
                                  margin: EdgeInsets.symmetric(vertical: 5),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: <Widget>[
                                      FittedBox(
                                        fit:BoxFit.fitWidth,
                                        child: Text(
                                          "Species",
                                          style: TextStyle(fontFamily: "Camphor",
                                              fontWeight: FontWeight.w900, fontSize: 16,color: Colors.white),
                                        ),
                                      ),

                                      Theme(
                                        data: Theme.of(context).copyWith(
                                          canvasColor: Color(0xff7c4f5f),
                                        ),
                                        child: DropdownButtonFormField(
                                          value: _speciesController,
                                          decoration: const InputDecoration(
                                            enabledBorder: UnderlineInputBorder(
                                              borderSide: BorderSide(color: Colors.white),
                                            ),
                                            focusedBorder: UnderlineInputBorder(
                                              borderSide: BorderSide(color: Colors.white),
                                            ),
                                            hintText: "",
                                            hintStyle: TextStyle(
                                              color: Color(0xFF666666),
                                              fontFamily: "Camphor",
                                              fontWeight: FontWeight.w500,
                                              fontSize: 16,
                                            ),
                                          ),
                                          onChanged: (newVal) {
                                            FocusScope.of(context).requestFocus(new FocusNode());///It
                                            setState(() {
                                              valueOnChangedSpecies = "onChangeEventSpecies";
                                              _breedController = null;
                                              _speciesController = newVal;
                                              _species = _speciesController;
                                              getBreed(_species);
                                            });
                                          },
                                          validator: (value) => value == null ? 'Select Species' : null,
                                          items: speciesListData.map((item) {
                                            return new DropdownMenuItem(
                                              child: new Text(item['SpeciesName']),
                                              value: item['speciesId'].toString(),);
                                          }).toList(),
                                          style: TextStyle(fontFamily: "Camphor", fontWeight: FontWeight.w500,fontSize: 16,color: Colors.white),
                                        ),
                                      ),

                                    ],
                                  ),
                                ),



                                SizedBox(
                                  height: 15,
                                ),


                                Container(
                                  margin: EdgeInsets.symmetric(vertical: 5),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: <Widget>[
                                      FittedBox(
                                        fit:BoxFit.fitWidth,
                                        child: Text(
                                          "Breed",
                                          style: TextStyle(fontFamily: "Camphor",
                                              fontWeight: FontWeight.w900, fontSize: 16,color: Colors.white),
                                        ),
                                      ),

                                      Theme(
                                        data: Theme.of(context).copyWith(
                                          canvasColor: Color(0xff7c4f5f),
                                        ),
                                        child: DropdownButtonFormField(
                                          value: _breedController,
                                          decoration: const InputDecoration(
                                            enabledBorder: UnderlineInputBorder(
                                              borderSide: BorderSide(color: Colors.white),
                                            ),
                                            focusedBorder: UnderlineInputBorder(
                                              borderSide: BorderSide(color: Colors.white),
                                            ),
                                            hintText: "",
                                            hintStyle: TextStyle(
                                              color: Color(0xFF666666),
                                              fontFamily: "Camphor",
                                              fontWeight: FontWeight.w500,
                                              fontSize: 16,
                                            ),
                                          ),
                                          onChanged: (newVal) {
                                            FocusScope.of(context).requestFocus(new FocusNode());///It
                                            setState(() {
                                              _breedController = newVal;
                                              _breed = _breedController;
                                            });
                                          },
                                          validator: (value) => value == null ? 'Select Breed' : null,
                                          items: breedListData.map((item) {
                                            return new DropdownMenuItem(
                                              child: new Text(item['BreedName']),
                                              value: item['BreedId'].toString(),
                                            );
                                          }).toList(),
                                          style: TextStyle(fontFamily: "Camphor",
                                              fontWeight: FontWeight.w500,fontSize: 16,color: Colors.white),
                                        ),
                                      ),

                                    ],
                                  ),
                                ),

                                SizedBox(
                                  height: 15,
                                ),

                                Container(
                                  margin: EdgeInsets.symmetric(vertical: 5),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: <Widget>[
                                      FittedBox(
                                        fit:BoxFit.fitWidth,
                                        child: Text(
                                          "Color",
                                          style: TextStyle(fontFamily: "Camphor",
                                              fontWeight: FontWeight.w900, fontSize: 16,color: Colors.white),
                                        ),
                                      ),

                                      TextFormField(
                                        initialValue: widget.color,
                                        onSaved: (value) {
                                          _color = value;
                                        },
                                        keyboardType: TextInputType.text,
                                        showCursor: true,
                                        decoration: InputDecoration(
                                          enabledBorder: UnderlineInputBorder(
                                            borderSide: BorderSide(color: Colors.white),
                                          ),
                                          focusedBorder: UnderlineInputBorder(
                                            borderSide: BorderSide(color: Colors.white),
                                          ),
                                        ),
                                        style: TextStyle(fontFamily: "Camphor",
                                            fontWeight: FontWeight.w500,
                                            color: Colors.white,
                                            fontSize: 16),
                                      ),
                                    ],
                                  ),
                                ),


                                SizedBox(
                                  height: 15,
                                ),

                                Container(
                                  margin: EdgeInsets.symmetric(vertical: 5),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: <Widget>[
                                      FittedBox(
                                        fit:BoxFit.fitWidth,
                                        child: Text(
                                          "Gender",
                                          style: TextStyle(fontFamily: "Camphor",
                                              fontWeight: FontWeight.w900, fontSize: 16,color: Colors.white),
                                        ),
                                      ),

                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        children: <Widget>[


                                          Radio(
                                            groupValue: _gender,
                                            value: 'Male',activeColor: Colors.white,
                                            onChanged: (val) {
                                              setState(() {
                                                _gender = val;

                                              });
                                            },
                                          ),
                                          Text(
                                            'Male',
                                            style: TextStyle(fontFamily: "Camphor",
                                                fontWeight: FontWeight.w900, fontSize: 16,color: Colors.white),
                                          ),


                                          SizedBox(
                                            width: 5,
                                          ),

                                          Radio(
                                            groupValue: _gender,
                                            value: 'Female',activeColor: Colors.white,
                                            onChanged: (val) {
                                              setState(() {
                                                _gender = val;
                                              });
                                            },
                                          ),
                                          Text(
                                            'Female',
                                            style: TextStyle(fontFamily: "Camphor",
                                                fontWeight: FontWeight.w900, fontSize: 16,color: Colors.white),
                                          ),


                                        ],
                                      ),
                                    ],
                                  ),
                                ),

                                SizedBox(
                                  height: 15,
                                ),


                                Column(
                                  children: <Widget>[
                                    Container(
                                      margin: EdgeInsets.all(2),
                                      //show file name here
                                      child: _photograph == null
                                          ? Text("")
                                          : Card(
                                          elevation: 2,
                                          child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Text(_photograph, style: TextStyle(fontFamily: "Camphor",
                                              fontWeight: FontWeight.w500,),),
                                          )),
                                      //basename is from path package, to get filename from path
                                      //check if file is selected, if yes then show file name
                                    ),
                                    Container(
                                        child: ElevatedButton.icon(
                                          onPressed: () {
                                            _photograph= null;
                                            //  widget.user.documenct = basename(selectedPic.path);
                                            //selectPhotograph();
                                            _photoPicker(context);
                                          },
                                          icon: Icon(Icons.folder_open, color: appColor),
                                          label: FittedBox(
                                              fit:BoxFit.fitWidth,child: Text("Upload Photograph", style: TextStyle(fontFamily: "Camphor",
                                            fontWeight: FontWeight.w900,color: appColor),)),
                                          // color: Colors.white,
                                          // colorBrightness: Brightness.dark,
                                        )),

                                    //if selectedfile is null then show empty container
                                    //if file is selected then show upload button
                                  ],
                                ),
                                SizedBox(
                                  height: 20,
                                ),

                                Align(
                                  alignment: Alignment.center,
                                  child:
                                  InkWell(
                                    onTap: () async {
                                      if (_formStateKey.currentState.validate()) {
                                        _formStateKey.currentState.save();

                                        setState(() {
                                                  _isInAsyncCall = true;
                                                });
                                        String photograph;
                                        if(_photograph == null){
                                         photograph = "-";
                                        }
                                        else if(_photograph != null){
                                          photograph = _photograph;
                                        }

                                        String color;
                                        if(_color == ""){
                                          color = "-";
                                        }
                                        else if(_color != ""){
                                          color = _color;
                                        }

                                        String dob;
                                        if(_dob == "Select DOB"){
                                          dob = "-";
                                        }
                                        else if(_dob != ""){
                                          dob = _dob;
                                        }


                                        final String petName = _petName;
                                        final String age = _age;
                                        final String species = _species;
                                        final String breed = _breed;
                                        final String gender = _gender;


                                        debugPrint('petName : ${petName}' );
                                        debugPrint('dob : ${dob}' );
                                        debugPrint('age : ${age}' );
                                        debugPrint('species : ${species}' );
                                        debugPrint('breed : ${breed}' );
                                        debugPrint('color : ${color}' );
                                        debugPrint('gender : ${gender}' );
                                        debugPrint('photograph : ${photograph}' );

                                        // Navigator.push(context, SlideLeftRoute(page: DashPage()));

                                        final ResultModel result = await modifyPet (petName, dob, age, species, breed, color, gender, photograph);
                                        debugPrint('Check Inserted result : $result');
                                        setState(() {
                                          _result = result;
                                        });

                                        if (_result.Result == "UPDATED" ) {
                                          setState(() {
                                            _isInAsyncCall = false;
                                          });
                                          _future = getPet();

                                          Navigator.pushReplacement(context, SlideLeftRoute(page: SelectPetForModifyPage(onPressed: rebuildPage)));
                                        }
                                        else
                                        {
                                          setState(() {
                                            _isInAsyncCall = false;
                                          });

                                          debugPrint('**');
                                        //  _displaySnackBar(context);
                                        }

                                      }
                                    },
                                    child: Container(
                                      height: 40,
                                      alignment: Alignment.center,
                                      child: Image.asset(
                                        "assets/modifyPet.png",
                                      ),
                                    ),
                                  ),
                                ),

                                SizedBox(
                                  height: 20,
                                ),


                              ],
                            ),
                          ),
                        ),
                     ],
                    ),
                  ),
                ),

              ],
            ),),
        ),
      ),

    );

  }
}

