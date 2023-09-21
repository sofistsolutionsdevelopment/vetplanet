// To parse this JSON data, do
//
//     final userModel = userModelFromJson(jsonString);

import 'dart:convert';

DentalModel dentalModelFromJson(String str) => DentalModel.fromJson(json.decode(str));

String dentalModelToJson(DentalModel data) => json.encode(data.toJson());

class DentalModel {

  int DentalId;
  int PatientId;
  int PatientPetId;
  int VetId;
  int QuestionId;
  String Questions;
  String Options;
  String Comments;
  String Date;
  String FromDate;
  String ToDate;


  DentalModel({
    this.DentalId,
    this.PatientId,
    this.PatientPetId,
    this.VetId,
    this.QuestionId,
    this.Questions,
    this.Options,
    this.Comments,
    this.Date,
    this.FromDate,
    this.ToDate,
  });

  factory DentalModel.fromJson(Map<String, dynamic> json) => DentalModel(
    DentalId: json["DentalId"],
    PatientId: json["PatientId"],
    PatientPetId: json["PatientPetId"],
    VetId: json["VetId"],
    QuestionId: json["QuestionId"],
    Questions: json["Questions"],
    Options: json["Options"],
    Comments: json["Comments"],
    Date: json["Date"],
    FromDate: json["FromDate"],
    ToDate: json["ToDate"],
  );

  Map<String, dynamic> toJson() => {
    "DentalId": DentalId,
    "PatientId": PatientId,
    "PatientPetId": PatientPetId,
    "VetId": VetId,
    "QuestionId": QuestionId,
    "Questions": Questions,
    "Options": Options,
    "Comments": Comments,
    "Date": Date,
    "FromDate": FromDate,
    "ToDate": ToDate,
  };
}
