// To parse this JSON data, do
//
//     final userModel = userModelFromJson(jsonString);

import 'dart:convert';

BreedResultModel breedResultModelFromJson(String str) => BreedResultModel.fromJson(json.decode(str));

String breedResultModelToJson(BreedResultModel data) => json.encode(data.toJson());

class BreedResultModel {
  int BreedId;
  int speciesId;
  String BreedName;


  BreedResultModel({
    this.BreedId,
    this.speciesId,
    this.BreedName,

  });

  factory BreedResultModel.fromJson(Map<String, dynamic> json) => BreedResultModel(
      BreedId: json["BreedId"],
      speciesId: json["speciesId"],
      BreedName: json["BreedName"]
  );

  Map<String, dynamic> toJson() => {
    "BreedId": BreedId,
    "speciesId": speciesId,
    "BreedName": BreedName,

  };
}
