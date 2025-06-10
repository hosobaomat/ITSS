class ConsumptionTrend {
  final String categoryName;
  final double consumptionPercentage;

  ConsumptionTrend(
      {required this.categoryName, required this.consumptionPercentage});

  factory ConsumptionTrend.fromJson(Map<String, dynamic> json) {
    return ConsumptionTrend(
      categoryName: json.keys.first,
      consumptionPercentage: json[json.keys.first],
    );
  }
}
