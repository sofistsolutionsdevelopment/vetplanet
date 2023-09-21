// To parse this JSON data, do
//
//     final userModel = userModelFromJson(jsonString);

import 'dart:convert';

OPHTOModel ophtoModelFromJson(String str) => OPHTOModel.fromJson(json.decode(str));

String opthoModelToJson(OPHTOModel data) => json.encode(data.toJson());

class OPHTOModel {

  int OpthoId;
  int PatientId;
  int PatientPetId;
  int VetId;
  int QuestionId;
  String Name;
  String Entropion;
  String Ectropion;
  String Normal;
  String Abnormal;
  String Comments;
  String VetName;
  String PetName;
  String PatientName;
  String Date;
  String FromDate;
  String ToDate;
  String Options;

  OPHTOModel({
    this.OpthoId,
    this.PatientId,
    this.PatientPetId,
    this.VetId,
    this.QuestionId,
    this.Name,
    this.Entropion,
    this.Ectropion,
    this.Normal,
    this.Abnormal,
    this.Comments,
    this.VetName,
    this.PetName,
    this.PatientName,
    this.Date,
    this.FromDate,
    this.ToDate,
    this.Options,
  });

  factory OPHTOModel.fromJson(Map<String, dynamic> json) => OPHTOModel(
    OpthoId: json["OpthoId"],
    PatientId: json["PatientId"],
    PatientPetId: json["PatientPetId"],
    VetId: json["VetId"],
    QuestionId: json["QuestionId"],
    Name: json["Name"],
    Entropion: json["Entropion"],
    Ectropion: json["Ectropion"],
    Normal: json["Normal"],
    Abnormal: json["Abnormal"],
    Comments: json["Comments"],
    VetName: json["VetName"],
    PetName: json["PetName"],
    PatientName: json["PatientName"],
    Date: json["Date"],
    FromDate: json["FromDate"],
    ToDate: json["ToDate"],
    Options: json["Options"],
  );

  Map<String, dynamic> toJson() => {
    "OpthoId": OpthoId,
    "PatientId": PatientId,
    "PatientPetId": PatientPetId,
    "VetId": VetId,
    "QuestionId": QuestionId,
    "Name": Name,
    "Entropion": Entropion,
    "Ectropion": Ectropion,
    "Normal": Normal,
    "Abnormal": Abnormal,
    "Comments": Comments,
    "VetName": VetName,
    "PetName": PetName,
    "PatientName": PatientName,
    "Date": Date,
    "FromDate": FromDate,
    "ToDate": ToDate,
    "Options": Options,

  };
}
