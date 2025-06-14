import 'dart:convert';

class ItemModel {
  final int id;
  final int foodId;
  final String foodname;
  final int quantity;
  final int unitId;
  final String unitName;
  final DateTime actionDate;

  ItemModel({
    required this.id,
    required this.foodId,
    required this.foodname,
    required this.quantity,
    required this.unitId,
    required this.unitName,
    required this.actionDate,
  });

  // Factory method để chuyển đổi từ JSON sang đối tượng UsedItemModel
  factory ItemModel.fromJson(Map<String, dynamic> json) {
   return ItemModel(
    id: (json['id'] as num).toInt(),
    foodId: (json['foodId'] as num).toInt(),
    foodname: json['foodname'] ?? '',
    quantity: (json['quantity'] as num).toInt(),
    unitId: (json['unitId'] as num).toInt(),
    unitName: json['unitName'] ?? '',
    actionDate: DateTime.fromMillisecondsSinceEpoch(
      (json['actionDate'] as num).toInt() * 1000,
    ),
  );
  }

  // Phương thức để chuyển đối tượng UsedItemModel thành JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'foodId': foodId,
      'foodname': foodname,
      'quantity': quantity,
      'unitId': unitId,
      'unitName': unitName,
      'actionDate': actionDate.toIso8601String(),
    };
  }
}

List<ItemModel> parseUsedItems(String responseBody) {
  final Map<String, dynamic> decoded = json.decode(responseBody);
  final List<dynamic> result =
      decoded['result']; // Lấy danh sách từ trường 'result'

  return result
      .map((json) => ItemModel.fromJson(json))
      .toList(); // Dùng map để chuyển đổi từng phần tử
}

List<ItemModel> parseWastedItems(String responseBody) {
  final Map<String, dynamic> decoded = json.decode(responseBody);
  final List<dynamic> result = decoded['result'];

  return result.map((json) => ItemModel.fromJson(json)).toList();
}
