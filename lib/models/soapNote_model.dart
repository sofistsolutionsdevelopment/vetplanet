// To parse this JSON data, do
//
//     final userModel = userModelFromJson(jsonString);

import 'dart:convert';

SOAPNoteModel soapNoteModelFromJson(String str) => SOAPNoteModel.fromJson(json.decode(str));

String soapNoteModelToJson(SOAPNoteModel data) => json.encode(data.toJson());

class SOAPNoteModel {

  int NoteId;
  int PatientId;
  int PatientPetId;
  int VetId;
  String Subjective;
  String Objective;
  String Assessment;
  String Plans;
  String VetName;
  String PetName;
  String PatientName;
  String Date;
  String FromDate;
  String ToDate;
  String SOAPUpload;

  SOAPNoteModel({
    this.NoteId,
    this.PatientId,
    this.PatientPetId,
    this.VetId,
    this.Subjective,
    this.Objective,
    this.Assessment,
    this.Plans,
    this.VetName,
    this.PetName,
    this.PatientName,
    this.Date,
    this.FromDate,
    this.ToDate,
    this.SOAPUpload,
  });

  factory SOAPNoteModel.fromJson(Map<String, dynamic> json) => SOAPNoteModel(
    NoteId: json["NoteId"],
    PatientId: json["PatientId"],
    PatientPetId: json["PatientPetId"],
    VetId: json["VetId"],
    Subjective: json["Subjective"],
    Objective: json["Objective"],
    Assessment: json["Assessment"],
    Plans: json["Plans"],
    VetName: json["VetName"],
    PetName: json["PetName"],
    PatientName: json["PatientName"],
    Date: json["Date"],
    FromDate: json["FromDate"],
    ToDate: json["ToDate"],
    SOAPUpload: json["SOAPUpload"],

  );

  Map<String, dynamic> toJson() => {
    "NoteId": NoteId,
    "PatientId": PatientId,
    "PatientPetId": PatientPetId,
    "VetId": VetId,
    "Subjective": Subjective,
    "Objective": Objective,
    "Assessment": Assessment,
    "Plans": Plans,
    "VetName": VetName,
    "PetName": PetName,
    "PatientName": PatientName,
    "Date": Date,
    "FromDate": FromDate,
    "ToDate": ToDate,
    "SOAPUpload": SOAPUpload,

  };
}
