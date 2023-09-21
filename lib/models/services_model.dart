// To parse this JSON data, do
//
//     final userModel = userModelFromJson(jsonString);

import 'dart:convert';

ServicesModel servicesModelFromJson(String str) => ServicesModel.fromJson(json.decode(str));

String servicesModelToJson(ServicesModel data) => json.encode(data.toJson());

class ServicesModel {
  int ServiceId;
  String ServiceName;
  bool IsChecked ;

  ServicesModel({
    this.ServiceId,
    this.ServiceName,
    this.IsChecked,
  });

  factory ServicesModel.fromJson(Map<String, dynamic> json) => ServicesModel(
      ServiceId: json["ServiceId"],
      ServiceName: json["ServiceName"],
      IsChecked: false,
  );

  Map<String, dynamic> toJson() => {
    "ServiceId": ServiceId,
    "ServiceName": ServiceName,
    "IsChecked": IsChecked,
  };
}
