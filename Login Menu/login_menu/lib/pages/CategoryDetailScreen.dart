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

  @override
  void initState() {
    super.initState();
    _items = List.from(widget.items); // clone tránh sửa trực tiếp
    _selectedItems.addAll(widget.selectedItems);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.categoryName),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context, _selectedItems.toList());
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
