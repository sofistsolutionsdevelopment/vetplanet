import 'dart:convert';
import 'dart:io';
import 'package:flutter/widgets.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vetplanet/constant/colors.dart';
import 'package:vetplanet/models/groomingServices_model.dart';
import 'package:vetplanet/models/pet_model.dart';
import 'package:vetplanet/screens/bookAppointment.dart';
import 'package:vetplanet/screens/selectClinic.dart';
import 'package:vetplanet/screens/selectGroomingCenter.dart';
import 'package:vetplanet/screens/servicesDialog.dart';
import 'package:vetplanet/transitions/slide_route.dart';
import 'dash.dart';
import 'drawer.dart';
import 'groomingBookAppointment.dart';

class SelectPetForGroomingPage extends StatefulWidget {
  final Function onPressed;
  final String shopId;
  final String groomingId;
  final String token;

  SelectPetForGroomingPage({this.onPressed, this.shopId, this.groomingId, this.token });
  @override
  _SelectPetForGroomingPageState createState() => _SelectPetForGroomingPageState();
}

class _SelectPetForGroomingPageState extends State<SelectPetForGroomingPage> {

  void rebuildPage() {
    setState(() {});
  }
  final _globalKey = GlobalKey<ScaffoldMessengerState>();

  List AnswerResponseListnew = List();
  String patientPetId;
  String petName;
  double amount = 0.0;
  String checkPet= "";
  String serviceSelected= "NoServicesSelected";

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
    print("vetId *** ${widget.groomingId}");
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
        for (var i = 0; i < _resultPet.length; i++) {
          amount = amount + double.parse("${_resultPet[i].TotalServiceRate}");
          if(_resultPet[i].ServiceCount != 0){
            serviceSelected = "ServicesSelected";
          }
        }
        print("_resultPet amount *** ${amount}");

      });
      return petModelFromJson(responseString);
    }else{
      return null;
    }
  }


  @override
  void initState() {
    _resultPetList =  getPets();
    super.initState();
  }


  final _scaffoldKey = GlobalKey<ScaffoldState>();
  _displaySnackBar(BuildContext context) {
    final snackBar = SnackBar(content: Text('Please select atleast one Service for Pet', style: TextStyle(fontSize: 20),));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: (){
        //on Back button press, you can use WillPopScope for another purpose also.
        // Navigator.pop(context); //return data along with pop
        Navigator.of(context)
            .pushReplacement(new MaterialPageRoute(builder: (context) => SelectGroomingShopPage(onPressed: rebuildPage, groomingId:widget.groomingId, token:widget.token,)));
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

        body:  Column (children: <Widget>[
          Expanded(
            child: FutureBuilder<PetModel>(
                future: _resultPetList,
                builder: (context, snapshot)
                {

                  return  ListView.builder(
                    itemCount: _resultPet == null ? 0 : _resultPet.length,
                    itemBuilder: (BuildContext context, int index){

                      return Column(
                          children: <Widget>[
                            if(_resultPet[index].ServiceCount == 0)
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: ListTile(
                                trailing:  InkWell(
                                  onTap: (){
                                    patientPetId = _resultPet[index].PatientPetId.toString();
                                  print('changed to patientPetId $patientPetId');
                                  Navigator.push(context, SlideLeftRoute(page: ServicesDialog(groomingId:widget.groomingId, patientPetId:patientPetId, shopId: widget.shopId, token:widget.token)));
                                  },
                                  child: Text("Add Services",style: TextStyle(fontSize:18, fontFamily: "Camphor",
                                      fontWeight: FontWeight.w900,color: Colors.grey),),
                                ),
                               /* IconButton(
                                  icon: new Icon(Icons.check_circle, color: Colors.grey,),
                                  tooltip: 'Services',
                                  onPressed: () {
                                    patientPetId = _resultPet[index].PatientPetId.toString();
                                    print('changed to patientPetId $patientPetId');
                                    Navigator.push(context, SlideLeftRoute(page: ServicesDialog(groomingId:widget.groomingId, patientPetId:patientPetId, shopId: widget.shopId, token:widget.token)));
                                  },
                                ),*/
                                title: Text(_resultPet[index].PetName,style: TextStyle(fontSize:18, fontFamily: "Camphor",
                                    fontWeight: FontWeight.w700,color: Colors.black),),
                                leading:  ClipRRect(
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
                            if(_resultPet[index].ServiceCount != 0)
                            Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: ListTile(
                                  trailing: InkWell(
                                    onTap: (){
                                      patientPetId = _resultPet[index].PatientPetId.toString();
                                      print('changed to patientPetId $patientPetId');
                                      Navigator.push(context, SlideLeftRoute(page: ServicesDialog(groomingId:widget.groomingId, patientPetId:patientPetId, shopId: widget.shopId, token:widget.token)));
                                    },
                                    child: Text("Add Services",style: TextStyle(fontSize:18, fontFamily: "Camphor",
                                        fontWeight: FontWeight.w900,color: Colors.green),),
                                  ),
                                 /* IconButton(
                                    icon: new Icon(Icons.check_circle, color: Colors.green,),
                                    tooltip: 'Services',
                                    onPressed: () {
                                      patientPetId = _resultPet[index].PatientPetId.toString();
                                      print('changed to patientPetId $patientPetId');
                                      Navigator.push(context, SlideLeftRoute(page: ServicesDialog(groomingId:widget.groomingId, patientPetId:patientPetId, shopId: widget.shopId, token:widget.token)));

                                    },
                                  ),*/
                                  title: Text(_resultPet[index].PetName,style: TextStyle(fontSize:18, fontFamily: "Camphor",
                                      fontWeight: FontWeight.w700,color: Colors.black),),
                                  leading:  ClipRRect(
                                    borderRadius: BorderRadius.circular(50),
                                    child: Image.network(
                                      "${_resultPet[index].Photograph}",
                                      width: 50,
                                      height: 50,
                                      fit: BoxFit.fill,
                                    ),
                                  ),
                                  subtitle: Text("${_resultPet[index].TotalServiceRate.toString()}/-",style: TextStyle(fontSize:18, fontFamily: "Camphor",
                                      fontWeight: FontWeight.w700,color: Colors.black),),


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
          if(amount != 0.0)
          Text("Amount : $amount/-", style: TextStyle(fontSize:25, fontFamily: "Camphor",
              fontWeight: FontWeight.w900,color: Colors.black),),

          SizedBox(height: 20,),


        ]),


        bottomNavigationBar: Container(
          height: 50,
          margin: EdgeInsets.all(10),
          width: double.infinity,
          decoration: BoxDecoration(
            ),
          child: ElevatedButton(
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all(appColorlight)
            ),
            onPressed: (){
              if(serviceSelected == "NoServicesSelected"){
          _displaySnackBar(context);
          }
          if(serviceSelected == "ServicesSelected"){
          String _groomingId = widget.groomingId;
          String _shopId = widget.shopId;
          String _token = widget.token;
          String _amount = amount.toString();

          print("widget  _groomingId  ============ : ${_groomingId} ");
          print("widget  _shopId  ============ : ${_shopId} ");
          print("widget  _token  ============ : ${_token} ");
          print("widget  _amount  ============ : ${_amount} ");

          Navigator.push(context, SlideLeftRoute(page: GroomingBookAppointmentPage(shopId:_shopId, groomingId:_groomingId, token:_token, amount:_amount)));

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

      ),
    );
  }
}
