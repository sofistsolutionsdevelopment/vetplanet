// To parse this JSON data, do
//
//     final userModel = userModelFromJson(jsonString);

import 'dart:convert';

VetProfileDetailsModel vetProfileDetailsModelFromJson(String str) => VetProfileDetailsModel.fromJson(json.decode(str));

String vetProfileDetailsModelToJson(VetProfileDetailsModel data) => json.encode(data.toJson());

class VetProfileDetailsModel {

  int UserKey;
  String User_Login;
  String User_Name;
  String User_EMail;
  String User_ContactNo;
  String Gender;
  String Photograph;
  String DOB;
  String Address;
  String Service;
  String TotalYearOfExp;
  String Education;
  String Description;
  String Specialization;
  String AwardRecognition;
  String RegistrationNo;
  double ConsultationFees;
  double Lat;
  double Long;
  int VisitorCount;
  int TotalRating;
  int TotalCommentCount;
  int IsRated;
  String Token;
  int TotalVisitorCount;

  VetProfileDetailsModel({
    this.UserKey,
    this.User_Login,
    this.User_Name,
    this.User_EMail,
    this.User_ContactNo,
    this.Gender,
    this.Photograph,
    this.DOB,
    this.Address,
    this.Service,
    this.TotalYearOfExp,
    this.Education,
    this.Description,
    this.Specialization,
    this.AwardRecognition,
    this.RegistrationNo,
    this.ConsultationFees,
    this.Lat,
    this.Long,
    this.VisitorCount,
    this.TotalRating,
    this.TotalCommentCount,
    this.IsRated,
    this.Token,
    this.TotalVisitorCount

  });

  factory VetProfileDetailsModel.fromJson(Map<String, dynamic> json) => VetProfileDetailsModel(
    UserKey: json["UserKey"],
    User_Login: json["User_Login"],
    User_Name: json["User_Name"],
    User_EMail: json["User_EMail"],
    User_ContactNo: json["User_ContactNo"],
    Gender: json["Gender"],
    Photograph: json["Photograph"],
    DOB: json["DOB"],
    Address: json["Address"],
    Service: json["Service"],
    TotalYearOfExp: json["TotalYearOfExp"],
    Education: json["Education"],
    Description: json["Description"],
    Specialization: json["Specialization"],
    AwardRecognition: json["AwardRecognition"],
    RegistrationNo: json["RegistrationNo"],
    ConsultationFees: json["ConsultationFees"],
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
    "UserKey": UserKey,
    "User_Login": User_Login,
    "User_Name": User_Name,
    "User_EMail": User_EMail,
    "User_ContactNo": User_ContactNo,
    "Gender": Gender,
    "Photograph": Photograph,
    "DOB": DOB,
    "Address": Address,
    "Service": Service,
    "TotalYearOfExp": TotalYearOfExp,
    "Education": Education,
    "Description": Description,
    "Specialization": Specialization,
    "AwardRecognition": AwardRecognition,
    "RegistrationNo": RegistrationNo,
    "ConsultationFees": ConsultationFees,
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
