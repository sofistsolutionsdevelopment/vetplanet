// To parse this JSON data, do
//
//     final userModel = userModelFromJson(jsonString);

import 'dart:convert';

ClientProfileModel clientProfileModelFromJson(String str) => ClientProfileModel.fromJson(json.decode(str));

String clientProfileModelToJson(ClientProfileModel data) => json.encode(data.toJson());

class ClientProfileModel {

  int PatientId;
  int VetId;
  String UserName;
  String ContactNo;
  String Password;
  String ADDRESS;
  String AlternateContactNo;
  String Email;
  String DOB;
  String Token;
  String ImeiNo;
  String UserType;
  String CREATEDON;


  ClientProfileModel({
    this.PatientId,
    this.VetId,
    this.UserName,
    this.ContactNo,
    this.Password,
    this.ADDRESS,
    this.AlternateContactNo,
    this.Email,
    this.DOB,
    this.Token,
    this.UserType,
    this.ImeiNo,
    this.CREATEDON,
  });

  factory ClientProfileModel.fromJson(Map<String, dynamic> json) => ClientProfileModel(
    PatientId: json["PatientId"],
    VetId: json["VetId"],
    UserName: json["UserName"],
    ContactNo: json["ContactNo"],
    Password: json["Password"],
    ADDRESS: json["ADDRESS"],
    AlternateContactNo: json["AlternateContactNo"],
    Email: json["Email"],
    DOB: json["DOB"],
    Token: json["Token"],
    UserType: json["UserType"],
    ImeiNo: json["ImeiNo"],
    CREATEDON: json["CREATEDON"],
  );

  Map<String, dynamic> toJson() => {
    "PatientId": PatientId,
    "VetId": VetId,
    "UserName": UserName,
    "ContactNo": ContactNo,
    "Password": Password,
    "ADDRESS": ADDRESS,
    "AlternateContactNo": AlternateContactNo,
    "Email": Email,
    "DOB": DOB,
    "Token": Token,
    "ImeiNo": ImeiNo,
    "UserType": UserType,
    "CREATEDON": CREATEDON,

  };
}
