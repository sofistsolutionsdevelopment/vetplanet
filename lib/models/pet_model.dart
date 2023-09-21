// To parse this JSON data, do
//
//     final userModel = userModelFromJson(jsonString);

import 'dart:convert';

PetModel petModelFromJson(String str) => PetModel.fromJson(json.decode(str));

String petModelToJson(PetModel data) => json.encode(data.toJson());

class PetModel {

  int PatientPetId;
  String PetName;
  String DOB;
  String Age;
  int SpeciesId;
  int BreedId;
  String Color;
  String Gender;
  String Photograph;
  String SpeciesName;
  String BreedName;
  int CREATEDBY;
  String CREATEDON;
  int MODIFIEDBY;
  String MODIFIEDON;
  bool IsChecked ;
  int ServiceCount;
  double TotalServiceRate;
  int HostelServiceCount;
  double TotalHostelServiceRate;


  PetModel({
    this.PatientPetId,
    this.PetName,
    this.DOB,
    this.Age,
    this.SpeciesId,
    this.BreedId,
    this.Color,
    this.Gender,
    this.Photograph,
    this.SpeciesName,
    this.BreedName,
    this.CREATEDBY,
    this.CREATEDON,
    this.MODIFIEDBY,
    this.MODIFIEDON,
    this.IsChecked,
    this.ServiceCount,
    this.TotalServiceRate,
    this.HostelServiceCount,
    this.TotalHostelServiceRate,

  });

  factory PetModel.fromJson(Map<String, dynamic> json) => PetModel(
    PatientPetId: json["PatientPetId"],
    PetName: json["PetName"],
    DOB: json["DOB"],
    Age: json["Age"],
    SpeciesId: json["SpeciesId"],
    BreedId: json["BreedId"],
    Color: json["Color"],
    Gender: json["Gender"],
    Photograph: json["Photograph"],
    SpeciesName: json["SpeciesName"],
    BreedName: json["BreedName"],
    CREATEDBY: json["CREATEDBY"],
    CREATEDON: json["CREATEDON"],
    MODIFIEDBY: json["MODIFIEDBY"],
    MODIFIEDON: json["MODIFIEDON"],
    IsChecked: false,
    ServiceCount: json["ServiceCount"],
    TotalServiceRate: json["TotalServiceRate"],
    HostelServiceCount: json["HostelServiceCount"],
    TotalHostelServiceRate: json["TotalHostelServiceRate"],

  );

  Map<String, dynamic> toJson() => {
    "PatientPetId": PatientPetId,
    "PetName": PetName,
    "DOB": DOB,
    "Age": Age,
    "SpeciesId": SpeciesId,
    "BreedId": BreedId,
    "Color": Color,
    "Gender": Gender,
    "Photograph": Photograph,
    "SpeciesName": SpeciesName,
    "BreedName": BreedName,
    "CREATEDBY": CREATEDBY,
    "CREATEDON": CREATEDON,
    "MODIFIEDBY": MODIFIEDBY,
    "MODIFIEDON": MODIFIEDON,
    "IsChecked": IsChecked,
    "ServiceCount": ServiceCount,
    "TotalServiceRate": TotalServiceRate,
    "HostelServiceCount": HostelServiceCount,
    "TotalHostelServiceRate": TotalHostelServiceRate,


  };
}
