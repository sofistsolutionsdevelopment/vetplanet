// To parse this JSON data, do
//
//     final userModel = userModelFromJson(jsonString);

import 'dart:convert';

CertificatesTypeModel certificatesTypeModelFromJson(String str) => CertificatesTypeModel.fromJson(json.decode(str));

String certificatesTypeModelToJson(CertificatesTypeModel data) => json.encode(data.toJson());

class CertificatesTypeModel {

  int CertificateId;
  String CertificateType;


  CertificatesTypeModel({
    this.CertificateId,
    this.CertificateType,
  });

  factory CertificatesTypeModel.fromJson(Map<String, dynamic> json) => CertificatesTypeModel(
    CertificateId: json["CertificateId"],
    CertificateType: json["CertificateType"],
  );

  Map<String, dynamic> toJson() => {
    "CertificateId": CertificateId,
    "CertificateType": CertificateType,
  };
}