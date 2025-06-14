import 'package:flutter/material.dart';
import 'package:login_menu/models/fooditem.dart';
import 'package:login_menu/models/recipes.dart';
import 'package:login_menu/models/recipesResponse.dart'; // Đảm bảo import đúng Recipesresponse

class MealPlan {
  DateTime date;
  Map<String, List<Recipesresponse>> meals; // Thay bằng List<Recipesresponse>

  MealPlan({required this.date})
      : meals = {
          'breakfast': [],
          'lunch': [],
          'dinner': [],
        };
}

class MealPlanProvider with ChangeNotifier {
  final Map<DateTime, MealPlan> _dailyPlans = {};

  Map<DateTime, MealPlan> get dailyPlans => _dailyPlans;

  void addMealPlan(DateTime date, String mealType, Recipesresponse recipe) {
    final mealPlan = _dailyPlans[date] ?? MealPlan(date: date);
    mealPlan.meals[mealType] ??= []; // Khởi tạo danh sách nếu chưa có
    if (!mealPlan.meals[mealType]!.contains(recipe)) { // Tránh thêm trùng lặp
      mealPlan.meals[mealType]!.add(recipe);
      _dailyPlans[date] = mealPlan;
      print('Added ${recipe.recipeName} to $mealType on $date');
      notifyListeners();
    }
    notifyListeners();
  }

  void removeMealPlan(DateTime date, String mealType, Recipesresponse recipe) {
    if (_dailyPlans[date] != null && _dailyPlans[date]!.meals[mealType] != null) {
      _dailyPlans[date]!.meals[mealType]!.remove(recipe);
      if (_dailyPlans[date]!.meals[mealType]!.isEmpty) {
        _dailyPlans[date]!.meals[mealType] = [];
      }
      if (_dailyPlans[date]!.meals.values.every((list) => list.isEmpty)) {
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
      if (item.name.isEmpty || item.quantity <= 0) return false;
    }
    return true;
  }

  void removeMealPlanForDate(DateTime date) {
    if (_dailyPlans.containsKey(date)) {
      _dailyPlans.remove(date);
      notifyListeners();
    }
  }

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