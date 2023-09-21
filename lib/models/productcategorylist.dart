// To parse this JSON data, do
//
//     final productCategoryList = productCategoryListFromJson(jsonString);

import 'dart:convert';

List<ProductCategoryList> productCategoryListFromJson(String str) => List<ProductCategoryList>.from(json.decode(str).map((x) => ProductCategoryList.fromJson(x)));

String productCategoryListToJson(List<ProductCategoryList> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class ProductCategoryList {
    int shopId;
    int speciesId;
    int pcId;
    String pCategName;
    String pCategDescription;

    ProductCategoryList({
        this.shopId,
        this.speciesId,
        this.pcId,
        this.pCategName,
        this.pCategDescription,
    });

    factory ProductCategoryList.fromJson(Map<String, dynamic> json) => ProductCategoryList(
        shopId: json["ShopId"],
        speciesId: json["speciesId"],
        pcId: json["PCId"],
        pCategName: json["PCategName"],
        pCategDescription: json["PCategDescription"],
    );

    Map<String, dynamic> toJson() => {
        "ShopId": shopId,
        "speciesId": speciesId,
        "PCId": pcId,
        "PCategName": pCategName,
        "PCategDescription": pCategDescription,
    };
}
