import 'package:flutter/material.dart';
import 'package:login_menu/models/fooditem.dart';
import 'package:login_menu/models/recipes.dart';
import 'package:login_menu/tabs/meal_plan_tab.dart';
import 'package:provider/provider.dart';

class RecipesScreen extends StatefulWidget {
  const RecipesScreen({super.key, required this.inventoryItems});
  final List<FoodItem> inventoryItems;
  @override
  State<RecipesScreen> createState() => _RecipesScreenState();
}

class _RecipesScreenState extends State<RecipesScreen> {
  List<FoodItem> filteredItems = [];
  TextEditingController searchController = TextEditingController();
  String searchText = '';
  final List<Recipe> allRecipes = [
    Recipe(
      name: 'Tomato Soup',
      ingredients: ['Carrot'],
      tag: 'Popular',
    ),
    Recipe(
      name: 'Chicken Salad',
      ingredients: ['Broccoli'],
      tag: 'Saved',
    ),
    // Thêm nhiều món khác
  ];
  List<FoodItem> mergeItems(List<FoodItem> base, List<FoodItem> updated) {
    final Map<String, FoodItem> itemMap = {
      for (var item in base) item.name: item,
    };

    for (var item in updated) {
      itemMap[item.name] = item; // Ghi đè nếu đã có
    }

    return itemMap.values.toList();
  }

  List<Recipe> filterRecipes(
      List<Recipe> allRecipes, List<FoodItem> inventory, String searchText) {
    final availableNames =
        inventory.map((item) => item.name.toLowerCase()).toSet();

    return allRecipes.where((recipe) {
      final nameMatch =
          recipe.name.toLowerCase().contains(searchText.toLowerCase());
      final ingredientsMatch = recipe.ingredients.every(
          (ingredient) => availableNames.contains(ingredient.toLowerCase()));
      return nameMatch && ingredientsMatch;
    }).toList();
  }

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
  }

  void _navigateToMealPlan(BuildContext context) {
    final inventory =
        Provider.of<FoodInventoryProvider>(context, listen: false).items;
    final mergedItems = mergeItems(widget.inventoryItems, inventory);
    final filteredRecipes = filterRecipes(allRecipes, mergedItems, searchText);
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => MealPlanScreen(
          inventory: mergedItems,
          recipes: filteredRecipes,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<FoodInventoryProvider>(
      builder: (context, provider, child) {
        final mergedItems = mergeItems(widget.inventoryItems, provider.items);
        final filteredRecipes =
            filterRecipes(allRecipes, mergedItems, searchText);

        return Scaffold(
          appBar: AppBar(
            title: const Text('Recipes'),
            centerTitle: false,
            elevation: 0,
            backgroundColor: Colors.white,
            foregroundColor: Colors.black,
            actions: [
              IconButton(
                icon: const Icon(Icons.calendar_today),
                onPressed: () => _navigateToMealPlan(context),
              ),
            ],
          ),
          backgroundColor: Colors.white,
          body: Column(
            children: [
              // Search bar
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: TextField(
                  controller: searchController,
                  onChanged: (value) {
                    setState(() {
                      searchText = value;
                    });
                  },
                  decoration: InputDecoration(
                    hintText: 'Search recipes',
                    prefixIcon: const Icon(Icons.search),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    fillColor: Colors.grey[200],
                    filled: true,
                  ),
                ),
              ),

              // List of recipes
              Expanded(
                child: ListView.builder(
                  itemCount: filteredRecipes.length,
                  itemBuilder: (context, index) {
                    final recipe = filteredRecipes[index];
                    return ListTile(
                      title: Text(recipe.name),
                      subtitle:
                          Text('Nguyên liệu: ${recipe.ingredients.join(', ')}'),
                      trailing: Text(recipe.tag),
                    );
                  },
                ),
              ),

              // Bottom row
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                child: Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.grey[300],
                          foregroundColor: Colors.black,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: const Text('Edit access'),
                      ),
                    ),
                    const SizedBox(width: 10),
                    ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        shape: const CircleBorder(),
                        padding: const EdgeInsets.all(16),
                        backgroundColor: Colors.grey[300],
                        foregroundColor: Colors.black,
                      ),
                      child: const Icon(Icons.add),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
