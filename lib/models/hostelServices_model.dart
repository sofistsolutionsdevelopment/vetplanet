// To parse this JSON data, do
//
//     final userModel = userModelFromJson(jsonString);

import 'dart:convert';

HostelServicesModel hostelServicesModelFromJson(String str) => HostelServicesModel.fromJson(json.decode(str));

String hostelServicesModelToJson(HostelServicesModel data) => json.encode(data.toJson());

class HostelServicesModel {
  int ServiceId;
  int HostelId;
  String Service;
  String ServiceDetails ;
  String Rate;
  bool IsChecked ;

  HostelServicesModel({
    this.ServiceId,
    this.HostelId,
    this.Service,
    this.ServiceDetails,
    this.Rate,
    this.IsChecked,

  });

  factory HostelServicesModel.fromJson(Map<String, dynamic> json) => HostelServicesModel(
      ServiceId: json["ServiceId"],
      HostelId: json["HostelId"],
      Service: json["Service"],
      ServiceDetails: json["ServiceDetails"],
      Rate: json["Rate"],
      IsChecked: false,

  );

  Map<String, dynamic> toJson() => {
    "ServiceId": ServiceId,
    "HostelId": HostelId,
    "Service": Service,
    "ServiceDetails": ServiceDetails,
    "Rate": Rate,
    "IsChecked": IsChecked,

  };
}
