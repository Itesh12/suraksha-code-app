// To parse this JSON data, do
//
//     final helpLineModel = helpLineModelFromJson(jsonString);

import 'dart:convert';

List<HelpLineModel> helpLineModelFromJson(String str) =>
    List<HelpLineModel>.from(
        json.decode(str).map((x) => HelpLineModel.fromJson(x)));

String helpLineModelToJson(List<HelpLineModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class HelpLineModel {
  final String title;
  final List<String> services;
  final List<String> languages;
  final String number;
  final String image;

  HelpLineModel({
    this.title = '',
    this.services = const [],
    this.languages = const [],
    this.number = '',
    this.image = '',
  });

  factory HelpLineModel.fromJson(Map<String, dynamic> json) => HelpLineModel(
        title: json["title"] ?? '',
        services: List<String>.from(json["services"].map((x) => x)) ?? [],
        languages: List<String>.from(json["languages"].map((x) => x)) ?? [],
        number: json["number"] ?? '',
        image: json["image"] ?? '',
      );

  Map<String, dynamic> toJson() => {
        "title": title,
        "services": List<dynamic>.from(services.map((x) => x)),
        "languages": List<dynamic>.from(languages.map((x) => x)),
        "number": number,
        "image": image,
      };
}
