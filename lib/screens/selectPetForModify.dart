import 'dart:convert';
import 'dart:io';
import 'package:flutter/widgets.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vetplanet/constant/colors.dart';
import 'package:vetplanet/models/pet_model.dart';
import 'package:vetplanet/models/result_model.dart';
import 'package:vetplanet/screens/bookAppointment.dart';
import 'package:vetplanet/screens/petModify.dart';
import 'package:vetplanet/screens/petRegistration.dart';
import 'package:vetplanet/screens/selectClinic.dart';
import 'package:vetplanet/transitions/slide_route.dart';
import 'dash.dart';
import 'drawer.dart';

class SelectPetForModifyPage extends StatefulWidget {
  final Function onPressed;

  SelectPetForModifyPage({ this.onPressed });
  @override
  _SelectPetForModifyPageState createState() => _SelectPetForModifyPageState();
}

class _SelectPetForModifyPageState extends State<SelectPetForModifyPage> {

  void rebuildPage() {
    setState(() {});
  }


  Future<List> _future;
  String _petLenght = "";
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

      });
      return _pet;

    } else {
      debugPrint('Check 6');
      return [];
    }
  }


  ResultModel _deletePetResult;

  Future<ResultModel> deletePet(String patientPetId ) async{
    final _prefs = await SharedPreferences.getInstance();
    String _API_Path = _prefs.getString('API_Path');
    String _RegistrationId = _prefs.getInt('id').toString();

    debugPrint('Check Inserted _API_Path $_API_Path');
    debugPrint('Check Inserted _RegistrationId $_RegistrationId');

    final String apiUrl =  "$_API_Path/DeletePet/DeletePet";

    debugPrint('Check Inserted 1 ');

    var response = await http.post(
      Uri.parse(apiUrl),
      headers: {HttpHeaders.contentTypeHeader: 'application/json', HttpHeaders.authorizationHeader: 'bearer VA5kBnSw50cbuJ4YoAVkl4XyFTA312fRtKF4GxlmkUcl3PQJBKvvtogvT_0syd6ZtsZ4-1zFK6_liq5dQpyMq2tOA7vCtZ332qal7LGyBxBvv4mtD461lwGhNtprYd8PyIR40bBsoBc7nMElIniHJXAu1V04eO5c7sNLHOGypeG70Zn06yQr-0i_eFbsCRg6kMWjkao3RZwDfXVra5JQ5I7Pr1CbSgYez6rbYLMbH2LL6K8VcpmUvs45WpLe4UjPpChygW96LCoxVh7YtNa74n1Bje4sDdGLZowZJWwe7F9P7ijy1nVyw_v5K-8MqzlI' },
      body: json.encode(
          {
            "PatientPetId":patientPetId
          }

      ),
    );

/*
    final response = await http.post(apiUrl, body:
    {
      "VisitorId": visitorId,
      "SlotId":SlotId
    }

    );*/
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


  Future<String> delete(String patientPetId) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Container(
              color: appColor,
              child: Padding(
                padding: const EdgeInsets.only(left:1, right:1, top:12, bottom:12),
                child: Text('Vet Planet',style: TextStyle(fontFamily: "Camphor",
                    fontWeight: FontWeight.w900,fontSize: 18, color: Colors.white),textAlign:TextAlign.center ,),
              ),
            ),
            content: Text('Do you want to remove the Pet?',style: TextStyle(fontFamily: "Camphor",
                fontWeight: FontWeight.w500,fontSize: 16),),
            actions: <Widget>[
              TextButton(
                  //color: Colors.red,
                  child: Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: Text('Yes',style: TextStyle(color: appColor,fontSize: 16,  fontFamily: "Camphor",
                      fontWeight: FontWeight.w900,),),
                  ),
                  onPressed: () async{
                    final ResultModel deletePetResult = await deletePet(patientPetId );
                    debugPrint('Check Inserted result : $deletePetResult');
                    setState(() {
                      _deletePetResult = deletePetResult;
                    });


                    if(_deletePetResult.Result == "Deleted"){
                      // Navigator.push(context, MaterialPageRoute(builder: (context) => DashPage()));
                      _future = getPet();
                      Navigator.pop(context);
                      final snackBar = SnackBar(
                          content: Text("Pet Deleted Successfully ",style: TextStyle(fontFamily: "Camphor",
                            fontWeight: FontWeight.w500,),)
                      );
                      ScaffoldMessenger.of(context).showSnackBar(snackBar);
                    }
                    else {
                      final snackBar = SnackBar(
                          content:  Text("Not Deleted",style: TextStyle(fontFamily: "Camphor",
                            fontWeight: FontWeight.w500,),)
                      );
                      ScaffoldMessenger.of(context).showSnackBar(snackBar);
                    }
                  }

              ),
              TextButton(
                //color: Colors.green,
                child: Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: Text('No',style: TextStyle(color: appColor,fontSize: 16, fontFamily: "Camphor",
                    fontWeight: FontWeight.w900,),),
                ),
                onPressed: () {
                  _future = getPet();
                  Navigator.pop(context);
                },
              ),

            ],
          );
        });
  }

  @override
  void initState() {
    _future = getPet();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
        FittedBox(
          fit:BoxFit.fitWidth,
          child: Text("", style: TextStyle(fontSize:22, fontFamily: "Camphor",
              fontWeight: FontWeight.w900,color: Colors.white),),
        ),
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

      body: WillPopScope(
        onWillPop: (){
          //on Back button press, you can use WillPopScope for another purpose also.
          // Navigator.pop(context); //return data along with pop
          Navigator.of(context)
              .pushReplacement(new MaterialPageRoute(builder: (context) => DashPage(onPressed: rebuildPage)));
          return new Future(() => false); //onWillPop is Future<bool> so return false
        },
        child: Column(
          children: <Widget>[
            if(_petLenght != "0")
            Expanded(
              child: FutureBuilder(
                future: _future,
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return Center(child: Text(''));
                  }
                  if (snapshot.hasData) {
                    List<PetModel> _pet = snapshot.data;
                    return ListView.builder(
                      shrinkWrap: true,
                      itemCount: _pet == null ? 0 : _pet.length,
                      itemBuilder: (BuildContext context, int index) {
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: InkWell(
                            onTap: (){
                              String patientPetId = "${_pet[index].PatientPetId}";
                              String petName = "${_pet[index].PetName}";
                              String dob = "${_pet[index].DOB}";
                              String age = "${_pet[index].Age}";
                              String speciesId = "${_pet[index].SpeciesId}";
                              String breedId = "${_pet[index].BreedId}";
                              String gender = "${_pet[index].Gender}";
                              String color = "${_pet[index].Color}";

                              print("patientPetId : $patientPetId");
                              print("petName : $petName");
                              print("dob : $dob");
                              print("age : $age");
                              print("speciesId : $speciesId");
                              print("breedId : $breedId");
                              print("gender : $gender");
                              print("color : $color");

                              Navigator.push(context, SlideLeftRoute(page: PetModify(patientPetId:patientPetId, petName:petName, dob: dob, age:age, speciesId:speciesId, breedId:breedId, gender:gender, color:color)));

                            },
                            child: Card(
                              elevation: 2,
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      children: <Widget>[

                                        ClipRRect(
                                          borderRadius: BorderRadius.circular(50),
                                          child: Image.network(
                                            "${_pet[index].Photograph}",
                                            width: 50,
                                            height: 50,
                                            fit: BoxFit.fill,
                                          ),
                                        ),
                                        SizedBox(width: 20,),
                                        Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          children: <Widget>[
                                            Text(
                                              " ${_pet[index].PetName}",
                                              style: TextStyle(
                                                color: Colors.black, fontSize: 16,fontFamily: "Camphor",
                                                fontWeight: FontWeight.w700,),
                                            ),
                                            Text(
                                              " ${_pet[index].SpeciesName} - ${_pet[index].BreedName}",
                                              style: TextStyle(
                                                color: Colors.black, fontSize: 16,fontFamily: "Camphor",
                                                fontWeight: FontWeight.w700,),
                                            ),
                                            Text(
                                              " ${_pet[index].Gender}",
                                              style: TextStyle(
                                                color: Colors.black, fontSize: 16,fontFamily: "Camphor",
                                                fontWeight: FontWeight.w700,),
                                            ),
                                            Text(
                                              " Age : ${_pet[index].Age} years/months",
                                              style: TextStyle(
                                                color: Colors.black, fontSize: 16,fontFamily: "Camphor",
                                                fontWeight: FontWeight.w700,),
                                            ),
                                          ],
                                        ),

                                        Divider(
                                          height: 1,
                                          thickness: 0.5,
                                          color: Colors.grey,
                                        ),
                                      ],
                                    ),
                                    Align(
                                      alignment: Alignment.topRight,
                                      child: IconButton(
                                          icon: Icon(Icons.delete),
                                          iconSize: 28,
                                          color: appColor,
                                          onPressed: (){
                                            String patientPetId = "${_pet[index].PatientPetId}";
                                            delete(patientPetId);
                                          }
                                      ),
                                    ),
                                  ],
                                ),
                              ),
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
            if(_petLenght == "0")
            Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Center(child: Align(
                    child: Text("No Pet Added", style: TextStyle(fontSize: 25, color: Colors.red,fontFamily: "Camphor",
                      fontWeight: FontWeight.w900,),),
                  )),
                ],
              ),
          ],
        ),
      ),

      floatingActionButton: InkWell(
        onTap: (){
          Navigator.pushReplacement(context, SlideLeftRoute(page: PetRegistration()));
        },
        child: new FloatingActionButton(backgroundColor: appColor,
          child: const Icon(Icons.add,color:Colors.white,),
        ),
      ),
      floatingActionButtonLocation:
      FloatingActionButtonLocation.centerFloat,


    );
  }
}
