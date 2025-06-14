class Getmissingingredient {
  final int? recipeId;
  final int? foodId;
  final String? foodName;
  final String? unitName;
  final int? unitId;
  final num? quantity;

  Getmissingingredient({
     this.recipeId,
     this.foodId,
     this.foodName,
     this.unitName,
     this.unitId,
     this.quantity,
  });

  factory Getmissingingredient.fromJson(Map<String, dynamic> json) {
    return Getmissingingredient(
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
