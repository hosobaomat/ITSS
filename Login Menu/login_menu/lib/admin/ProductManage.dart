import 'package:flutter/material.dart';
import 'package:login_menu/data/data_store.dart';

class Productmanage extends StatefulWidget {
  const Productmanage({super.key});

  @override
  State<Productmanage> createState() => _ProductmanageState();
}

class _ProductmanageState extends State<Productmanage> {
  @override
  Widget build(BuildContext context) {
    final categories = DataStore.itemsByCategory.keys.toList();

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Categories'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            tooltip: 'Thêm danh mục',
            onPressed: _addCategory,
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: categories.length,
        itemBuilder: (context, categoryIndex) {
          final category = categories[categoryIndex];
          final products = DataStore.itemsByCategory[category]!;

          return Card(
            margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            child: ExpansionTile(
              title: Text(category,
                  style: const TextStyle(fontWeight: FontWeight.bold)),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: const Icon(Icons.edit, color: Colors.blue),
                    onPressed: () => _editCategory(category),
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () => _deleteCategory(category),
                  ),
                ],
              ),
              children: [
                ...List.generate(products.length, (productIndex) {
                  final product = products[productIndex];
                  return ListTile(
                    title: Text(product),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.edit, color: Colors.blue),
                          onPressed: () => _editProduct(category, productIndex),
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () =>
                              _deleteProduct(category, productIndex),
                        ),
                      ],
                    ),
                  );
                }),
                TextButton.icon(
                  onPressed: () => _addProduct(category),
                  icon: const Icon(Icons.add),
                  label: const Text('Thêm sản phẩm'),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  // ---------- PRODUCT FUNCTIONS ----------

  void _editProduct(String category, int productIndex) {
    final controller = TextEditingController(
      text: DataStore.itemsByCategory[category]![productIndex],
    );

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Sửa sản phẩm'),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(labelText: 'Tên mới'),
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Huỷ')),
          ElevatedButton(
            onPressed: () {
              setState(() {
                DataStore.itemsByCategory[category]![productIndex] =
                    controller.text;
              });
              Navigator.pop(context);
            },
            child: const Text('Lưu'),
          ),
        ],
      ),
    );
  }

  void _deleteProduct(String category, int productIndex) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Xác nhận xoá'),
        content: const Text('Bạn có chắc chắn muốn xoá sản phẩm này không?'),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Huỷ')),
          ElevatedButton(
            onPressed: () {
              setState(() {
                DataStore.itemsByCategory[category]!.removeAt(productIndex);
              });
              Navigator.pop(context);
            },
            child: const Text('Xoá'),
          ),
        ],
      ),
    );
  }

  void _addProduct(String category) {
    final controller = TextEditingController();

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Thêm sản phẩm'),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(labelText: 'Tên sản phẩm'),
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Huỷ')),
          ElevatedButton(
            onPressed: () {
              setState(() {
                DataStore.itemsByCategory[category]!.add(controller.text);
              });
              Navigator.pop(context);
            },
            child: const Text('Thêm'),
          ),
        ],
      ),
    );
  }

  // ---------- CATEGORY FUNCTIONS ----------

  void _editCategory(String oldCategory) {
    final controller = TextEditingController(text: oldCategory);

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Sửa danh mục'),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(labelText: 'Tên danh mục mới'),
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Huỷ')),
          ElevatedButton(
            onPressed: () {
              final newCategory = controller.text.trim();
              if (newCategory.isNotEmpty && newCategory != oldCategory) {
                setState(() {
                  final items = DataStore.itemsByCategory.remove(oldCategory);
                  if (items != null) {
                    DataStore.itemsByCategory[newCategory] = items;
                  }
                });
              }
              Navigator.pop(context);
            },
            child: const Text('Lưu'),
          ),
        ],
      ),
    );
  }

  void _deleteCategory(String category) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Xác nhận xoá'),
        content: Text(
            'Bạn có chắc chắn muốn xoá danh mục "$category" không?\nTất cả sản phẩm bên trong cũng sẽ bị xoá.'),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Huỷ')),
          ElevatedButton(
            onPressed: () {
              setState(() {
                DataStore.itemsByCategory.remove(category);
              });
              Navigator.pop(context);
            },
            child: const Text('Xoá'),
          ),
        ],
      ),
    );
  }

  void _addCategory() {
    final controller = TextEditingController();

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Thêm danh mục mới'),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(labelText: 'Tên danh mục'),
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Huỷ')),
          ElevatedButton(
            onPressed: () {
              final newCategory = controller.text.trim();
              if (newCategory.isNotEmpty &&
                  !DataStore.itemsByCategory.containsKey(newCategory)) {
                setState(() {
                  DataStore.itemsByCategory[newCategory] = [];
                });
              }
              Navigator.pop(context);
            },
            child: const Text('Thêm'),
          ),
        ],
      ),
    );
  }
}
