// To parse this JSON data, do
//
//     final userModel = userModelFromJson(jsonString);

import 'dart:convert';

PrescriptionResultModel prescriptionModelFromJson(String str) => PrescriptionResultModel.fromJson(json.decode(str));

String prescriptionModelToJson(PrescriptionResultModel data) => json.encode(data.toJson());

class PrescriptionResultModel {

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

  PrescriptionResultModel({
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
  });

  factory PrescriptionResultModel.fromJson(Map<String, dynamic> json) => PrescriptionResultModel(
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
  };
}
