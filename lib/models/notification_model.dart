// To parse this JSON data, do
//
//     final userModel = userModelFromJson(jsonString);

import 'dart:convert';

NotificationModel notificationModelFromJson(String str) => NotificationModel.fromJson(json.decode(str));

String notificationModelToJson(NotificationModel data) => json.encode(data.toJson());

class NotificationModel {

  int FeedbackId;
  int PatientId;
  int VetId;
  int PetGroomingId;
  int ReadFlg;
  String MsgFrom;
  String Feedback;
  String Date;
  int NotificationCount;


  NotificationModel({
    this.FeedbackId,
    this.PatientId,
    this.VetId,
    this.PetGroomingId,
    this.ReadFlg,
    this.MsgFrom,
    this.Feedback,
    this.Date,
    this.NotificationCount,
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json) => NotificationModel(
    FeedbackId: json["FeedbackId"],
    PatientId: json["PatientId"],
    VetId: json["VetId"],
    PetGroomingId: json["PetGroomingId"],
    ReadFlg: json["ReadFlg"],
    MsgFrom: json["MsgFrom"],
    Feedback: json["Feedback"],
    Date: json["Date"],
    NotificationCount: json["NotificationCount"],
  );

  Map<String, dynamic> toJson() => {
    "FeedbackId": FeedbackId,
    "PatientId": PatientId,
    "VetId": VetId,
    "PetGroomingId": PetGroomingId,
    "ReadFlg": ReadFlg,
    "MsgFrom": MsgFrom,
    "Feedback": Feedback,
    "Date": Date,
    "NotificationCount": NotificationCount,
  };
}
