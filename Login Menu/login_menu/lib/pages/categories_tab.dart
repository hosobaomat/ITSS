import 'package:flutter/material.dart';

class CategoriesTab extends StatelessWidget {
  const CategoriesTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Tiêu đề "All Categories"
          Center(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                'All Categories',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ),
          ),
          // Danh sách các category
          Expanded(
            child: ListView(
              children: const [
                ListTile(
                  title: Text('Category 1'),
                  leading: Icon(Icons.category),
                ),
                ListTile(
                  title: Text('Category 2'),
                  leading: Icon(Icons.category),
                ),
                ListTile(
                  title: Text('Category 3'),
                  leading: Icon(Icons.category),
                ),
                ListTile(
                  title: Text('Category 4'),
                  leading: Icon(Icons.category),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
