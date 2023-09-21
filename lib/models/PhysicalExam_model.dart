// To parse this JSON data, do
//
//     final userModel = userModelFromJson(jsonString);

import 'dart:convert';

PhysicalExamModel physicalExamModelFromJson(String str) => PhysicalExamModel.fromJson(json.decode(str));

String physicalExamModelToJson(PhysicalExamModel data) => json.encode(data.toJson());

class PhysicalExamModel {

  int VetExamId;
  int PatientId;
  int PatientPetId;
  int VetId;
  String Weight;
  double Temperature;
  String TemperatureC;
  double HeartRate;
  double RespirationRate;
  double BPSystolic;
  double BPDiastolic;
  double CapillaryRefillTime;
  String MucousMembrane;
  String VetName;
  String PetName;
  String PatientName;
  String Date;
  String FromDate;
  String ToDate;

  PhysicalExamModel({
    this.VetExamId,
    this.PatientId,
    this.PatientPetId,
    this.VetId,
    this.Weight,
    this.Temperature,
    this.TemperatureC,
    this.HeartRate,
    this.RespirationRate,
    this.BPSystolic,
    this.BPDiastolic,
    this.CapillaryRefillTime,
    this.MucousMembrane,
    this.VetName,
    this.PetName,
    this.PatientName,
    this.Date,
    this.FromDate,
    this.ToDate,
  });

  factory PhysicalExamModel.fromJson(Map<String, dynamic> json) => PhysicalExamModel(
  VetExamId: json["VetExamId"],
    PatientId: json["PatientId"],
    PatientPetId: json["PatientPetId"],
    VetId: json["VetId"],
    Weight: json["Weight"],
    Temperature: json["Temperature"],
    TemperatureC: json["TemperatureC"],
    HeartRate: json["HeartRate"],
    RespirationRate: json["RespirationRate"],
    BPSystolic: json["BPSystolic"],
    BPDiastolic: json["BPDiastolic"],
    CapillaryRefillTime: json["CapillaryRefillTime"],
    MucousMembrane: json["MucousMembrane"],
    VetName: json["VetName"],
    PetName: json["PetName"],
    PatientName: json["PatientName"],
    Date: json["Date"],
    FromDate: json["FromDate"],
    ToDate: json["ToDate"],
  );

  Map<String, dynamic> toJson() => {
    "VetExamId": VetExamId,
    "PatientId": PatientId,
    "PatientPetId": PatientPetId,
    "VetId": VetId,
    "Weight": Weight,
    "Temperature": Temperature,
    "TemperatureC": TemperatureC,
    "HeartRate": HeartRate,
    "RespirationRate": RespirationRate,
    "BPSystolic": BPSystolic,
    "BPDiastolic": BPDiastolic,
    "CapillaryRefillTime": CapillaryRefillTime,
    "MucousMembrane": MucousMembrane,
    "VetName": VetName,
    "PetName": PetName,
    "PatientName": PatientName,
    "Date": Date,
    "FromDate": FromDate,
    "ToDate": ToDate,
  };
}