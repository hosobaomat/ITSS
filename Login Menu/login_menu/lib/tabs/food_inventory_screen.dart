import 'package:flutter/material.dart';

class FoodInventoryScreen extends StatefulWidget {
  const FoodInventoryScreen({super.key});

  @override
  _FoodInventoryScreenState createState() => _FoodInventoryScreenState();
}

class _FoodInventoryScreenState extends State<FoodInventoryScreen> {
  final List<Map<String, String>> allItems = [
    {
      'name': 'Apples',
      'amount': '6 ml',
      'desc': 'Erin, aus gent\n16t / 34 |14',
    },
    {
      'name': 'Milk',
      'amount': '23 g',
      'desc': 'Brolicht expart\n16t / 8-9',
    },
    {
      'name': 'Bread',
      'amount': '15 km',
      'desc': 'Day het hax an\n3 day, aire',
    },
    {
      'name': 'Chicken',
      'amount': '4 g',
      'desc': 'Chicken\n14 ctykan',
    },
  ];

  List<Map<String, String>> filteredItems = [];
  final TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    filteredItems = allItems;
  }

  void updateSearch(String query) {
    setState(() {
      filteredItems = allItems.where((item) {
        return item['name']!.toLowerCase().contains(query.toLowerCase());
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 12.0),
            child: Text(
              'Food Inventory',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0),
            child: TextField(
              controller: searchController,
              onChanged: updateSearch,
              decoration: InputDecoration(
                hintText: 'Search items',
                prefixIcon: const Icon(Icons.search),
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                filled: true,
                fillColor: Colors.grey[200],
              ),
            ),
          ),
          const SizedBox(height: 10),
          Expanded(
            child: filteredItems.isEmpty
                ? const Center(child: Text('No items found.'))
                : ListView.builder(
                    itemCount: filteredItems.length,
                    itemBuilder: (context, index) {
                      final item = filteredItems[index];
                      return ListTile(
                        title: Text(
                          item['name']!,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        trailing: Text(item['amount']!),
                        subtitle: Text(item['desc']!),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
