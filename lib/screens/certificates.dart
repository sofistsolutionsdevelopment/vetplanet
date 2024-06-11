import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
// import 'package:ext_storage/ext_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vetplanet/constant/colors.dart';
import 'package:intl/intl.dart';
import 'package:vetplanet/models/certificatesType_model.dart';
import 'package:vetplanet/models/certificates_model.dart';
import 'package:vetplanet/models/prescriptionNote_model.dart';
import 'package:vetplanet/screens/vetDetails.dart';
import 'package:vetplanet/transitions/slide_route.dart';
import 'certificatesListAsPerType.dart';
import 'dash.dart';
import 'drawer.dart';
import 'package:http/http.dart' as http;


class CertificatesPage extends StatefulWidget {
  final Function onPressed;
  final String vetId;
  final String petId;

  CertificatesPage({this.onPressed, this.vetId, this.petId});
  @override
  _CertificatesPageState createState() => _CertificatesPageState();
}

class _CertificatesPageState extends State<CertificatesPage> {

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final GlobalKey<FormState> _formStateKey = GlobalKey<FormState>();

  Future<List> _futurCertificates;
  String _certificatesLenght = "";
  Future<List<CertificatesTypeModel>> getCertificates() async {
    final _prefs = await SharedPreferences.getInstance();
    
    String _RegistrationId = _prefs.getInt('id').toString();
    debugPrint('Check Inserted apiUrl $apiUrl ');
    debugPrint('Check Inserted _RegistrationId $_RegistrationId ');
    debugPrint('Check Inserted vetId ${widget.vetId} ');

    final String url = "$apiUrl/GetCertificateType/GetCertificateType";

    debugPrint('Check Inserted 1 ');
    var response = await http.post(
      Uri.parse(url),
      headers: {HttpHeaders.contentTypeHeader: 'application/json', HttpHeaders.authorizationHeader: bearerToken },
    );

    debugPrint('Check 2}');
    if (response != null && response.statusCode == 200) {
      debugPrint('Check 3}');
      var _response = json.decode(response.body);
      debugPrint('Check 4  ${_response}');


      List<CertificatesTypeModel> _certificates = _response
          .map<CertificatesTypeModel>(
              (_json) => CertificatesTypeModel.fromJson(_json))
          .toList();


      debugPrint('Check 5  ${_certificates}');
      setState(() {
        _certificatesLenght = _certificates.length.toString();
        debugPrint('Check _certificatesLenght &&&&&&&&&&&&&&&&&&&&&&&&&: $_certificatesLenght}');

      });
      return _certificates;

    } else {
      debugPrint('Check 6');
      return [];
    }
  }


  Future<String> approved() {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('', style:TextStyle(color: Colors.black,fontSize: 19,
                fontWeight: FontWeight.bold),),
            content: Text('Certificate Downloaded Sucessfully!',style:TextStyle(fontFamily: "Camphor",
                fontWeight: FontWeight.w500, fontSize: 18,color: Colors.black),),
            actions: <Widget>[
              TextButton(
                  //color: appColor,
                  child: Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: Text('OK',style: TextStyle(fontFamily: "Camphor",
                      fontWeight: FontWeight.w500, fontSize: 18,color: Colors.white,),),
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                  }
              ),
            ],
          );
        });
  }



  Future download(Dio dio, String url, String savePath) async {
    try {
      Response response = await dio.get(
        url,
        onReceiveProgress: showDownloadProgress,
        //Received data with List<int>
        options: Options(
            responseType: ResponseType.bytes,
            followRedirects: false,
            validateStatus: (status) {
              return status < 500;
            }),
      );
      print(response.headers);
      File file = File(savePath);
      var raf = file.openSync(mode: FileMode.write);
      // response.data is List<int> type
      raf.writeFromSync(response.data);
      await raf.close();
    } catch (e) {
      print(e);
    }
  }

  void showDownloadProgress(received, total) {
    if (total != -1) {
      print((received / total * 100).toStringAsFixed(0) + "%");
      if((received / total * 100).toStringAsFixed(0) + "%" == "100%")
      {
        print("Successfully Downloaded");
        approved();
      }
    }
  }

  var dio = Dio();

  void getPermission() async {
    print("getPermission");
    Map<Permission, PermissionStatus> permissions =
    await [Permission.storage].request();
  }

  var splitPrescription1;
  var splitPrescription2;

  @override
  void initState() {
    getPermission();
    _futurCertificates =  getCertificates();
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
            .pushReplacement(new MaterialPageRoute(builder: (context) => VetDetails(onPressed: rebuildPage , userKey:widget.vetId)));
        return new Future(() => false); //onWillPop is Future<bool> so return false
      },
      child: Scaffold(
        key: _scaffoldKey,
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
        body: Form(
          key: _formStateKey,
          child: Column(
            children: <Widget>[
              SizedBox(height: 20,),
              if(_certificatesLenght != "0")
                Expanded(
                  child: FutureBuilder(
                    future: _futurCertificates,
                    builder: (context, snapshot) {
                      if (snapshot.hasError) {
                        return Center(child: Text(''));
                      }
                      if (snapshot.hasData) {
                        List<CertificatesTypeModel> _certificates = snapshot.data;
                        return ListView.builder(
                          shrinkWrap: true,
                          itemCount: _certificates == null ? 0 : _certificates.length,
                          itemBuilder: (BuildContext context, int index) {
                            return Padding(
                              padding: const EdgeInsets.only(right:15, left:15, bottom:15, top:5),
                              child: InkWell(
                                onTap: (){
                                  String certificateId = "${_certificates[index].CertificateId.toString()}";

                                  Navigator.push(context, SlideLeftRoute(page: CertificatesListAsPerTypePage(vetId:widget.vetId, petId:widget.petId, certificateId:certificateId)));

                                },
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: <Widget>[

                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Text("${_certificates[index].CertificateType}",style: TextStyle(fontSize:16, fontFamily: "Camphor",
                                            fontWeight: FontWeight.w700,color: Colors.black),),
                                        Icon(Icons.arrow_forward_ios, color: Colors.black,size: 20,)
                                      ],
                                    ),
                                    SizedBox(height: 10,),
                                    Divider(
                                      height: 1,
                                      thickness: 0.5,
                                      color: Colors.grey,
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
              if(_certificatesLenght == "0")
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[

                    SizedBox(height: 25,),

                    Center(child: Align(
                      child: Text("No Certificates Found", style: TextStyle(fontSize: 19, color: Colors.black,fontFamily: "Camphor",
                        fontWeight: FontWeight.w700,),),
                    )),
                  ],
                ),


            ],
          ),
        ),
      ),
    );
  }
}



