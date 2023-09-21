// To parse this JSON data, do
//
//     final userModel = userModelFromJson(jsonString);

import 'dart:convert';

NeuroPostureModel neuroPostureModelFromJson(String str) => NeuroPostureModel.fromJson(json.decode(str));

String neuroPostureModelToJson(NeuroPostureModel data) => json.encode(data.toJson());

class NeuroPostureModel {

  int NeuroPostureId;
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


  NeuroPostureModel({
    this.NeuroPostureId,
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

  factory NeuroPostureModel.fromJson(Map<String, dynamic> json) => NeuroPostureModel(
    NeuroPostureId: json["NeuroPostureId"],
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
    "NeuroPostureId": NeuroPostureId,
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
