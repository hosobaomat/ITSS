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
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.green,
      ),
      body: IndexedStack(
        index: _selectedIndex,
        children: [
          ShoppingListTab(
            authService: widget.authService,
          ),
          CategoriesTab(),
          FoodInventoryScreen(authService: widget.authService, items: [],),
          // RecipesScreen(inventoryItems: [], authService: widget.authService,),
          MealPlanScreenGet(authService: widget.authService),
          StatisticTab(),
          ProfilTab(),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.green,
        unselectedItemColor: Colors.grey,
        onTap: _onItemTapped,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(
              icon: Icon(Icons.category), label: 'Categories'),
          BottomNavigationBarItem(
              icon: Icon(Icons.shopping_bag), label: 'Food Inventory'),
          BottomNavigationBarItem(
              icon: Icon(Icons.play_lesson_outlined), label: 'Meal Plan'),
          BottomNavigationBarItem(
              icon: Icon(Icons.receipt), label: 'Statistic'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
  }
}
