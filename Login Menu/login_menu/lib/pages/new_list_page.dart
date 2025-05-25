import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:login_menu/pages/CategoryDetailScreen.dart';
import 'package:login_menu/tabs/shoppinglist_tab.dart';

import '../models/shopping_list_model.dart.dart';

class NewListPage extends StatefulWidget {
  const NewListPage({super.key, required this.itemsByCategory});
  final Map<String, List<String>> itemsByCategory;

  @override
  State<NewListPage> createState() => _NewListPageState();
}

class _NewListPageState extends State<NewListPage> {
  DateTime? _selectedDate;
  final Map<String, List<String>> _selectedItemsByCategory = {};
  final Map<String, Map<String, int>> _quantitiesByCategory =
      {}; // Thêm để lưu số lượng

  void _pickDate() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: now,
      firstDate: now.subtract(const Duration(days: 365)),
      lastDate: now.add(const Duration(days: 365)),
    );

    if (picked != null) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  Widget _buildCategoryItem(IconData icon, String categoryName) {
    return Column(
      children: [
        ListTile(
          leading: Icon(icon, size: 28),
          title: Text(categoryName, style: const TextStyle(fontSize: 18)),
          trailing: _selectedItemsByCategory[categoryName]?.isNotEmpty == true
              ? const Icon(Icons.check_circle, color: Colors.green)
              : null,
          onTap: () async {
            final result = await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => CategoryDetailScreen(
                  categoryName: categoryName,
                  items: widget.itemsByCategory[categoryName] ?? [],
                  selectedItems: _selectedItemsByCategory[categoryName] ?? [],
                ),
              ),
            );

            if (result != null && result is Map) {
              setState(() {
                _selectedItemsByCategory[categoryName] =
                    List<String>.from(result['items']);
                _quantitiesByCategory[categoryName] =
                    Map<String, int>.from(result['quantities']);
              });
            }
          },
        ),
        const Divider(height: 1),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final dateText = _selectedDate == null
        ? 'Select date'
        : DateFormat('EEE, dd/MM/yyyy').format(_selectedDate!);

    final List<IconData> icons = [
      Icons.eco_outlined,
      Icons.set_meal_outlined,
      Icons.rice_bowl_outlined,
      Icons.local_fire_department_outlined,
      Icons.local_drink_outlined,
      Icons.cake_outlined,
      Icons.icecream_outlined,
      Icons.ac_unit_outlined,
    ];

    final categories = widget.itemsByCategory.keys.toList();

    return Scaffold(
      appBar: AppBar(
        leading: TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text(
            'X',
            style: TextStyle(fontSize: 20),
          ),
        ),
        title: const Text('New List', style: TextStyle(fontSize: 22)),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.black,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Date', style: TextStyle(fontSize: 16)),
            const SizedBox(height: 8),
            GestureDetector(
              onTap: _pickDate,
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(8),
                ),
                width: double.infinity,
                child: Text(
                  dateText,
                  style: TextStyle(
                    fontSize: 16,
                    color: _selectedDate == null ? Colors.grey : Colors.black,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),
            const Text('Add Items', style: TextStyle(fontSize: 16)),
            const SizedBox(height: 8),
            Expanded(
              child: ListView.builder(
                itemCount: categories.length,
                itemBuilder: (context, index) {
                  final category = categories[index];
                  final icon = icons[index % icons.length];
                  return _buildCategoryItem(icon, category);
                },
              ),
            ),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                onPressed: () {
                  if (_selectedDate == null) return;

                  final items = _selectedItemsByCategory.entries
                      .expand((entry) => entry.value.map(
                            (itemName) => ShoppingItem(
                              itemName,
                              Icons.shopping_cart,
                              false,
                              quantity: _quantitiesByCategory[entry.key]
                                      ?[itemName] ??
                                  1,
                              category:
                                  entry.key, // Thêm category vào ShoppingItem
                            ),
                          ))
                      .toList();

                  final newList = ShoppingListModel(
                    date: _selectedDate!,
                    items: items,
                  );

                  Navigator.pop(context, newList);
                },
                child: const Padding(
                  padding: EdgeInsets.symmetric(vertical: 14),
                  child: Text('Create', style: TextStyle(fontSize: 18)),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
