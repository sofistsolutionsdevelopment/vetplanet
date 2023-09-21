// To parse this JSON data, do
//
//     final shopList = shopListFromJson(jsonString);

import 'dart:convert';

List<ShopList> shopListFromJson(String str) => List<ShopList>.from(json.decode(str).map((x) => ShopList.fromJson(x)));

String shopListToJson(List<ShopList> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class ShopList {
    int shopId;
    int shopBId;
    String shopName;
    String branchName;
    int cityId;
    int stateId;
    int countryId;
    String longitude;
    String latitude;
    String shopContactNo;
    String pCategName;
    int rating;
    String img;
    int favourite;

    ShopList({
        this.shopId,
        this.shopBId,
        this.shopName,
        this.branchName,
        this.cityId,
        this.stateId,
        this.countryId,
        this.longitude,
        this.latitude,
        this.shopContactNo,
        this.pCategName,
        this.rating,
        this.img,
        this.favourite,
    });

    factory ShopList.fromJson(Map<String, dynamic> json) => ShopList(
        shopId: json["ShopID"],
        shopBId: json["ShopBId"],
        shopName: json["ShopName"],
        branchName: json["BranchName"],
        cityId: json["CityId"],
        stateId: json["StateId"],
        countryId: json["CountryId"],
        longitude: json["Longitude"],
        latitude: json["Latitude"],
        shopContactNo: json["ShopContactNo"],
        pCategName: json["PCategName"],
        rating: json["Rating"],
        img: json["IMG"],
        favourite: json["Favourite"],
    );

    Map<String, dynamic> toJson() => {
        "ShopID": shopId,
        "ShopBId": shopBId,
        "ShopName": shopName,
        "BranchName": branchName,
        "CityId": cityId,
        "StateId": stateId,
        "CountryId": countryId,
        "Longitude": longitude,
        "Latitude": latitude,
        "ShopContactNo": shopContactNo,
        "PCategName": pCategName,
        "Rating": rating,
        "IMG": img,
        "Favourite": favourite,
    };
}
