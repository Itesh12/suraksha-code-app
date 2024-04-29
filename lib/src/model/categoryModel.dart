// To parse this JSON data, do
//
//     final categoryModel = categoryModelFromJson(jsonString);

import 'dart:convert';

List<CategoryModel> categoryModelFromJson(String str) =>
    List<CategoryModel>.from(
        json.decode(str).map((x) => CategoryModel.fromJson(x)));

String categoryModelToJson(List<CategoryModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class CategoryModel {
  final String categoryName;
  final String categoryIcon;

  CategoryModel({
    this.categoryName = '',
    this.categoryIcon = '',
  });

  factory CategoryModel.fromJson(Map<String, dynamic> json) => CategoryModel(
        categoryName: json["categoryName"] ?? '',
        categoryIcon: json["categoryIcon"] ?? '',
      );

  Map<String, dynamic> toJson() => {
        "categoryName": categoryName,
        "categoryIcon": categoryIcon,
      };
}
