// To parse this JSON data, do
//
//     final userModel = userModelFromJson(jsonString);

import 'dart:convert';

PrescriptionNoteModel prescriptionNoteModelFromJson(String str) => PrescriptionNoteModel.fromJson(json.decode(str));

String prescriptionNoteModelToJson(PrescriptionNoteModel data) => json.encode(data.toJson());

class PrescriptionNoteModel {

  int PrescriptionId;
  int PatientId;
  int PatientPetId;
  int VetId;
  String Prescription;
  String Dosage;
  String Duration;
  String Remarks;
  String VetName;
  String PetName;
  String PatientName;
  String Date;
  String FromDate;
  String ToDate;
  String PrescriptionUpload;

  PrescriptionNoteModel({
    this.PrescriptionId,
    this.PatientId,
    this.PatientPetId,
    this.VetId,
    this.Prescription,
    this.Dosage,
    this.Duration,
    this.Remarks,
    this.VetName,
    this.PetName,
    this.PatientName,
    this.Date,
    this.FromDate,
    this.ToDate,
    this.PrescriptionUpload,
  });

  factory PrescriptionNoteModel.fromJson(Map<String, dynamic> json) => PrescriptionNoteModel(
    PrescriptionId: json["PrescriptionId"],
    PatientId: json["PatientId"],
    PatientPetId: json["PatientPetId"],
    VetId: json["VetId"],
    Prescription: json["Prescription"],
    Dosage: json["Dosage"],
    Duration: json["Duration"],
    Remarks: json["Remarks"],
    VetName: json["VetName"],
    PetName: json["PetName"],
    PatientName: json["PatientName"],
    Date: json["Date"],
    FromDate: json["FromDate"],
    ToDate: json["ToDate"],
    PrescriptionUpload: json["PrescriptionUpload"],
  );

  Map<String, dynamic> toJson() => {
    "PrescriptionId": PrescriptionId,
    "PatientId": PatientId,
    "PatientPetId": PatientPetId,
    "VetId": VetId,
    "Prescription": Prescription,
    "Dosage": Dosage,
    "Duration": Duration,
    "Remarks": Remarks,
    "VetName": VetName,
    "PetName": PetName,
    "PatientName": PatientName,
    "Date": Date,
    "FromDate": FromDate,
    "ToDate": ToDate,
    "PrescriptionUpload": PrescriptionUpload,
  };
}