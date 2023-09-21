import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:vetplanet/constant/colors.dart';
import 'package:vetplanet/models/clinic_model.dart';
import 'package:vetplanet/models/groomingShop_model.dart';
import 'package:vetplanet/models/result_model.dart';
import 'package:vetplanet/screens/dash.dart';
import 'package:http/http.dart' as http;
import 'package:vetplanet/screens/groomingList.dart';
import 'package:vetplanet/screens/selectGroomingServices.dart';
import 'package:vetplanet/screens/selectPetForGrooming.dart';
import 'package:vetplanet/screens/selectServices.dart';
import 'package:vetplanet/transitions/slide_route.dart';
import 'bookAppointment.dart';
import 'drawer.dart';

class SelectGroomingShopPage extends StatefulWidget {
  final Function onPressed;
  final String groomingId;
  final String token;

  SelectGroomingShopPage({ this.groomingId, this.onPressed, this.token });
  @override
  _SelectGroomingShopPageState createState() => _SelectGroomingShopPageState();
}

class _SelectGroomingShopPageState extends State<SelectGroomingShopPage> {

  void rebuildPage() {
    setState(() {});
  }


  Future<List> _future;

  String __groomingLenght = "";

  Future<List<GroomingShopModel>> getGrooming() async {
    final _prefs = await SharedPreferences.getInstance();
    String _API_Path = _prefs.getString('API_Path');
    String _RegistrationId = _prefs.getInt('id').toString();
    debugPrint('Check Inserted _API_Path $_API_Path ');
    debugPrint('Check Inserted _RegistrationId $_RegistrationId ');


    final String apiUrl = "$_API_Path/GetShopListByPetGroomingId/GetShopListByPetGroomingId";

    debugPrint('Check Inserted 1 ');
    var response = await http.post(
      Uri.parse(apiUrl),
      headers: {HttpHeaders.contentTypeHeader: 'application/json', HttpHeaders.authorizationHeader: 'bearer VA5kBnSw50cbuJ4YoAVkl4XyFTA312fRtKF4GxlmkUcl3PQJBKvvtogvT_0syd6ZtsZ4-1zFK6_liq5dQpyMq2tOA7vCtZ332qal7LGyBxBvv4mtD461lwGhNtprYd8PyIR40bBsoBc7nMElIniHJXAu1V04eO5c7sNLHOGypeG70Zn06yQr-0i_eFbsCRg6kMWjkao3RZwDfXVra5JQ5I7Pr1CbSgYez6rbYLMbH2LL6K8VcpmUvs45WpLe4UjPpChygW96LCoxVh7YtNa74n1Bje4sDdGLZowZJWwe7F9P7ijy1nVyw_v5K-8MqzlI' },
      body: json.encode(
          {
            "PetGroomingId":widget.groomingId
          }
      ),
    );

    debugPrint('Check 2}');
    if (response != null && response.statusCode == 200) {
      debugPrint('Check 3}');
      var _response = json.decode(response.body);
      debugPrint('Check 4  ${_response}');


      List<GroomingShopModel> _grooming = _response
          .map<GroomingShopModel>(
              (_json) => GroomingShopModel.fromJson(_json))
          .toList();

      debugPrint('Check 5  ${_grooming}');
      setState(() {
        __groomingLenght = _grooming.length.toString();
        debugPrint('Check _petLenght &&&&&&&&&&&&&&&&&&&&&&&&&: $__groomingLenght}');

      });
      return _grooming;

    } else {
      debugPrint('Check 6');
      return [];
    }
  }

  void launchMap(String address) async {
    String query = Uri.encodeComponent(address);
    String googleUrl = "https://www.google.com/maps/search/?api=1&query=$query";

    if (await canLaunch(googleUrl)) {
      await launch(googleUrl);
    }
  }


  ResultModel _deleteServices;

  Future<ResultModel> deleteServices() async{
    final _prefs = await SharedPreferences.getInstance();
    String _API_Path = _prefs.getString('API_Path');
    String _RegistrationId = _prefs.getInt('id').toString();

    debugPrint('Check Inserted _API_Path $_API_Path');
    debugPrint('Check Inserted _RegistrationId $_RegistrationId');

    final String apiUrl =  "$_API_Path/DeleteTempGroomingService/DeleteTempGroomingService";

    debugPrint('Check Inserted 1 ');

    var response = await http.post(
      Uri.parse(apiUrl),
      headers: {HttpHeaders.contentTypeHeader: 'application/json', HttpHeaders.authorizationHeader: 'bearer VA5kBnSw50cbuJ4YoAVkl4XyFTA312fRtKF4GxlmkUcl3PQJBKvvtogvT_0syd6ZtsZ4-1zFK6_liq5dQpyMq2tOA7vCtZ332qal7LGyBxBvv4mtD461lwGhNtprYd8PyIR40bBsoBc7nMElIniHJXAu1V04eO5c7sNLHOGypeG70Zn06yQr-0i_eFbsCRg6kMWjkao3RZwDfXVra5JQ5I7Pr1CbSgYez6rbYLMbH2LL6K8VcpmUvs45WpLe4UjPpChygW96LCoxVh7YtNa74n1Bje4sDdGLZowZJWwe7F9P7ijy1nVyw_v5K-8MqzlI' },
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

  Future<ResultModel> deletePreServices() async{
    final _prefs = await SharedPreferences.getInstance();
    String _API_Path = _prefs.getString('API_Path');
    String _RegistrationId = _prefs.getInt('id').toString();

    debugPrint('Check Inserted _API_Path $_API_Path');
    debugPrint('Check Inserted _RegistrationId $_RegistrationId');

    final String apiUrl =  "$_API_Path/DeletePreGroomingService/DeletePreGroomingService";

    debugPrint('Check Inserted 1 ');

    var response = await http.post(
      Uri.parse(apiUrl),
      headers: {HttpHeaders.contentTypeHeader: 'application/json', HttpHeaders.authorizationHeader: 'bearer VA5kBnSw50cbuJ4YoAVkl4XyFTA312fRtKF4GxlmkUcl3PQJBKvvtogvT_0syd6ZtsZ4-1zFK6_liq5dQpyMq2tOA7vCtZ332qal7LGyBxBvv4mtD461lwGhNtprYd8PyIR40bBsoBc7nMElIniHJXAu1V04eO5c7sNLHOGypeG70Zn06yQr-0i_eFbsCRg6kMWjkao3RZwDfXVra5JQ5I7Pr1CbSgYez6rbYLMbH2LL6K8VcpmUvs45WpLe4UjPpChygW96LCoxVh7YtNa74n1Bje4sDdGLZowZJWwe7F9P7ijy1nVyw_v5K-8MqzlI' },
      body: json.encode(
          {
            "PatientId"	:_RegistrationId,
            "GroomerId":widget.groomingId
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

  void deleteService() async {
    final ResultModel resultdelete = await deleteServices();
    final ResultModel resultpredelete = await deletePreServices();
    setState(() {
      _deleteServices = resultdelete;
      _deletePreServices = resultpredelete;
      if(_deleteServices != null){
        print("_deleteServices *******************${_deleteServices.Result}");
      }
      if(_deletePreServices != null){
        print("_deletePreServices *******************${_deletePreServices.Result}");
      }
    });

  }


  @override
  void initState() {
    _future = getGrooming();
  //  deleteService();
    super.initState();
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

        body:    FutureBuilder(
          future: _future,
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Center(child: Text(''));
            }
            if (snapshot.hasData) {
              List<GroomingShopModel> _grooming =  snapshot.data;
              return ListView.builder(
                shrinkWrap: true,
                itemCount: _grooming == null ? 0 : _grooming.length,
                itemBuilder: (BuildContext context, int index) {
                  return Column(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: InkWell(
                          onTap: (){
                            String _shopId = "${_grooming[index].ShopId}";
                            String _groomingId = widget.groomingId;
                            String _token = widget.token;
                            deleteService();
                            Navigator.push(context, SlideLeftRoute(page: SelectPetForGroomingPage(shopId:_shopId, groomingId:_groomingId, token:_token)));
                          },
                          child:Padding(
                            padding: const EdgeInsets.all(8.0),
                            child:   Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: <Widget>[
                                      Image.asset(
                                        "assets/grooming.png",width: 20,height: 15,
                                      ),
                                      SizedBox(height: 5,),
                                      Text(
                                        "${_grooming[index].ShopName}",
                                        style: TextStyle(
                                          color: Colors.black, fontSize: 18,fontFamily: "Camphor",
                                          fontWeight: FontWeight.w700,),
                                      ),
                                      Text(
                                        "${_grooming[index].ContactNo}",
                                        style: TextStyle(
                                          color: Colors.black, fontSize: 16,fontFamily: "Camphor",
                                          fontWeight: FontWeight.w700,),
                                      ),
                                      Text(
                                        "${_grooming[index].ShopAddress}",
                                        style: TextStyle(
                                          color: Colors.black, fontSize: 16,fontFamily: "Camphor",
                                          fontWeight: FontWeight.w700,),
                                      ),

                                    ],
                                  ),
                                ),
                                InkWell(
                                    onTap: (){
                                      String address = "${_grooming[index].ShopAddress}";

                                      print("address : $address");
                                      launchMap(address);
                                    },
                                    child: Icon(Icons.location_on, color: appColor,size: 30,)),
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

      ),
    );
  }
}
