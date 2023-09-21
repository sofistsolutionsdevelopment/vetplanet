// To parse this JSON data, do
//
//     final userModel = userModelFromJson(jsonString);

import 'dart:convert';

GroomingServicesModel groomingServicesModelFromJson(String str) => GroomingServicesModel.fromJson(json.decode(str));

String groomingServicesModelToJson(GroomingServicesModel data) => json.encode(data.toJson());

class GroomingServicesModel {
  int ServiceId;
  String Service;
  String Rate;
  bool IsChecked ;

  GroomingServicesModel({
    this.ServiceId,
    this.Service,
    this.Rate,
    this.IsChecked,
  });

  factory GroomingServicesModel.fromJson(Map<String, dynamic> json) => GroomingServicesModel(
      ServiceId: json["ServiceId"],
      Service: json["Service"],
      Rate: json["Rate"],
      IsChecked: false,
  );

  Map<String, dynamic> toJson() => {
    "ServiceId": ServiceId,
    "Service": Service,
    "Rate": Rate,
    "IsChecked": IsChecked,
  };
}
