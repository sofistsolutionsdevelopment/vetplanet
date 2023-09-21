// To parse this JSON data, do
//
//     final userModel = userModelFromJson(jsonString);

import 'dart:convert';

DermatoModel dermatoModelFromJson(String str) => DermatoModel.fromJson(json.decode(str));

String dermatoModelToJson(DermatoModel data) => json.encode(data.toJson());

class DermatoModel {

  int DermatoId;
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


  DermatoModel({
    this.DermatoId,
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

  factory DermatoModel.fromJson(Map<String, dynamic> json) => DermatoModel(
  DermatoId: json["DermatoId"],
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
    "DermatoId": DermatoId,
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
