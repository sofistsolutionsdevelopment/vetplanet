// To parse this JSON data, do
//
//     final userModel = userModelFromJson(jsonString);

import 'dart:convert';

ClinicModel clinicModelFromJson(String str) => ClinicModel.fromJson(json.decode(str));

String clinicModelToJson(ClinicModel data) => json.encode(data.toJson());

class ClinicModel {


  int ClinicId;
  int VetId;
  String ClinicName;
  String ClinicAddress;
  String ClinicContactNo;
  double AppointmentCharges;

  ClinicModel({
    this.ClinicId,
    this.VetId,
    this.ClinicName,
    this.ClinicAddress,
    this.ClinicContactNo,
    this.AppointmentCharges,
  });

  factory ClinicModel.fromJson(Map<String, dynamic> json) => ClinicModel(
    ClinicId: json["ClinicId"],
    VetId: json["VetId"],
    ClinicName: json["ClinicName"],
    ClinicAddress: json["ClinicAddress"],
    ClinicContactNo: json["ClinicContactNo"],
    AppointmentCharges: json["AppointmentCharges"],
  );

  Map<String, dynamic> toJson() => {
    "ClinicId": ClinicId,
    "VetId": VetId,
    "ClinicName": ClinicName,
    "ClinicAddress": ClinicAddress,
    "ClinicContactNo": ClinicContactNo,
    "AppointmentCharges": AppointmentCharges,
  };
}
