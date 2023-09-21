import 'dart:convert';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import '../models/ProductDetail.dart';
import '../models/productbyshoplist.dart';
import '../models/productcategorylist.dart';
import '../models/products.dart';
import '../models/shoplist.dart';
import '../models/specieslist.dart';

class ShopController {
  String _API_Path = "http://sofistsolutions.in/POP";

  Future<List<Specieslist>> getSpeciesList(var shopid) async {
    final _prefs = await SharedPreferences.getInstance();
    //String _API_Path = "http://sofistsolutions.in/POP";
    String _RegistrationId = _prefs.getInt('id').toString();
    debugPrint('Check getProfile _API_Path $_API_Path ');
    final String apiUrl = "$_API_Path/api/Master/GetSpeciesList";

    debugPrint('Check Inserted 1 ' + apiUrl);
   var data = {"ShopId": shopid};

    var response = await http.post(
      Uri.parse(apiUrl),
      headers: {
        HttpHeaders.contentTypeHeader: 'application/json'
        // HttpHeaders.authorizationHeader: 'bearer VA5kBnSw50cbuJ4YoAVkl4XyFTA312fRtKF4GxlmkUcl3PQJBKvvtogvT_0syd6ZtsZ4-1zFK6_liq5dQpyMq2tOA7vCtZ332qal7LGyBxBvv4mtD461lwGhNtprYd8PyIR40bBsoBc7nMElIniHJXAu1V04eO5c7sNLHOGypeG70Zn06yQr-0i_eFbsCRg6kMWjkao3RZwDfXVra5JQ5I7Pr1CbSgYez6rbYLMbH2LL6K8VcpmUvs45WpLe4UjPpChygW96LCoxVh7YtNa74n1Bje4sDdGLZowZJWwe7F9P7ijy1nVyw_v5K-8MqzlI'
      },
      body: json.encode(data),
    );

    debugPrint('data' + data.toString());
    debugPrint('Check Inserted 2 ' + response.body);

    if (response.statusCode == 200) {
      debugPrint('Check Inserted 3 : ${response.body}');

      final String responseString = response.body;

      debugPrint('Check Inserted 4  ${responseString}');

      return specieslistFromJson(responseString);
    } else {
      debugPrint('Check Inserted 5 ');
      return null;
    }
  }
  
  Future<List<ProductCategoryList>> getProductCategoryList(var shopid,var speciesid) async {
    final _prefs = await SharedPreferences.getInstance();
    //String _API_Path = "http://sofistsolutions.in/POP";
    String _RegistrationId = _prefs.getInt('id').toString();
    debugPrint('Check getProfile _API_Path $_API_Path ');
    final String apiUrl = "$_API_Path/api/Master/GetProductCategoryList";

    debugPrint('Check Inserted 1 ' + apiUrl);
   var data = {"ShopId": shopid,"speciesId":speciesid};

    var response = await http.post(
      Uri.parse(apiUrl),
      headers: {
        HttpHeaders.contentTypeHeader: 'application/json'
        //HttpHeaders.authorizationHeader: 'bearer VA5kBnSw50cbuJ4YoAVkl4XyFTA312fRtKF4GxlmkUcl3PQJBKvvtogvT_0syd6ZtsZ4-1zFK6_liq5dQpyMq2tOA7vCtZ332qal7LGyBxBvv4mtD461lwGhNtprYd8PyIR40bBsoBc7nMElIniHJXAu1V04eO5c7sNLHOGypeG70Zn06yQr-0i_eFbsCRg6kMWjkao3RZwDfXVra5JQ5I7Pr1CbSgYez6rbYLMbH2LL6K8VcpmUvs45WpLe4UjPpChygW96LCoxVh7YtNa74n1Bje4sDdGLZowZJWwe7F9P7ijy1nVyw_v5K-8MqzlI'
      },
      body: json.encode(data),
    );

    debugPrint('data' + data.toString());
    debugPrint('Check Inserted 2 ' + response.body);

    if (response.statusCode == 200) {
      debugPrint('Check Inserted 3 : ${response.body}');

      final String responseString = response.body;

      debugPrint('Check Inserted 4  ${responseString}');

      return productCategoryListFromJson(responseString);
    } else {
      debugPrint('Check Inserted 5 ');
      return null;
    }
  }
  
  Future<List<ShopList>> getShopList(var lat, var long) async {
    final _prefs = await SharedPreferences.getInstance();
    //String _API_Path = "http://sofistsolutions.in/POP";
    String _RegistrationId = _prefs.getInt('id').toString();
    debugPrint('Check getProfile _API_Path $_API_Path ');
    final String apiUrl = "$_API_Path/api/Master/GetShopList";

    debugPrint('Check Inserted 1 ' + apiUrl);
    var data = {"Longitude": "$lat", "Latitude": "$long"};

    var response = await http.post(
      Uri.parse(apiUrl),
      headers: {
        HttpHeaders.contentTypeHeader: 'application/json'
        // HttpHeaders.authorizationHeader: 'bearer VA5kBnSw50cbuJ4YoAVkl4XyFTA312fRtKF4GxlmkUcl3PQJBKvvtogvT_0syd6ZtsZ4-1zFK6_liq5dQpyMq2tOA7vCtZ332qal7LGyBxBvv4mtD461lwGhNtprYd8PyIR40bBsoBc7nMElIniHJXAu1V04eO5c7sNLHOGypeG70Zn06yQr-0i_eFbsCRg6kMWjkao3RZwDfXVra5JQ5I7Pr1CbSgYez6rbYLMbH2LL6K8VcpmUvs45WpLe4UjPpChygW96LCoxVh7YtNa74n1Bje4sDdGLZowZJWwe7F9P7ijy1nVyw_v5K-8MqzlI'
      },
      body: json.encode(data),
    );

    debugPrint('data' + data.toString());
    debugPrint('Check Inserted 2 ' + response.body);

    if (response.statusCode == 200) {
      debugPrint('Check Inserted 3 : ${response.body}');

      final String responseString = response.body;

      debugPrint('Check Inserted 4  ${responseString}');

      return shopListFromJson(responseString);
    } else {
      debugPrint('Check Inserted 5 ');
      return null;
    }
  }
  
  // Future<List<Products>> getProductList(var shopid) async {
  //   final _prefs = await SharedPreferences.getInstance();

  //   String _RegistrationId = _prefs.getInt('id').toString();
  //   debugPrint('Check getProfile _API_Path $_API_Path ');
  //   final String apiUrl = "$_API_Path/api/Master/GetProductList";

  //   debugPrint('Check Inserted 1 ' + apiUrl);
  //   var data = {"ShopId": shopid};

  //   var response = await http.post(
  //     Uri.parse(apiUrl),
  //     headers: {
  //       HttpHeaders.contentTypeHeader: 'application/json'
  //       // HttpHeaders.authorizationHeader: 'bearer VA5kBnSw50cbuJ4YoAVkl4XyFTA312fRtKF4GxlmkUcl3PQJBKvvtogvT_0syd6ZtsZ4-1zFK6_liq5dQpyMq2tOA7vCtZ332qal7LGyBxBvv4mtD461lwGhNtprYd8PyIR40bBsoBc7nMElIniHJXAu1V04eO5c7sNLHOGypeG70Zn06yQr-0i_eFbsCRg6kMWjkao3RZwDfXVra5JQ5I7Pr1CbSgYez6rbYLMbH2LL6K8VcpmUvs45WpLe4UjPpChygW96LCoxVh7YtNa74n1Bje4sDdGLZowZJWwe7F9P7ijy1nVyw_v5K-8MqzlI'
  //     },
  //     body: json.encode(data),
  //   );

  //   debugPrint('data' + data.toString());
  //   debugPrint('Check Inserted 2 ' + response.body);

  //   if (response.statusCode == 200) {
  //      final String responseString = response.body;
  //   // var productList = productlistFromJson(responseString);
  //     return productsFromJson(responseString);
  //   } else {
  //     debugPrint('Check Inserted 5 ');
  //     return null;
  //   }
  // }
 
  Future<List<Products>> getProductList(var shopid,var pcid,var speciesid) async {
    final _prefs = await SharedPreferences.getInstance();

    String _RegistrationId = _prefs.getInt('id').toString();
    debugPrint('Check getProfile _API_Path $_API_Path ');
    final String apiUrl = "$_API_Path/api/Master/GetSubCatgWiseProdList";

    debugPrint('Check Inserted 1 ' + apiUrl);
    var data = {"ShopId": shopid, "PCId":pcid,
    "speciesId":speciesid,};

    var response = await http.post(
      Uri.parse(apiUrl),
      headers: {
        HttpHeaders.contentTypeHeader: 'application/json'
        // HttpHeaders.authorizationHeader: 'bearer VA5kBnSw50cbuJ4YoAVkl4XyFTA312fRtKF4GxlmkUcl3PQJBKvvtogvT_0syd6ZtsZ4-1zFK6_liq5dQpyMq2tOA7vCtZ332qal7LGyBxBvv4mtD461lwGhNtprYd8PyIR40bBsoBc7nMElIniHJXAu1V04eO5c7sNLHOGypeG70Zn06yQr-0i_eFbsCRg6kMWjkao3RZwDfXVra5JQ5I7Pr1CbSgYez6rbYLMbH2LL6K8VcpmUvs45WpLe4UjPpChygW96LCoxVh7YtNa74n1Bje4sDdGLZowZJWwe7F9P7ijy1nVyw_v5K-8MqzlI'
      },
      body: json.encode(data),
    );

    debugPrint('data' + data.toString());
    debugPrint('Check Inserted 2 ' + response.body);

    if (response.statusCode == 200) {
       final String responseString = response.body;
      // var productList = productlistFromJson(responseString);
      return productsFromJson(responseString);
    } else {
      debugPrint('Check Inserted 5 ');
      return null;
    }
  }
 
  Future<List<Productlistbyshopid>> GetShopWiseCatgList(var shopid) async {
    final _prefs = await SharedPreferences.getInstance();

   
    debugPrint('Check getProfile _API_Path $_API_Path ');
    final String apiUrl = "$_API_Path/api/Master/GetShopWiseCatgList";

    debugPrint('Check Inserted 1 ' + apiUrl);
    var data = {"ShopId": shopid};

    var response = await http.post(
      Uri.parse(apiUrl),
      headers: {
        HttpHeaders.contentTypeHeader: 'application/json'
        // HttpHeaders.authorizationHeader: 'bearer VA5kBnSw50cbuJ4YoAVkl4XyFTA312fRtKF4GxlmkUcl3PQJBKvvtogvT_0syd6ZtsZ4-1zFK6_liq5dQpyMq2tOA7vCtZ332qal7LGyBxBvv4mtD461lwGhNtprYd8PyIR40bBsoBc7nMElIniHJXAu1V04eO5c7sNLHOGypeG70Zn06yQr-0i_eFbsCRg6kMWjkao3RZwDfXVra5JQ5I7Pr1CbSgYez6rbYLMbH2LL6K8VcpmUvs45WpLe4UjPpChygW96LCoxVh7YtNa74n1Bje4sDdGLZowZJWwe7F9P7ijy1nVyw_v5K-8MqzlI'
      },
      body: json.encode(data),
    );

    debugPrint('data' + data.toString());
    debugPrint('Check Inserted 2 ' + response.body);

    if (response.statusCode == 200) {
       final String responseString = response.body;
    // var productList = productlistFromJson(responseString);
      return productlistbyshopidFromJson(responseString);
    } else {
      debugPrint('Check Inserted 5 ');
      return null;
    }
  }
  Future<List<ProductDetail>> GetProductDetails(var productid) async {
    final String apiUrl = "$_API_Path/api/Master/GetProductDetails";

    debugPrint('Check Inserted 1 ' + apiUrl);
    var data = {"ProductId": productid};

    var response = await http.post(
      Uri.parse(apiUrl),
      headers: {
        HttpHeaders.contentTypeHeader: 'application/json'
        // HttpHeaders.authorizationHeader: 'bearer VA5kBnSw50cbuJ4YoAVkl4XyFTA312fRtKF4GxlmkUcl3PQJBKvvtogvT_0syd6ZtsZ4-1zFK6_liq5dQpyMq2tOA7vCtZ332qal7LGyBxBvv4mtD461lwGhNtprYd8PyIR40bBsoBc7nMElIniHJXAu1V04eO5c7sNLHOGypeG70Zn06yQr-0i_eFbsCRg6kMWjkao3RZwDfXVra5JQ5I7Pr1CbSgYez6rbYLMbH2LL6K8VcpmUvs45WpLe4UjPpChygW96LCoxVh7YtNa74n1Bje4sDdGLZowZJWwe7F9P7ijy1nVyw_v5K-8MqzlI'
      },
      body: json.encode(data),
    );

    debugPrint('data' + data.toString());
    debugPrint('Check Inserted 2 ' + response.body);

    if (response.statusCode == 200) {
       final String responseString = response.body;
    // var productList = productlistFromJson(responseString);
      return productDetailFromJson(responseString);
    } else {
      debugPrint('Check Inserted 5 ');
      return null;
    }
  }

}
