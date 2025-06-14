import 'package:flutter/material.dart';
import 'package:login_menu/data/data_store.dart';
import 'package:login_menu/pages/productScreen.dart';

class CategoriesTab extends StatefulWidget {
  const CategoriesTab({super.key});

  @override
  State<CategoriesTab> createState() => _CategoriesTabState();
}

class _CategoriesTabState extends State<CategoriesTab> {
  @override
  Widget build(BuildContext context) {
    final categories = DataStore.itemsByCategory.keys.toList();
    return Scaffold(
      appBar: AppBar(
        title: const Text('All Categories'),
      ),
      body: ListView.builder(
        itemCount: categories.length,
        itemBuilder: (context, index) {
          final category = categories[index];
          return ListTile(
            title: Text(category),
            leading: const Icon(Icons.category),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => Productscreen(
                    ProductName: category,
                    items: DataStore.itemsByCategory[category]!,
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
