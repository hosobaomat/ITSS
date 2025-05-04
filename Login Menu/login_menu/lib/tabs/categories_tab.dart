import 'package:flutter/material.dart';
import 'package:login_menu/screen/productlistscreen.dart';

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
            children: [
              ListTile(
                title: const Text(
                  'Fruits',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                ),
                leading: SizedBox(
                  width: 80,
                  height: 80,
                  child: Image.asset('lib/images/fruit.jpg', fit: BoxFit.cover),
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          ProductListScreen(category: 'Fruits'),
                    ),
                  );
                },
              ),
              ListTile(
                title: const Text(
                  'Meats',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                ),
                leading: SizedBox(
                  width: 80,
                  height: 80,
                  child: Image.asset('lib/images/meat.jpg', fit: BoxFit.cover),
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          ProductListScreen(category: 'Meats'),
                    ),
                  );
                },
              ),
              ListTile(
                title: const Text(
                  'Vegetables',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                ),
                leading: SizedBox(
                  width: 80,
                  height: 80,
                  child: Image.asset('lib/images/vegetables.jpg',
                      fit: BoxFit.cover),
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          ProductListScreen(category: 'Vegetables'),
                    ),
                  );
                },
              ),
              ListTile(
                title: const Text(
                  'Drinks',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                ),
                leading: SizedBox(
                  width: 80,
                  height: 80,
                  child:
                      Image.asset('lib/images/drinks.jpg', fit: BoxFit.cover),
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          ProductListScreen(category: 'Drinks'),
                    ),
                  );
                },
              ),
              ListTile(
                title: const Text(
                  'Spices',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                ),
                leading: SizedBox(
                  width: 80,
                  height: 80,
                  child:
                      Image.asset('lib/images/spices.jpg', fit: BoxFit.cover),
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          ProductListScreen(category: 'Spices'),
                    ),
                  );
                },
              ),
            ],
          )),
        ],
      ),
    );
  }
}
