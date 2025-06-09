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
import 'package:water_drop_nav_bar/water_drop_nav_bar.dart';
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
  late Future<List<Recipesresponse>> _recipeFuture;
  @override
  void initState() {
    super.initState();
    if (DataStore().recipesresponse.isNotEmpty) {
      _recipeFuture = Future.value(DataStore().recipesresponse);
    } else {
      _recipeFuture = widget.authService.fetchRecipesByUser().then((recipes) {
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
          items: [
            SalomonBottomBarItem(
                icon: Icon(Icons.home),
                title: Text("Home"),
                selectedColor: Colors.green),
            SalomonBottomBarItem(
                icon: Icon(Icons.category),
                title: Text("Categories"),
                selectedColor: Colors.green),
            SalomonBottomBarItem(
                icon: Icon(Icons.shopping_bag),
                title: Text("Inventory"),
                selectedColor: Colors.green),
            SalomonBottomBarItem(
                icon: Icon(Icons.play_lesson),
                title: Text("Meal"),
                selectedColor: Colors.green),
            SalomonBottomBarItem(
                icon: Icon(Icons.receipt),
                title: Text("Statistic"),
                selectedColor: Colors.green),
            SalomonBottomBarItem(
                icon: Icon(Icons.person),
                title: Text("Profile"),
                selectedColor: Colors.green),
          ],
        ));
  }
}
