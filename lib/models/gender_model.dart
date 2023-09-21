// To parse this JSON data, do
//
//     final userModel = userModelFromJson(jsonString);

import 'dart:convert';

GenderResultModel genderResultModelFromJson(String str) => GenderResultModel.fromJson(json.decode(str));

String genderResultModelToJson(GenderResultModel data) => json.encode(data.toJson());

class GenderResultModel {
  int GenderId;
  String Gender;


  GenderResultModel({
    this.GenderId,
    this.Gender,

  });

  factory GenderResultModel.fromJson(Map<String, dynamic> json) => GenderResultModel(
      GenderId: json["GenderId"],
      Gender: json["Gender"]
  );

  Map<String, dynamic> toJson() => {
    "GenderId": GenderId,
    "Gender": Gender,

  };
}
