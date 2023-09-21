// To parse this JSON data, do
//
//     final userModel = userModelFromJson(jsonString);

import 'dart:convert';

PaymentReportModel paymentReportModelFromJson(String str) => PaymentReportModel.fromJson(json.decode(str));

String paymentReportModelToJson(PaymentReportModel data) => json.encode(data.toJson());

class PaymentReportModel {

  String Date;
  String UserName;
  String PetNames;
  double Amount;


  PaymentReportModel({
    this.Date,
    this.UserName,
    this.PetNames,
    this.Amount,
  });

  factory PaymentReportModel.fromJson(Map<String, dynamic> json) => PaymentReportModel(
    Date: json["Date"],
    UserName: json["UserName"],
    PetNames: json["PetNames"],
    Amount: json["Amount"],
  );

  Map<String, dynamic> toJson() => {
    "Date": Date,
    "UserName": UserName,
    "PetNames": PetNames,
    "Amount": Amount,
  };
}

