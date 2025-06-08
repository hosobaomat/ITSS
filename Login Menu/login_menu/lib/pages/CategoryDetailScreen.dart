import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:login_menu/models/foodCategoryResponse.dart';
import 'package:login_menu/service/auth_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/selected_item.dart';

const String apiUrl = AuthService.apiUrl;

class CategoryDetailScreen extends StatefulWidget {
  final String categoryName;
  final List<String> items; // Danh sách tên thực phẩm
  final List<SelectedItem> selectedItems;

  const CategoryDetailScreen({
    super.key,
    required this.categoryName,
    required this.items,
    this.selectedItems = const [],
  });

  @override
  State<CategoryDetailScreen> createState() => _CategoryDetailScreenState();
}

class _CategoryDetailScreenState extends State<CategoryDetailScreen> {
  late List<String> _items;
  final Map<String, SelectedItem> _selectedItems = {};
  final Map<String, TextEditingController> quantityControllers = {};
  Map<String, String> selectedUnits = {};

  // NEW: mapping tên thực phẩm -> list đơn vị hợp lệ
  Map<String, List<String>> foodToUnits = {};

  @override
  void initState() {
    super.initState();
    _items = List.from(widget.items);

    for (var item in widget.selectedItems) {
      _selectedItems[item.name] = item;
      quantityControllers[item.name] =
          TextEditingController(text: item.quantity.toString());
      selectedUnits[item.name] = item.unit;
    }

    loadFoodCatalogAndUnits();
  }

  @override
  void dispose() {
    for (var controller in quantityControllers.values) {
      controller.dispose();
    }
    super.dispose();
  }

  // NEW: Mapping món ăn -> đơn vị đúng
  Future<void> loadFoodCatalogAndUnits() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');
      if (token == null) throw Exception('Token không tồn tại');

      final response = await http.get(
        Uri.parse("$apiUrl/ShoppingList/FoodCatalog"),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },
      );

      if (response.statusCode == 200) {
        final decodedBody = utf8.decode(response.bodyBytes);
        final data = jsonDecode(decodedBody);

        if (data['result'] is List) {
          final categories = (data['result'] as List)
              .map((json) => FoodCategoryResponse.fromJson(json))
              .toList();

          // Map: tên thực phẩm -> list đơn vị
          final tempFoodToUnits = <String, List<String>>{};
          for (var cat in categories) {
            final unitsInCat = cat.unitResponses
                    ?.map((u) => u.unitName ?? '')
                    .where((e) => e.isNotEmpty)
                    .toList() ??
                [];
            for (var food in cat.foodCatalogResponses) {
              final name = food.foodCatalogName;
              if (name != null && name.isNotEmpty) {
                tempFoodToUnits[name] = unitsInCat;
              }
            }
          }
          setState(() {
            foodToUnits = tempFoodToUnits;
          });
        } else {
          throw Exception('Dữ liệu result không phải là danh sách');
        }
      } else {
        throw Exception('Không thể lấy dữ liệu FoodCatalog: ${response.body}');
      }
    } catch (e) {
      print("Lỗi kết nối hoặc ánh xạ: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.categoryName),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context, _selectedItems.values.toList());
            },
            child: const Text('Done', style: TextStyle(color: Colors.black)),
          ),
        ],
      ),
      body: ListView(
        children: _items.map((item) {
          final isSelected = _selectedItems.containsKey(item);
          final selectedItem = _selectedItems[item];

          // Lấy list đơn vị phù hợp cho từng item
          final foodUnits = foodToUnits[item] ?? [];

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CheckboxListTile(
                title: Text(item),
                value: isSelected,
                onChanged: (val) {
                  setState(() {
                    if (val == true) {
                      final newItem = SelectedItem(
                        id: DateTime.now().millisecondsSinceEpoch,
                        name: item,
                        quantity: 1,
                        unit: foodUnits.isNotEmpty ? foodUnits.first : '',
                      );
                      _selectedItems[item] = newItem;
                      quantityControllers[item] =
                          TextEditingController(text: '1');
                      selectedUnits[item] =
                          foodUnits.isNotEmpty ? foodUnits.first : '';
                    } else {
                      _selectedItems.remove(item);
                      quantityControllers[item]?.dispose();
                      quantityControllers.remove(item);
                      selectedUnits.remove(item);
                    }
                  });
                },
              ),
              if (isSelected)
                Padding(
                  padding:
                      const EdgeInsets.only(left: 32, right: 16, bottom: 12),
                  child: Row(
                    children: [
                      SizedBox(
                        width: 80,
                        child: TextField(
                          keyboardType: TextInputType.number,
                          decoration:
                              const InputDecoration(labelText: 'Số lượng'),
                          controller: quantityControllers[item],
                          onChanged: (val) {
                            final qty = int.tryParse(val) ?? 1;
                            setState(() {
                              selectedItem?.quantity = qty;
                            });
                          },
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: DropdownButtonFormField<String>(
                          value: selectedUnits[item]?.isNotEmpty == true
                              ? selectedUnits[item]
                              : null,
                          decoration:
                              const InputDecoration(labelText: 'Đơn vị'),
                          items: foodUnits.map((unit) {
                            return DropdownMenuItem(
                              value: unit,
                              child: Text(unit),
                            );
                          }).toList(),
                          onChanged: (val) {
                            setState(() {
                              if (val != null) {
                                selectedUnits[item] = val;
                                selectedItem?.unit = val;
                              }
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              const Divider(height: 1),
            ],
          );
        }).toList(),
      ),
    );
  }
}
