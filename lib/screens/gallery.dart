import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:galleryimage/galleryimage.dart';
import 'package:vetplanet/constant/colors.dart';
import 'package:vetplanet/models/gelleryPhotos_model.dart';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;



class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {


  Future<List> _galleryPhotosfuture;
  String _gelleryPhotosLenght = "";

  Future<List<GalleryPhotosModel>> getGalleryPhotos() async {
    final _prefs = await SharedPreferences.getInstance();
    
    debugPrint('Check getGalleryPhotos apiUrl $apiUrl ');
    final String url = "$apiUrl/GetHostelPhotos/GetHostelPhotos";

    debugPrint('Check getGalleryPhotos 1 ');
    var response = await http.post(
      Uri.parse(url),
      headers: {HttpHeaders.contentTypeHeader: 'application/json', HttpHeaders.authorizationHeader: bearerToken },
      body: json.encode(
          {
            "HostelId":"9"
          }
      ),
    );
    debugPrint('Check getGalleryPhotos 2}');
    if (response != null && response.statusCode == 200) {
      debugPrint('Check getGalleryPhotos 3}');
      var _response = json.decode(response.body);
      debugPrint('Check getGalleryPhotos 4  ${_response}');


      List<GalleryPhotosModel> _galleryPhotos = _response
          .map<GalleryPhotosModel>(
              (_json) => GalleryPhotosModel.fromJson(_json))
          .toList();


      debugPrint('Check getGalleryPhotos 5  ${_galleryPhotos}');


      setState(() {
        _gelleryPhotosLenght = _galleryPhotos.length.toString();
        debugPrint('Check _gelleryPhotosLenght &&&&&&&&&&&&&&&&&&&&&&&&&: $_gelleryPhotosLenght}');

      });


      return _galleryPhotos;

    } else {
      debugPrint('Check getGalleryPhotos 6');
      return [];
    }
  }



  @override
  void initState() {
    _galleryPhotosfuture  = getGalleryPhotos();
    super.initState();
  }


  Widget build(BuildContext context) {
    return Scaffold(

      appBar: AppBar(
        title: Text("title"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text("Tap to show image"),
            Expanded(
              child: FutureBuilder(
                future: _galleryPhotosfuture,
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return Center(child: Text(''));
                  }
                  if (snapshot.hasData) {
                    List<GalleryPhotosModel> _gallery = snapshot.data;
                    return
                      GridView.count(
                          crossAxisCount: 3,

                          children: List.generate(_gallery.length, (index) {
                            return GalleryImage(
                              imageUrls: [ "${_gallery[index].Photograph}"],
                            );
                          }
                          )
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
      ),
    );
  }
}