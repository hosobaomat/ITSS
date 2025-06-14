import 'package:flutter/material.dart';
import 'package:login_menu/models/fooditem.dart';

class UpdateItemProvider extends ChangeNotifier {
  final List<FoodItem> _updateItems = [];

  List<FoodItem> get updateItems => _updateItems;

  void add(FoodItem item) {
    _updateItems.add(item);
    notifyListeners();
  }

  void remove(String name) {
    for (int i = 0; i < _updateItems.length; i++) {
      if (_updateItems[i].name == name) {
        _updateItems.remove(_updateItems[i]);
      }
    }
    notifyListeners();
  }

  void update(FoodItem updatedItem) {
    for (int i = 0; i < _updateItems.length; i++) {
      if (_updateItems[i].name == updatedItem.name) {
        _updateItems[i] = updatedItem;
        notifyListeners();
        return;
      }
    }
    _updateItems.add(updatedItem);
    notifyListeners();
  }

  void clearItems() {
    _updateItems.clear();
    notifyListeners();
  }

  FoodItem findByName(String name) {
    for (int i = 0; i < _updateItems.length; i++) {
      print(
          '${_updateItems[i].name} - ${_updateItems[i].isDeleted}-${_updateItems[i].location}-${_updateItems[i].quantity}-${_updateItems[i].expiry}-11');
    }
    try {
      return _updateItems.firstWhere((item) => item.name == name);
    } catch (e) {
      return FoodItem(
          '', Icons.abc_outlined, false, 0, '', DateTime.now(), false, false);
    }
  }
}
