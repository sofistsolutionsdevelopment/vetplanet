// To parse this JSON data, do
//
//     final userModel = userModelFromJson(jsonString);

import 'dart:convert';

AppointmentSlotModel appointmentSlotModelFromJson(String str) => AppointmentSlotModel.fromJson(json.decode(str));

String appointmentSlotModelToJson(AppointmentSlotModel data) => json.encode(data.toJson());

class AppointmentSlotModel {

  int SId;
  String SlotDate;
  String SlotStart;
  String SlotEnd;
  int IfAvail;
  int IfExist;
  int DayId;
  String SelectedDate;
  int VetId;
  int PatientId;
  int IsBooked;


  AppointmentSlotModel({
    this.SId,
    this.SlotDate,
    this.SlotStart,
    this.SlotEnd,
    this.IfAvail,
    this.IfExist,
    this.DayId,
    this.SelectedDate,
    this.VetId,
    this.PatientId,
    this.IsBooked,
  });

  factory AppointmentSlotModel.fromJson(Map<String, dynamic> json) => AppointmentSlotModel(
  SId: json["SId"],
  SlotDate: json["SlotDate"],
  SlotStart: json["SlotStart"],
  SlotEnd: json["SlotEnd"],
  IfAvail: json["IfAvail"],
  IfExist: json["IfExist"],
  DayId: json["DayId"],
  SelectedDate: json["SelectedDate"],
  VetId: json["VetId"],
  PatientId: json["PatientId"],
  IsBooked: json["IsBooked"],
  );

  Map<String, dynamic> toJson() => {
    "SId": SId,
    "SlotDate": SlotDate,
    "SlotStart": SlotStart,
    "SlotEnd": SlotEnd,
    "IfAvail": IfAvail,
    "IfExist": IfExist,
    "DayId": DayId,
    "SelectedDate": SelectedDate,
    "VetId": VetId,
    "PatientId": PatientId,
    "IsBooked": IsBooked,

  };
}
