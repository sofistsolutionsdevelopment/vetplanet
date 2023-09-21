// To parse this JSON data, do
//
//     final specieslist = specieslistFromJson(jsonString);

import 'dart:convert';

List<Specieslist> specieslistFromJson(String str) => List<Specieslist>.from(json.decode(str).map((x) => Specieslist.fromJson(x)));

String specieslistToJson(List<Specieslist> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Specieslist {
    int speciesId;
    String speciesName;

    Specieslist({
        this.speciesId,
        this.speciesName,
    });

    factory Specieslist.fromJson(Map<String, dynamic> json) => Specieslist(
        speciesId: json["speciesId"],
        speciesName: json["SpeciesName"],
    );

    Map<String, dynamic> toJson() => {
        "speciesId": speciesId,
        "SpeciesName": speciesName,
    };
}
