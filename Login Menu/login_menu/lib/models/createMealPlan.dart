class Createmealplan {
  String planName;
  DateTime startDate;
  DateTime endDate;
  final int groupId;
  final int createdBy;
  List<CreateMealPlanDetail> details;

  Createmealplan({
    required this.planName,
    required this.startDate,
    required this.endDate,
    required this.groupId,
    required this.createdBy,
    required this.details,
  });

  factory Createmealplan.fromJson(Map<String, dynamic> json) {
    return Createmealplan(
      planName: json['planName'],
      startDate: DateTime.parse(json['startDate']),
      endDate: DateTime.parse(json['endDate']),
      groupId: json['groupId'],
      createdBy: json['createdBy'],
      details: (json['details'] as List)
          .map((e) => CreateMealPlanDetail.fromJson(e))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'planName': planName,
      'startDate': startDate.toIso8601String(),
      'endDate': endDate.toIso8601String(),
      'groupId': groupId,
      'createdBy': createdBy,
      'details': details.map((e) => e.toJson()).toList(),
    };
  }
}

class CreateMealPlanDetail {
  final int recipeId;
  final DateTime mealDate;
  final String mealType;

  CreateMealPlanDetail({
    required this.recipeId,
    required this.mealDate,
    required this.mealType,
  });

  factory CreateMealPlanDetail.fromJson(Map<String, dynamic> json) {
    return CreateMealPlanDetail(
      recipeId: json['recipeId'],
      mealDate: DateTime.parse(json['mealDate']),
      mealType: json['mealType'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'recipeId': recipeId,
      'mealDate': mealDate.toIso8601String(),
      'mealType': mealType,
    };
  }
}
