// To parse this JSON data, do
//
//     final projectsModel = projectsModelFromJson(jsonString);

import 'dart:convert';

List<ProjectsModel> projectsModelFromJson(String str) =>
    List<ProjectsModel>.from(
        json.decode(str).map((x) => ProjectsModel.fromJson(x)));

String projectsModelToJson(List<ProjectsModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class ProjectsModel {
  ProjectsModel({
    this.id,
    this.title,
    this.address,
    this.description,
    this.featuredImage,
    this.gallery,
    this.locality,
    this.city,
    this.area,
    this.startingPrice,
    this.endingPrice,
    this.walkthroughThreeD,
    this.createdAt,
    this.updatedAt,
    this.developerId,
    this.categoryId,
    this.projectNearByPlaceId,
    this.status,
  });

  int? id;
  String? title;
  String? address;
  String? description;
  String? featuredImage;
  String? gallery;
  String? locality;
  String? city;
  String? area;
  String? startingPrice;
  String? endingPrice;
  String? walkthroughThreeD;
  DateTime? createdAt;
  DateTime? updatedAt;
  int? developerId;
  int? categoryId;
  int? projectNearByPlaceId;
  bool? status;

  factory ProjectsModel.fromJson(Map<String, dynamic> json) => ProjectsModel(
        id: json["id"],
        title: json["title"],
        address: json["address"],
        description: json["description"],
        featuredImage: json["featuredImage"],
        gallery: json["gallery"],
        locality: json["locality"],
        city: json["city"],
        area: json["area"],
        startingPrice: json["startingPrice"],
        endingPrice: json["endingPrice"],
        walkthroughThreeD: json["walkthroughThreeD"],
        createdAt: DateTime.parse(json["createdAt"]),
        updatedAt: DateTime.parse(json["updatedAt"]),
        developerId: json["developerId"],
        categoryId: json["categoryId"],
        projectNearByPlaceId: json["projectNearByPlaceId"],
        status: json['status'],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
        "address": address,
        "description": description,
        "featuredImage": featuredImage,
        "gallery": gallery,
        "locality": locality,
        "city": city,
        "area": area,
        "startingPrice": startingPrice,
        "endingPrice": endingPrice,
        "walkthroughThreeD": walkthroughThreeD,
        "createdAt": createdAt!.toIso8601String(),
        "updatedAt": updatedAt!.toIso8601String(),
        "developerId": developerId,
        "categoryId": categoryId,
        "projectNearByPlaceId": projectNearByPlaceId,
        "status": status,
      };
}
