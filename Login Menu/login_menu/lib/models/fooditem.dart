import 'package:flutter/material.dart';

class FoodItem {
  final String name;
  final IconData icon;
  bool isSelected;

  FoodItem(this.name, this.icon, this.isSelected);
}

class FoodInventoryProvider extends ChangeNotifier {
  final List<FoodItem> _items = [];

  List<FoodItem> get items => _items;

  void addItem(FoodItem item) {
    _items.add(item);
    notifyListeners(); // Gửi thông báo cập nhật đến UI
  }

  void removeItem(FoodItem item) {
    _items.remove(item);
    notifyListeners();
  }
}
