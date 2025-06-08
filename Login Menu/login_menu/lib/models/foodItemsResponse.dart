class FoodItemResponse {
  int id;
  String foodname;
  int quantity;
  String unitName;
  String storageLocation;
  DateTime expiryDate;
  DateTime addedAt;
  String categoryName;
  String storageSuggestion;
  DateTime updatedAt;

  FoodItemResponse({
    required this.id,
    required this.foodname,
    required this.quantity,
    required this.unitName,
    required this.storageLocation,
    required this.expiryDate,
    required this.addedAt,
    required this.categoryName,
    required this.storageSuggestion,
    required this.updatedAt,
  });

  factory FoodItemResponse.fromJson(Map<String, dynamic> json) {
    return FoodItemResponse(
      id: json['id'] as int,
      foodname: json['foodname'] as String,
      quantity: json['quantity'] as int,
      unitName: json['unitName'] as String? ?? '', // sửa ở đây
      storageLocation: json['storageLocation'] as String? ?? '', // sửa ở đây
      expiryDate: json['expiryDate'] != null
          ? DateTime.fromMillisecondsSinceEpoch(json['expiryDate'])
          : DateTime.now(),
      addedAt: json['addedAt'] != null
          ? DateTime.fromMillisecondsSinceEpoch(json['addedAt'])
          : DateTime.now(),
      categoryName: json['categoryName'] as String? ?? '',
      storageSuggestion: json['storageSuggestion'] as String? ?? '',
      updatedAt: json['updatedAt'] != null
          ? DateTime.fromMillisecondsSinceEpoch(json['updatedAt'])
          : DateTime.now(),
    );
  }
}

class foodCategory {
  int? categoryId;
  String? categoryName;
  String? categoryDescription;
  List<FoodItemResponse> foodItemResponses;

  foodCategory(
    this.categoryId,
    this.categoryName,
    this.categoryDescription, {
    required this.foodItemResponses,
  });

  factory foodCategory.fromJson(Map<String, dynamic> json) {
    return foodCategory(
      json['categoryId'] as int?,
      json['categoryName'] as String?,
      json['categoryDescription'] as String?,
      foodItemResponses: (json['foodItemResponses'] as List<dynamic>?)
              ?.map((itemJson) => FoodItemResponse.fromJson(itemJson))
              .toList() ??
          [],
    );
  }
}
