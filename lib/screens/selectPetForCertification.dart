import 'dart:convert';
import 'dart:io';
import 'package:flutter/widgets.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vetplanet/constant/colors.dart';
import 'package:vetplanet/models/pet_model.dart';
import 'package:vetplanet/screens/vetDetails.dart';
import 'package:vetplanet/transitions/slide_route.dart';
import 'certificates.dart';
import 'dash.dart';
import 'drawer.dart';
import 'nextVaccinationList.dart';
import 'nextVaccinationListFromDrawer.dart';


class SelectPetForCertificationPage extends StatefulWidget {
  final Function onPressed;
  final String vetId;
  final String from;

  SelectPetForCertificationPage({ this.onPressed, this.vetId, this.from });
  @override
  _SelectPetForCertificationPageState createState() => _SelectPetForCertificationPageState();
}

class _SelectPetForCertificationPageState extends State<SelectPetForCertificationPage> {

  void rebuildPage() {
    setState(() {});
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

      body: WillPopScope(
        onWillPop: (){
          //on Back button press, you can use WillPopScope for another purpose also.
          // Navigator.pop(context); //return data along with pop
          Navigator.of(context)
              .pushReplacement(new MaterialPageRoute(builder: (context) => VetDetails(onPressed: rebuildPage , userKey:widget.vetId)));
          return new Future(() => false); //onWillPop is Future<bool> so return false
        },
        child: Column(
          children: <Widget>[
            if(_petLenght != "0")
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
                      return Column(
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: InkWell(
                              onTap: (){
                                String patientPetId = "${_pet[index].PatientPetId}";
                                String vetId = widget.vetId;
                                print("patientPetId : $patientPetId");

                                if(widget.from == "vetDetails"){
                                  Navigator.push(context, SlideLeftRoute(page: CertificatesPage(petId:patientPetId, vetId:vetId)));
                                }


                              },
                              child:Padding(
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
                                          " Age : ${_pet[index].Age} years/months",
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
                return Center(child: SpinKitRotatingCircle(
                  color: appColor,
                  size: 50.0,
                ));
              },
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


    );
  }
}
