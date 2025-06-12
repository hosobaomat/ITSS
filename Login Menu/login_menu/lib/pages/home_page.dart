import 'package:flutter/material.dart';
import 'package:login_menu/data/data_store.dart';
import 'package:login_menu/pages/notification.dart';
import 'package:login_menu/tabs/meal_plan.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:login_menu/service/auth_service.dart';
import 'package:login_menu/tabs/shoppinglist_tab.dart';
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
  int? userId;
  bool _showedPopup = false; // Biến để kiểm tra đã hiển thị popup hay chưa
  @override
  void initState() {
    super.initState();

    if (DataStore().recipesSuggest.isEmpty) {
      widget.authService.fetchRecipesByUser().then((recipes) {
        DataStore().recipesresponse = recipes;
      });
    }

    widget.authService.getUserId().then((id) {
      // id đã được lưu vào DataStore, nhưng bạn vẫn dùng biến local cho chắc chắn.
      setState(() {
        userId = id;
      });
      // Show popup sau khi đã có userId và build xong
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!_showedPopup) {
          _showedPopup = true;
          showNotificationPopup(context, id, widget.authService);
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    if (userId == null) {
      return Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

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
            //CategoriesTab(),
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
          itemPadding: const EdgeInsets.symmetric(
              horizontal: 4, vertical: 6), // giảm padding
          items: [
            SalomonBottomBarItem(
                icon: Icon(Icons.home, size: 20),
                title: Text("Home", style: TextStyle(fontSize: 14)),
                selectedColor: Colors.green),
            // SalomonBottomBarItem(
            //     icon: Icon(Icons.category),
            //     title: Text("Categories"),
            //     selectedColor: Colors.green),
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
