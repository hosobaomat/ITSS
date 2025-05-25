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
<<<<<<< HEAD
  final Set<String> _selectedItems = {};
  final Map<String, int> _itemQuantities = {}; // Lưu số lượng của từng sản phẩm
=======
  final Map<String, SelectedItem> _selectedItems = {};
  final Map<String, TextEditingController> quantityControllers = {};
  final Map<String, TextEditingController> unitControllers = {};
>>>>>>> 898fbf3be0448210a6a988cf05ee58b1dd345f06

  @override
  void initState() {
    super.initState();
<<<<<<< HEAD
    _items = List.from(widget.items); // Clone để tránh sửa trực tiếp
    _selectedItems.addAll(widget.selectedItems);
    // Khởi tạo số lượng mặc định là 1 cho các sản phẩm đã chọn trước đó
    for (var item in _selectedItems) {
      _itemQuantities[item] = _itemQuantities[item] ?? 1;
    }
  }

  Future<int?> showQuantityDialog(BuildContext context, String itemName) async {
    int quantity = _itemQuantities[itemName] ??
        1; // Giá trị mặc định hoặc giá trị hiện tại
    final TextEditingController controller =
        TextEditingController(text: quantity.toString());

    return showDialog<int>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Enter Quantity for $itemName'),
        content: TextField(
          controller: controller,
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(
            labelText: 'Quantity',
            hintText: 'Enter a number',
          ),
          onChanged: (value) {
            quantity = int.tryParse(value) ?? 1;
          },
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context), // Hủy
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              if (quantity > 0) {
                Navigator.pop(context, quantity); // Xác nhận
              }
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
=======
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
>>>>>>> 898fbf3be0448210a6a988cf05ee58b1dd345f06
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.categoryName),
        actions: [
          TextButton(
            onPressed: () {
<<<<<<< HEAD
              // Trả về cả danh sách sản phẩm và số lượng
              Navigator.pop(context, {
                'items': _selectedItems.toList(),
                'quantities': _itemQuantities,
              });
=======
              Navigator.pop(context, _selectedItems.values.toList());
>>>>>>> 898fbf3be0448210a6a988cf05ee58b1dd345f06
            },
            child: const Text('Done', style: TextStyle(color: Colors.black)),
          ),
        ],
      ),
      body: ListView(
        children: _items.map((item) {
<<<<<<< HEAD
          final isSelected = _selectedItems.contains(item);
          return CheckboxListTile(
            title: Text(item),
            subtitle: isSelected
                ? Text('Quantity: ${_itemQuantities[item] ?? 1}')
                : null,
            value: isSelected,
            onChanged: (val) async {
              if (val == true) {
                // Hiển thị dialog khi chọn sản phẩm
                final quantity = await showQuantityDialog(context, item);
                if (quantity != null) {
                  setState(() {
                    _selectedItems.add(item);
                    _itemQuantities[item] = quantity;
                  });
                }
              } else {
                setState(() {
                  _selectedItems.remove(item);
                  _itemQuantities.remove(item);
                });
              }
            },
=======
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
>>>>>>> 898fbf3be0448210a6a988cf05ee58b1dd345f06
          );
        }).toList(),
      ),
    );
  }
}