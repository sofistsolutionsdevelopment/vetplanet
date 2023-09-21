// To parse this JSON data, do
//
//     final userModel = userModelFromJson(jsonString);

import 'dart:convert';

GroomingModel groomingModelFromJson(String str) => GroomingModel.fromJson(json.decode(str));

String groomingModelToJson(GroomingModel data) => json.encode(data.toJson());

class GroomingModel {

  int PetGroomingId;
  String GroomingCenterName;
  String LoginId;
  String Password;
  String Email;
  String ContactNo;
  String RegisteredAddress;
  String SubscriptionEndDate;
  String Photograph;
  String Description;
  String ShopAddress;
  String Education;
  String Status;
  double Lat;
  double Long;
  int VisitorCount;
  int TotalRating;
  int TotalCommentCount;
  int IsRated;
  String Token;
  int TotalVisitorCount;

  GroomingModel({
    this.PetGroomingId,
    this.GroomingCenterName,
    this.LoginId,
    this.Password,
    this.Email,
    this.ContactNo,
    this.RegisteredAddress,
    this.SubscriptionEndDate,
    this.Photograph,
    this.Description,
    this.ShopAddress,
    this.Status,
    this.Lat,
    this.Long,
    this.VisitorCount,
    this.TotalRating,
    this.TotalCommentCount,
    this.IsRated,
    this.Token,
    this.TotalVisitorCount

  });

  factory GroomingModel.fromJson(Map<String, dynamic> json) => GroomingModel(
      PetGroomingId: json["PetGroomingId"],
      GroomingCenterName: json["GroomingCenterName"],
      LoginId: json["LoginId"],
      Password: json["Password"],
      Email: json["Email"],
      ContactNo: json["ContactNo"],
      RegisteredAddress: json["RegisteredAddress"],
      SubscriptionEndDate: json["SubscriptionEndDate"],
      Photograph: json["Photograph"],
      Description: json["Description"],
      ShopAddress: json["ShopAddress"],
      Status: json["Status"],
      Lat: json["Lat"],
      Long: json["Long"],
      VisitorCount: json["VisitorCount"],
      TotalRating: json["TotalRating"],
      TotalCommentCount: json["TotalCommentCount"],
      IsRated: json["IsRated"],
      Token: json["Token"],
      TotalVisitorCount: json["TotalVisitorCount"],

  );

  Map<String, dynamic> toJson() => {
    "PetGroomingId": PetGroomingId,
    "GroomingCenterName": GroomingCenterName,
    "LoginId": LoginId,
    "Password": Password,
    "Email": Email,
    "ContactNo": ContactNo,
    "RegisteredAddress": RegisteredAddress,
    "SubscriptionEndDate": SubscriptionEndDate,
    "Photograph": Photograph,
    "Description": Description,
    "ShopAddress": ShopAddress,
    "Status": Status,
    "Lat": Lat,
    "Long": Long,
    "VisitorCount": VisitorCount,
    "TotalRating": TotalRating,
    "TotalCommentCount": TotalCommentCount,
    "IsRated": IsRated,
    "Token": Token,
    "TotalVisitorCount": TotalVisitorCount,

  };
}
