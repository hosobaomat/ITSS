import 'package:flutter/material.dart';

class FoodItem {
  late final String name;
  final IconData icon;
  bool isSelected;
  int quantity;
  String? location;
  DateTime? expiry;
  bool? isDeleted;
  bool? isUpdate;
  FoodItem(this.name, this.icon, this.isSelected, this.quantity, this.location,
      this.expiry, this.isDeleted, this.isUpdate);

  FoodItem copy() {
    return FoodItem(
      name,
      icon,
      isSelected,
      quantity,
      location,
      expiry != null
          ? DateTime.fromMillisecondsSinceEpoch(expiry!.millisecondsSinceEpoch)
          : null,
      isDeleted,
      isUpdate,
    );
  }
}

class FoodInventoryProvider extends ChangeNotifier {
  final List<FoodItem> _items = [
    FoodItem('Carrot', Icons.abc_outlined, false, 5, 'Ngăn mát',
        DateTime.now().add(Duration(days: 2)), false, false),
    FoodItem('Broccoli', Icons.abc_outlined, false, 5, 'Ngăn mát',
        DateTime.now().add(Duration(days: 2)), false, false),
  ];
  late final List<FoodItem> _originalItems;
  List<FoodItem> get items => _items;
  FoodInventoryProvider() {
    // Khi khởi tạo provider, sao chép dữ liệu ban đầu
    _originalItems = _items.map((item) => item.copy()).toList();
  }
  List<FoodItem> get originalItems => _originalItems;
  void addItem(FoodItem item) {
    _items.add(item);
    notifyListeners(); // Gửi thông báo cập nhật đến UI
  }

  void removeItem(FoodItem item) {
    _items.remove(item);
    notifyListeners();
  }

  void clearItems() {
    _items.clear();
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
