// To parse this JSON data, do
//
//     final placeModel = placeModelFromJson(jsonString);

import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

PlaceModel placeModelFromJson(String str) =>
    PlaceModel.fromJson(json.decode(str));

String placeModelToJson(PlaceModel data) => json.encode(data.toJson());

class PlaceModel {
  final String? userId;
  final String? placeId;
  final String? name;
  final String? mobile;
  final int? categoryId;
  final String? address;
  final String? price;
  final bool? isForSale;
  final bool? isApproved;
  final String? rejectedReason;
  final String? beds;
  final String? bath;
  final String? sqft;
  final String? documentUrl;
  final List<String>? imagesUrl;
  final String? description;
  final double? latitude;
  final double? longitude;
  final Timestamp? createdAt;

  PlaceModel({
    this.userId,
    this.placeId,
    this.name,
    this.mobile,
    this.categoryId,
    this.address,
    this.price,
    this.isForSale,
    this.isApproved,
    this.rejectedReason,
    this.beds,
    this.bath,
    this.sqft,
    this.documentUrl,
    this.imagesUrl,
    this.description,
    this.latitude,
    this.longitude,
    this.createdAt,
  });

  factory PlaceModel.fromJson(Map<String, dynamic> json) => PlaceModel(
        userId: json["user_id"],
        placeId: json["place_id"],
        name: json["name"],
        mobile: json["mobile"],
        categoryId: json["category_id"],
        address: json["address"],
        price: json["price"],
        isForSale: json["isForSale"],
        isApproved: json["isApproved"],
        rejectedReason: json["rejected_reason"],
        beds: json["beds"],
        bath: json["bath"],
        sqft: json["sqft"],
        documentUrl: json["document_url"],
        imagesUrl: List<String>.from(json["images_url"].map((x) => x)),
        description: json["description"],
        latitude: json["latitude"]?.toDouble(),
        longitude: json["longitude"]?.toDouble(),
        createdAt: json["created_at"] != null
            ? Timestamp.fromMillisecondsSinceEpoch(json["created_at"])
            : null,
      );

  Map<String, dynamic> toJson() => {
        "user_id": userId,
        "place_id": placeId,
        "name": name,
        "mobile": mobile,
        "category_id": categoryId,
        "address": address,
        "price": price,
        "isForSale": isForSale,
        "isApproved": isApproved,
        "rejected_reason": rejectedReason,
        "beds": beds,
        "bath": bath,
        "sqft": sqft,
        "document_url": documentUrl,
        "images_url": imagesUrl != null
            ? List<dynamic>.from(imagesUrl!.map((x) => x))
            : null,
        "description": description,
        "latitude": latitude,
        "longitude": longitude,
        "created_at": createdAt?.millisecondsSinceEpoch,
      };
}