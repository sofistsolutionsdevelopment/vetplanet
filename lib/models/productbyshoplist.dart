// To parse this JSON data, do
//
//     final productlistbyshopid = productlistbyshopidFromJson(jsonString);

import 'dart:convert';

List<Productlistbyshopid> productlistbyshopidFromJson(String str) => List<Productlistbyshopid>.from(json.decode(str).map((x) => Productlistbyshopid.fromJson(x)));

String productlistbyshopidToJson(List<Productlistbyshopid> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Productlistbyshopid {
    int shopId;
    int pcId;
    String pCategName;
    List<ShopPrdList> shopPrdList;

    Productlistbyshopid({
        this.shopId,
        this.pcId,
        this.pCategName,
        this.shopPrdList,
    });

    factory Productlistbyshopid.fromJson(Map<String, dynamic> json) => Productlistbyshopid(
        shopId: json["ShopID"],
        pcId: json["PCId"],
        pCategName: json["PCategName"],
        shopPrdList: List<ShopPrdList>.from(json["ShopPRDList"].map((x) => ShopPrdList.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "ShopID": shopId,
        "PCId": pcId,
        "PCategName": pCategName,
        "ShopPRDList": List<dynamic>.from(shopPrdList.map((x) => x.toJson())),
    };
}

class ShopPrdList {
    int shopId;
    int pmid;
    String prodName;

    ShopPrdList({
        this.shopId,
        this.pmid,
        this.prodName,
    });

    factory ShopPrdList.fromJson(Map<String, dynamic> json) => ShopPrdList(
        shopId: json["ShopID"],
        pmid: json["PMID"],
        prodName: json["ProdName"],
    );

    Map<String, dynamic> toJson() => {
        "ShopID": shopId,
        "PMID": pmid,
        "ProdName": prodName,
    };
}
