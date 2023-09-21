// To parse this JSON data, do
//
//     final productDetail = productDetailFromJson(jsonString);

import 'dart:convert';

List<ProductDetail> productDetailFromJson(String str) => List<ProductDetail>.from(json.decode(str).map((x) => ProductDetail.fromJson(x)));

String productDetailToJson(List<ProductDetail> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class ProductDetail {
    int shopId;
    int productId;
    int speciesId;
    int pcId;
    int scId;
    String prodName;
    String prodDesc;
    String prodShortDesc;
    String hsinCode;
    String weight;
    String prodImg;
    String prodRate;
    int bmid;

    ProductDetail({
        this.shopId,
        this.productId,
        this.speciesId,
        this.pcId,
        this.scId,
        this.prodName,
        this.prodDesc,
        this.prodShortDesc,
        this.hsinCode,
        this.weight,
        this.prodImg,
        this.prodRate,
        this.bmid,
    });

    factory ProductDetail.fromJson(Map<String, dynamic> json) => ProductDetail(
        shopId: json["ShopID"],
        productId: json["ProductId"],
        speciesId: json["speciesId"],
        pcId: json["PCId"],
        scId: json["SCId"],
        prodName: json["ProdName"],
        prodDesc: json["ProdDesc"],
        prodShortDesc: json["ProdShortDesc"],
        hsinCode: json["HSINCode"],
        weight: json["Weight"],
        prodImg: json["ProdIMG"],
        prodRate: json["ProdRate"],
        bmid: json["BMID"],
    );

    Map<String, dynamic> toJson() => {
        "ShopID": shopId,
        "ProductId": productId,
        "speciesId": speciesId,
        "PCId": pcId,
        "SCId": scId,
        "ProdName": prodName,
        "ProdDesc": prodDesc,
        "ProdShortDesc": prodShortDesc,
        "HSINCode": hsinCode,
        "Weight": weight,
        "ProdIMG": prodImg,
        "ProdRate": prodRate,
        "BMID": bmid,
    };
}
