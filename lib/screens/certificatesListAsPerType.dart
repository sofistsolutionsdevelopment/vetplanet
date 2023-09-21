import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:ext_storage/ext_storage.dart';
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
import 'certificates.dart';
import 'dash.dart';
import 'drawer.dart';
import 'package:http/http.dart' as http;


class CertificatesListAsPerTypePage extends StatefulWidget {
  final String vetId;
  final String petId;
  final String certificateId;

  CertificatesListAsPerTypePage({ this.vetId, this.petId, this.certificateId});
  @override
  _CertificatesListAsPerTypePage createState() => _CertificatesListAsPerTypePage();
}

class _CertificatesListAsPerTypePage extends State<CertificatesListAsPerTypePage> {

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final GlobalKey<FormState> _formStateKey = GlobalKey<FormState>();

  Future<List> _futurCertificates;
  String _certificatesLenght = "";
  Future<List<CertificatesModel>> getCertificates() async {
    final _prefs = await SharedPreferences.getInstance();
    String _API_Path = _prefs.getString('API_Path');
    String _RegistrationId = _prefs.getInt('id').toString();
    debugPrint('Check Inserted _API_Path $_API_Path ');
    debugPrint('Check Inserted _RegistrationId $_RegistrationId ');
    debugPrint('Check Inserted vetId ${widget.vetId} ');

    final String apiUrl = "$_API_Path/GetCertificatesByVetId/GetCertificatesByVetId";

    debugPrint('Check Inserted 1 ');
    var response = await http.post(
      Uri.parse(apiUrl),
      headers: {HttpHeaders.contentTypeHeader: 'application/json', HttpHeaders.authorizationHeader: 'bearer VA5kBnSw50cbuJ4YoAVkl4XyFTA312fRtKF4GxlmkUcl3PQJBKvvtogvT_0syd6ZtsZ4-1zFK6_liq5dQpyMq2tOA7vCtZ332qal7LGyBxBvv4mtD461lwGhNtprYd8PyIR40bBsoBc7nMElIniHJXAu1V04eO5c7sNLHOGypeG70Zn06yQr-0i_eFbsCRg6kMWjkao3RZwDfXVra5JQ5I7Pr1CbSgYez6rbYLMbH2LL6K8VcpmUvs45WpLe4UjPpChygW96LCoxVh7YtNa74n1Bje4sDdGLZowZJWwe7F9P7ijy1nVyw_v5K-8MqzlI' },
      body: json.encode(
          {
            "VetId":widget.vetId,
            "PatientId":_RegistrationId,
            "PatientPetId":widget.petId,
            "CertificateId":widget.certificateId
          }

      ),
    );

    debugPrint('Check 2}');
    if (response != null && response.statusCode == 200) {
      debugPrint('Check 3}');
      var _response = json.decode(response.body);
      debugPrint('Check 4  ${_response}');


      List<CertificatesModel> _certificates = _response
          .map<CertificatesModel>(
              (_json) => CertificatesModel.fromJson(_json))
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
            title: Container(
              color: appColor,
              child: Padding(
                padding: const EdgeInsets.only(left:1, right:1, top:12, bottom:12),
                child: Text('Vet Planet',style: TextStyle(fontFamily: "Camphor",
                    fontWeight: FontWeight.w900,fontSize: 18, color: Colors.white),textAlign:TextAlign.center ,),
              ),
            ),
            content: Text('Certificate Downloaded Sucessfully!',style:TextStyle(fontFamily: "Camphor",
                fontWeight: FontWeight.w500, fontSize: 16,color: Colors.black),),
            actions: <Widget>[

              TextButton(
                // color: Colors.red,
                child: Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: Text('Ok',style: TextStyle(color: appColor,fontSize: 16,  fontFamily: "Camphor",
                    fontWeight: FontWeight.w900,),),
                ),
                onPressed: () async{
                  Navigator.pop(context);
                },
                // onPressed: ()=> exit(0),

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
    Map<PermissionGroup, PermissionStatus> permissions =
    await PermissionHandler().requestPermissions([PermissionGroup.storage]);
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
            .pushReplacement(new MaterialPageRoute(builder: (context) => CertificatesPage(onPressed: rebuildPage , vetId:widget.vetId, petId:widget.petId)));
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
                      List<CertificatesModel> _certificates = snapshot.data;
                      return ListView.builder(
                        shrinkWrap: true,
                        itemCount: _certificates == null ? 0 : _certificates.length,
                        itemBuilder: (BuildContext context, int index) {
                          return Padding(
                            padding: const EdgeInsets.only(right:25, left:25, bottom:15, top:5),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: <Widget>[

                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Text("${_certificates[index].Date}",style: TextStyle(fontSize:16, fontFamily: "Camphor",
                                        fontWeight: FontWeight.w700,color: Colors.black),),
                                    Padding(
                                      padding: const EdgeInsets.only(right:15),
                                      child: InkWell(
                                          onTap: ()async {
                                            String imgUrl = "${_certificates[index].CertificatePath}";
                                            var splitString = imgUrl.split(".");
                                            splitPrescription1 = splitString[1];
                                            splitPrescription2 = splitString[2];

                                            print("splitPrescription1 : $splitPrescription1");
                                            print("splitPrescription2 : $splitPrescription2");
                                            String path =
                                            await ExtStorage.getExternalStoragePublicDirectory(
                                                ExtStorage.DIRECTORY_DOWNLOADS);
                                            //String fullPath = tempDir.path + "/boo2.pdf'";
                                            String fullPath = "$path/PetCertificate.$splitPrescription2";
                                            //String fullPath = "$path";
                                            print('full path ${fullPath}');

                                            download(dio, imgUrl, fullPath);
                                          },
                                          child: Icon(Icons.file_download, color: Colors.black,size: 20,)),
                                    ),

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



