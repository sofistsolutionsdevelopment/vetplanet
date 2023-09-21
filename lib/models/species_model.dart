// To parse this JSON data, do
//
//     final userModel = userModelFromJson(jsonString);

import 'dart:convert';

SpeciesModel speciesModelFromJson(String str) => SpeciesModel.fromJson(json.decode(str));

String speciesModelToJson(SpeciesModel data) => json.encode(data.toJson());

class SpeciesModel {
  int speciesId;
  String SpeciesName;


  SpeciesModel({
    this.speciesId,
    this.SpeciesName,

  });

  factory SpeciesModel.fromJson(Map<String, dynamic> json) => SpeciesModel(
      speciesId: json["speciesId"],
      SpeciesName: json["SpeciesName"]
  );

  Map<String, dynamic> toJson() => {
    "speciesId": speciesId,
    "SpeciesName": SpeciesName,

  };
}
