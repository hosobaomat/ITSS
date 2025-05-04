import 'package:flutter/material.dart';
import 'package:login_menu/data/data_store.dart';
import 'package:login_menu/pages/CategoryDetailScreen.dart';

class CategoriesTab extends StatefulWidget {
  const CategoriesTab({super.key});

  @override
  State<CategoriesTab> createState() => _CategoriesTabState();
}

class _CategoriesTabState extends State<CategoriesTab> {

  void _addCategory(String name) {
    if (name.isEmpty || DataStore.itemsByCategory.containsKey(name)) return;
    setState(() {
      DataStore.itemsByCategory[name] = [];
    });
  }

  void _editItems(String category, List<String> newItems) {
    setState(() {
      DataStore.itemsByCategory[category] = newItems;
    });
  }

  void _showAddCategoryDialog() {
    final controller = TextEditingController();
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Add Category"),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(hintText: "Category name"),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: () {
              _addCategory(controller.text.trim());
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
    final categories = DataStore.itemsByCategory.keys.toList();
    return Scaffold(
      appBar: AppBar(
        title: const Text('All Categories'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: _showAddCategoryDialog,
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: categories.length,
        itemBuilder: (context, index) {
          final category = categories[index];
          return ListTile(
            title: Text(category),
            leading: const Icon(Icons.category),
            onTap: () async {
              final result = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => CategoryDetailScreen(
                    categoryName: category,
                    items: DataStore.itemsByCategory[category]!,
                  ),
                ),
              );

              // Nếu người dùng chỉnh sửa danh sách item
              if (result is List<String>) {
                _editItems(category, result);
              }
            },
          );
        },
      ),
    );
  }
}
