class Ingredient {
  final int recipeId;
  final int foodId;
  final String foodName;
  final String unitName;
  final int unitId;
  final num quantity;

  Ingredient({
    required this.recipeId,
    required this.foodId,
    required this.foodName,
    required this.unitName,
    required this.unitId,
    required this.quantity,
  });

  factory Ingredient.fromJson(Map<String, dynamic> json) {
    return Ingredient(
      recipeId: json['recipeid'],
      foodId: json['foodId'],
      foodName: json['foodname'],
      unitName: json['unitName'],
      unitId: json['unitId'],
      quantity: json['quantity'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'recipeid': recipeId,
      'foodId': foodId,
      'foodname': foodName,
      'unitName': unitName,
      'unitId': unitId,
      'quantity': quantity,
    };
  }
}
