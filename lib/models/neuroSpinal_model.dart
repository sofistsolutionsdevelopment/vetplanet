// To parse this JSON data, do
//
//     final userModel = userModelFromJson(jsonString);

import 'dart:convert';

NeuroSpinalModel neuroSpinalModelFromJson(String str) => NeuroSpinalModel.fromJson(json.decode(str));

String neuroSpinalModelToJson(NeuroSpinalModel data) => json.encode(data.toJson());

class NeuroSpinalModel {

  int NeuroSpinalId;
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


  NeuroSpinalModel({
    this.NeuroSpinalId,
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

  factory NeuroSpinalModel.fromJson(Map<String, dynamic> json) => NeuroSpinalModel(
    NeuroSpinalId: json["NeuroSpinalId"],
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
    "NeuroSpinalId": NeuroSpinalId,
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
