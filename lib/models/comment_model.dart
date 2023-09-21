// To parse this JSON data, do
//
//     final userModel = userModelFromJson(jsonString);

import 'dart:convert';

CommentModel commentModelFromJson(String str) => CommentModel.fromJson(json.decode(str));

String commentModelToJson(CommentModel data) => json.encode(data.toJson());

class CommentModel {

  int CommentId;
  int PatientId;
  int VetId;
  int GroomerId;
  String PatientName;
  String Comments;


  CommentModel({
    this.CommentId,
    this.PatientId,
    this.VetId,
    this.GroomerId,
    this.PatientName,
    this.Comments,
  });

  factory CommentModel.fromJson(Map<String, dynamic> json) => CommentModel(
    CommentId: json["CommentId"],
    PatientId: json["PatientId"],
    VetId: json["VetId"],
    GroomerId: json["GroomerId"],
    PatientName: json["PatientName"],
    Comments: json["Comments"],
  );

  Map<String, dynamic> toJson() => {
    "CommentId": CommentId,
    "PatientId": PatientId,
    "VetId": VetId,
    "GroomerId": GroomerId,
    "PatientName": PatientName,
    "Comments": Comments,
  };
}
