// // To parse this JSON data, do
// //
// //     final products = productsFromJson(jsonString);

// import 'dart:convert';

// List<Products> productsFromJson(String str) => List<Products>.from(json.decode(str).map((x) => Products.fromJson(x)));

// String productsToJson(List<Products> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

// class Products {
//     int shopId;
//     int pmid;
//     String prodName;
//     String prodRate;
//     String weight;
//     String prodImg;
//     String prodShortDesc;

//     Products({
//         this.shopId,
//         this.pmid,
//         this.prodName,
//         this.prodRate,
//         this.weight,
//         this.prodImg,
//         this.prodShortDesc,
//     });

//     factory Products.fromJson(Map<String, dynamic> json) => Products(
//         shopId: json["ShopID"],
//         pmid: json["PMID"],
//         prodName: json["ProdName"],
//         prodRate: json["ProdRate"],
//         weight: json["Weight"],
//         prodImg: json["ProdIMG"],
//         prodShortDesc: json["ProdShortDesc"],
//     );

//     Map<String, dynamic> toJson() => {
//         "ShopID": shopId,
//         "PMID": pmid,
//         "ProdName": prodName,
//         "ProdRate": prodRate,
//         "Weight": weight,
//         "ProdIMG": prodImg,
//         "ProdShortDesc": prodShortDesc,
//     };
// }
// To parse this JSON data, do
//
//     final productlist = productlistFromJson(jsonString);

// To parse this JSON data, do
//
//     final products = productsFromJson(jsonString);

// To parse this JSON data, do
//
//     final products = productsFromJson(jsonString);

import 'dart:convert';

List<Products> productsFromJson(String str) => List<Products>.from(json.decode(str).map((x) => Products.fromJson(x)));

String productsToJson(List<Products> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Products {
    int shopId;
    int pcId;
    int speciesId;
    int scId;
    String subCatgName;
    List<ShopPrdList> shopPrdList;

    Products({
        this.shopId,
        this.pcId,
        this.speciesId,
        this.scId,
        this.subCatgName,
        this.shopPrdList,
    });

    factory Products.fromJson(Map<String, dynamic> json) => Products(
        shopId: json["ShopID"],
        pcId: json["PCId"],
        speciesId: json["speciesId"],
        scId: json["SCId"],
        subCatgName: json["SubCatgName"],
        shopPrdList: List<ShopPrdList>.from(json["ShopPRDList"].map((x) => ShopPrdList.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "ShopID": shopId,
        "PCId": pcId,
        "speciesId": speciesId,
        "SCId": scId,
        "SubCatgName": subCatgName,
        "ShopPRDList": List<dynamic>.from(shopPrdList.map((x) => x.toJson())),
    };
}

class ShopPrdList {
    int shopId;
    int productId;
    String prodName;
    int pcId;
    String pCategName;
    int scId;
    String subCatgName;
    String prodDesc;
    String prodShortDesc;
    String hsinCode;
    String weight;
    String prodImg;
    String prodRate;
    int brandId;

    ShopPrdList({
        this.shopId,
        this.productId,
        this.prodName,
        this.pcId,
        this.pCategName,
        this.scId,
        this.subCatgName,
        this.prodDesc,
        this.prodShortDesc,
        this.hsinCode,
        this.weight,
        this.prodImg,
        this.prodRate,
        this.brandId,
    });

    factory ShopPrdList.fromJson(Map<String, dynamic> json) => ShopPrdList(
        shopId: json["ShopID"],
        productId: json["ProductId"],
        prodName: json["ProdName"],
        pcId: json["PCId"],
        pCategName: json["PCategName"],
        scId: json["SCId"],
        subCatgName: json["SubCatgName"],
        prodDesc: json["ProdDesc"],
        prodShortDesc: json["ProdShortDesc"],
        hsinCode: json["HSINCode"],
        weight: json["Weight"],
        prodImg: json["ProdIMG"],
        prodRate: json["ProdRate"],
        brandId: json["BrandId"],
    );

    Map<String, dynamic> toJson() => {
        "ShopID": shopId,
        "ProductId": productId,
        "ProdName": prodName,
        "PCId": pcId,
        "PCategName": pCategName,
        "SCId": scId,
        "SubCatgName": subCatgName,
        "ProdDesc": prodDesc,
        "ProdShortDesc": prodShortDesc,
        "HSINCode": hsinCode,
        "Weight": weight,
        "ProdIMG": prodImg,
        "ProdRate": prodRate,
        "BrandId": brandId,
    };
}
