import 'dart:convert';
import 'dart:io';
import 'package:flutter/widgets.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vetplanet/constant/colors.dart';
import 'package:vetplanet/models/pet_model.dart';
import 'package:vetplanet/screens/bookAppointment.dart';
import 'package:vetplanet/screens/selectClinic.dart';
import 'package:vetplanet/transitions/slide_route.dart';
import 'dash.dart';
import 'drawer.dart';

class SelectPetPage extends StatefulWidget {
  final String vetId;
  final String token;

  SelectPetPage({ this.vetId, this.token });
  @override
  _SelectPetPageState createState() => _SelectPetPageState();
}

class _SelectPetPageState extends State<SelectPetPage> {

  void rebuildPage() {
    setState(() {});
  }
  final _globalKey = GlobalKey<ScaffoldMessengerState>();


  Future<List> _future;
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



  List<PetModel> _resultPet;
  List petListData = List(); //edited line
  Future<PetModel> _resultPetList;
  Future<PetModel> getPets() async {

    print("1 ***");
    final _prefs = await SharedPreferences.getInstance();
    
    String _RegistrationId = _prefs.getInt('id').toString();
    debugPrint('Check Inserted apiUrl $apiUrl ');
    debugPrint('Check Inserted _RegistrationId $_RegistrationId ');


    final String url = "$apiUrl/GetPetList/GetPetList";

    print("2 ***");
    print("vetId *** ${widget.vetId}");
    var response = await http.post(
      Uri.parse(url),
      headers: {HttpHeaders.contentTypeHeader: 'application/json', HttpHeaders.authorizationHeader: bearerToken },
      body: json.encode(
          {
            "PatientId": _RegistrationId
          }
      ),
    );

    print("3 ***");

    print("statusCode *** ${response.statusCode}");
    if(response.statusCode == 200){
      final String responseString = response.body;
      print("responseString *** ${responseString}");

      this.setState(() {
        petListData = json.decode(response.body);
        print("speciesListData *** ${petListData}");

        _resultPet = petListData
            .map<PetModel>(
                (_json) => PetModel.fromJson(_json))
            .toList();
        print("_resultPet *** ${_resultPet}");
        print("_resultPet length*** ${_resultPet.length}");
      });
      return petModelFromJson(responseString);
    }else{
      return null;
    }
  }

  List AnswerResponseListnew = List();
  String patientPetId;
  String petName;

  String checkPet= "";


  @override
  void initState() {
    _future = getPet();
    _resultPetList =  getPets();
    super.initState();
  }


  final _scaffoldKey = GlobalKey<ScaffoldState>();
  _displaySnackBar(BuildContext context) {
    final snackBar = SnackBar(content: Text('Please select atleast one Pet', style: TextStyle(fontSize: 20),));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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

      body:   Column (children: <Widget>[
        Expanded(
          child: FutureBuilder<PetModel>(
              future: _resultPetList,
              builder: (context, snapshot)
              {

                return  ListView.builder(
                  itemCount: _resultPet == null ? 0 : _resultPet.length,
                  itemBuilder: (BuildContext context, int index){

                    return
                      Column(
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: ListTile(
                              trailing: Checkbox(
                                value: _resultPet[index].IsChecked,
                                activeColor: appColorlight,
                                checkColor: Colors.white,
                                onChanged: (val) {
                                  setState(() {
                                    _resultPet[index].IsChecked = val;

                                    patientPetId = _resultPet[index].PatientPetId.toString();
                                    petName =  _resultPet[index].PetName;

                                    print('changed to patientPetId $patientPetId');
                                    print('changed to petName $petName');

                                    var data= AnswerResponseListnew.where((AnswerResponseListnew) => (AnswerResponseListnew[0].contains(_resultPet[index].PatientPetId.toString())));
                                    print("data : $data");

                                    if(_resultPet[index].IsChecked == true){
                                      print("data : true");
                                      AnswerResponseListnew.removeWhere((AnswerResponseListnew) => (AnswerResponseListnew[0].contains(patientPetId)));
                                      AnswerResponseListnew.add([patientPetId,petName]) ;
                                    }
                                    else{
                                      print("data : false");
                                      AnswerResponseListnew.removeWhere((AnswerResponseListnew) => (AnswerResponseListnew[0].contains(patientPetId)));
                                    }

                                  },
                                  );
                                },
                              ),
                              title: Text(_resultPet[index].PetName,style: TextStyle(fontSize:18, fontFamily: "Camphor",
                                  fontWeight: FontWeight.w700,color: Colors.black),),
                              leading:    ClipRRect(
                                borderRadius: BorderRadius.circular(50),
                                child: Image.network(
                                  "${_resultPet[index].Photograph}",
                                  width: 50,
                                  height: 50,
                                  fit: BoxFit.fill,
                                ),
                              ),


                            ),
                          ),
                          Divider(
                            height: 1,
                            thickness: 0.5,
                            color: Colors.grey,
                          ),
                        ],
                      );


                  },
                );


              }
          ),
        ),



      ]),

      bottomNavigationBar: Container(
        margin: EdgeInsets.all(14),
        height: 50,
        width: double.infinity,
        decoration: BoxDecoration(
          ),
        child: ElevatedButton(
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all(appColorlight)
          ),
          onPressed: (){
             checkPet = "";
        // Navigator.push(context, SlideLeftRoute(page: DashPage()));

        print("AnswerResponseList .................................... : $AnswerResponseListnew");
        print("AnswerResponseList Length.................................... : ${AnswerResponseListnew.length}");

        if(AnswerResponseListnew.length == 0){
        _displaySnackBar(context);
        }
        if(AnswerResponseListnew.length != 0){
        for(var i=0; i < AnswerResponseListnew.length; i++) {
          print(
              "AnswerResponseListnew[i] ================================ : ${AnswerResponseListnew[i]} ");

          var AnswerResponse = AnswerResponseListnew;

          print(
              "AnswerResponse*******====******* : ${AnswerResponse}");


          String _petId = AnswerResponseListnew[i][0];
          String _petName = AnswerResponseListnew[i][1];

          print(" STRING serviceId  ============ : ${_petId} ");
          print(" STRING serviceName  ============ : ${_petName} ");

          checkPet = checkPet + _petId  +', ';


          // final String result = await markHODApproval(empAttnCode, hodApprovedValue);

          /*     if(result == "Success")
        {
        _resultEmpAttList =  empAttListData();
        }
        else
        {
        Toast.show("Error", context, duration: Toast.LENGTH_SHORT, gravity: Toast.BOTTOM);
        }
*/
        }

        // SharedPreferences prefs = await SharedPreferences.getInstance();
        //prefs.setString('checkPet', checkPet);

        String _vetId = widget.vetId;
        String _token = widget.token;


        print("  checkServices  ============ : ${checkPet} ");
        print(" widget _vetId  ============ : ${_vetId} ");
        print(" widget _token  ============ : ${_token} ");
        Navigator.push(context, SlideLeftRoute(page: SelectClinicPage(vetId:_vetId, checkPet: checkPet, token:_token)));

        }
          },
          child: Text("Continue",style: TextStyle(color: Colors.white,fontFamily: "Camphor",
              fontWeight: FontWeight.w900, fontSize: 16),),
        ),

      ),



/*
      FutureBuilder(
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
                      String _vetId = widget.vetId;
                      Navigator.push(context, SlideLeftRoute(page: SelectClinicPage(vetId:_vetId)));

                    },
                    child: Card(
                      elevation: 2,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
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
                                  " ${_pet[index].Age} Years old",
                                  style: TextStyle(
                                    color: Colors.black, fontSize: 16,fontFamily: "Camphor",
                                    fontWeight: FontWeight.w700,),
                                ),
                              ],
                            ),

                            Divider(),
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
      ),*/

    );
  }
}
