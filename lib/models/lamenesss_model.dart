// To parse this JSON data, do
//
//     final userModel = userModelFromJson(jsonString);

import 'dart:convert';

LamenesssModel lamenesssModelFromJson(String str) => LamenesssModel.fromJson(json.decode(str));

String lamenesssModelToJson(LamenesssModel data) => json.encode(data.toJson());

class LamenesssModel {

  int LamenessId;
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


  LamenesssModel({
    this.LamenessId,
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

  factory LamenesssModel.fromJson(Map<String, dynamic> json) => LamenesssModel(
    LamenessId: json["LamenessId"],
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
    "LamenessId": LamenessId,
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
