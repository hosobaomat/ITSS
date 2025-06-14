class PlanDetail {
  final int planDetailId;
  final int recipeId;
  final String recipeName;
  final int mealDate;
  final String mealType;

  PlanDetail({
    required this.planDetailId,
    required this.recipeId,
    required this.recipeName,
    required this.mealDate,
    required this.mealType,
  });

  factory PlanDetail.fromJson(Map<String, dynamic> json) {
    return PlanDetail(
      planDetailId: json['planDetailId'],
      recipeId: json['recipeId'],
      recipeName: json['recipeName'],
      mealDate: json['mealDate'],
      mealType: json['mealType'],
    );
  }
}

class MealPlanResponse {
  final int planId;
  final String planName;
  final int startDate;
  final int endDate;
  final int groupId;
  final int createdBy;
  final int createdAt;
  final bool status;
  final List<PlanDetail> details;

  MealPlanResponse({
    required this.planId,
    required this.planName,
    required this.startDate,
    required this.endDate,
    required this.groupId,
    required this.createdBy,
    required this.createdAt,
    required this.status,
    required this.details,
  });
  // 👉 Convert milliseconds -> DateTime
  DateTime get startDateTime => DateTime.fromMillisecondsSinceEpoch(startDate);

  factory MealPlanResponse.fromJson(Map<String, dynamic> json) {
    var detailsList = (json['details'] as List)
        .map((d) => PlanDetail.fromJson(d))
        .toList();

    return MealPlanResponse(
      planId: json['planId'],
      planName: json['planName'],
      startDate: json['startDate'],
      endDate: json['endDate'],
      groupId: json['groupId'],
      createdBy: json['createdBy'],
      createdAt: json['createdAt'],
      status: json['status'],
      details: detailsList,
    );
  }
}