import 'package:flutter/material.dart';

class CategoryDetailScreen extends StatefulWidget {
  final String categoryName;
  final List<String> items;

  const CategoryDetailScreen({
    super.key,
    required this.categoryName,
    required this.items,
  });

  @override
  State<CategoryDetailScreen> createState() => _CategoryDetailScreenState();
}

class _CategoryDetailScreenState extends State<CategoryDetailScreen> {
  late List<String> _items;
  final Set<String> _selectedItems = {};
  final TextEditingController _itemController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _items = List.from(widget.items); // clone tránh sửa trực tiếp
  }

  void _addItem(String itemName) {
    if (itemName.isNotEmpty && !_items.contains(itemName)) {
      setState(() {
        _items.add(itemName);
      });
    }
  }

  void _showAddItemDialog() {
    _itemController.clear();
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Add Item"),
        content: TextField(
          controller: _itemController,
          decoration: const InputDecoration(hintText: "Item name"),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: () {
              _addItem(_itemController.text.trim());
              Navigator.pop(context);
            },
            child: const Text("Add"),
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
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: _showAddItemDialog,
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context, _items); // Trả về danh sách mới
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
            value: isSelected,
            onChanged: (val) {
              setState(() {
                if (val == true) {
                  _selectedItems.add(item);
                } else {
                  _selectedItems.remove(item);
                }
              });
            },
          );
        }).toList(),
      ),
    );
  }
}
