// To parse this JSON data, do
//
//     final userModel = userModelFromJson(jsonString);

import 'dart:convert';

GroomingAppointmentSlotModel groomingAppointmentSlotModelFromJson(String str) => GroomingAppointmentSlotModel.fromJson(json.decode(str));

String groomingAppointmentSlotModelToJson(GroomingAppointmentSlotModel data) => json.encode(data.toJson());

class GroomingAppointmentSlotModel {

  int SId;
  String SlotDate;
  String SlotStart;
  String SlotEnd;
  int IfAvail;
  int IfExist;
  int DayId;
  String SelectedDate;
  int ShopId;
  int PatientId;
  int IsBooked;


  GroomingAppointmentSlotModel({
    this.SId,
    this.SlotDate,
    this.SlotStart,
    this.SlotEnd,
    this.IfAvail,
    this.IfExist,
    this.DayId,
    this.SelectedDate,
    this.ShopId,
    this.PatientId,
    this.IsBooked,

  });

  factory GroomingAppointmentSlotModel.fromJson(Map<String, dynamic> json) => GroomingAppointmentSlotModel(
    SId: json["SId"],
    SlotDate: json["SlotDate"],
    SlotStart: json["SlotStart"],
    SlotEnd: json["SlotEnd"],
    IfAvail: json["IfAvail"],
    IfExist: json["IfExist"],
    DayId: json["DayId"],
    SelectedDate: json["SelectedDate"],
    ShopId: json["ShopId"],
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
    "ShopId": ShopId,
    "PatientId": PatientId,
    "IsBooked": IsBooked,

  };
}
