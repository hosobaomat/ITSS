import 'package:flutter/material.dart';

class ShopTab extends StatelessWidget {
  const ShopTab({super.key});

  @override
  Widget build(BuildContext context) {
    return
        // Tab Shop
        SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 16),

          // Search bar
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search for "cheese slices"',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: Colors.green),
                ),
                contentPadding: const EdgeInsets.symmetric(horizontal: 16),
              ),
            ),
          ),

          const SizedBox(height: 16),

          // Banner carousel (mock)
          const SizedBox(height: 16),
          // Categories
          SizedBox(
            height: 90,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              children: const [
                _CategoryItem(label: 'Fruits', icon: Icons.apple),
                _CategoryItem(label: 'Meat & Fish', icon: Icons.set_meal),
                _CategoryItem(label: 'Beverages', icon: Icons.local_drink),
                _CategoryItem(label: 'Dairy', icon: Icons.icecream),
                _CategoryItem(label: 'Snacks', icon: Icons.fastfood),
              ],
            ),
          ),

          const SizedBox(height: 16),
          // Weekly Details title
          const SizedBox(height: 12),
          // Weekly items
          const SizedBox(height: 30),
        ],
      ),
    );
  }
}

class _CategoryItem extends StatelessWidget {
  final String label;
  final IconData icon;

  const _CategoryItem({required this.label, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 80,
      margin: const EdgeInsets.only(right: 12),
      child: Column(
        children: [
          CircleAvatar(
            backgroundColor: Colors.green.shade100,
            child: Icon(icon, color: Colors.green),
          ),
          const SizedBox(height: 6),
          Text(
            label,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 12),
          ),
        ],
      ),
    );
  }
}
