// To parse this JSON data, do
//
//     final userModel = userModelFromJson(jsonString);

import 'dart:convert';

ViewHostelBookingResultModel viewHostelBookingResultModelFromJson(String str) => ViewHostelBookingResultModel.fromJson(json.decode(str));

String viewHostelBookingResultModelToJson(ViewHostelBookingResultModel data) => json.encode(data.toJson());

class ViewHostelBookingResultModel {

    int HostelSlotId;
    int HostelId;
    String HostelName;
    int PatientId;
    String FromDate;
    String ToDate;
    int StatusId;
    String Status;

  ViewHostelBookingResultModel({
    this.HostelSlotId,
    this.HostelId,
    this.HostelName,
    this.PatientId,
    this.FromDate,
    this.ToDate,
    this.StatusId,
    this.Status,
  });

  factory ViewHostelBookingResultModel.fromJson(Map<String, dynamic> json) => ViewHostelBookingResultModel(
      HostelSlotId: json["HostelSlotId"],
      HostelId: json["HostelId"],
      HostelName: json["HostelName"],
      PatientId: json["PatientId"],
      FromDate: json["FromDate"],
      ToDate: json["ToDate"],
      StatusId: json["StatusId"],
      Status: json["Status"],
  );

  Map<String, dynamic> toJson() => {
    "HostelSlotId": HostelSlotId,
    "HostelId": HostelId,
    "HostelName": HostelName,
    "PatientId": PatientId,
    "FromDate": FromDate,
    "ToDate": ToDate,
    "StatusId": StatusId,
    "Status": Status,
  };
}
