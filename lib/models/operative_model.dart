// To parse this JSON data, do
//
//     final userModel = userModelFromJson(jsonString);

import 'dart:convert';

OperativeModel operativeModelFromJson(String str) => OperativeModel.fromJson(json.decode(str));

String operativeModelToJson(OperativeModel data) => json.encode(data.toJson());

class OperativeModel {

  int OperativeReportId;
  int PatientId;
  int PatientPetId;
  int VetId;
  int QuestionId;
  String Question;
  String Options;
  String Comments;
  String VetName;
  String PetName;
  String PatientName;
  String Date;
  String FromDate;
  String ToDate;

  OperativeModel({
    this.OperativeReportId,
    this.PatientId,
    this.PatientPetId,
    this.VetId,
    this.QuestionId,
    this.Question,
    this.Options,
    this.Comments,
    this.VetName,
    this.PetName,
    this.PatientName,
    this.Date,
    this.FromDate,
    this.ToDate,
  });

  factory OperativeModel.fromJson(Map<String, dynamic> json) => OperativeModel(
    OperativeReportId: json["OperativeReportId"],
    PatientId: json["PatientId"],
    PatientPetId: json["PatientPetId"],
    VetId: json["VetId"],
    QuestionId: json["QuestionId"],
    Question: json["Question"],
    Options: json["Options"],
    Comments: json["Comments"],
    VetName: json["VetName"],
    PetName: json["PetName"],
    PatientName: json["PatientName"],
    Date: json["Date"],
    FromDate: json["FromDate"],
    ToDate: json["ToDate"],
  );

  Map<String, dynamic> toJson() => {
    "OperativeReportId": OperativeReportId,
    "PatientId": PatientId,
    "PatientPetId": PatientPetId,
    "VetId": VetId,
    "QuestionId": QuestionId,
    "Question": Question,
    "Options": Options,
    "Comments": Comments,
    "VetName": VetName,
    "PetName": PetName,
    "PatientName": PatientName,
    "Date": Date,
    "FromDate": FromDate,
    "ToDate": ToDate,
  };
}
