import 'package:flutter/material.dart';
import '../models/selected_item.dart'; // import đúng đường dẫn bạn lưu file SelectedItem

class CategoryDetailScreen extends StatefulWidget {
  final String categoryName;
  final List<String> items;
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
  final Map<String, TextEditingController> unitControllers = {};

  @override
  void initState() {
    super.initState();
    _items = List.from(widget.items);

    for (var item in widget.selectedItems) {
      _selectedItems[item.name] = item;
      quantityControllers[item.name] = TextEditingController(text: item.quantity.toString());
      unitControllers[item.name] = TextEditingController(text: item.unit);
    }
  }

  @override
  void dispose() {
    for (var controller in quantityControllers.values) {
      controller.dispose();
    }
    for (var controller in unitControllers.values) {
      controller.dispose();
    }
    super.dispose();
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

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CheckboxListTile(
                title: Text(item),
                value: isSelected,
                onChanged: (val) {
                  setState(() {
                    if (val == true) {
                      final newItem = SelectedItem(name: item, quantity: 1, unit: '');
                      _selectedItems[item] = newItem;
                      quantityControllers[item] = TextEditingController(text: '1');
                      unitControllers[item] = TextEditingController();
                    } else {
                      _selectedItems.remove(item);
                      quantityControllers[item]?.dispose();
                      unitControllers[item]?.dispose();
                      quantityControllers.remove(item);
                      unitControllers.remove(item);
                    }
                  });
                },
              ),
              if (isSelected)
                Padding(
                  padding: const EdgeInsets.only(left: 32, right: 16, bottom: 12),
                  child: Row(
                    children: [
                      SizedBox(
                        width: 80,
                        child: TextField(
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(labelText: 'Số lượng'),
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
                        child: TextField(
                          decoration: const InputDecoration(labelText: 'Đơn vị'),
                          controller: unitControllers[item],
                          onChanged: (val) {
                            setState(() {
                              selectedItem?.unit = val;
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