import 'package:flutter/material.dart';
import 'package:login_menu/models/fooditem.dart';
import 'package:provider/provider.dart';

class FoodInventoryScreen extends StatefulWidget {
  const FoodInventoryScreen({super.key, required this.inventoryItems});
  final List<FoodItem> inventoryItems;
  @override
  _FoodInventoryScreenState createState() => _FoodInventoryScreenState();
}

class _FoodInventoryScreenState extends State<FoodInventoryScreen> {
  List<FoodItem> filteredItems = [];

  final TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    final merged = mergeItems(widget.inventoryItems,
        Provider.of<FoodInventoryProvider>(context, listen: false).items);
    final provider = Provider.of<FoodInventoryProvider>(context, listen: false);
    for (var item in merged) {
      if (!provider.items.any((e) => e.name == item.name)) {
        provider.addItem(item);
      }
    }
    filteredItems = List.from(provider.items);
  }

  void updateSearch(String query) {
    final inventory =
        Provider.of<FoodInventoryProvider>(context, listen: false).items;
    setState(() {
      filteredItems = inventory.where((item) {
        return item.name.toLowerCase().contains(query.toLowerCase());
      }).toList();
    });
  }

  List<FoodItem> mergeItems(List<FoodItem> base, List<FoodItem> updated) {
    final Map<String, FoodItem> itemMap = {
      for (var item in base) item.name: item,
    };

    for (var item in updated) {
      itemMap[item.name] = item; // Ghi đè nếu đã có
    }

    return itemMap.values.toList();
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
            child: Selector<FoodInventoryProvider, List<FoodItem>>(
              selector: (_, provider) => provider.items,
              builder: (context, inventory, _) {
                final query = searchController.text.trim().toLowerCase();
                final results = query.isEmpty
                    ? inventory
                    : inventory
                        .where(
                            (item) => item.name.toLowerCase().contains(query))
                        .toList();

                return results.isEmpty
                    ? const Center(child: Text('No items found.'))
                    : ListView.builder(
                        itemCount: results.length,
                        itemBuilder: (context, index) {
                          final item = results[index];
                          return ListTile(
                            title: Text(item.name,
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold)),
                            trailing: const Text('amount'),
                            subtitle: const Text('description'),
                          );
                        },
                      );
              },
            ),
          )
        ],
      ),
    );
  }
}
