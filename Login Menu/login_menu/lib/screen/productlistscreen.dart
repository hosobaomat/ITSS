import 'package:flutter/material.dart';

class ProductListScreen extends StatelessWidget {
  final String category;

  const ProductListScreen({super.key, required this.category});

  @override
  Widget build(BuildContext context) {
    // Dữ liệu mẫu: danh sách sản phẩm với tên và đường dẫn ảnh
    final Map<String, List<Map<String, String>>> productsByCategory = {
      'Fruits': [
        {'name': 'Apple', 'image': 'lib/images/apple.jpg'},
        {'name': 'Banana', 'image': 'lib/images/banana.jpg'},
        {'name': 'Orange', 'image': 'lib/images/orange.jpg'},
      ],
      'Meats': [
        {'name': 'Chicken', 'image': 'lib/images/chicken.jpg'},
        {'name': 'Beef', 'image': 'lib/images/beef.jpg'},
        {'name': 'Pork', 'image': 'lib/images/pork.jpg'},
      ],
      'Vegetables': [
        {'name': 'Carrot', 'image': 'lib/images/carrot.jpg'},
        {'name': 'Broccoli', 'image': 'lib/images/broccoli.jpg'},
        {'name': 'Lettuce', 'image': 'lib/images/lettuce.jpg'},
      ],
      'Drinks': [
        {'name': 'Water', 'image': 'lib/images/water.jpg'},
        {'name': 'Coca cola', 'image': 'lib/images/cocacola.jpg'},
        {'name': '7up', 'image': 'lib/images/7up.jpg'},
      ],
      'Spices': [
        {'name': 'Pepper', 'image': 'lib/images/pepper.jpg'},
        {'name': 'Salt', 'image': 'lib/images/salt.jpg'},
        {'name': 'Fish sauce', 'image': 'lib/images/fishsauce.jpg'},
      ],
    };

    final products = productsByCategory[category] ?? [];

    return Scaffold(
      appBar: AppBar(
        title: Text('$category products'),
      ),
      body: ListView.builder(
        itemCount: products.length,
        itemBuilder: (context, index) {
          final product = products[index];
          return ListTile(
            leading: SizedBox(
              width: 60,
              height: 60,
              child: Image.asset(product['image']!, fit: BoxFit.cover),
            ),
            title: Text(product['name']!),
          );
        },
      ),
    );
  }
}
