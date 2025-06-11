import 'package:flutter/material.dart';
import 'package:login_menu/data/data_store.dart';
import 'package:login_menu/models/recipesResponse.dart';
import 'package:login_menu/tabs/meal_plan.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:login_menu/service/auth_service.dart';
import 'package:login_menu/tabs/shoppinglist_tab.dart';
import 'package:login_menu/tabs/categories_tab.dart';
import 'package:login_menu/tabs/profil_tab.dart';
import 'package:login_menu/tabs/food_inventory_screen.dart';
import 'package:login_menu/tabs/statistic_tab.dart';
import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key, required this.authService});
  final AuthService authService;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;
  int? _userId;
  @override
  void initState() {
    super.initState();
    if (DataStore().recipesSuggest.isNotEmpty) {
    } else {
      widget.authService.fetchRecipesByUser().then((recipes) {
        DataStore().recipesresponse = recipes;
        return recipes;
      });
    }
    _loadUserId();
  }

  Future<void> _loadUserId() async {
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getInt('userId'); //  Đảm bảo đã lưu userId khi login
    setState(() {
      _userId = userId;
    });
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        // appBar: AppBar(
        //   centerTitle: true,
        //   backgroundColor: Colors.green,
        // ),
        body: IndexedStack(
          index: _selectedIndex,
          children: [
            ShoppingListTab(
              authService: widget.authService,
            ),
            CategoriesTab(),
            FoodInventoryScreen(
              authService: widget.authService,
              items: [],
            ),
            // RecipesScreen(inventoryItems: [], authService: widget.authService,),
            MealPlanScreenGet(authService: widget.authService),
            StatisticTab(),
            ProfilTab(),
          ],
        ),
        bottomNavigationBar: SalomonBottomBar(
          currentIndex: _selectedIndex,
          onTap: (i) => setState(() => _selectedIndex = i),
          itemPadding: const EdgeInsets.symmetric(horizontal: 4, vertical: 6), // giảm padding
          items: [
            SalomonBottomBarItem(
                icon: Icon(Icons.home, size: 20),
                title: Text("Home", style: TextStyle(fontSize: 14)),
                selectedColor: Colors.green),
            SalomonBottomBarItem(
                icon: Icon(Icons.category, size: 20),
                title: Text("Categories", style: TextStyle(fontSize: 14)),
                selectedColor: Colors.green),
            SalomonBottomBarItem(
                icon: Icon(Icons.shopping_bag, size: 20),
                title: Text("Inventory", style: TextStyle(fontSize: 14)),
                selectedColor: Colors.green),
            SalomonBottomBarItem(
                icon: Icon(Icons.play_lesson, size: 20),
                title: Text("Meal", style: TextStyle(fontSize: 14)),
                selectedColor: Colors.green),
            SalomonBottomBarItem(
                icon: Icon(Icons.receipt, size: 20),
                title: Text("Statistic", style: TextStyle(fontSize: 14)),
                selectedColor: Colors.green),
            SalomonBottomBarItem(
                icon: Icon(Icons.person, size: 20),
                title: Text("Profile", style: TextStyle(fontSize: 14)),
                selectedColor: Colors.green),
          ],
        ));
  }
}
