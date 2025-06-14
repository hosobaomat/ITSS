class FoodCatalogResponse {
  int foodCatalogId;
  String foodCatalogName;
  String foodCatalogDescription;

  FoodCatalogResponse(
    this.foodCatalogId,
    this.foodCatalogName,
    this.foodCatalogDescription,
  );

  factory FoodCatalogResponse.fromJson(Map<String, dynamic> json) {
    return FoodCatalogResponse(
      json['foodCatalogId'],
      json['foodCatalogName'],
      json['foodCatalogDescription'],
    );
  }
}
