// To parse this JSON data, do
//
//     final userModel = userModelFromJson(jsonString);

import 'dart:convert';

ViewAppointmentResultModel viewappointmentresultModelFromJson(String str) => ViewAppointmentResultModel.fromJson(json.decode(str));

String viewappointmentresultModelToJson(ViewAppointmentResultModel data) => json.encode(data.toJson());

class ViewAppointmentResultModel {

  int SlotId;
  String SlotTime;
  String SlotDate;
  int PatientId;
  int VetId;
  String UserName;
  int StatusId;
  String Status;



  ViewAppointmentResultModel({
    this.SlotId,
    this.SlotTime,
    this.SlotDate,
    this.PatientId,
    this.VetId,
    this.UserName,
    this.StatusId,
    this.Status,
  });

  factory ViewAppointmentResultModel.fromJson(Map<String, dynamic> json) => ViewAppointmentResultModel(
      SlotId: json["SlotId"],
      SlotTime: json["SlotTime"],
      SlotDate: json["SlotDate"],
      PatientId: json["PatientId"],
      VetId: json["VetId"],
      UserName: json["UserName"],
      StatusId: json["StatusId"],
      Status: json["Status"],
  );

  Map<String, dynamic> toJson() => {
    "SlotId": SlotId,
    "SlotTime": SlotTime,
    "SlotDate": SlotDate,
    "PatientId": PatientId,
    "VetId": VetId,
    "UserName": UserName,
    "StatusId": StatusId,
    "Status": Status,


  };
}
