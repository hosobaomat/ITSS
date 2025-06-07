import 'package:flutter/material.dart';
import 'package:login_menu/models/fooditem.dart';
import 'package:login_menu/models/recipes.dart';

class InventoryProvider with ChangeNotifier {
  List<FoodItem> _inventory = [];
  List<Recipe> _recipes = [];

  List<FoodItem> get inventory => _inventory;
  List<Recipe> get recipes => _recipes;

  void setInventory(List<FoodItem> inventory) {
    _inventory = inventory;
    notifyListeners();
  }

  void setRecipes(List<Recipe> recipes) {
    _recipes = recipes;
    notifyListeners();
  }

  void addFoodItem(FoodItem item) {
    _inventory.add(item);
    notifyListeners();
  }

  void removeFoodItem(FoodItem item) {
    _inventory.remove(item);
    notifyListeners();
  }

  void addRecipe(Recipe recipe) {
    _recipes.add(recipe);
    notifyListeners();
  }

  void removeRecipe(Recipe recipe) {
    _recipes.remove(recipe);
    notifyListeners();
  }
}