import 'package:flutter/material.dart';
import 'package:login_menu/models/fooditem.dart';
import 'package:login_menu/models/recipes.dart';

class MealPlan {
  DateTime date;
  Map<String, Recipe?> meals; // Key: 'breakfast', 'lunch', 'dinner'

  MealPlan({required this.date})
      : meals = {
          'breakfast': null,
          'lunch': null,
          'dinner': null,
        };
}

class MealPlanProvider with ChangeNotifier {
  final Map<DateTime, MealPlan> _dailyPlans = {};

  Map<DateTime, MealPlan> get dailyPlans => _dailyPlans;

  void addMealPlan(DateTime date, String mealType, Recipe? recipe) {
    final mealPlan = _dailyPlans[date] ?? MealPlan(date: date);
    mealPlan.meals[mealType] = recipe;
    _dailyPlans[date] = mealPlan;
    notifyListeners();
  }

  void removeMealPlan(DateTime date, String mealType) {
    if (_dailyPlans[date] != null) {
      _dailyPlans[date]!.meals[mealType] = null;
      if (_dailyPlans[date]!.meals.values.every((meal) => meal == null)) {
        _dailyPlans.remove(date);
      }
      notifyListeners();
    }
  }

  bool checkIngredients(Recipe recipe, List<FoodItem> inventory) {
    if (recipe.ingredients.isEmpty)
      return false; // Tránh lỗi nếu không có nguyên liệu
    for (var ingredient in recipe.ingredients) {
      final trimmedIngredient = ingredient.trim().toLowerCase();
      final item = inventory.firstWhere(
        (item) => item.name.trim().toLowerCase() == trimmedIngredient,
      );
      if (item.name.isEmpty || item.quantity! <= 0) return false;
    }
    return true;
  }

  void removeMealPlanForDate(DateTime date) {
    if (_dailyPlans.containsKey(date)) {
      _dailyPlans.remove(date);
      notifyListeners();
    }
  }

  //Them 1 thuc don moi khi chon ngay khac
  void initializeMealPlanForDate(DateTime date) {
    if (!_dailyPlans.containsKey(date)) {
      _dailyPlans[date] = MealPlan(date: date);
      print('Initialized new meal plan for $date');
      notifyListeners();
    }
  }

  void clearPlans() {
    _dailyPlans.clear();
    notifyListeners();
  }
}
