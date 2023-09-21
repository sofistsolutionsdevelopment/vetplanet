// To parse this JSON data, do
//
//     final userModel = userModelFromJson(jsonString);

import 'dart:convert';

ResultModel resultModelFromJson(String str) => ResultModel.fromJson(json.decode(str));

String registrationresultModelToJson(ResultModel data) => json.encode(data.toJson());

class ResultModel {
  int Id;
  String Result;
  String RedirectTo;


  ResultModel({
    this.Id,
    this.Result,
    this.RedirectTo,

  });

  factory ResultModel.fromJson(Map<String, dynamic> json) => ResultModel(
      Id: json["Id"],
      Result: json["Result"],
      RedirectTo: json["RedirectTo"]
  );

  Map<String, dynamic> toJson() => {
    "Id": Id,
    "Result": Result,
    "RedirectTo": RedirectTo,
  };
}
