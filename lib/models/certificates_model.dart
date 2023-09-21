// To parse this JSON data, do
//
//     final userModel = userModelFromJson(jsonString);

import 'dart:convert';

CertificatesModel certificatesModelFromJson(String str) => CertificatesModel.fromJson(json.decode(str));

String certificatesModelToJson(CertificatesModel data) => json.encode(data.toJson());

class CertificatesModel {

  int PetCertificateId;
  int VetId;
  int PatientId;
  int PatientPetId;
  int CertificateId;
  String CertificatePath;
  String VetName;
  String PatientName;
  String PetName;
  String Date;
  String CertificateType;

  CertificatesModel({
    this.PetCertificateId,
    this.VetId,
    this.PatientId,
    this.PatientPetId,
    this.CertificateId,
    this.CertificatePath,
    this.VetName,
    this.PatientName,
    this.PetName,
    this.Date,
    this.CertificateType
  });

  factory CertificatesModel.fromJson(Map<String, dynamic> json) => CertificatesModel(
    PetCertificateId: json["PetCertificateId"],
    VetId: json["VetId"],
    PatientId: json["PatientId"],
    PatientPetId: json["PatientPetId"],
    CertificateId: json["CertificateId"],
    CertificatePath: json["CertificatePath"],
    VetName: json["VetName"],
    PatientName: json["PatientName"],
    PetName: json["PetName"],
    Date: json["Date"],
    CertificateType: json["CertificateType"],

  );

  Map<String, dynamic> toJson() => {
    "PetCertificateId": PetCertificateId,
    "VetId": VetId,
    "PatientId": PatientId,
    "PatientPetId": PatientPetId,
    "CertificateId": CertificateId,
    "CertificatePath": CertificatePath,
    "VetName": VetName,
    "PatientName": PatientName,
    "PetName": PetName,
    "Date": Date,
    "CertificateType": CertificateType,

  };
}