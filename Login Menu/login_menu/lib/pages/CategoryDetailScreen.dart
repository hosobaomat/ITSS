import 'package:flutter/material.dart';

class CategoryDetailScreen extends StatefulWidget {
  final String categoryName;
  final List<String> items;
  final List<String> selectedItems;

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
  final Set<String> _selectedItems = {};
  final Map<String, int> _itemQuantities = {}; // Lưu số lượng của từng sản phẩm

  @override
  void initState() {
    super.initState();
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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.categoryName),
        actions: [
          TextButton(
            onPressed: () {
              // Trả về cả danh sách sản phẩm và số lượng
              Navigator.pop(context, {
                'items': _selectedItems.toList(),
                'quantities': _itemQuantities,
              });
            },
            child: const Text('Done', style: TextStyle(color: Colors.black)),
          ),
        ],
      ),
      body: ListView(
        children: _items.map((item) {
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
          );
        }).toList(),
      ),
    );
  }
}
