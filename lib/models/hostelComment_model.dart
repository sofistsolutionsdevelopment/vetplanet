// To parse this JSON data, do
//
//     final userModel = userModelFromJson(jsonString);

import 'dart:convert';

HostelCommentModel hostelCommentModelFromJson(String str) => HostelCommentModel.fromJson(json.decode(str));

String hostelCommentModelToJson(HostelCommentModel data) => json.encode(data.toJson());

class HostelCommentModel {

  int CommentId;
  int PatientId;
  int HostelId;
  String PatientName;
  String Comments;


  HostelCommentModel({
    this.CommentId,
    this.PatientId,
    this.HostelId,
    this.PatientName,
    this.Comments,
  });

  factory HostelCommentModel.fromJson(Map<String, dynamic> json) => HostelCommentModel(
    CommentId: json["CommentId"],
    PatientId: json["PatientId"],
    HostelId: json["HostelId"],
    PatientName: json["PatientName"],
    Comments: json["Comments"],
  );

  Map<String, dynamic> toJson() => {
    "CommentId": CommentId,
    "PatientId": PatientId,
    "HostelId": HostelId,
    "PatientName": PatientName,
    "Comments": Comments,
  };
}


