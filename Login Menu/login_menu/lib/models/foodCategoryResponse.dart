import 'package:login_menu/models/foodCatalogResponse.dart';
import 'package:login_menu/models/unitResponse.dart';

class FoodCategoryResponse {
  int? categoryId;
  String? categoryName;
  String? categoryDescription;
  Set<FoodCatalogResponse> foodCatalogResponses;
  Set<UnitResponse>? unitResponses;

  FoodCategoryResponse(
    this.categoryId,
    this.categoryName,
    this.categoryDescription, {
    required this.foodCatalogResponses,
    this.unitResponses,
  });

  factory FoodCategoryResponse.fromJson(Map<String, dynamic> json) {
    print("Mapping FoodCategoryResponse JSON: $json"); // Debug dữ liệu JSON
    return FoodCategoryResponse(
      json['categoryId'] as int?,
      json['categoryName'] as String?,
      json['categoryDescription'] as String?,
      foodCatalogResponses: (json['foodCatalogResponses'] as List<dynamic>?)
              ?.map((foodJson) {
            print("Mapping FoodCatalogResponse: $foodJson"); // Debug từng mục
            return FoodCatalogResponse.fromJson(foodJson);
          }).toSet() ??
          {},
      unitResponses: (json['unitResponses'] as List<dynamic>?)
              ?.map((unitJson) => UnitResponse.fromJson(unitJson))
              .toSet() ??
          {},
    );
  }

  @override
  String toString() =>
      'FoodCategoryResponse(categoryId: $categoryId, categoryName: $categoryName)';
}
