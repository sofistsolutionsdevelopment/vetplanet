// To parse this JSON data, do
//
//     final userModel = userModelFromJson(jsonString);

import 'dart:convert';

VaccinationModel vaccinationModelFromJson(String str) => VaccinationModel.fromJson(json.decode(str));

String vaccinationModelToJson(VaccinationModel data) => json.encode(data.toJson());

class VaccinationModel {

  int PatientId;
  int PatientPetId;
  int VetId;
  int ClinicId;
  int ItemId;
  String ClinicName;
  String ItemName;
  String Type;
  String Remarks;
  String NextVaccDate;
  String Date;
  String VaccinatedBy;


  VaccinationModel({
    this.PatientId,
    this.PatientPetId,
    this.VetId,
    this.ClinicId,
    this.ItemId,
    this.ClinicName,
    this.ItemName,
    this.Type,
    this.Remarks,
    this.NextVaccDate,
    this.Date,
    this.VaccinatedBy,


  });

  factory VaccinationModel.fromJson(Map<String, dynamic> json) => VaccinationModel(
    PatientId: json["PatientId"],
    PatientPetId: json["PatientPetId"],
    VetId: json["VetId"],
    ClinicId: json["ClinicId"],
    ItemId: json["ItemId"],
    ClinicName: json["ClinicName"],
    ItemName: json["ItemName"],
    Type: json["Type"],
    Remarks: json["Remarks"],
    NextVaccDate: json["NextVaccDate"],
    Date: json["Date"],
    VaccinatedBy: json["VaccinatedBy"],
  );

  Map<String, dynamic> toJson() => {
    "PatientId": PatientId,
    "PatientPetId": PatientPetId,
    "VetId": VetId,
    "ClinicId": ClinicId,
    "ItemId": ItemId,
    "ClinicName": ClinicName,
    "ItemName": ItemName,
    "Type": Type,
    "Remarks": Remarks,
    "NextVaccDate": NextVaccDate,
    "Date": Date,
    "VaccinatedBy": VaccinatedBy,
  };
}
