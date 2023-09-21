// To parse this JSON data, do
//
//     final userModel = userModelFromJson(jsonString);

import 'dart:convert';

ViewGroomingAppointmentResultModel viewGroomingAppointmentResultModelFromJson(String str) => ViewGroomingAppointmentResultModel.fromJson(json.decode(str));

String viewGroomingAppointmentResultModelToJson(ViewGroomingAppointmentResultModel data) => json.encode(data.toJson());

class ViewGroomingAppointmentResultModel {

  int SlotId;
  String SlotTime;
  String SlotDate;
  int PatientId;
  int PetGroomingId;
  String GroomingCenterName;
  int StatusId;
  String Status;



  ViewGroomingAppointmentResultModel({
    this.SlotId,
    this.SlotTime,
    this.SlotDate,
    this.PatientId,
    this.PetGroomingId,
    this.GroomingCenterName,
    this.StatusId,
    this.Status,
  });

  factory ViewGroomingAppointmentResultModel.fromJson(Map<String, dynamic> json) => ViewGroomingAppointmentResultModel(
      SlotId: json["SlotId"],
      SlotTime: json["SlotTime"],
      SlotDate: json["SlotDate"],
      PatientId: json["PatientId"],
      PetGroomingId: json["PetGroomingId"],
      GroomingCenterName: json["GroomingCenterName"],
      StatusId: json["StatusId"],
      Status: json["Status"],
  );

  Map<String, dynamic> toJson() => {
    "SlotId": SlotId,
    "SlotTime": SlotTime,
    "SlotDate": SlotDate,
    "PatientId": PatientId,
    "PetGroomingId": PetGroomingId,
    "GroomingCenterName": GroomingCenterName,
    "StatusId": StatusId,
    "Status": Status,


  };
}
