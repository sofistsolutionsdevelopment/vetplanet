// To parse this JSON data, do
//
//     final userModel = userModelFromJson(jsonString);

import 'dart:convert';

GroomingShopModel groomingShopModelFromJson(String str) => GroomingShopModel.fromJson(json.decode(str));

String groomingShopModelToJson(GroomingShopModel data) => json.encode(data.toJson());

class GroomingShopModel {

  int ShopId;
  int PetGroomingId;
  String ShopName;
  String ShopAddress;
  String ContactNo;


  GroomingShopModel({
    this.ShopId,
    this.PetGroomingId,
    this.ShopName,
    this.ShopAddress,
    this.ContactNo,
  });

  factory GroomingShopModel.fromJson(Map<String, dynamic> json) => GroomingShopModel(
    ShopId: json["ShopId"],
    PetGroomingId: json["PetGroomingId"],
    ShopName: json["ShopName"],
    ShopAddress: json["ShopAddress"],
    ContactNo: json["ContactNo"],
  );

  Map<String, dynamic> toJson() => {
    "ShopId": ShopId,
    "PetGroomingId": PetGroomingId,
    "ShopName": ShopName,
    "ShopAddress": ShopAddress,
    "ContactNo": ContactNo,
  };
}
