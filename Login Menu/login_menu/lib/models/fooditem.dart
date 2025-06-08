import 'package:flutter/material.dart';

class FoodItem {
  int foodId;
  int groupId;
  String name;
  int unitId;
  int quantity;
  DateTime? expiry;
  String? location;
  DateTime? addedAt;
  DateTime? updatedAt;
  int foodCatalogId;

  // UI fields
  IconData icon;
  bool isSelected;
  bool isDeleted;
  bool isUpdate;
  String? category;

  FoodItem(
    this.foodId,
    this.groupId,
    this.name,
    this.unitId,
    this.quantity,
    this.expiry,
    this.location,
    this.addedAt,
    this.updatedAt,
    this.foodCatalogId, {
    this.icon = Icons.fastfood,
    this.isSelected = false,
    this.isDeleted = false,
    this.isUpdate = false,
    this.category,
  });

  factory FoodItem.fromJson(Map<String, dynamic> json) {
    return FoodItem(
      json['food_id'] ?? 0,
      json['group_id'] ?? 0,
      json['food_name'] ?? '',
      json['unit_id'] ?? 0,
      json['quantity'] ?? 0,
      json['expiry_date'] != null
          ? DateTime.tryParse(json['expiry_date'])
          : null,
      json['storage_location'],
      json['added_at'] != null ? DateTime.tryParse(json['added_at']) : null,
      json['updated_at'] != null ? DateTime.tryParse(json['updated_at']) : null,
      json['food_catalog_id'] ?? 0,
      icon: Icons
          .fastfood, // Bạn có thể thay đổi theo foodCatalogId hoặc foodName nếu muốn
    );
  }

  FoodItem copy() {
    return FoodItem(
      foodId,
      groupId,
      name,
      unitId,
      quantity,
      expiry,
      location,
      addedAt,
      updatedAt,
      foodCatalogId,
      icon: icon,
      isSelected: isSelected,
      isDeleted: isDeleted,
      isUpdate: isUpdate,
      category: category,
    );
  }
}

class FoodInventoryProvider extends ChangeNotifier {
  final List<FoodItem> _items = [
    FoodItem(0, 0, 'Carrot', 0, 5, DateTime.now().add(Duration(days: 2)),
        'Ngăn mát', null, null, 0),
    FoodItem(0, 0, 'Broccoli', 0, 5, DateTime.now().add(Duration(days: 2)),
        'Ngăn mát', null, null, 0),
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
    notifyListeners();
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
    final index =
        _items.indexWhere((item) => item.foodId == updatedItem.foodId);
    if (index != -1) {
      _items[index] = updatedItem;
      notifyListeners();
    }
  }
}
