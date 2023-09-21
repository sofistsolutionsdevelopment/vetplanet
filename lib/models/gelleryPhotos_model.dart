// To parse this JSON data, do
//
//     final userModel = userModelFromJson(jsonString);

import 'dart:convert';

GalleryPhotosModel galleryPhotosModelFromJson(String str) => GalleryPhotosModel.fromJson(json.decode(str));

String galleryPhotosModelToJson(GalleryPhotosModel data) => json.encode(data.toJson());

class GalleryPhotosModel {
 // int PhotosId;
  //int HostelId;
  String Photograph;


  GalleryPhotosModel({
   // this.PhotosId,
  //  this.HostelId,
    this.Photograph,

  });

  factory GalleryPhotosModel.fromJson(Map<String, dynamic> json) => GalleryPhotosModel(
    //  PhotosId: json["PhotosId"],
    //  HostelId: json["HostelId"],
      Photograph: json["Photograph"]
  );

  Map<String, dynamic> toJson() => {
   // "PhotosId": PhotosId,
   // "HostelId": HostelId,
    "Photograph": Photograph,

  };
}
