// To parse this JSON data, do
//
//     final userModel = userModelFromJson(jsonString);

import 'dart:convert';

HostelModel hostelModelFromJson(String str) => HostelModel.fromJson(json.decode(str));

String hostelModelToJson(HostelModel data) => json.encode(data.toJson());

class HostelModel {

  int HostelId;
  int HostelOwnerId;
  String HostelName;
  String HostelOwnerName;
  String HostelAddress;
  String ContactNo;
  String ContactPerson;
  String Description;
  String Amenities;
  String Timing;
  double Lat;
  double Long;
  int VisitorCount;
  int IsRated;
  int PatientId;
  int TotalCommentCount;
  int TotalRating;
  int TotalVisitorCount;
  String Token;
  String Logo;


  HostelModel({
    this.HostelId,
    this.HostelOwnerId,
    this.HostelName,
    this.HostelOwnerName,
    this.HostelAddress,
    this.ContactNo,
    this.ContactPerson,
    this.Description,
    this.Amenities,
    this.Timing,
    this.Lat,
    this.Long,
    this.VisitorCount,
    this.IsRated,
    this.PatientId,
    this.TotalCommentCount,
    this.TotalRating,
    this.TotalVisitorCount,
    this.Token,
    this.Logo,


  });

  factory HostelModel.fromJson(Map<String, dynamic> json) => HostelModel(
    HostelId: json["HostelId"],
    HostelOwnerId: json["HostelOwnerId"],
    HostelName: json["HostelName"],
    HostelOwnerName: json["HostelOwnerName"],
    HostelAddress: json["HostelAddress"],
    ContactNo: json["ContactNo"],
    ContactPerson: json["ContactPerson"],
    Description: json["Description"],
    Amenities: json["Amenities"],
    Timing: json["Timing"],
    Lat: json["Lat"],
    Long: json["Long"],
    VisitorCount: json["VisitorCount"],
    IsRated: json["IsRated"],
    PatientId: json["PatientId"],
    TotalCommentCount: json["TotalCommentCount"],
    TotalRating: json["TotalRating"],
    TotalVisitorCount: json["TotalVisitorCount"],
    Token: json["Token"],
    Logo: json["Logo"],
  );

  Map<String, dynamic> toJson() => {
    "HostelId": HostelId,
    "HostelOwnerId": HostelOwnerId,
    "HostelName": HostelName,
    "HostelOwnerName": HostelOwnerName,
    "HostelAddress": HostelAddress,
    "ContactNo": ContactNo,
    "ContactPerson": ContactPerson,
    "Description": Description,
    "Amenities": Amenities,
    "Timing": Timing,
    "Lat": Lat,
    "Long": Long,
    "VisitorCount": VisitorCount,
    "IsRated": IsRated,
    "PatientId": PatientId,
    "TotalCommentCount": TotalCommentCount,
    "TotalRating": TotalRating,
    "TotalVisitorCount": TotalVisitorCount,
    "Token": Token,
    "Logo": Logo,


  };
}
