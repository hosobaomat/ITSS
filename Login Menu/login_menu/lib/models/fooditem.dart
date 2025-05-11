import 'package:flutter/material.dart';

class FoodItem {
  final String name;
  final IconData icon;
  bool isSelected;
  int? quantity;
  String? location;
  DateTime? expiry;
  FoodItem(this.name, this.icon, this.isSelected, this.quantity, this.location,
      this.expiry);
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
  void updateItem(FoodItem updatedItem) {
    final index = _items.indexWhere((item) => item.name == updatedItem.name);
    if (index != -1) {
      _items[index] = updatedItem;
      notifyListeners();
    }
  }
}
